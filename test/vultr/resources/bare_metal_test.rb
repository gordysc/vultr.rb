# frozen_string_literal: true

require "test_helper"

class BareMetalResourceTest < Minitest::Test
  def test_list
    stub = stub_request("bare-metals", response: stub_response(fixture: "bare_metals/list"))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    bare_metal = client.bare_metal.list

    assert_equal Vultr::Collection, bare_metal.class
    assert_equal Vultr::BareMetal, bare_metal.data.first.class
    assert_equal 1, bare_metal.total
    assert_equal "next", bare_metal.next_cursor
    assert_equal "prev", bare_metal.prev_cursor
  end

  def test_create
    body = { region: "ams", plan: "vbm-4c-32gb", label: "Example Bare Metal", app_id: 3, enable_ipv6: true }
    stub = stub_request("bare-metals", method: :post, body: body, response: stub_response(fixture: "bare_metals/create", status: 201))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    bare_metal = client.bare_metal.create(**body)

    assert bare_metal.region, "ams"
    assert bare_metal.date_created, Time.parse("2020-10-10T01:56:20+00:00")
    assert bare_metal.plan, "vbm-4c-32gb"
    assert bare_metal.label, "Example Bare Metal"
    assert bare_metal.features, ["ipv6"]
  end
end
