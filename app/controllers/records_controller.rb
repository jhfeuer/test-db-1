class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    @records = Record.all
    @records = @records.order(:product, :removalDate)

    convert_to_excel_option
  end
  
  # Resolved records kept around for future analysis/charts/etc
  def resolved
    @records = Record.where(resolved: true)
    @records = @records.order(:product, :removalDate)
    
    convert_to_excel_option
  end

  # Active refers to records that still need to be tracked
  def active
    @records = Record.where(resolved: false)
    @records = @records.order(:product, :removalDate)
    
    convert_to_excel_option
  end
  
  # Supports combined searches, excel export will export only the records in the current view (params persist)
  def search
    @records = Record.all.order(:product, :removalDate)
    if params.has_key? :record
      then @records = Record.matchesSearch(params[:record][:snQuery], 
                                           params[:record][:productQuery], 
                                           params[:record][:supplierQuery],
                                           params[:record][:statusQuery]).order(:product, :removalDate)
    end
    
    convert_to_excel_option
  end
  
  # GET /records/1
  # GET /records/1.json
  def show
  end

  # GET /records/new
  def new
    @record = Record.new
    @partNums = (Product.all.collect { |p| p.prodNum}).uniq.sort
    @partSuppliers = (Product.all.collect { |p| p.prodSupplier}).uniq.sort
    @partOwners = (Product.all.collect { |p| p.prodUTASowners}).uniq.sort
  end
  
  def narrow_choices
    @partNums = Product.numAssociatedWithPart(params[:product_choice]).collect{|p| p.prodNum}.uniq.sort
    @partSuppliers = Product.numAssociatedWithPart(params[:product_choice]).collect{|p| p.prodNum}.uniq.sort
    @partOwners = Product.numAssociatedWithPart(params[:product_choice]).collect{|p| p.prodNum}.uniq.sort
  end
  
  # GET /records/1/edit
  def edit
    @partNums = (Product.all.collect { |p| p.prodNum}).uniq.sort
    @partSuppliers = (Product.all.collect { |p| p.prodSupplier}).uniq.sort
    @partOwners = (Product.all.collect { |p| p.prodUTASowners}).uniq.sort
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Return information was successfully created.' }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /records/1
  # PATCH/PUT /records/1.json
  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @record, notice: 'Return information was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  # FIXME : Disallow permanent deletions (maybe)
  def destroy
    @record.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: 'Record was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_record
      @record = Record.find(params[:id])
    end
    
    def convert_to_excel_option
      respond_to do |format|
        format.html 
        # FIXME : C'mon Jacob, you can do better
        format.csv { render text: @records.to_csv( @records ) }
        format.xlsx do
          send_excel
        end
      end
    end
    
    # This converts the current set of records, @records, to an xlsx format, and sends it to the stream
    def send_excel
      p = Axlsx::Package.new
        wb = p.workbook
        wb.add_worksheet(name: "Records") do |sheet|
          sheet.add_row ["Serial Number", "Removal Date", "Removal Location", 
          "Program", "Product", "Part Number", "Supplier", "Owner", "Status", 
          "PW QN", "UTAS D3 QN", "UTAS V2 QN", "PW PO", "UTAS PO", 
          "Action Required", "Removal Reason", "Comments", "Resolved?"]
          @records.each do |record|
            sheet.add_row [record.serialNum, record.removalDate, 
              record.removalLocation, record.program, record.product, 
              record.partNum, record.supplier, record.owner, record.status, 
              record.qn, record.d3QN, record.v2QN, record.pwPO, record.utasPO, 
              record.actionRequiredBy, record.removalReason, record.comments, 
              record.resolved]
          end
        end
      
      # FIXME : Make filename change based on the view
      send_data p.to_stream.read, type: "application/xlsx", filename: "Returns_excel_export.xlsx"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:serialNum, :product, :partNum, 
      :removalDate, :owner, :status, :location, :resolveBy, :removalReason, 
      :comments, :supplier, :utasPO, :pwPO, :qn, :resolved, :removalLocation,
      :program, :d3QN, :v2QN, :actionRequiredBy)
    end
end
