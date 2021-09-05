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

  def test_retrieve
    baremetal_id = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    stub = stub_request("bare-metals/#{baremetal_id}", response: stub_response(fixture: "bare_metals/retrieve"))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    bare_metal = client.bare_metal.retrieve(baremetal_id: baremetal_id)

    assert bare_metal.id, baremetal_id
    assert bare_metal.os, "Application"
    assert bare_metal.ram, "32768 MB"
    assert bare_metal.disk, "2x 240GB SSD"
    assert bare_metal.main_ip, "192.0.2.123"
    assert bare_metal.cpu_count, 4
    assert bare_metal.region, "ams"
    assert bare_metal.date_created, "2020-10-10T01:56:20+00:00"
    assert bare_metal.status, "pending"
    assert bare_metal.netmask_v4, "255.255.254.0"
    assert bare_metal.gateway_v4, "192.0.2.1"
    assert bare_metal.plan, "vbm-4c-32gb"
    assert bare_metal.v6_network, "2001:0db8:5001:3990::"
    assert bare_metal.v6_main_ip, "2001:0db8:5001:3990:0ec4:7aff:fe8e:f97a"
    assert bare_metal.v6_network_size, 64
    assert bare_metal.mac_address, 2199756823533
    assert bare_metal.label, "Example Bare Metal"
    assert bare_metal.tag, "Example Tag"
    assert bare_metal.os_id, 183
    assert bare_metal.app_id, 3
    assert bare_metal.image_id, ""
    assert bare_metal.features, ["ipv6"]
  end

  def test_update
    baremetal_id = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    body = { label: "Updated Bare Metal Label", tag: "Updated Tag", user_data: "QmFzZTY0IEV4YW1wbGUgRGF0YQ==" }
    stub = stub_request("bare-metals/#{baremetal_id}", method: :patch, body: body, response: stub_response(fixture: "bare_metals/update", status: 202))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    bare_metal = client.bare_metal.update(baremetal_id: baremetal_id, **body)

    assert bare_metal.id, baremetal_id
    assert bare_metal.os, "Application"
    assert bare_metal.ram, "32768 MB"
    assert bare_metal.disk, "2x 240GB SSD"
    assert bare_metal.main_ip, "192.0.2.123"
    assert bare_metal.cpu_count, 4
    assert bare_metal.region, "ams"
    assert bare_metal.date_created, "2020-10-10T01:56:20+00:00"
    assert bare_metal.status, "pending"
    assert bare_metal.netmask_v4, "255.255.254.0"
    assert bare_metal.gateway_v4, "192.0.2.1"
    assert bare_metal.plan, "vbm-4c-32gb"
    assert bare_metal.v6_network, "2001:0db8:5001:3990::"
    assert bare_metal.v6_main_ip, "2001:0db8:5001:3990:0ec4:7aff:fe8e:f97a"
    assert bare_metal.v6_network_size, 64
    assert bare_metal.mac_address, 2199756823533
    assert bare_metal.label, "Updated Bare Metal Label"
    assert bare_metal.tag, "Updated Tag"
    assert bare_metal.os_id, 183
    assert bare_metal.app_id, 3
    assert bare_metal.image_id, ""
    assert bare_metal.features, ["ipv6"]
  end

  def test_delete
    baremetal_id = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    stub = stub_request("bare-metals/#{baremetal_id}", method: :delete, response: {})
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert client.bare_metal.delete(baremetal_id: baremetal_id)
  end

  def test_start
    baremetal_id = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    stub = stub_request("bare-metals/#{baremetal_id}/start", method: :post, body: {}, response: {})
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert client.bare_metal.start(baremetal_id: baremetal_id)
  end

  def test_reboot
    baremetal_id = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    stub = stub_request("bare-metals/#{baremetal_id}/reboot", method: :post, body: {}, response: {})
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)

    assert client.bare_metal.reboot(baremetal_id: baremetal_id)
  end
end
