# Autogenerated from Ekylibre (`rake clean:models` or `rake clean`)
module Ekylibre
  mattr_reader :models, :references
  # List of all models
  @@models = [:account, :account_balance, :area, :bank_statement, :cash, :cash_transfer, :company, :contact, :cultivation, :currency, :custom_field, :custom_field_choice, :custom_field_datum, :delay, :department, :deposit, :deposit_line, :district, :document, :document_template, :entity, :entity_category, :entity_link, :entity_link_nature, :entity_nature, :establishment, :event, :event_nature, :financial_year, :inventory, :inventory_line, :invoice, :invoice_line, :journal, :journal_entry, :journal_entry_line, :land_parcel, :land_parcel_group, :land_parcel_kinship, :listing, :listing_node, :listing_node_item, :mandate, :observation, :operation, :operation_line, :operation_nature, :operation_use, :preference, :price, :product, :product_category, :product_component, :production_chain, :production_chain_conveyor, :production_chain_operation, :production_chain_operation_line, :production_chain_operation_use, :profession, :purchase_delivery, :purchase_delivery_line, :purchase_delivery_mode, :purchase_order, :purchase_order_line, :purchase_payment, :purchase_payment_mode, :purchase_payment_part, :role, :sale_delivery, :sale_delivery_line, :sale_delivery_mode, :sale_order, :sale_order_line, :sale_order_nature, :sale_payment, :sale_payment_mode, :sale_payment_part, :sequence, :stock, :stock_move, :stock_transfer, :subscription, :subscription_nature, :tax, :tax_declaration, :tool, :tracking, :tracking_state, :transfer, :transport, :unit, :user, :warehouse]

  # List of all references
  @@references = {
    :account => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :account_balance => {
      :account_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :financial_year_id => :financial_year,
      :updater_id => :user
    },
    :area => {
      :company_id => :company,
      :creator_id => :user,
      :district_id => :district,
      :updater_id => :user
    },
    :bank_statement => {
      :cash_id => :cash,
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :cash => {
      :account_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :currency_id => :currency,
      :entity_id => :entity,
      :journal_id => :journal,
      :updater_id => :user
    },
    :cash_transfer => {
      :company_id => :company,
      :creator_id => :user,
      :currency_id => :currency,
      :emitter_cash_id => :cash,
      :journal_entry_id => :journal_entry,
      :receiver_cash_id => :cash,
      :updater_id => :user
    },
    :company => {
      :creator_id => :user,
      :entity_id => :entity,
      :updater_id => :user
    },
    :contact => {
      :area_id => :area,
      :company_id => :company,
      :creator_id => :user,
      :entity_id => :entity,
      :updater_id => :user
    },
    :cultivation => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :currency => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :custom_field => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :custom_field_choice => {
      :company_id => :company,
      :creator_id => :user,
      :custom_field_id => :custom_field,
      :updater_id => :user
    },
    :custom_field_datum => {
      :choice_value_id => :custom_field_choice,
      :company_id => :company,
      :creator_id => :user,
      :custom_field_id => :custom_field,
      :entity_id => :entity,
      :updater_id => :user
    },
    :delay => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :department => {
      :company_id => :company,
      :creator_id => :user,
      :parent_id => :department,
      :updater_id => :user
    },
    :deposit => {
      :cash_id => :cash,
      :company_id => :company,
      :creator_id => :user,
      :journal_entry_id => :journal_entry,
      :mode_id => :sale_payment_mode,
      :responsible_id => :user,
      :updater_id => :user
    },
    :deposit_line => {
      :company_id => :company,
      :creator_id => :user,
      :deposit_id => :deposit,
      :updater_id => :user
    },
    :district => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :document => {
      :company_id => :company,
      :creator_id => :user,
      :owner_id => "owner_type",
      :template_id => :document_template,
      :updater_id => :user
    },
    :document_template => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :entity => {
      :attorney_account_id => :account,
      :category_id => :entity_category,
      :client_account_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :nature_id => :entity_nature,
      :payment_delay_id => :delay,
      :payment_mode_id => :sale_payment_mode,
      :proposer_id => :entity,
      :responsible_id => :user,
      :supplier_account_id => :account,
      :updater_id => :user
    },
    :entity_category => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :entity_link => {
      :company_id => :company,
      :creator_id => :user,
      :entity_1_id => :entity,
      :entity_2_id => :entity,
      :nature_id => :entity_link_nature,
      :updater_id => :user
    },
    :entity_link_nature => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :entity_nature => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :establishment => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :event => {
      :company_id => :company,
      :creator_id => :user,
      :entity_id => :entity,
      :nature_id => :event_nature,
      :responsible_id => :user,
      :updater_id => :user
    },
    :event_nature => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :financial_year => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :inventory => {
      :company_id => :company,
      :creator_id => :user,
      :journal_entry_id => :journal_entry,
      :responsible_id => :user,
      :updater_id => :user
    },
    :inventory_line => {
      :company_id => :company,
      :creator_id => :user,
      :inventory_id => :inventory,
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :invoice => {
      :client_id => :entity,
      :company_id => :company,
      :contact_id => :contact,
      :creator_id => :user,
      :currency_id => :currency,
      :journal_entry_id => :journal_entry,
      :origin_id => :invoice,
      :payment_delay_id => :delay,
      :sale_order_id => :sale_order,
      :updater_id => :user
    },
    :invoice_line => {
      :company_id => :company,
      :creator_id => :user,
      :entity_id => :entity,
      :invoice_id => :invoice,
      :order_line_id => :sale_order_line,
      :origin_id => :invoice_line,
      :price_id => :price,
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :journal => {
      :company_id => :company,
      :counterpart_id => :account,
      :creator_id => :user,
      :currency_id => :currency,
      :updater_id => :user
    },
    :journal_entry => {
      :company_id => :company,
      :creator_id => :user,
      :currency_id => :currency,
      :journal_id => :journal,
      :resource_id => "resource_type",
      :updater_id => :user
    },
    :journal_entry_line => {
      :account_id => :account,
      :bank_statement_id => :bank_statement,
      :company_id => :company,
      :creator_id => :user,
      :entry_id => :journal_entry,
      :journal_id => :journal,
      :updater_id => :user
    },
    :land_parcel => {
      :area_unit_id => :unit,
      :company_id => :company,
      :creator_id => :user,
      :group_id => :land_parcel_group,
      :updater_id => :user
    },
    :land_parcel_group => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :land_parcel_kinship => {
      :child_land_parcel_id => :land_parcel,
      :company_id => :company,
      :creator_id => :user,
      :parent_land_parcel_id => :land_parcel,
      :updater_id => :user
    },
    :listing => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :listing_node => {
      :company_id => :company,
      :creator_id => :user,
      :item_listing_id => :listing,
      :item_listing_node_id => :listing_node,
      :listing_id => :listing,
      :parent_id => :listing_node,
      :updater_id => :user
    },
    :listing_node_item => {
      :company_id => :company,
      :creator_id => :user,
      :node_id => :listing_node,
      :updater_id => :user
    },
    :mandate => {
      :company_id => :company,
      :creator_id => :user,
      :entity_id => :entity,
      :updater_id => :user
    },
    :observation => {
      :company_id => :company,
      :creator_id => :user,
      :entity_id => :entity,
      :updater_id => :user
    },
    :operation => {
      :company_id => :company,
      :creator_id => :user,
      :nature_id => :operation_nature,
      :responsible_id => :user,
      :target_id => "target_type",
      :updater_id => :user
    },
    :operation_line => {
      :area_unit_id => :unit,
      :company_id => :company,
      :creator_id => :user,
      :operation_id => :operation,
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :operation_nature => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :operation_use => {
      :company_id => :company,
      :creator_id => :user,
      :operation_id => :operation,
      :tool_id => :tool,
      :updater_id => :user
    },
    :preference => {
      :company_id => :company,
      :creator_id => :user,
      :record_value_id => "record_value_type",
      :updater_id => :user,
      :user_id => :user
    },
    :price => {
      :category_id => :entity_category,
      :company_id => :company,
      :creator_id => :user,
      :currency_id => :currency,
      :entity_id => :entity,
      :product_id => :product,
      :tax_id => :tax,
      :updater_id => :user
    },
    :product => {
      :category_id => :product_category,
      :company_id => :company,
      :creator_id => :user,
      :immobilizations_account_id => :account,
      :purchases_account_id => :account,
      :sales_account_id => :account,
      :subscription_nature_id => :subscription_nature,
      :unit_id => :unit,
      :updater_id => :user
    },
    :product_category => {
      :company_id => :company,
      :creator_id => :user,
      :parent_id => :product_category,
      :updater_id => :user
    },
    :product_component => {
      :company_id => :company,
      :component_id => :product_component,
      :creator_id => :user,
      :product_id => :product,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :production_chain => {
      :building_id => :warehouse,
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :production_chain_conveyor => {
      :company_id => :company,
      :creator_id => :user,
      :product_id => :product,
      :production_chain_id => :production_chain,
      :source_id => "source_type",
      :target_id => "target_type",
      :unit_id => :unit,
      :updater_id => :user
    },
    :production_chain_operation => {
      :company_id => :company,
      :creator_id => :user,
      :operation_nature_id => :operation_nature,
      :production_chain_id => :production_chain,
      :updater_id => :user
    },
    :production_chain_operation_line => {
      :company_id => :company,
      :creator_id => :user,
      :from_operation_line_id => :production_chain_operation_line,
      :operation_id => :operation,
      :product_id => :product,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :production_chain_operation_use => {
      :company_id => :company,
      :creator_id => :user,
      :operation_id => :operation,
      :tool_id => :tool,
      :updater_id => :user
    },
    :profession => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :purchase_delivery => {
      :company_id => :company,
      :contact_id => :contact,
      :creator_id => :user,
      :currency_id => :currency,
      :order_id => :purchase_order,
      :updater_id => :user
    },
    :purchase_delivery_line => {
      :company_id => :company,
      :creator_id => :user,
      :delivery_id => :purchase_delivery,
      :order_line_id => :purchase_order_line,
      :price_id => :price,
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :purchase_delivery_mode => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :purchase_order => {
      :company_id => :company,
      :creator_id => :user,
      :currency_id => :currency,
      :dest_contact_id => :contact,
      :journal_entry_id => :journal_entry,
      :supplier_id => :entity,
      :updater_id => :user
    },
    :purchase_order_line => {
      :account_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :order_id => :purchase_order,
      :price_id => :price,
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :purchase_payment => {
      :company_id => :company,
      :creator_id => :user,
      :journal_entry_id => :journal_entry,
      :mode_id => :purchase_payment_mode,
      :payee_id => :entity,
      :responsible_id => :user,
      :updater_id => :user
    },
    :purchase_payment_mode => {
      :cash_id => :cash,
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :purchase_payment_part => {
      :company_id => :company,
      :creator_id => :user,
      :expense_id => :purchase_order,
      :journal_entry_id => :journal_entry,
      :payment_id => :purchase_payment,
      :updater_id => :user
    },
    :role => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :sale_delivery => {
      :company_id => :company,
      :contact_id => :contact,
      :creator_id => :user,
      :currency_id => :currency,
      :invoice_id => :invoice,
      :mode_id => :sale_delivery_mode,
      :order_id => :sale_order,
      :transport_id => :transport,
      :transporter_id => :entity,
      :updater_id => :user
    },
    :sale_delivery_line => {
      :company_id => :company,
      :creator_id => :user,
      :delivery_id => :sale_delivery,
      :order_line_id => :sale_order_line,
      :price_id => :price,
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :sale_delivery_mode => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :sale_order => {
      :client_id => :entity,
      :company_id => :company,
      :contact_id => :contact,
      :creator_id => :user,
      :currency_id => :currency,
      :delivery_contact_id => :contact,
      :expiration_id => :delay,
      :invoice_contact_id => :contact,
      :journal_entry_id => :journal_entry,
      :nature_id => :sale_order_nature,
      :payment_delay_id => :delay,
      :responsible_id => :user,
      :transporter_id => :entity,
      :updater_id => :user
    },
    :sale_order_line => {
      :account_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :entity_id => :entity,
      :order_id => :sale_order,
      :price_id => :price,
      :product_id => :product,
      :reduction_origin_id => :sale_order_line,
      :tax_id => :tax,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :sale_order_nature => {
      :company_id => :company,
      :creator_id => :user,
      :expiration_id => :delay,
      :payment_delay_id => :delay,
      :payment_mode_id => :sale_payment_mode,
      :updater_id => :user
    },
    :sale_payment => {
      :company_id => :company,
      :creator_id => :user,
      :deposit_id => :deposit,
      :journal_entry_id => :journal_entry,
      :mode_id => :sale_payment_mode,
      :payer_id => :entity,
      :responsible_id => :user,
      :updater_id => :user
    },
    :sale_payment_mode => {
      :cash_id => :cash,
      :commission_account_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :depositables_account_id => :account,
      :updater_id => :user
    },
    :sale_payment_part => {
      :company_id => :company,
      :creator_id => :user,
      :expense_id => "expense_type",
      :journal_entry_id => :journal_entry,
      :payment_id => :sale_payment,
      :updater_id => :user
    },
    :sequence => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :stock => {
      :company_id => :company,
      :creator_id => :user,
      :origin_id => "origin_type",
      :product_id => :product,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :stock_move => {
      :company_id => :company,
      :creator_id => :user,
      :origin_id => "origin_type",
      :product_id => :product,
      :second_move_id => :stock_move,
      :second_warehouse_id => :warehouse,
      :stock_id => :stock,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :stock_transfer => {
      :company_id => :company,
      :creator_id => :user,
      :product_id => :product,
      :second_warehouse_id => :warehouse,
      :tracking_id => :tracking,
      :unit_id => :unit,
      :updater_id => :user,
      :warehouse_id => :warehouse
    },
    :subscription => {
      :company_id => :company,
      :contact_id => :contact,
      :creator_id => :user,
      :entity_id => :entity,
      :invoice_id => :invoice,
      :nature_id => :subscription_nature,
      :product_id => :product,
      :sale_order_id => :sale_order,
      :sale_order_line_id => :sale_order_line,
      :updater_id => :user
    },
    :subscription_nature => {
      :company_id => :company,
      :creator_id => :user,
      :entity_link_nature_id => :entity_link_nature,
      :updater_id => :user
    },
    :tax => {
      :account_collected_id => :account,
      :account_paid_id => :account,
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :tax_declaration => {
      :company_id => :company,
      :creator_id => :user,
      :financial_year_id => :financial_year,
      :journal_entry_id => :journal_entry,
      :updater_id => :user
    },
    :tool => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :tracking => {
      :company_id => :company,
      :creator_id => :user,
      :producer_id => :entity,
      :product_id => :product,
      :updater_id => :user
    },
    :tracking_state => {
      :company_id => :company,
      :creator_id => :user,
      :operation_id => :operation,
      :production_chain_operation_id => :production_chain_operation,
      :responsible_id => :user,
      :tracking_id => :tracking,
      :updater_id => :user
    },
    :transfer => {
      :company_id => :company,
      :creator_id => :user,
      :journal_entry_id => :journal_entry,
      :supplier_id => :entity,
      :updater_id => :user
    },
    :transport => {
      :company_id => :company,
      :creator_id => :user,
      :responsible_id => :user,
      :transporter_id => :entity,
      :updater_id => :user
    },
    :unit => {
      :company_id => :company,
      :creator_id => :user,
      :updater_id => :user
    },
    :user => {
      :company_id => :company,
      :creator_id => :user,
      :department_id => :department,
      :establishment_id => :establishment,
      :profession_id => :profession,
      :role_id => :role,
      :updater_id => :user
    },
    :warehouse => {
      :account_id => :account,
      :company_id => :company,
      :contact_id => :contact,
      :creator_id => :user,
      :establishment_id => :establishment,
      :parent_id => :warehouse,
      :product_id => :product,
      :unit_id => :unit,
      :updater_id => :user
    }
  }

end
