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
# == Table: land_parcel_kinships
#
#  child_land_parcel_id  :integer          not null
#  company_id            :integer          not null
#  created_at            :datetime         not null
#  creator_id            :integer          
#  id                    :integer          not null, primary key
#  lock_version          :integer          default(0), not null
#  nature                :string(16)       
#  parent_land_parcel_id :integer          not null
#  updated_at            :datetime         not null
#  updater_id            :integer          
#

class LandParcelKinship < ActiveRecord::Base
  attr_readonly :company_id
  belongs_to :company
  belongs_to :parent_land_parcel, :class_name=>LandParcel.name
  belongs_to :child_land_parcel, :class_name=>LandParcel.name

end
