require "csv"

class TransactionsController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_transaction, only: %i[ show edit update destroy shortcut ]

  # GET /transactions or /transactions.json
  def index
      @accounts = Account.all

    curr = params["curr"]

    if curr.blank?
      @current = Transaction.pending.ordered.first

    else
      @current = Transaction.find(curr)
    end


    @prev = @current.prev
    @next = @current.next

    @transactions = Transaction.ordered
    .where("transaction_date > :d OR (transaction_date = :d AND id >= :i)",
           d: @current.transaction_date, i: @current.id)
    .limit(5)
  end

  def frame
    @accounts = Account.all
    curr = params["curr"]

    if curr.blank?
      @current = Transaction.pending.ordered.first

    else
      @current = Transaction.find(curr)
    end


    @prev = @current.prev
    @next = @current.next
    @transactions = Transaction.ordered
    .where("transaction_date > :d OR (transaction_date = :d AND id >= :i)",
           d: @current.transaction_date, i: @current.id)
    .limit(5)
    render partial: "transactions/transaction_table", locals: { transactions: @transactions, current: @current, prev: @prev, next: @next }
  end

  # GET /transactions/shortcut
  def shortcut
        @accounts = Account.all

    tx_params = params.require(:transaction).permit(
    :transaction_date,
    :raw_description,
    :user_description,
    :amount,
    entries_attributes: [
      :id,
      :account_id,
      :entry_type,
      :amount,
      :_destroy
    ])
    if tx_params[:amount].present?
      tx_params[:amount] = (BigDecimal(tx_params[:amount]) * 100).to_i
    end

    if tx_params[:entries_attributes]
      tx_params[:entries_attributes].each do |_, entry|
        if entry[:amount].present?
            entry[:amount] = (BigDecimal(entry[:amount], 4) * 100).to_i
        end
      end
    end

    @transaction.assign_attributes(tx_params)

   respond_to do |format|
    format.turbo_stream do
      render turbo_stream: turbo_stream.replace(
        dom_id(@transaction, :form),
        partial: "transactions/form",
        locals: { transaction: @transaction, accounts: @accounts }
      )
    end
  end
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
    tx_params = params.require(:transaction).permit(
    :transaction_date,
    :raw_description,
    :user_description,
    :amount,
    entries_attributes: [
      :id,
      :account_id,
      :entry_type,
      :amount,
      :_destroy
    ])

    if tx_params[:amount].present?
      tx_params[:amount] = (BigDecimal(tx_params[:amount]) * 100).to_i
    end

    if tx_params[:entries_attributes]
      tx_params[:entries_attributes].each do |_, entry|
        if entry[:amount].present?
            entry[:amount] = (BigDecimal(entry[:amount], 4) * 100).to_i
        end
      end
    end

    @transaction.update(tx_params)
    @accounts = Account.all

    @current = @transaction.next
    @prev = @current.prev
    @next = @current.next
    @transactions = Transaction.ordered
    .where("transaction_date > :d OR (transaction_date = :d AND id >= :i)",
           d: @current.transaction_date, i: @current.id)
    .limit(5)
    render turbo_stream: turbo_stream.replace(
      "transaction_table",
      partial: "transactions/transaction_table",
      locals: { transactions: @transactions, current: @current, prev: @prev, next: @next }
    )
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

          amount = parse_amount(row["Amount"])
          raise StandardError, "Invalid amount on line #{line_no}: #{row['Amount'].inspect}" if amount.nil?
          # debugger
          tx_date = Date.strptime(row["Date"].strip, "%m/%d/%Y")
          raise StandardError, "Invalid date on line #{line_no}: #{row['Date'].inspect}" if tx_date.nil?

          desc = row["Transaction"].to_s.strip
          raise StandardError, "Missing description on line #{line_no}" if desc.blank?

          Transaction.create!(
            raw_description:  desc,
            user_description: nil,
            amount:           amount,
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

  def parse_amount(str)
    return nil if str.blank?

    s = str.strip
    neg = false

    # Handle parentheses "(123.45)"
    if s.start_with?("(") && s.end_with?(")")
      neg = true
      s = s[1..-2]
    end

    # Handle trailing minus "123.45-"
    if s.end_with?("-")
      neg = true
      s = s[0..-2]
    end

    # Remove $ and commas
    s = s.gsub(/[,$\s]/, "")

    # Handle leading negative
    if s.start_with?("-")
      neg = true
      s = s[1..]
    end

    # Only accept digits + optional .xx
    return nil unless s.match?(/\A\d+(\.\d{1,2})?\z/)

    # Convert to cents
    amount = (BigDecimal(s) * 100).to_i
    neg ? -amount : amount
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
