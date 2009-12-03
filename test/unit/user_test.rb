
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @klass = User
    @basic = @klass.new(
      :name      => "name",
      :api_token => "00000000000000000000000000000000")

    @yuya   = users(:yuya)
    @shinya = users(:shinya)
    @risa   = users(:risa)
  end

  #
  # 関連
  #

  test "has_many :open_id_credentials" do
    expected = [
      open_id_credentials(:yuya_livedoor),
      open_id_credentials(:yuya_mixi),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.open_id_credentials.sort_by(&:id))

    expected = [
      open_id_credentials(:shinya_example),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @shinya.open_id_credentials.sort_by(&:id))
  end

  test "has_many :taggings" do
    expected = [
      taggings(:yuya_asahi1_rail),
      taggings(:yuya_asahi2_rail),
      taggings(:yuya_asahi3_nonrail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @yuya.taggings.sort_by(&:id))

    expected = [
      taggings(:risa_asahi1_rail),
      taggings(:risa_asahi2_nonrail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @risa.taggings.sort_by(&:id))
  end

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

  test "validates_presence_of :api_token" do
    @basic.api_token = ""
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
      ["aa_a",                       true ],
      ["aaa_",                       true ],
      ["aa0a",                       true ],
      ["aaa0",                       true ],
      ["AAAA",                       false],
      ["_aaa",                       false],
      ["0aaa",                       false],
      ["あいうえお",                 false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_format_of :api_token" do
    [
      ["0123456789abcdef0123456789abcdef",  true ],
      ["0000000000000000000000000000000",   false],
      ["000000000000000000000000000000000", false],
      ["g0000000000000000000000000000000",  false],
    ].each { |value, expected|
      @basic.api_token = value
      assert_equal(expected, @basic.valid?, value)
    }
  end
end
