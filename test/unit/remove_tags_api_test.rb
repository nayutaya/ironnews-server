
require 'test_helper'

class RemoveTagsApiTest < ActiveSupport::TestCase
  def setup
    @klass = RemoveTagsApi
    @form  = @klass.new
    @basic = @klass.new(
      :article_id => 1,
      :tag1       => "tag1")
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:article_id, nil, "1", 1],
      [:tag1,       nil, "1", "1"],
      [:tag2,       nil, "1", "1"],
      [:tag3,       nil, "1", "1"],
      [:tag4,       nil, "1", "1"],
      [:tag5,       nil, "1", "1"],
      [:tag6,       nil, "1", "1"],
      [:tag7,       nil, "1", "1"],
      [:tag8,       nil, "1", "1"],
      [:tag9,       nil, "1", "1"],
      [:tag10,      nil, "1", "1"],
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

  test "validates_presence_of :article_id" do
    @basic.article_id = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :tag1" do
    @basic.tag1 = ""
    assert_equal(false, @basic.valid?)
  end

  #
  # クラスメソッド
  #

  test "self.from" do
    params = {
      :controller => "a",
      :article_id => 1,
    }
    form = @klass.from(params)
    assert_equal(1, form.article_id)
  end

  #
  # インスタンスメソッド
  #

  test "tags, empty" do
    assert_equal([], @form.tags)
  end

  test "tags, one" do
    @form.tag1 = "a"
    assert_equal(["a"], @form.tags)
  end

  test "tags, blanks" do
    @form.tag1 = nil
    @form.tag2 = ""
    @form.tag3 = " "
    assert_equal([], @form.tags)
  end

  test "tags, full" do
    @form.tag1  = "1"
    @form.tag2  = "2"
    @form.tag3  = "3"
    @form.tag4  = "4"
    @form.tag5  = "5"
    @form.tag6  = "6"
    @form.tag7  = "7"
    @form.tag8  = "8"
    @form.tag9  = "9"
    @form.tag10 = "10"
    assert_equal(
      %w[1 2 3 4 5 6 7 8 9 10],
      @form.tags)
  end

  test "execute, exist tagging" do
    user    = taggings(:yuya_asahi1_rail).user
    article = taggings(:yuya_asahi1_rail).article
    tag     = taggings(:yuya_asahi1_rail).tag

    @form.article_id = article.id
    @form.tag1       = tag.name

    result = nil
    assert_difference("Tag.count", 0) {
      assert_difference("Tagging.count", -1) {
        result = @form.execute(user.id)
      }
    }

    assert_equal(
      nil,
      Tagging.find_by_user_id_and_article_id_and_tag_id(user.id, article.id, tag.id))

    expected = {
      :success => true,
    }
    assert_equal(expected, result)
  end

  test "execute, no exist tagging" do
    user     = users(:yuya)
    article  = articles(:asahi1)
    tag_name = "非鉄"

    @form.article_id = article.id
    @form.tag1       = tag_name

    result = nil
    assert_difference("Tag.count", 0) {
      assert_difference("Tagging.count", 0) {
        result = @form.execute(user.id)
      }
    }

    expected = {
      :success => true,
    }
    assert_equal(expected, result)
  end

  test "execute, no exist tag" do
    user     = users(:yuya)
    article  = articles(:asahi1)
    tag_name = "存在しないタグ"

    @form.article_id = article.id
    @form.tag1       = tag_name

    result = nil
    assert_difference("Tag.count", 0) {
      assert_difference("Tagging.count", 0) {
        result = @form.execute(user.id)
      }
    }

    expected = {
      :success => true,
    }
    assert_equal(expected, result)
  end
end
