
require 'test_helper'

class GetArticlesApiTest < ActiveSupport::TestCase
  def setup
    @klass = GetArticlesApi
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
end
