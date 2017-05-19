class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy]

  # GET /records
  # GET /records.json
  def index
    @records = Record.all
    @records = @records.order(:product, :removalDate)

    convert_to_excel_option
  end
  
  def resolved
    @records = Record.where(resolved: true)
    @records = @records.order(:product, :removalDate)
    
    convert_to_excel_option
  end

  def active
    @records = Record.where(resolved: false)
    @records = @records.order(:product, :removalDate)
    
    convert_to_excel_option
  end
  
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
  end

  # GET /records/1/edit
  def edit
  end

  # POST /records
  # POST /records.json
  def create
    @record = Record.new(record_params)

    respond_to do |format|
      if @record.save
        format.html { redirect_to @record, notice: 'Record was successfully created.' }
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
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
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
        format.csv { render text: @records.to_csv }
        format.xlsx do
          send_excel
        end
      end
    end
    
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
      send_data p.to_stream.read, type: "application/xlsx", filename: "filename.xlsx"
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def record_params
      params.require(:record).permit(:serialNum, :product, :partNum, 
      :removalDate, :owner, :status, :location, :resolveBy, :removalReason, 
      :comments, :supplier, :utasPO, :pwPO, :qn, :resolved, :removalLocation,
      :program, :d3QN, :v2QN, :actionRequiredBy)
    end
end
