
require 'test_helper'

class GetUserTaggedArticlesTest < ActiveSupport::TestCase
  def setup
    @klass = GetUserTaggedArticles
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:page,      1, "1", 1],
      [:per_page, 10, "1", 1],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end
end
