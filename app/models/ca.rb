require 'openssl'

class Ca < ApplicationRecord

  has_many :certificates

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

  def generate_certificate
    subject = subject()
    cert = OpenSSL::X509::Certificate.new
    cert.issuer = subject
    cert.subject = subject
    cert.serial = 1
    cert.public_key = @key_pair.public_key
    cert.not_before = self.not_before.to_time
    cert.not_after = self.not_after.to_time
    cert.sign(@key_pair, self.signature_algorithm)

    self.certificate = cert
  end

  def sign(csr)
    ca_private_key = OpenSSL::PKey::RSA.new(self.private_key)

    cert = OpenSSL::X509::Certificate.new
    cert.issuer = subject
    cert.subject = csr.subject
    cert.serial = self.serial
    cert.public_key = csr.public_key
    cert.not_before = Time.now
    cert.not_after = cert.not_before + 2.years
    cert.sign(ca_private_key, self.signature_algorithm)
    cert
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
