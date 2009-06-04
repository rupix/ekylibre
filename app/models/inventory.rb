# == Schema Information
# Schema version: 20090520140946
#
# Table name: inventories
#
#  id                :integer       not null, primary key
#  date              :date          not null
#  comment           :text          
#  changes_reflected :boolean       
#  company_id        :integer       not null
#  created_at        :datetime      not null
#  updated_at        :datetime      not null
#  created_by        :integer       
#  updated_by        :integer       
#  lock_version      :integer       default(0), not null
#

class Inventory < ActiveRecord::Base
end
