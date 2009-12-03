
require 'test_helper'

class AddArticleApiTest < ActiveSupport::TestCase
  def setup
    @klass = AddArticleApi
    @form  = @klass.new
    @basic = @klass.new
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:url1, nil, "1", "1"],
      [:url2, nil, "1", "1"],
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
  # クラスメソッド
  #

  test "self.suppress_parameter" do
    params = {
      :controller         => "a",
      :action             => "b",
      :commit             => "c",
      :authenticity_token => "d",
      :callback           => "e",
      :url1               => "f",
    }
    expected = {
      :url1 => "f",
    }
    assert_equal(expected, @klass.suppress_parameter(params))
  end

  test "self.from" do
    params = {
      :controller => "a",
      :url1       => "b",
    }
    form = @klass.from(params)
    assert_equal("b", form.url1)
  end

  #
  # インスタンスメソッド
  #

  test "execute" do
    url1   = "http://www.asahi.com/national/update/1202/SEB200912020015.html"
    title1 = "asahi.com（朝日新聞社）：母の故郷に１億円「ふるさと納税」　福岡の８０歳 - 社会"

    @form.url1 = url1

    result = nil
    assert_difference("Article.count", +1) {
      result = @form.execute
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

  test "execute, 2" do
    url1   = "http://www.asahi.com/national/update/1202/TKY200912020353.html"
    title1 = "asahi.com（朝日新聞社）：リンゼイさん殺害の疑い　沈黙の市橋容疑者を再逮捕　 - 社会"
    url2   = "http://www.asahi.com/politics/update/1202/TKY200912020359.html"
    title2 = "asahi.com（朝日新聞社）：「連立３党合意に普天間入ってない」　官房長官、会見で - 政治"

    @form.url1 = url1
    @form.url2 = url2

    result = nil
    assert_difference("Article.count", +2) {
      result = @form.execute
    }

    expected = {
      1 => {:url => url1, :title => title1},
      2 => {:url => url2, :title => title2},
    }
    assert_equal(expected, result[:result])

    article = Article.first(:order => "articles.id DESC")
    assert_equal(title2, article.title)
    assert_equal(url2,   article.url)
  end

  test "execute, already exist" do
    url1   = articles(:asahi1).url
    title1 = articles(:asahi1).title

    @form.url1 = url1

    result = nil
    assert_difference("Article.count", 0) {
      result = @form.execute
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
  end

  test "urls, full" do
    @form.attributes = {
      :url1 => "a",
      :url2 => "b",
    }
    expected = [
      [1, "a"],
      [2, "b"],
    ]
    assert_equal(expected, @form.urls)
  end

  test "urls, empty" do
    assert_equal([], @form.urls)
  end
end
