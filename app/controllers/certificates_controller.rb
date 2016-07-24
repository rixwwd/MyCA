require 'openssl'

class CertificatesController < ApplicationController
  before_action :set_ca
  before_action :set_certificate, only: [:show, :destroy]

  # GET /certificates
  # GET /certificates.json
  def index
    @certificates = @ca.certificates.all
  end

  # GET /certificates/1
  # GET /certificates/1.json
  def show
  end

  # GET /certificates/new
  def new
    @certificate = Certificate.new
  end

  # POST /certificates
  # POST /certificates.json
  def create
    @certificate = @ca.certificates.build(certificate_params)

    @certificate.generate_key_pair
    csr = @certificate.generate_csr
    @certificate.create_certificate(csr)

    respond_to do |format|
      if @certificate.save
        format.html { redirect_to [@ca, @certificate], notice: 'Certificate was successfully created.' }
        format.json { render :show, status: :created, location: @certificate }
      else
        format.html { render :new }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /certificates/upload_csr
  def upload_csr
  end

  # POST /certificates/csr
  def csr
    @certificate = @ca.certificates.build()
    csr = OpenSSL::X509::Request.new(params[:csr])
    @certificate.create_certificate(csr)
    @certificate.set_param_from_csr(csr)
    if @certificate.save
      redirect_to [@ca, @certificate], notice: 'Certificate was successfully created.'
    else
      byebug
      render :upload_csr
    end
  end

  # DELETE /certificates/1
  # DELETE /certificates/1.json
  def destroy
    @certificate.destroy
    respond_to do |format|
      format.html { redirect_to ca_certificates_url, notice: 'Certificate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_ca
      @ca = Ca.find(params[:ca_id])
    end

    def set_certificate
      @certificate = Certificate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def certificate_params
      params.require(:certificate).permit(:country, :organization, :organization_unit, :common_name, :state, :locality, :serial, :not_before, :not_after, :signature_algorithm)
    end

end
