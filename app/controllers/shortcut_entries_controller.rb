class ShortcutEntriesController < ApplicationController
  before_action :set_shortcut_entry, only: %i[ show edit update destroy ]

  # GET /shortcut_entries or /shortcut_entries.json
  def index
    @shortcut_entries = ShortcutEntry.all
  end

  # GET /shortcut_entries/1 or /shortcut_entries/1.json
  def show
  end

  # GET /shortcut_entries/new
  def new
    @accounts = Account.all

    @shortcut_entry = ShortcutEntry.new
  end

  # GET /shortcut_entries/1/edit
  def edit
  end

  # POST /shortcut_entries or /shortcut_entries.json
  def create
    @shortcut_entry = ShortcutEntry.new(shortcut_entry_params)

    respond_to do |format|
      if @shortcut_entry.save
        format.html { redirect_to @shortcut_entry, notice: "Shortcut entry was successfully created." }
        format.json { render :show, status: :created, location: @shortcut_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shortcut_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shortcut_entries/1 or /shortcut_entries/1.json
  def update
    respond_to do |format|
      if @shortcut_entry.update(shortcut_entry_params)
        format.html { redirect_to @shortcut_entry, notice: "Shortcut entry was successfully updated." }
        format.json { render :show, status: :ok, location: @shortcut_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shortcut_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shortcut_entries/1 or /shortcut_entries/1.json
  def destroy
    @shortcut_entry.destroy!

    respond_to do |format|
      format.html { redirect_to shortcut_entries_path, status: :see_other, notice: "Shortcut entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortcut_entry
      @shortcut_entry = ShortcutEntry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def shortcut_entry_params
      params.expect(shortcut_entry: [ :shortcut_key_id, :account_id, :entry_type ])
    end
end
