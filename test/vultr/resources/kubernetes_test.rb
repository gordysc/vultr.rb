# frozen_string_literal: true

require "test_helper"

class KubernetesResourceTest < Minitest::Test
  def test_list
    stub = stub_request("kubernetes/clusters", response: stub_response(fixture: "kubernetes/list"))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    kubernetes = client.kubernetes.list

    assert_equal Vultr::Collection, kubernetes.class
    assert_equal Vultr::KubernetesCluster, kubernetes.data.first.class
    assert_equal 2, kubernetes.total
    assert_equal "next", kubernetes.next_cursor
    assert_equal "prev", kubernetes.prev_cursor
  end
end