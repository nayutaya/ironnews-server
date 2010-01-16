
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
      @rail.taggings.sort_by(&:id))

    expected = [
      taggings(:yuya_asahi3_nonrail),
      taggings(:risa_asahi2_nonrail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @nonrail.taggings.sort_by(&:id))
  end

  #
  # クラスメソッド
  #

  test "self.normalize" do
    [
      ["  A  B  ", "ab"],
      ["\tA\tB\t", "ab"],
      ["\rA\rB\r", "ab"],
      ["\nA\nB\n", "ab"],
      ["　A　B　", "ab"],
      ["//A//B//", "ab"],
      [",,A,,B,,", "ab"],
      ["ABCDEFGHIJKLM", "abcdefghijklm"],
      ["NOPQRSTUVWXYZ", "nopqrstuvwxyz"],
      ["ＡＢＣＤＥ",    "ＡＢＣＤＥ"],
      ["あいうえお",    "あいうえお"],
    ].each { |value, expected|
      assert_equal(expected, @klass.normalize(value), value)
    }
  end

  test "self.split" do
    [
      ["  A  B  ", %w[A B]],
      ["\tA\tB\t", %w[A B]],
      ["\rA\rB\r", %w[A B]],
      ["\nA\nB\n", %w[A B]],
      ["　A　B　", %w[A B]],
      ["//A//B//", %w[A B]],
      [",,A,,B,,", %w[A B]],
    ].each { |value, expected|
      assert_equal(expected, @klass.split(value), value)
    }
  end

  test "self.get, tag object" do
    assert_equal(
      tags(:rail),
      @klass.get(tags(:rail)))
    assert_equal(
      tags(:nonrail),
      @klass.get(tags(:nonrail)))
  end

  test "self.get, tag id" do
    assert_equal(
      tags(:rail),
      @klass.get(tags(:rail).id))
    assert_equal(
      tags(:nonrail),
      @klass.get(tags(:nonrail).id))
  end

  test "self.get, tag id, invalid" do
    assert_raise(ActiveRecord::RecordNotFound) {
      @klass.get(0)
    }
  end

  test "self.get, tag name, already exists" do
    tag1 = @klass.get(@rail.name)
    assert_equal(@rail.id, tag1.id)
    tag2 = @klass.get(@rail.name, :create => false)
    assert_equal(@rail.id, tag2.id)
  end

  test "self.get, tag name, not exists" do
    tag1, tag2 = nil
    assert_difference("#{@klass}.count", +1) {
      tag1 = @klass.get("TAG")
    }
    assert_equal("tag", tag1.name)

    assert_difference("#{@klass}.count", 0) {
      tag2 = @klass.get("tag")
    }
    assert_equal(tag2.id, tag1.id)
  end

  test "self.get, tag name, not exists but not create" do
    tag1 = nil
    assert_difference("#{@klass}.count", 0) {
      tag1 = @klass.get("TAG", :create => false)
    }
    assert_equal(nil, tag1)
  end

  test "self.get, tag name, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.get("tag", :invalid => true)
    }
  end

  test "self.get, invalid type" do
    assert_raise(ArgumentError) {
      @klass.get(:invalid)
    }
  end

  test "self.get_by_names, exist tags" do
    names = [
      tags(:rail).name + " ",
      tags(:nonrail).name + " ",
    ]
    expected = [
      tags(:rail),
      tags(:nonrail),
    ]
    assert_difference("#{@klass}.count", 0) {
      assert_equal(
        expected,
        @klass.get_by_names(names))
    }
  end

  test "self.get_by_names, include new tag" do
    names = [
      "新しいタグA ",
      tags(:rail).name + " ",
      "新しいタグB ",
    ]
    expected = [
      "新しいタグa",
      tags(:rail).name,
      "新しいタグb",
    ]
    assert_difference("#{@klass}.count", +2) {
      assert_equal(
        expected,
        @klass.get_by_names(names).map(&:name))
    }
  end

  test "self.get_by_names, include new tag but not create" do
    names = [
      "新しいタグA",
      tags(:rail).name,
      "新しいタグB",
    ]
    expected = [tags(:rail).name]
    assert_difference("#{@klass}.count", 0) {
      assert_equal(
        expected,
        @klass.get_by_names(names, :create => false).map(&:name))
    }
  end

  test "self.get_by_names, empty" do
    assert_equal([], @klass.get_by_names([]))
  end

  test "self.get_by_names, invalid parameter" do
    assert_raise(ArgumentError) {
      @klass.get_by_names([], :invalid => true)
    }
  end
end
