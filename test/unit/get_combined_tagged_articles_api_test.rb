
require 'test_helper'

class GetCombinedTaggedArticlesApiTest < ActiveSupport::TestCase
  def setup
    @klass = GetCombinedTaggedArticlesApi
    @form  = @klass.new
    @basic = @klass.new(
      :division_tag => "tag",
      :page         => 1,
      :per_page     => 10)
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

  #
  # 検証
  #

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :page" do
    @basic.page = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :per_page" do
    @basic.per_page = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_numericality_of :page" do
    [
      ["0",   false],
      ["0.1", false],
      ["1",   true ],
      ["a",   false],
    ].each { |value, expected|
      @basic.page = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  test "validates_numericality_of :per_page" do
    [
      ["0",   false],
      ["0.1", false],
      ["1",   true ],
      ["100", true ],
      ["101", false],
      ["a",   false],
    ].each { |value, expected|
      @basic.per_page = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  #
  # クラスメソッド
  #

  test "self.schema" do
    assert_kind_of(Hash, @klass.schema)
  end

  #
  # インスタンスメソッド
  #

  test "search, division, rail" do
    @form.division_tag = tags(:rail).name

    expected = [
      articles(:asahi1),
      articles(:mainichi1),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, division, nonrail" do
    @form.division_tag = tags(:nonrail).name

    expected = [
      articles(:asahi3),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, category, social" do
    @form.category_tag = tags(:social).name

    expected = [
      articles(:asahi1),
      articles(:mainichi1),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, category, economy" do
    @form.category_tag = tags(:economy).name

    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, area, kanto" do
    @form.area_tag = tags(:kanto).name

    expected = [
      articles(:asahi1),
      articles(:mainichi1),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, area, kinki" do
    @form.area_tag = tags(:kinki).name

    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, complex" do
    @form.division_tag = tags(:rail).name
    @form.category_tag = tags(:economy).name
    @form.area_tag     = tags(:kinki).name

    expected = [
      articles(:asahi1),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search)
  end

  test "search, paginate" do
    @form.page     = 2
    @form.per_page = 1

    articles = @form.search
    assert_equal(2, articles.current_page)
    assert_equal(1, articles.per_page)
  end

  test "execute" do
    actual = @form.execute
    assert_valid_json(@klass.schema, actual)
    assert_equal(true, actual["success"])
    assert_equal(nil,  actual["errors"])

    articles = @form.search
    assert_equal(articles.total_entries, actual["result"]["total_entries"])
    assert_equal(articles.total_pages,   actual["result"]["total_pages"])
    assert_equal(articles.current_page,  actual["result"]["current_page"])
    assert_equal(articles.per_page,      actual["result"]["entries_per_page"])

    expected = articles.map { |article|
      {
        "article_id" => article.id,
        "title"      => article.title,
        "url"        => article.url,
      }
    }
    assert_equal(expected, actual["result"]["articles"])
  end

  test "execute, paginate" do
    @form.page     = 2
    @form.per_page = 1

    actual = @form.execute
    assert_valid_json(@klass.schema, actual)
    assert_equal(2, actual["result"]["current_page"])
    assert_equal(1, actual["result"]["entries_per_page"])
  end

  test "execute, invalid" do
    @form.page = 0
    assert_equal(false, @form.valid?)

    actual = @form.execute
    assert_valid_json(@klass.schema, actual)
    assert_equal(false, actual["success"])
    assert_equal(["Page must be greater than or equal to 1"], actual["errors"])
    assert_equal(nil, actual["result"])
  end
end
