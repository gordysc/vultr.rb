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

  def test_create
    body = {label: "vke", region: "lax", version: "v1.20.0+1", node_pools: [{node_quantity: 2, label: "my-label", plan: "vc2-1c-2gb"}]}
    stub = stub_request("kubernetes/clusters", method: :post, body: body, response: stub_response(fixture: "kubernetes/create", status: 201))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    kubernetes = client.kubernetes.create(**body)

    assert_equal kubernetes.id, "455dcd32-e621-48ee-a10e-0cb5f754e13e"
    assert_equal kubernetes.label, "vke"
    assert_equal kubernetes.date_created, Time.parse("2021-07-07T22:57:01+00:00")
    assert_equal kubernetes.cluster_subnet, "10.244.0.0/16"
    assert_equal kubernetes.service_subnet, "10.96.0.0/12"
    assert_equal kubernetes.ip, "0.0.0.0"
    assert_equal kubernetes.endpoint, "455dcd32-e621-48ee-a10e-0cb5f754e13e.vultr-k8s.com"
    assert_equal kubernetes.version, "v1.20.0+1"
    assert_equal kubernetes.region, "lax"
    assert_equal kubernetes.status, "pending"
    assert_equal kubernetes.node_pools.class, Array
  end
end