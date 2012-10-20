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
# == Table: public.companies
#
#  code :string(16)       not null
#  id   :integer          not null, primary key
#  log  :text             
#


require 'test_helper'
require "digest/sha2"

class CompanyTest < ActiveSupport::TestCase
  fixtures :companies


  context "A generated company" do

    setup do
      @company, @user = Company.create_with_data({:name=>"Generated LTD", :code=>"gltd", :currency=>'EUR'}, {:first_name=>"Gendo", :last_name=>"IKARI", :name=>"gendo", :password=>"12345678", :password_confirmation=>"12345678"}, "fr-FR")
      assert_operator @company.id, :> , 0
    end
    
    should "not be locked" do
      assert !@company.locked
      assert !@user.locked
    end

    should "have valid default document templates" do
      assert_raise Exception do
        @company.print
      end
      for template in @company.document_templates
        if DocumentTemplate.document_natures[template.nature.to_sym].size > 0
          assert_raise ArgumentError do
            @company.print(:id=>template.code)
          end
        else
          assert_nothing_raised do
            @company.print(:id=>template.code)
          end        
        end
        code = ""
        assert_nothing_raised(template.source) do
          code = Templating.compile(template.source, :xil, :mode=>:debug)
        end
        # puts code
        assert_nothing_raised(code) do
          eval(code)
        end
      end
    end

    should "be backed up without prints" do
      assert_raise ArgumentError do
        @company.restore(nil)
      end
      assert_nothing_raised do
        @save_1 = @company.backup(:creator=>"Me")
      end
    end

    context "with sales" do

      setup do
        @sale = @company.sales.create!(:client=>@company.entities.third, :nature=>@company.sale_natures.first)
      end

      should "invoice its sales" do
        assert !@sale.invoice

        line = @sale.lines.new(:quantity=>12, :product=>@company.products.first, :warehouse=>@company.warehouses.first, :price_amount=>46, :tax_id=>@company.taxes.first.id)
        assert line.save, line.errors.inspect
        line = @sale.lines.new(:quantity=>25, :product=>@company.products.second, :warehouse=>@company.warehouses.first, :price_amount=>14.5, :tax_id=>@company.taxes.first.id)
        assert line.save, line.errors.inspect
        @sale.reload
        assert_equal "draft", @sale.state
        assert @sale.propose
        assert_equal "estimate", @sale.state
        assert !@sale.can_invoice?, "Deliverables: "+@sale.lines.collect{|l| l.product.attributes.inspect}.to_sentence
        assert @sale.confirm
        assert @sale.invoice
        assert_equal "invoice", @sale.state
      end

      should "print its sales" do
        assert_nothing_raised do
          @company.print(:id=>:sales_order, :sales_order=>@sale)
        end
      end

    end

    context "already invoiced" do

      setup do
        @sale = @company.sales.new(:client=>@company.entities.third, :nature=>@company.sale_natures.first)
        assert @sale.save, @sale.errors.inspect
        assert_equal Date.today, @sale.created_on
        for y in 1..10
          line = @sale.lines.new(:quantity=>rand*50, :product=>@company.products.first, :warehouse=>@company.warehouses.first, :price_amount=>5*y, :tax_id=>@company.taxes.first.id)
          # assert line.valid?, [product.prices, line.price].inspect
          assert line.save, line.errors.inspect
        end
        @sale.reload
        assert_equal "draft", @sale.state
        assert @sale.propose
        assert_equal "estimate", @sale.state
        assert !@sale.can_invoice?, "Deliverables: "+@sale.lines.collect{|l| l.product.attributes.inspect}.to_sentence
        assert @sale.confirm
        assert @sale.invoice
        assert_equal "invoice", @sale.state
        assert_equal Date.today, @sale.invoiced_on
      end
      
      should "not be updateable" do
        amount = @sale.amount
        assert_raise ActiveModel::MassAssignmentSecurity::Error do
          @sale.update_attributes(:amount => amount.to_i+50)
        end
        @sale.reload
        assert_equal amount, @sale.amount, "State of sale is: #{@sale.state}"
      end

      should "print and archive its sales invoices" do
        data = []
        assert_nothing_raised do
          data << Digest::SHA256.hexdigest(@company.print(:id=>:sales_invoice, :sales_invoice=>@sale)[0])
        end
        assert_nothing_raised do
          data << Digest::SHA256.hexdigest(@company.print(:id=>:sales_invoice, :sales_invoice=>@sale)[0])
        end
        assert_nothing_raised do
          data << Digest::SHA256.hexdigest(@company.print(:id=>:sales_invoice, :sales_invoice=>@sale.id)[0])
        end
        assert_equal data[0], data[1], "The template doesn't seem to be archived"        
        assert_equal data[0], data[2], "The template doesn't seem to be archived or understand Integers"
      end

      should "be backed up and restored" do
        assert_nothing_raised do
          @backup_1 = @company.backup(:creator=>"Me again", :with_prints=>true)
        end

        assert_nothing_raised do
          @backup_2 = @company.backup(:creator=>"Me again", :with_prints=>false)
        end

        assert_nothing_raised do
          assert @company.restore(@backup_1)
        end

        assert_nothing_raised do
          assert @company.restore(@backup_2)
        end
      end

    end


  end


  

end
