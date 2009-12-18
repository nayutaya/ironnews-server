
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

  test "tags, normalize" do
    @form.tag1 = " A "
    @form.tag2 = nil
    @form.tag3 = ""
    @form.tag4 = " "
    assert_equal(["a"], @form.tags)
  end

  test "tags, sort and uniq" do
    @form.tag1 = "b"
    @form.tag2 = "a"
    @form.tag3 = "a"
    assert_equal(%w[a b], @form.tags)
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
      %w[1 2 3 4 5 6 7 8 9 10].sort,
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
      user.taggings.find_by_article_id_and_tag_id(article.id, tag.id))

    expected = {
      :success => true,
      :result  => {
        :article_id => article.id,
        :tags       => [tag.name],
      },
    }
    assert_equal(expected, result)
  end

  test "execute, no exist tagging" do
    user     = users(:yuya)
    article  = articles(:asahi1)
    tag_name = tags(:nonrail).name

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
      :result  => {
        :article_id => article.id,
        :tags       => [tag_name],
      },
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
      :result  => {
        :article_id => article.id,
        :tags       => [tag_name],
      },
    }
    assert_equal(expected, result)
  end

  test "execute, multiple" do
    user    = users(:yuya)
    article = articles(:asahi1)

    assert_difference("Tag.count", +10) {
      assert_difference("Tagging.count", +10) {
        user.taggings.create!(:article => article, :tag => Tag.get("1"))
        user.taggings.create!(:article => article, :tag => Tag.get("2"))
        user.taggings.create!(:article => article, :tag => Tag.get("3"))
        user.taggings.create!(:article => article, :tag => Tag.get("4"))
        user.taggings.create!(:article => article, :tag => Tag.get("5"))
        user.taggings.create!(:article => article, :tag => Tag.get("6"))
        user.taggings.create!(:article => article, :tag => Tag.get("7"))
        user.taggings.create!(:article => article, :tag => Tag.get("8"))
        user.taggings.create!(:article => article, :tag => Tag.get("9"))
        user.taggings.create!(:article => article, :tag => Tag.get("10"))
      }
    }

    @form.article_id = article.id
    @form.tag1       = "1"
    @form.tag2       = "2"
    @form.tag3       = "3"
    @form.tag4       = "4"
    @form.tag5       = "5"
    @form.tag6       = "6"
    @form.tag7       = "7"
    @form.tag8       = "8"
    @form.tag9       = "9"
    @form.tag10      = "10"

    result = nil
    assert_difference("Tag.count", 0) {
      assert_difference("Tagging.count", -10) {
        result = @form.execute(user.id)
      }
    }

    expected = {
      :success => true,
      :result  => {
        :article_id => article.id,
        :tags       => %w[1 2 3 4 5 6 7 8 9 10].sort,
      },
    }
    assert_equal(expected, result)
  end
end
