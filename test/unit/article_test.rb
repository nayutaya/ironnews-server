
require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @klass = Article
    @basic = @klass.new(
      :title => "title",
      :host  => "host",
      :path  => "path")
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

  test "validates_presence_of :title" do
    @basic.title = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :host" do
    @basic.host = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :path" do
    @basic.path = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_length_of :title" do
    [
      ["あ" *   1, true ],
      ["あ" * 200, true ],
      ["あ" * 201, false],
    ].each { |value, expected|
      @basic.title = value
      assert_equal(expected, @basic.valid?, value.chars.to_a.size)
    }
  end

  test "validates_length_of :host" do
    [
      ["a" *   1, true ],
      ["a" * 100, true ],
      ["a" * 101, false],
    ].each { |value, expected|
      @basic.host = value
      assert_equal(expected, @basic.valid?, value.chars.to_a.size)
    }
  end

  test "validates_length_of :path" do
    [
      ["a" *    1, true ],
      ["a" * 2000, true ],
      ["a" * 2001, false],
    ].each { |value, expected|
      @basic.path = value
      assert_equal(expected, @basic.valid?, value.chars.to_a.size)
    }
  end
end
