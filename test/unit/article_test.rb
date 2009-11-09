
require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  def setup
    @klass = Article
    @basic = @klass.new(
      :title => "title",
      :host  => "host",
      :path  => "path")

    @asahi1    = articles(:asahi1)
    @mainichi1 = articles(:mainichi1)
  end

  #
  # 関連
  #

  test "has_many :taggings" do
    expected = [
      taggings(:yuya_asahi1_rail),
      taggings(:risa_asahi1_rail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      articles(:asahi1).taggings.sort_by(&:id))

    expected = [
      taggings(:yuya_asahi2_rail),
      taggings(:risa_asahi2_nonrail),
    ]
    assert_equal(
      expected.sort_by(&:id),
      articles(:asahi2).taggings.sort_by(&:id))
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

  test "validates_format_of :host" do
    [
      ["www.asahi.com", true ],
      ["mainichi.jp",   true ],
      ["www.47news.jp", true ],
      ["abcdef-ghijklm.nopqrst-uvwxyz",    true ],
      ["nopqrs-tuvwxyz.abcdefg-hijklm",    true ],
      ["0123456789.0123456789:0123456789", true ],
      ["WWW.ASAHI.COM", false],
    ].each { |value, expected|
      @basic.host = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  #
  # インスタンスメソッド
  #

  test "url" do
    assert_equal(
      "http://" + @asahi1.host + @asahi1.path,
      @asahi1.url)
    assert_equal(
      "http://" + @mainichi1.host + @mainichi1.path,
      @mainichi1.url)
  end
end
