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
# == Table: affairs
#
#  accounted_at           :datetime
#  cash_session_id        :integer
#  closed                 :boolean          default(FALSE), not null
#  closed_at              :datetime
#  created_at             :datetime         not null
#  creator_id             :integer
#  credit                 :decimal(19, 4)   default(0.0), not null
#  currency               :string           not null
#  dead_line_at           :datetime
#  deals_count            :integer          default(0), not null
#  debit                  :decimal(19, 4)   default(0.0), not null
#  description            :text
#  id                     :integer          not null, primary key
#  journal_entry_id       :integer
#  letter                 :string
#  lock_version           :integer          default(0), not null
#  name                   :string
#  number                 :string           not null
#  origin                 :string
#  pretax_amount          :decimal(19, 4)   default(0.0)
#  probability_percentage :decimal(19, 4)   default(0.0)
#  responsible_id         :integer
#  state                  :string
#  third_id               :integer          not null
#  type                   :string
#  updated_at             :datetime         not null
#  updater_id             :integer
#
require 'test_helper'

class SaleAffairTest < AffairTest
  test 'homogeneousity' do
    sale = Sale.order(:id).first
    assert_equal SaleAffair, sale.affair.class
    assert_raise Exception do
      sale.affair.deal_with! Purchase.first
    end
  end

  test 'balancing with payment' do
    sale = new_valid_sales_invoice

    payment = IncomingPayment.create!(
      payer: sale.client,
      amount: sale.amount,
      received: true,
      mode: IncomingPaymentMode.where(
        with_accounting: true,
        cash: Cash.where(currency: sale.currency)
      ).first
    )

    sale.deal_with! payment.affair

    assert_equal sale.affair, payment.affair

    check_closed_state(sale.affair)
  end

  test 'finishing with loss gap' do
    sale = new_valid_sales_invoice
    assert_equal 1, sale.affair.deals.count
    assert sale.affair.finishable?
    assert_equal 1, sale.affair.deals.count
    sale.affair.finish
    assert_equal 2, sale.affair.deals.count

    check_closed_state(sale.affair)
  end

  test 'finishing with payment and a profit gap' do
    sale = new_valid_sales_invoice

    payment = IncomingPayment.create!(
      payer: sale.client,
      amount: sale.amount + 2,
      received: true,
      mode: IncomingPaymentMode.where(
        with_accounting: true,
        cash: Cash.where(currency: sale.currency)
      ).first
    )

    sale.deal_with! payment.affair

    assert_equal sale.affair, payment.affair

    assert_equal 2, sale.affair.deals.count
    assert sale.affair.finishable?
    assert_equal 2, sale.affair.deals.count
    sale.affair.finish
    assert_equal 3, sale.affair.deals.count

    check_closed_state(sale.affair)
  end

  # Creates a sale and check affair informations
  def new_valid_sales_invoice
    client = entities(:entities_005)
    journal = Journal.find_by(nature: :sales)
    nature = SaleNature.find_or_initialize_by(
      with_accounting: true,
      journal: journal,
      currency: journal.currency,
      catalog: Catalog.by_default!(:sale)
    )
    nature.name ||= 'Sales baby!'
    nature.save!
    items = (0..4).to_a.map do |index|
      SaleItem.new(
        quantity: 1 + rand(20),
        unit_pretax_amount: 10 + (100 * rand).round(2),
        variant: ProductNatureVariant.where(
          category: ProductNatureCategory.where(saleable: true)
        ).offset(index).first,
        tax: Tax.all.sample
      )
    end
    sale = Sale.create!(client: client, nature: nature, items: items)
    assert sale.amount > 0, "Sale amount should be greater than 0. Got: #{sale.amount.inspect}"
    assert_equal sale.affair.credit, sale.amount, 'Sale amount should match exactly affair credit'
    sale.invoice!
    sale.reload
    assert sale.journal_entry, 'A journal entry should exists after sale invoicing'
    assert_equal sale.affair.credit, sale.amount, 'Sale amount should match exactly affair credit'
    assert sale.affair.unbalanced?,
           "Affair should not be balanced:\n" +
           sale.affair.attributes.sort_by(&:first).map { |k, v| " - #{k}: #{v}" }.join("\n")
    assert sale.affair.letterable_journal_entry_items.any?,
           "Affair should have letterable journal entry items:\n" +
           sale.affair.deals.map { |d| " - #{d.class.name}: #{d.journal_entry.inspect}" }.join("\n")
    assert sale.affair.journal_entry_items_unbalanced?,
           "Journal entry items should be unbalanced:\n" +
           sale.affair.letterable_journal_entry_items.map { |i| " - #{i.account_number.ljust(14)} | #{i.debit.to_s.rjust(10)} | #{i.credit.to_s.rjust(10)}" }.join("\n")
    assert !sale.affair.multi_thirds?
    assert !sale.affair.journal_entry_items_already_lettered?

    assert !sale.affair.letterable?
    sale
  end
end
