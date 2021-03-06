# = Informations
#
# == License
#
# Ekylibre - Simple agricultural ERP
# Copyright (C) 2008-2009 Brice Texier, Thibaud Merigon
# Copyright (C) 2010-2012 Brice Texier
# Copyright (C) 2012-2016 Brice Texier, David Joulin
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
#
# == Table: tax_declarations
#
#  accounted_at      :datetime
#  created_at        :datetime         not null
#  creator_id        :integer
#  currency          :string           not null
#  description       :text
#  financial_year_id :integer          not null
#  id                :integer          not null, primary key
#  invoiced_on       :date
#  journal_entry_id  :integer
#  lock_version      :integer          default(0), not null
#  mode              :string           not null
#  number            :string
#  reference_number  :string
#  responsible_id    :integer
#  started_on        :date             not null
#  state             :string
#  stopped_on        :date             not null
#  updated_at        :datetime         not null
#  updater_id        :integer
#

class TaxDeclaration < Ekylibre::Record::Base
  include Attachable
  attr_readonly :currency
  refers_to :currency
  enumerize :mode, in: [:debit, :payment], predicates: true
  belongs_to :financial_year
  belongs_to :journal_entry, dependent: :destroy
  belongs_to :responsible, class_name: 'User'
  # belongs_to :tax_office, class_name: 'Entity'
  has_many :items, class_name: 'TaxDeclarationItem', dependent: :destroy, inverse_of: :tax_declaration
  # [VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates :accounted_at, timeliness: { on_or_after: -> { Time.new(1, 1, 1).in_time_zone }, on_or_before: -> { Time.zone.now + 50.years } }, allow_blank: true
  validates :currency, :financial_year, :mode, presence: true
  validates :description, length: { maximum: 500_000 }, allow_blank: true
  validates :invoiced_on, timeliness: { on_or_after: -> { Time.new(1, 1, 1).in_time_zone }, on_or_before: -> { Time.zone.today + 50.years }, type: :date }, allow_blank: true
  validates :number, :reference_number, :state, length: { maximum: 500 }, allow_blank: true
  validates :started_on, presence: true, timeliness: { on_or_after: -> { Time.new(1, 1, 1).in_time_zone }, on_or_before: -> { Time.zone.today + 50.years }, type: :date }
  validates :stopped_on, presence: true, timeliness: { on_or_after: ->(tax_declaration) { tax_declaration.started_on || Time.new(1, 1, 1).in_time_zone }, on_or_before: -> { Time.zone.today + 50.years }, type: :date }
  # ]VALIDATORS]
  validates :number, uniqueness: true
  validates_associated :items

  acts_as_numbered
  # acts_as_affairable :tax_office
  accepts_nested_attributes_for :items, reject_if: proc { |item| item[:tax_id].blank? && item[:tax].blank? }, allow_destroy: true

  delegate :tax_declaration_mode, :tax_declaration_frequency,
           :tax_declaration_mode_payment?, :tax_declaration_mode_debit?,
           to: :financial_year

  protect on: :destroy do
    (validated? || sent?)
  end

  state_machine :state, initial: :draft do
    state :draft
    state :validated
    state :sent
    event :propose do
      transition draft: :validated, if: :has_content?
    end
    event :confirm do
      transition validated: :sent, if: :has_content?
    end
  end

  before_validation(on: :create) do
    self.state ||= :draft
    self.invoiced_on ||= Date.today
    if financial_year
      self.mode = financial_year.tax_declaration_mode
      self.currency = financial_year.currency
      # if tax_declarations exists for current financial_year, then get the last to compute started_on
      self.started_on = financial_year.next_tax_declaration_on
      # anyway, stopped_on is started_on + tax_declaration_frequency_duration
    end
    if started_on
      self.stopped_on ||= financial_year.tax_declaration_end_date(started_on)
    end
  end

  before_validation do
    self.created_at ||= Time.zone.now
  end

  after_save :compute!, if: :draft?

  def has_content?
    items.any?
  end

  # Prints human name of current state
  def state_label
    self.class.state_machine.state(self.state.to_sym).human_name
  end

  # This callback bookkeeps the sale depending on its state
  bookkeep do |b|
    journal = unsuppress { Journal.used_for_tax_declarations!(currency: currency) }
    b.journal_entry(journal, printed_on: invoiced_on, if: (has_content? && (validated? || sent?))) do |entry|
      label = tc(:bookkeep, resource: self.class.model_name.human, number: number, started_on: started_on.l, stopped_on: stopped_on.l)
      items.each do |item|
        entry.add_debit(label, item.tax.collect_account.id, item.collected_tax_amount.round(2), tax: item.tax, resource: item, as: :collect) unless item.collected_tax_amount.zero?
        entry.add_credit(label, item.tax.deduction_account.id, item.deductible_tax_amount.round(2), tax: item.tax, resource: item, as: :deduction) unless item.deductible_tax_amount.zero?
        entry.add_credit(label, item.tax.fixed_asset_deduction_account.id, item.fixed_asset_deductible_tax_amount.round(2), tax: item.tax, resource: item, as: :fixed_asset_deduction) unless item.fixed_asset_deductible_tax_amount.zero?
      end
      balance = items.sum(:balance_tax_amount).round(2)
      unless balance.zero?
        # FIXME: Too french
        account = Account.find_or_create_by(number: balance < 0 ? '45567' : '44551')
        entry.add_credit(label, account, balance, as: :balance)
      end
    end
  end

  def dealt_at
    (validated? ? invoiced_on : created_at? ? self.created_at : Time.zone.now)
  end

  def status
    return :go if sent?
    return :caution if validated?
    :stop
  end

  # FIXME: Too french
  def undeclared_tax_journal_entry_items
    JournalEntryItem.includes(:entry, account: [:collected_taxes, :paid_taxes]).order('journal_entries.printed_on, accounts.number').where(printed_on: started_on..stopped_on, tax_declaration_item: nil).where('accounts.number LIKE ?', '445%')
  end

  # FIXME: Too french
  def unidentified_revenues_journal_entry_items
    JournalEntryItem.includes(:entry, :account).order('journal_entries.printed_on, accounts.number').where(printed_on: started_on..stopped_on).where('accounts.number LIKE ? AND journal_entry_items.resource_id is null', '7%')
  end

  # FIXME: Too french
  def unidentified_expenses_journal_entry_items
    JournalEntryItem.includes(:entry, :account).order('journal_entries.printed_on, accounts.number').where(printed_on: started_on..stopped_on).where('accounts.number LIKE ? AND journal_entry_items.resource_id is null', '6%')
  end

  def deductible_tax_amount_balance
    items.map(&:deductible_tax_amount).compact.sum
  end

  def collected_tax_amount_balance
    items.map(&:collected_tax_amount).compact.sum
  end

  # Compute tax declaration with its items
  def compute!
    taxes = Tax.order(:name)
    # Removes unwanted tax declaration item
    items.where.not(tax: taxes).find_each(&:destroy)
    # Create or update other items
    taxes.find_each do |tax|
      items.find_or_initialize_by(tax: tax).compute!
    end
  end
end
