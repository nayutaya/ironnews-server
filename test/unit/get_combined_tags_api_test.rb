
require 'test_helper'

class GetCombinedTagsApiTest < ActiveSupport::TestCase
  def setup
    @klass = GetCombinedTagsApi
    @basic = @klass.new(
      :article_ids => "1")
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:article_ids, nil, "1", "1"],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :article_ids" do
    @basic.article_ids = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_format_of :article_ids" do
    [
      ["1234567890", true ],
      ["1,2",        true ],
      ["1,2,3",      true ],
      ["a",          false],
      ["1,",         false],
      [",1",         false],
    ].each { |value, expected|
      @basic.article_ids = value
      assert_equal(expected, @basic.valid?, value)
    }
  end
end
