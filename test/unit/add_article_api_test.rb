
require 'test_helper'

class AddArticleApiTest < ActiveSupport::TestCase
  def setup
    @klass = AddArticleApi
    @basic = @klass.new
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
