require 'csv'
 
CSV.generate do |csv|
  csv_column_names = ["productno","lotno","producttype","steeltype","size","quantity"]
  csv << csv_column_names
  @receptions.each do |reception|
    csv_column_values = [
      reception.productno,
      reception.lotno,
      reception.producttype,
      reception.steeltype,
      reception.size,
      reception.quantity
    ]
    csv << csv_column_values
  end
end