class Record < ApplicationRecord
    
    scope :serialNum, -> (serialNum) { where serialNum: serialNum }
    scope :supplier, -> (supplier) { where supplier: supplier }
    scope :product, -> (product) { where product: product }
    scope :status, -> (status) { where status: status }
    
    before_update :log_changes
    after_initialize :set_defaults, unless: :persisted?
    
    validates :serialNum, length: {maximum: 16}
    validates :product, length: {maximum: 16}, presence: true
    validates :removalDate, presence: true
    validates :qn, presence: true
    validates :supplier, length: {maximum: 16}, presence: true
    validates :owner, length: {maximum: 16}
    validates :partNum, length: {maximum: 16}
    
    STATUSES = [ "Waiting to ship", "Shipped", "Received" ]
    
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
    
    def set_defaults
        self.fullChangelog = "All previous changes: "
        self.serialNum = "" if !self.serialNum
        self.removalDate = "" if !self.removalDate
        self.removalLocation = "" if !self.removalLocation
        self.program = "" if !self.program
        self.product = "" if !self.product
        self.partNum = "" if !self.partNum
        self.owner = "" if !self.owner 
        self.status = "" if !self.status 
        self.qn = "" if !self.qn
        self.d3QN = "" if !self.d3QN 
        self.v2QN = "" if !self.v2QN
        self.pwPO = "" if !self.pwPO
        self.utasPO = "" if !self.utasPO
        self.actionRequiredBy = "" if !self.actionRequiredBy
        self.removalReason = "" if !self.removalReason 
        self.comments = "" if !self.comments
        
    end
    
    def log_changes 
        if self.serialNum_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Serial number changed from:  " + 
                "#{self.serialNum_was}" + " to  " + "#{self.serialNum}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
    end
end