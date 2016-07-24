require 'test_helper'

class CasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ca = cas(:one)
  end

  test "should get index" do
    get cas_url
    assert_response :success
  end

  test "should get new" do
    get new_ca_url
    assert_response :success
  end

  test "should create ca" do
    assert_difference('Ca.count') do
      post cas_url, params: { ca: { common_name: @ca.common_name, country: @ca.country, locality: @ca.locality, not_after: @ca.not_after, not_before: @ca.not_before, organization: @ca.organization, organization_unit: @ca.organization_unit, state: @ca.state } }
    end

    assert_redirected_to ca_url(Ca.last)
  end

  test "should show ca" do
    get ca_url(@ca)
    assert_response :success
  end

  test "should destroy ca" do
    assert_difference('Ca.count', -1) do
      delete ca_url(@ca)
    end

    assert_redirected_to cas_url
  end
end
