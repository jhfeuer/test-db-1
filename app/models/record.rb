class Record < ApplicationRecord
    validates :serialNum, presence: true
    validates :product, presence: true
    validates :removalDate, presence: true
    validates :supplier, presence: true
    validates :partNum, presence: true
    
    def self.to_csv(options = {})
        all_headers = Array.[]("Serial Number", "Product", "Part Number", "Removal Date", "Owner", "Status", "Location", "Resolve by", "Removal Reason", "Comments", "Supplier", "PW PO", "UTAS PO", "QN", "Resolved?")
        cols_of_interest = Array.[]('serialNum', 'product', 'partNum', 'removalDate', 'owner', 'status', 'location', 'resolveBy', 'removalReason', 'comments', 'supplier', 'pwPO', 'utasPO', 'qn', 'resolved')
        CSV.generate(options) do |csv|
            csv << all_headers
            all.each do |record|
                csv << record.attributes.values_at(*cols_of_interest)
            end
        end
    end
    
end