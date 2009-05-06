# == Schema Information
# Schema version: 20090428134248
#
# Table name: currencies
#
#  id           :integer       not null, primary key
#  name         :string(255)   not null
#  code         :string(255)   not null
#  format       :string(16)    not null
#  rate         :decimal(16, 6 default(1.0), not null
#  active       :boolean       default(TRUE), not null
#  comment      :text          
#  company_id   :integer       not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  created_by   :integer       
#  updated_by   :integer       
#  lock_version :integer       default(0), not null
#

class Currency < ActiveRecord::Base
  belongs_to :company

  has_many :bank_accounts
  has_many :entries
  has_many :journals
  has_many :prices


end
