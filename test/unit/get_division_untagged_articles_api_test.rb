
require 'test_helper'

class GetDivisionUntaggedArticlesApiTest < ActiveSupport::TestCase
  def setup
    @klass = GetDivisionUntaggedArticlesApi
    @form  = @klass.new
    @basic = @klass.new(
      :page     => 1,
      :per_page => 10)
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:page,      1, "1", 1],
      [:per_page, 10, "1", 1],
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
  # インスタンスメソッド
  #

  test "execute" do
    @form.page     = 1
    @form.per_page = 10

    articles = Article.
      division_untagged_by(users(:yuya).id).
      paginate(
        :order    => "articles.created_at DESC",
        :page     => 1,
        :per_page => 10)

    expected = {
      :success => true,
      :result  => {
        :page          => articles.current_page,
        :per_page      => articles.per_page,
        :total_entries => articles.total_entries,
        :articles      => articles.map { |article|
          {
            :article_id => 1,
            :title      => "x",
            :url        => "y",
          }
        },
      },
    }
    assert_equal(
      expected,
      @form.execute(users(:yuya).id))
  end
end
