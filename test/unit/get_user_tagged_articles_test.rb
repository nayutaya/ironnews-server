
require 'test_helper'

class GetUserTaggedArticlesTest < ActiveSupport::TestCase
  def setup
    @klass = GetUserTaggedArticles
    @form  = @klass.new
    @basic = @klass.new(
      :tag      => "tag",
      :page     => 1,
      :per_page => 10)
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:tag,      nil, "1", "1"],
      [:page,     1,   "1", 1],
      [:per_page, 10,  "1", 1],
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

  test "validates_presence_of :tag" do
    @basic.tag = ""
    assert_equal(false, @basic.valid?)
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
  # インスタンスメソッド
  #

  test "search, yuya" do
    @form.tag = tags(:rail).name

    articles = @form.search(users(:yuya).id)
    assert_equal( 1, articles.current_page)
    assert_equal(10, articles.per_page)

    expected = [
      articles(:asahi1),
      articles(:asahi2),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      articles)
  end

  test "search, risa" do
    @form.tag = tags(:nonrail).name

    expected = [
      articles(:asahi2),
    ]
    assert_equal(
      expected.sort_by { |article| [article.created_at.to_i, article.id] }.reverse,
      @form.search(users(:risa).id))
  end

  test "search, paginate" do
    @form.tag      = tags(:rail).name
    @form.page     = 2
    @form.per_page = 1

    articles = @form.search(users(:yuya).id)
    assert_equal(2, articles.current_page)
    assert_equal(1, articles.per_page)
  end
end
