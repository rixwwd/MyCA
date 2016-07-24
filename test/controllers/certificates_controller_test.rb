require 'test_helper'

class CertificatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @certificate = certificates(:one)
  end

  test "should get index" do
    get certificates_url
    assert_response :success
  end

  test "should get new" do
    get new_certificate_url
    assert_response :success
  end

  test "should create certificate" do
    assert_difference('Certificate.count') do
      post certificates_url, params: { certificate: { ca: @certificate.ca, common_name: @certificate.common_name, country: @certificate.country, locality: @certificate.locality, not_after: @certificate.not_after, not_before: @certificate.not_before, organization_unit: @certificate.organization_unit, ornanization: @certificate.ornanization, state: @certificate.state
         } }
    end

    assert_redirected_to certificate_url(Certificate.last)
  end

  test "should show certificate" do
    get certificate_url(@certificate)
    assert_response :success
  end

  test "should destroy certificate" do
    assert_difference('Certificate.count', -1) do
      delete certificate_url(@certificate)
    end

    assert_redirected_to certificates_url
  end
end
