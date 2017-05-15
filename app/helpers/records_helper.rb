module RecordsHelper
  def Record::matchesSearch(snIn = nil, productIn = nil, supplierIn = nil)
    if !snIn.empty? && !productIn.empty? && !supplierIn.empty?
      then return Record.where(serialNum: snIn, product: productIn, supplier: supplierIn)
    elsif !productIn.empty? && !supplierIn.empty?
      then return Record.where(product: productIn, supplier: supplierIn)
    elsif !snIn.empty? && !supplierIn.empty?
      then return Record.where(serialNum: sn_in, supplier: supplierIn)
    elsif !snIn.empty? && !productIn.empty?
      then return Record.where(serialNum: snIn, product: productIn)
    elsif !snIn.empty?
      then return Record.where(serialNum: snIn)
    elsif !productIn.empty?
      then return Record.where(product: productIn)
    elsif !supplierIn.empty?
      then return Record.where(supplier: supplierIn)
    else return Record.all
    end
  end
  
end
