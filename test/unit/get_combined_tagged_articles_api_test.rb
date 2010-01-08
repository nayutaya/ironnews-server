
require 'test_helper'

class GetCombinedTaggedArticlesApiTest < ActiveSupport::TestCase
  def setup
    @klass = GetCombinedTaggedArticlesApi
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:division_tag, nil, "1", "1"],
      [:category_tag, nil, "1", "1"],
      [:area_tag,     nil, "1", "1"],
      [:page,         1,   "1", 1],
      [:per_page,     10,  "1", 1],
    ].each { |name, default, set_value, get_value|
      form = @klass.new
      assert_equal(default, form.__send__(name))
      form.__send__("#{name}=", set_value)
      assert_equal(get_value, form.__send__(name))
    }
  end
end
