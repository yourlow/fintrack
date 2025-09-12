class ShortcutKeysController < ApplicationController
  before_action :set_shortcut_key, only: %i[ edit update destroy ]

  # GET /shortcut_keys or /shortcut_keys.json
  def index
    @shortcut_keys = ShortcutKey.all
  end

  # GET /shortcut_keys/1 or /shortcut_keys/1.json
  def show
    @shortcut_key = ShortcutKey.preload(shortcut_entries: :account).find(params.expect(:id))
  end

  # GET /shortcut_keys/new
  def new
    @accounts = Account.all

    @shortcut_key = ShortcutKey.new
  end

  # GET /shortcut_keys/1/edit
  def edit
  @accounts = Account.all
  end

  # POST /shortcut_keys or /shortcut_keys.json
  def create
    @shortcut_key = ShortcutKey.new(shortcut_key_params)

    respond_to do |format|
      if @shortcut_key.save
        format.html { redirect_to @shortcut_key, notice: "Shortcut key was successfully created." }
        format.json { render :show, status: :created, location: @shortcut_key }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @shortcut_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shortcut_keys/1 or /shortcut_keys/1.json
  def update
    respond_to do |format|
      if @shortcut_key.update(shortcut_key_params)
        format.html { redirect_to @shortcut_key, notice: "Shortcut key was successfully updated." }
        format.json { render :show, status: :ok, location: @shortcut_key }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shortcut_key.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shortcut_keys/1 or /shortcut_keys/1.json
  def destroy
    @shortcut_key.destroy!

    respond_to do |format|
      format.html { redirect_to shortcut_keys_path, status: :see_other, notice: "Shortcut key was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shortcut_key
      @shortcut_key = ShortcutKey.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def shortcut_key_params
      params.require(:shortcut_key).permit(
            :name,
            :combination,
            shortcut_entries_attributes: [
              :id,
              :account_id,
              :entry_type,
              :_destroy
            ]
          )
    end
end
