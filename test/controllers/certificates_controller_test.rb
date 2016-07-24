require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ca = cas(:one)
    @certificate = certificates(:one)
  end

  test "should get index" do
    get ca_certificates_url(@ca)
    assert_response :success
  end

  test "should get new" do
    get new_ca_certificate_url(@ca)
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      post ca_certificates_url(@ca), params: { certificate: { ca: @certificate.ca, common_name: @certificate.common_name, country: @certificate.country, locality: @certificate.locality, not_after: @certificate.not_after, not_before: @certificate.not_before, organization_unit: @certificate.organization_unit, organization: @certificate.organization, state: @certificate.state
         } }
    end

    assert_redirected_to ca_certificate_url(@ca, Certificate.last)
  end

  test "should show certificate" do
    get ca_certificate_url(@ca, @certificate)
    assert_response :success
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete ca_certificate_url(@ca, @certificate)
    end

    assert_redirected_to ca_certificates_url(@ca)
  end
end
