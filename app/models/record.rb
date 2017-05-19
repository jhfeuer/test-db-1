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
    
    # These are the possible statuses supported in the form
    # FIXME : Allow users to add/subtract from this list
    STATUSES = [ "Waiting to ship", "Shipped", "Received" ]
    
    # This converts to csv with explicit column headings and each member explicit as well
    def self.to_csv(records = self.all, options = {})
        
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
            records.each do |record|
                csv << record.attributes.values_at(*cols_of_interest)
            end
        end
    end
    
    # defaults are set so the log_changes function does not break
    def set_defaults
        self.fullChangelog = ""
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
    
    # I tried to come up with a fancier/refactored way to do this but couldn't 
    # figure it out while still using _was
    # FIXME : Take a second look (use a helper that takes the 3 as arguments?)
    def log_changes 
        if self.comments_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Comments " +  
                " updated on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.removalReason_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Removal reason " +  
                " updated on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.actionRequiredBy_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Action Required " +  
                " updated on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.utasPO_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>UTAS PO changed from:  " + 
                "#{self.utasPO_was}" + "     to  " + "#{self.utasPO}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.pwPO_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>PW PO changed from:  " + 
                "#{self.pwPO_was}" + "    to  " + "#{self.pwPO}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.v2QN_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>UTAS V2 QN changed from:  " + 
                "#{self.v2QN_was}" + "    to  " + "#{self.v2QN}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.d3QN_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>UTAS D3 QN changed from:  " + 
                "#{self.d3QN_was}" + "    to  " + "#{self.d3QN}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.qn_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>PW QN changed from:  " + 
                "#{self.qn_was}" + "    to  " + "#{self.qn}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.status_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Status changed from:  " + 
                "#{self.status_was}" + "    to  " + "#{self.status}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.owner_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Owner changed from:  " + 
                "#{self.owner_was}" + "    to  " + "#{self.owner}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.product_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Product changed from:  " + 
                "#{self.product_was}" + "    to  " + "#{self.product}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.program_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Program changed from:  " + 
                "#{self.program_was}" + "    to  " + "#{self.program}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.removalLocation_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Removal location changed from:  " + 
                "#{self.removalLocation_was}" + "    to  " + "#{self.removalLocation}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.removalDate_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Removal date changed from:  " + 
                "#{self.removalDate_was}" + "    to  " + "#{self.removalDate}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
        if self.serialNum_changed?
            then 
                timeNow = Time.now
                self.fullChangelog = "<br>Serial number changed from:  " + 
                "#{self.serialNum_was}" + "    to  " + "#{self.serialNum}" + 
                " on " + "#{timeNow.month} / " + 
                "#{timeNow.day} / " + "#{timeNow.year} " + "</br>" +
                "#{self.fullChangelog}"
        end
    end
end