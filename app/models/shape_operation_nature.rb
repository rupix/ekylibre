# == Schema Information
# Schema version: 20090428134248
#
# Table name: shape_operation_natures
#
#  id           :integer       not null, primary key
#  name         :string(255)   not null
#  description  :text          
#  company_id   :integer       not null
#  created_at   :datetime      not null
#  updated_at   :datetime      not null
#  created_by   :integer       
#  updated_by   :integer       
#  lock_version :integer       default(0), not null
#

class ShapeOperationNature < ActiveRecord::Base

  belongs_to :company
  has_many :shape_operations

end
