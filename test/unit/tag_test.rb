
require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @klass = Tag
    @basic = @klass.new(
      :name => "name")

    @rail    = tags(:rail)
    @nonrail = tags(:nonrail)
  end

  #
  # 関連
  #

  test "has_many :taggings" do
    expected = [
      taggings(:yuya_asahi1_rail),
      taggings(:yuya_asahi2_rail),
      taggings(:risa_asahi1_rail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @rail.taggings.all.sort_by(&:id))

    expected = [
      taggings(:yuya_asahi3_nonrail),
      taggings(:risa_asahi2_nonrail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @nonrail.taggings.all.sort_by(&:id))
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

  test "validates_length_of :name" do
    [
      ["あ" *  1, true ],
      ["あ" * 50, true ],
      ["あ" * 51, false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?, value.chars.to_a.size)
    }
  end

  test "validates_format_of :name" do
    [
      ["あいうえお",         true ],
      [("0".."9").to_a.join, true ],
      [("a".."z").to_a.join, true ],
      [("A".."Z").to_a.join, false],
    ].each { |value, expected|
      @basic.name = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_uniqueness_of :name, on create" do
    name = @rail.name
    assert_not_nil(@klass.find_by_name(name))

    @basic.name = name
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :name, on update" do
    name = @nonrail.name
    assert_not_nil(@klass.find_by_name(name))

    @rail.name = name
    assert_equal(false, @rail.valid?)
  end
end
