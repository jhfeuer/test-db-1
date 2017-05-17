class Record < ApplicationRecord
    
    scope :serialNum, -> (serialNum) { where serialNum: serialNum }
    scope :supplier, -> (supplier) { where supplier: supplier }
    scope :product, -> (product) { where product: product }
    scope :status, -> (status) { where status: status }
    
    validates :serialNum, length: {maximum: 16}, presence: true
    validates :product, length: {maximum: 16}, presence: true
    validates :removalDate, presence: true
    validates :supplier, length: {maximum: 16}, presence: true
    validates :owner, length: {maximum: 16}, presence: true
    validates :partNum, length: {maximum: 16}, presence: true
    
    STATUSES = [ "Waiting to ship", "Shipped", "Received" ]
    PRODUCTS = { foo: "Foo bar", boo: "Boo far" }
    
    # This converts to csv with explicit column headings and each member explicit as well
    def self.to_csv(options = {})
        
        all_headers = Array.[]("Serial Number", "Removal Date", 
        "Removal Location", "Program", "Product", "Part Number", "Supplier", 
        "Owner", "Status", "PW QN", "UTAS D3 QN", "UTAS V2 QN", "PW PO", "UTAS PO", 
        "Action Required", "Removal Reason", "Comments", "Resolved?")
        
        cols_of_interest = Array.[]('serialNum', 'removalDate', 'removalLocation', 
        'program', 'product', 'partNum', 'supplier', 'owner', 'status', 'pwQN', 
        'd3QN', 'v2QN', 'pwPO', 'utasPO', 'actionReq', 'removalReason', 
        'comments', 'resolved')
        
        CSV.generate(options) do |csv|
            csv << all_headers
            all.each do |record|
                csv << record.attributes.values_at(*cols_of_interest)
            end
        end
    end
end