
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @klass = User
    @basic = @klass.new(
      :name => "name")
  end

  #
  # 関連
  #

  # TODO: 関連を実装せよ

  #
  # 検証
  #

  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :name" do
    @basic.name = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :name" do
    [
      ["a" *  3, false],
      ["a" *  4, true ],
      ["a" * 40, true ],
      ["a" * 41, false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?, value.chars.to_a.size)
    }
  end

  test "validates_format_of :name" do
    [
      ["a0123456789",                true ],
      ["abcdefghijklmnopqrstuvwxyz", true ],
      ["ABCDEFGHIJKLMNOPQRSTUVWXYZ", true ],
      ["aa_a",                       true ],
      ["aaa_",                       true ],
      ["aa0a",                       true ],
      ["aaa0",                       true ],
      ["_aaa",                       false],
      ["0aaa",                       false],
      ["あいうえお",                 false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?, value)
    }
  end
end
