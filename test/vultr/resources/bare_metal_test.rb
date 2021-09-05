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
end
