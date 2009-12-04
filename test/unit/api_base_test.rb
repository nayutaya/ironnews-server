
require 'test_helper'

class ApiBaseTest < ActiveSupport::TestCase
  def setup
    @klass = ApiBase
  end

  #
  # クラスメソッド
  #

  test "self.suppress_parameter" do
    params = {
      :controller         => "a",
      :action             => "b",
      :commit             => "c",
      :authenticity_token => "d",
      :callback           => "e",
      :foo                => "f",
      :bar                => "g",
    }
    expected = {
      :foo => "f",
      :bar => "g",
    }
    assert_equal(expected, @klass.suppress_parameter(params))
  end
end
