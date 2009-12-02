
require 'test_helper'

class AddArticleApiTest < ActiveSupport::TestCase
  def setup
    @klass = AddArticleApi
    @basic = @klass.new
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:url1, nil, "1", "1"],
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

  #
  # インスタンスメソッド
  #

  test "execute" do
    api = @klass.new

    result = nil
    assert_difference("Article.count", +1) {
      result = api.execute
    }
    expected = {
      :success => true,
    }
    assert_equal(expected, result)
  end
end
