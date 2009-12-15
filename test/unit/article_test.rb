
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

  test "has_one :combined_tagging" do
    assert_equal(
      combined_taggings(:asahi1),
      articles(:asahi1).combined_tagging)

    assert_equal(
      nil,
      articles(:mainichi1).combined_tagging)
  end

  #
  # 名前付きスコープ
  #

  test "division, rail" do
    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @klass.division(tags(:rail)).all.sort_by(&:id))
    assert_equal(
      expected.sort_by(&:id),
      @klass.division(tags(:rail).id).all.sort_by(&:id))
    assert_equal(
      expected.sort_by(&:id),
      @klass.division(tags(:rail).name).all.sort_by(&:id))
  end

  test "division, nonrail" do
    expected = [
      articles(:asahi3),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @klass.division(tags(:nonrail)).all.sort_by(&:id))
  end

  test "category, social" do
    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @klass.category(tags(:social)).all.sort_by(&:id))
    assert_equal(
      expected.sort_by(&:id),
      @klass.category(tags(:social).id).all.sort_by(&:id))
    assert_equal(
      expected.sort_by(&:id),
      @klass.category(tags(:social).name).all.sort_by(&:id))
  end

  test "category, economy" do
    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @klass.category(tags(:economy)).all.sort_by(&:id))
  end

  test "area, kanto" do
    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @klass.area(tags(:kanto)).all.sort_by(&:id))
    assert_equal(
      expected.sort_by(&:id),
      @klass.area(tags(:kanto).id).all.sort_by(&:id))
    assert_equal(
      expected.sort_by(&:id),
      @klass.area(tags(:kanto).name).all.sort_by(&:id))
  end

  test "area, kinki" do
    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by(&:id),
      @klass.area(tags(:kinki)).all.sort_by(&:id))
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
  # クラスメソッド
  #

  test "self.join_host_path" do
    [
      [["example.jp",       "/"],    "http://example.jp/"],
      [["example.com",      "/foo"], "http://example.com/foo"],
      [["example.org:80",   "/bar"], "http://example.org:80/bar"],
      [["example.net:8080", "/baz"], "http://example.net:8080/baz"],
    ].each { |value, expected|
      assert_equal(
        expected,
        @klass.join_host_path(*value))
    }
  end

  test "self.split_host_path" do
    [
      ["http://example.jp/",          ["example.jp",       "/"]],
      ["http://example.com/foo",      ["example.com",      "/foo"]],
      ["http://example.org:80/bar",   ["example.org",      "/bar"]],
      ["http://example.net:8080/baz", ["example.net:8080", "/baz"]],
    ].each { |value, expected|
      assert_equal(
        expected,
        @klass.split_host_path(value))
    }
  end

  test "self.find_by_url" do
    assert_equal(
      @asahi1.id,
      @klass.find_by_url(@asahi1.url).id)
    assert_equal(
      @mainichi1.id,
      @klass.find_by_url(@mainichi1.url).id)
    assert_equal(
      nil,
      @klass.find_by_url("http://example.jp/"))
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

  test "url=" do
    [
      ["http://example.jp/",          "example.jp",       "/"],
      ["http://example.com/foo",      "example.com",      "/foo"],
      ["http://example.org:80/bar",   "example.org",      "/bar"],
      ["http://example.net:8080/baz", "example.net:8080", "/baz"],
    ].each { |url, host, path|
      record = @klass.new
      record.url = url
      assert_equal(host, record.host, url)
      assert_equal(path, record.path, url)
    }
  end
end
