module RecordsHelper
  def Record::matchesSearch(snIn = "", productIn = "", supplierIn = "", statusIn = "", records = Record.all)
    if !snIn.empty?
      then records = records.serialNum(snIn)
    end
    if !productIn.empty?
      then records = records.product(productIn)
    end
    if !supplierIn.empty?
      then records = records.supplier(supplierIn)
    end
    if !statusIn.empty?
      then records = records.status(statusIn)
    end
    
    return records
  end
end
