# = Informations
#
# == License
#
# Ekylibre ERP - Simple agricultural ERP
# Copyright (C) 2008-2009 Brice Texier, Thibaud Merigon
# Copyright (C) 2010-2012 Brice Texier
# Copyright (C) 2012-2015 Brice Texier, David Joulin
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
# == Table: cash_sessions
#
#  affair_id            :integer
#  created_at           :datetime         not null
#  creator_id           :integer
#  currency             :string(255)
#  expected_stop_amount :float
#  id                   :integer          not null, primary key
#  lock_version         :integer          default(0), not null
#  noticed_start_amount :float
#  noticed_stop_amount  :float
#  sequence_id          :integer
#  started_at           :datetime
#  stopped_at           :datetime
#  updated_at           :datetime         not null
#  updater_id           :integer
#
class CashSession < Ekylibre::Record::Base
  #[VALIDATORS[ Do not edit these lines directly. Use `rake clean:validations`.
  validates_datetime :started_at, :stopped_at, allow_blank: true, on_or_after: Time.new(1, 1, 1, 0, 0, 0, '+00:00')
  validates_numericality_of :expected_stop_amount, :noticed_start_amount, :noticed_stop_amount, allow_nil: true
  validates_length_of :currency, allow_nil: true, maximum: 255
  #]VALIDATORS]
end