
require 'test_helper'

class AddArticleApiTest < ActiveSupport::TestCase
  def setup
    @klass = AddArticleApi
    @basic = @klass.new
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:url1, nil, "1", "1"],
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

  #
  # インスタンスメソッド
  #

  test "execute" do
    url1   = "http://www.asahi.com/national/update/1202/SEB200912020015.html"
    title1 = "asahi.com（朝日新聞社）：母の故郷に１億円「ふるさと納税」　福岡の８０歳 - 社会"

    form = @klass.new
    form.url1 = url1

    result = nil
    assert_difference("Article.count", +1) {
      result = form.execute
    }

    expected = {
      :success => true,
      :result  => {
        1 => {
          :url   => url1,
          :title => title1,
        },
      }
    }
    assert_equal(expected, result)

    article = Article.first(:order => "articles.id DESC")
    assert_equal(title1, article.title)
    assert_equal(url1,   article.url)
  end
end
