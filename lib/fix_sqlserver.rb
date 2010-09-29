# Autogenerated from Ekylibre (`rake clean:fix_sqlserver` or `rake clean`)
if ActiveRecord::Base.connection.adapter_name.lower == 'sqlserver'
  BankStatement.coerce_sqlserver_date :started_on, :stopped_on
  Company.coerce_sqlserver_date :born_on
  Cultivation.coerce_sqlserver_date :started_on, :stopped_on
  CustomFieldDatum.coerce_sqlserver_date :date_value
  Deposit.coerce_sqlserver_date :created_on
  Entity.coerce_sqlserver_date :born_on, :dead_on, :first_met_on
  EntityLink.coerce_sqlserver_date :started_on, :stopped_on
  FinancialYear.coerce_sqlserver_date :started_on, :stopped_on
  Inventory.coerce_sqlserver_date :created_on
  Invoice.coerce_sqlserver_date :created_on, :payment_on
  Journal.coerce_sqlserver_date :closed_on
  JournalEntry.coerce_sqlserver_date :created_on, :printed_on
  JournalEntryLine.coerce_sqlserver_date :expired_on
  LandParcel.coerce_sqlserver_date :started_on, :stopped_on
  Mandate.coerce_sqlserver_date :started_on, :stopped_on
  Operation.coerce_sqlserver_date :moved_on, :planned_on
  PurchaseDelivery.coerce_sqlserver_date :moved_on, :planned_on
  PurchaseOrder.coerce_sqlserver_date :created_on, :moved_on, :planned_on
  PurchasePayment.coerce_sqlserver_date :created_on, :paid_on, :to_bank_on
  SaleDelivery.coerce_sqlserver_date :moved_on, :planned_on
  SaleOrder.coerce_sqlserver_date :confirmed_on, :created_on, :expired_on
  SalePayment.coerce_sqlserver_date :created_on, :paid_on, :to_bank_on
  StockMove.coerce_sqlserver_date :moved_on, :planned_on
  StockTransfer.coerce_sqlserver_date :moved_on, :planned_on
  Subscription.coerce_sqlserver_date :started_on, :stopped_on
  TaxDeclaration.coerce_sqlserver_date :declared_on, :paid_on, :started_on, :stopped_on
  Transfer.coerce_sqlserver_date :created_on, :started_on, :stopped_on
  Transport.coerce_sqlserver_date :created_on, :transport_on
  User.coerce_sqlserver_date :arrived_on, :departed_on
end
