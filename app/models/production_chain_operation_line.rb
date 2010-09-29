# = Informations
# 
# == License
# 
# Ekylibre - Simple ERP
# Copyright (C) 2009-2010 Brice Texier, Thibaud Mérigon
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
# == Table: production_chain_operation_lines
#
#  company_id             :integer          not null
#  created_at             :datetime         not null
#  creator_id             :integer          
#  direction              :string(255)      default("out"), not null
#  from_operation_line_id :integer          not null
#  id                     :integer          not null, primary key
#  lock_version           :integer          default(0), not null
#  operation_id           :integer          not null
#  product_id             :integer          
#  quantity               :decimal(16, 4)   default(0.0)
#  unit_id                :integer          
#  updated_at             :datetime         not null
#  updater_id             :integer          
#  warehouse_id           :integer          
#

class ProductionChainOperationLine < ActiveRecord::Base
  attr_readonly :company_id
  belongs_to :company
  belongs_to :operation, :class_name=>ProductionChainOperation.name

end
