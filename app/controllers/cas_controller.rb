class CasController < ApplicationController
  before_action :set_ca, only: [:show, :destroy]

  # GET /cas
  # GET /cas.json
  def index
    @cas = Ca.all
  end

  # GET /cas/1
  # GET /cas/1.json
  def show
  end

  # GET /cas/new
  def new
    @ca = Ca.new
  end

  # POST /cas
  # POST /cas.json
  def create
    @ca = Ca.new(ca_params)

    @ca.generate_key_pair
    @ca.generate_certificate

    respond_to do |format|
      if @ca.save
        format.html { redirect_to @ca, notice: 'Ca was successfully created.' }
        format.json { render :show, status: :created, location: @ca }
      else
        format.html { render :new }
        format.json { render json: @ca.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cas/1
  # DELETE /cas/1.json
  def destroy
    @ca.destroy
    respond_to do |format|
      format.html { redirect_to cas_url, notice: 'Ca was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ca
      @ca = Ca.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ca_params
      params.require(:ca).permit(:country, :organization, :organization_unit, :common_name, :state, :locality, :not_before, :not_after)
    end
end
