# = Informations
# 
# == License
# 
# Ekylibre - Simple ERP
# Copyright (C) 2009-2012 Brice Texier, Thibaud Merigon
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see http://www.gnu.org/licenses.
# 
# == Table: subscription_natures
#
#  actual_number         :integer          
#  comment               :text             
#  created_at            :datetime         not null
#  creator_id            :integer          
#  entity_link_nature_id :integer          
#  id                    :integer          not null, primary key
#  lock_version          :integer          default(0), not null
#  name                  :string(255)      not null
#  nature                :string(8)        not null
#  reduction_rate        :decimal(19, 10)  
#  updated_at            :datetime         not null
#  updater_id            :integer          
#


class SubscriptionNature < CompanyRecord
  belongs_to :entity_link_nature
  has_many :products
  has_many :subscriptions, :foreign_key=>:nature_id

  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_numericality_of :actual_number, :allow_nil => true, :only_integer => true
  validates_numericality_of :reduction_rate, :allow_nil => true
  validates_length_of :nature, :allow_nil => true, :maximum => 8
  validates_length_of :name, :allow_nil => true, :maximum => 255
  validates_presence_of :name, :nature
  #]VALIDATORS]
  validates_numericality_of :reduction_rate, :greater_than_or_equal_to=>0, :less_than_or_equal_to=>1

  default_scope order(:name)

  before_validation do
    self.reduction_rate ||= 0
  end

  protect(:on => :destroy) do
    self.subscriptions.size <= 0 and self.products.size <= 0
  end

  def self.natures
    [:quantity, :period].collect{|x| [tc('natures.'+x.to_s), x] }
  end


  def nature_label
    tc('natures.'+self.nature.to_s)
  end

  def period?
    self.nature == "period"
  end

  def now
    return (self.period? ? Date.today : self.actual_number)
  end

  def fields
    if self.period?
      return :started_on, :stopped_on
    else
      return :first_number, :last_number
    end
  end

  def start
    if self.period?
      return :started_on
    else
      return :first_number
    end
  end

  def finish
    if self.period?
      return :stopped_on
    else
      return :last_number
    end
  end
    


end

