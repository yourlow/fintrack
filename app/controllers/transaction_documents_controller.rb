class TransactionDocumentsController < ApplicationController
  before_action :set_transaction_document, only: %i[ show edit update destroy ]

  # GET /transaction_documents or /transaction_documents.json
  def index
    @transaction_documents = TransactionDocument.all
  end

  # GET /transaction_documents/1 or /transaction_documents/1.json
  def show
  end

  # GET /transaction_documents/new
  def new
    @transaction_document = TransactionDocument.new
  end

  # GET /transaction_documents/1/edit
  def edit
  end

  # POST /transaction_documents or /transaction_documents.json
  def create
    @transaction_document = TransactionDocument.new(transaction_document_params)

    respond_to do |format|
      if @transaction_document.save
        format.html { redirect_to @transaction_document, notice: "Transaction document was successfully created." }
        format.json { render :show, status: :created, location: @transaction_document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_documents/1 or /transaction_documents/1.json
  def update
    respond_to do |format|
      if @transaction_document.update(transaction_document_params)
        format.html { redirect_to @transaction_document, notice: "Transaction document was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction_document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_documents/1 or /transaction_documents/1.json
  def destroy
    @transaction_document.destroy!

    respond_to do |format|
      format.html { redirect_to transaction_documents_path, status: :see_other, notice: "Transaction document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_document
      @transaction_document = TransactionDocument.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def transaction_document_params
      params.expect(transaction_document: [ :transaction_id, :filepath, :description, :created_at, :uploaded_at ])
    end
end
