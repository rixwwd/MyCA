require 'openssl'

class Ca < ApplicationRecord

  has_many :certificates, dependent: :delete_all

  validates :country, length:{is:2}
  validates :organization, length:{maximum: 64}, allow_blank: true
  validates :organization_unit, length:{maximum: 64}, allow_blank: true
  validates :common_name, length:{minimum: 1, maximum: 64}
  validates :state, length:{maximum: 64}, allow_blank: true
  validates :locality, length:{maximum: 64}, allow_blank: true

  validates :not_before, presence: true
  validates :not_after, presence: true

  def generate_key_pair
    rsa = OpenSSL::PKey::RSA.generate(2048)
    self.private_key = rsa.to_pem

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
    cert.sign(@key_pair, "SHA256")

    self.serial = 2
    self.certificate = cert
  end

  def sign(csr, not_before, not_after)
    ca_private_key = OpenSSL::PKey::RSA.new(self.private_key)

    cert = OpenSSL::X509::Certificate.new
    cert.issuer = subject
    cert.subject = csr.subject
    cert.serial = Ca.update_serial(self.id)
    cert.public_key = csr.public_key
    cert.not_before = not_before
    cert.not_after = not_after
    cert.sign(ca_private_key, "SHA256")
    cert
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

  def self.update_serial(id)
    s = 0
    Ca.transaction do
      ca = Ca.lock.find(id)
      s = ca.serial
      ca.serial = s + 1
      ca.save
    end
    s
  end
end
