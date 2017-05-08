json.array!(@records) do |record|
  json.extract! record, :id, :serialNum, :product, :partNum, :removalDate, :owner, :status, :location, :resolveBy, :removalReason, :comments, :supplier, :utasPO, :pwPO, :qn, :resolved
  json.url record_url(record, format: :json)
end
