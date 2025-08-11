require "csv"

class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    curr = params["curr"]

    if curr.blank?
      @current = OrderedTransaction.first

    else
      @current = OrderedTransaction.find_by(computed_index: curr.to_i)
    end
    @transactions = OrderedTransaction.window(@current.computed_index.to_i)
  end

  def frame
    curr = params["curr"]

    if curr.blank?
      @current = OrderedTransaction.first

    else
      @current = OrderedTransaction.find_by(computed_index: curr.to_i)
    end

    @transactions = OrderedTransaction.window(@current.computed_index.to_i)

    render partial: "transactions/transaction_table", locals: { transactions: @transactions, current: @current }
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to @transaction, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to @transaction, notice: "Transaction was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_path, status: :see_other, notice: "Transaction was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def bulk_upload
    return unless request.post?

    if params[:file].blank?
      redirect_to bulk_upload_transactions_path, alert: "Please choose a CSV file."
      return
    end


    file = params[:file]
    created = 0

    begin
      ActiveRecord::Base.transaction do
        line_no = 1 # header row
        CSV.foreach(file.path, headers: true, encoding: "bom|utf-8") do |row|
          line_no += 1
          next if row.to_h.values.all?(&:blank?)

          amount_cents = parse_amount_to_cents(row["Amount"])
          raise StandardError, "Invalid amount on line #{line_no}: #{row['Amount'].inspect}" if amount_cents.nil?
          # debugger
          tx_date = Date.strptime(row["Date"].strip, "%m/%d/%Y")
          raise StandardError, "Invalid date on line #{line_no}: #{row['Date'].inspect}" if tx_date.nil?

          desc = row["Transaction"].to_s.strip
          raise StandardError, "Missing description on line #{line_no}" if desc.blank?

          Transaction.create!(
            raw_description:  desc,
            user_description: nil,
            amount:           amount_cents,
            transaction_date: tx_date,
          )

          created += 1
        end

        raise StandardError, "CSV contained no importable rows." if created.zero?
      end

      redirect_to transactions_path, notice: "Imported #{created} transaction(s)."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to bulk_upload_transactions_path,
        alert: "Import aborted. Validation failed: #{e.record.errors.full_messages.to_sentence}"
    rescue CSV::MalformedCSVError => e
      redirect_to bulk_upload_transactions_path, alert: "CSV parsing error: #{e.message}"
    rescue StandardError => e
      redirect_to bulk_upload_transactions_path, alert: "Import aborted. #{e.message}"
    end
  end


  private

  # Converts strings like "-$250.00", "$1,234.56", "1,234.56-", "(1,234.56)" to integer cents.
  def parse_amount_to_cents(str)
    return nil if str.blank?

    s = str.strip
    neg = false

    # Handle parentheses for negatives "(123.45)"
    if s.start_with?("(") && s.end_with?(")")
      neg = true
      s = s[1..-2]
    end

    # Handle trailing minus "123.45-"
    if s.end_with?("-")
      neg = true
      s = s[0..-2]
    end

    # Remove currency symbols and thousands separators
    s = s.gsub(/[,$\s]/, "")

    # Handle leading negative like "-123.45" or "-$123.45"
    if s.start_with?("-")
      neg = true
      s = s[1..]
    end

    # At this point s should be digits with optional decimal
    return nil unless s.match?(/\A\d+(\.\d{1,2})?\z/)

    cents = (BigDecimal(s) * 100).to_i
    neg ? -cents : cents
  rescue ArgumentError
    nil
  end


  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.expect(transaction: [ :raw_description, :user_description, :amount, :balanced ])
  end
end
