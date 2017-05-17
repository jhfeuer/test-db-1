json.array!(@products) do |product|
  json.extract! product, :id, :prodName, :prodNum, :prodSupplierNum, :prodUTASowners, :prodSupplier
  json.url product_url(product, format: :json)
end
