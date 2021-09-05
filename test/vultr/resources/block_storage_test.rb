# frozen_string_literal: true

require "test_helper"

class BlockStorageResourceTest < Minitest::Test
  def test_list
    stub = stub_request("blocks", response: stub_response(fixture: "block_storage/list"))
    client = Vultr::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    blocks = client.block_storage.list

    assert_equal Vultr::Collection, blocks.class
    assert_equal Vultr::BlockStorage, blocks.data.first.class
    assert_equal 1, blocks.total
    assert_equal "next", blocks.next_cursor
    assert_equal "prev", blocks.prev_cursor
  end
end
