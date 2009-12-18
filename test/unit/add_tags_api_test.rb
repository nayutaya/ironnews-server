
require 'test_helper'

class AddTagsApiTest < ActiveSupport::TestCase
  def setup
    @klass = AddTagsApi
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

  test "execute, exist tag" do
    user    = users(:yuya)
    article = articles(:mainichi1)
    tag     = tags(:rail)

    @form.article_id = article.id
    @form.tag1       = tag.name

    result = nil
    assert_difference("Tag.count", 0) {
      assert_difference("Tagging.count", +1) {
        result = @form.execute(user.id)
      }
    }

    tagging = Tagging.first(:order => "taggings.id DESC")
    assert_equal(user.id,    tagging.user_id)
    assert_equal(article.id, tagging.article_id)
    assert_equal(tag.id,     tagging.tag_id)

    expected = {
      :success => true,
      :result  => {
        :article_id => article.id,
        :tag1_id    => tag.id,
      },
    }
    assert_equal(expected, result)
  end

  test "execute, new tag" do
    user     = users(:yuya)
    article  = articles(:mainichi1)
    tag_name = "新しいタグ"

    @form.article_id = article.id
    @form.tag1       = tag_name

    result = nil
    assert_difference("Tag.count", +1) {
      assert_difference("Tagging.count", +1) {
        result = @form.execute(user.id)
      }
    }

    tag     = Tag.get(tag_name)
    tagging = Tagging.first(:order => "taggings.id DESC")
    assert_equal(user.id,    tagging.user_id)
    assert_equal(article.id, tagging.article_id)
    assert_equal(tag.id,     tagging.tag_id)

    expected = {
      :success => true,
      :result  => {
        :article_id => article.id,
        :tag1_id    => tag.id,
      },
    }
    assert_equal(expected, result)
  end

  test "execute, exist tagging" do
    user     = taggings(:yuya_asahi1_rail).user
    article  = taggings(:yuya_asahi1_rail).article
    tag      = taggings(:yuya_asahi1_rail).tag

    @form.article_id = article.id
    @form.tag1       = tag.name

    result = nil
    assert_difference("Tag.count", +0) {
      assert_difference("Tagging.count", +0) {
        result = @form.execute(user.id)
      }
    }

    expected = {
      :success => true,
      :result  => {
        :article_id => article.id,
        :tag1_id    => tag.id,
      },
    }
    assert_equal(expected, result)
  end

  test "execute, multiple" do
    user     = users(:yuya)
    article  = articles(:asahi1)

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
    assert_difference("Tag.count", +10) {
      assert_difference("Tagging.count", +10) {
        result = @form.execute(user.id)
      }
    }

    expected = {
      :success => true,
      :result  => {
        :article_id => article.id,
        :tag1_id    => Tag.get("1").id,
=begin
        :tag2_id    => Tag.get("2").id,
        :tag3_id    => Tag.get("3").id,
        :tag4_id    => Tag.get("4").id,
        :tag5_id    => Tag.get("5").id,
        :tag6_id    => Tag.get("6").id,
        :tag7_id    => Tag.get("7").id,
        :tag8_id    => Tag.get("8").id,
        :tag9_id    => Tag.get("9").id,
        :tag10_id   => Tag.get("10").id,
=end
      },
    }
    assert_equal(expected, result)
  end
end
