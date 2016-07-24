require 'openssl'

class Certificate < ApplicationRecord

  belongs_to :ca

  validates :country, length:{is:2}
  validates :organization, length:{maximum: 64}
  validates :organization_unit, length:{maximum: 64}
  validates :common_name, length:{minimum: 1, maximum: 64}
  validates :state, length:{maximum: 64}
  validates :locality, length:{maximum: 64}

  def generate_key_pair
    rsa = OpenSSL::PKey::RSA.generate(2048)
    self.private_key = rsa.to_pem
    self.public_key = rsa.public_key.to_pem

    @key_pair = rsa
  end

  def generate_csr
    csr = OpenSSL::X509::Request.new
    csr.subject = subject()
    csr.public_key = @key_pair.public_key
    csr.sign(@key_pair, "SHA256")
  end

  def create_certificate(csr)
    cert = ca.sign(csr)

    self.certificate = cert.to_pem
    self.not_after = cert.not_after
    self.not_before = cert.not_before
    self.serial = cert.serial.to_i
    self.signature_algorithm = cert.signature_algorithm
  end

  def set_param_from_csr(csr)
    dn_map = csr.subject.to_a.map{|x| [x[0], x[1]]}.to_h
    byebug
    self.country = dn_map["C"]
    self.organization = dn_map["O"]
    self.organization_unit = dn_map["OU"]
    self.common_name = dn_map["CN"]
    self.state = dn_map["ST"]
    self.locality = dn_map["L"]
    self.public_key = csr.public_key
  end

private
  def subject
    subject = OpenSSL::X509::Name.new(
      [["C", self.country],
       ["O", self.organization],
       ["OU", self.organization_unit],
       ["CN", self.common_name],
       ["ST", self.state],
       ["L", self.locality]])
    subject
  end

end
