require 'openssl'

class Certificate < ApplicationRecord

  belongs_to :ca

  validates :country, length:{is:2}
  validates :organization, length:{maximum: 64}, allow_blank: true
  validates :organization_unit, length:{maximum: 64}, allow_blank: true
  validates :common_name, length:{minimum: 1, maximum: 64}
  validates :state, length:{maximum: 64}, allow_blank: true
  validates :locality, length:{maximum: 64}, allow_blank: true

  validates :not_before, presence: true
  validates :not_after, presence: true

  validates_associated :ca

  def generate_key_pair
    rsa = OpenSSL::PKey::RSA.generate(2048)
    self.private_key = rsa.to_pem

    @key_pair = rsa
  end

  def generate_csr
    csr = OpenSSL::X509::Request.new
    csr.subject = subject()
    csr.public_key = @key_pair.public_key
    csr.sign(@key_pair, "SHA256")
  end

  def create_certificate(csr)
    cert = ca.sign(csr, self.not_before, self.not_after)

    self.certificate = cert.to_pem
    self.not_after = cert.not_after
    self.not_before = cert.not_before
    self.serial = cert.serial.to_i
  end

  def set_param_from_csr(csr)
    dn_map = csr.subject.to_a.map{|x| [x[0], x[1]]}.to_h
    self.country = dn_map["C"]
    self.organization = dn_map["O"]
    self.organization_unit = dn_map["OU"]
    self.common_name = dn_map["CN"]
    self.state = dn_map["ST"]
    self.locality = dn_map["L"]
  end

private
  def subject
    subject = OpenSSL::X509::Name.new()
    subject.add_entry("C", self.country) if self.country.present?
    subject.add_entry("O", self.organization) if self.organization.present?
    subject.add_entry("OU", self.organization_unit) if self.organization_unit.present?
    subject.add_entry("CN", self.common_name) if self.common_name.present?
    subject.add_entry("ST", self.state) if self.state.present?
    subject.add_entry("L", self.locality) if self.locality.present?
    subject
  end

end
