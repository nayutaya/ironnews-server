
require 'test_helper'

class AddTagApiTest < ActiveSupport::TestCase
  def setup
    @klass = AddTagApi
    @form  = @klass.new
    @basic = @klass.new(
      :article_id => 1,
      :tag        => "tag")
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:article_id, nil, "1", 1],
      [:tag,        nil, "1", "1"],
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

  test "validates_presence_of :tag" do
    @basic.tag = ""
    assert_equal(false, @basic.valid?)
  end

  #
  # インスタンスメソッド
  #

  test "execute, exist tag" do
    user    = users(:yuya)
    article = articles(:mainichi1)
    tag     = tags(:rail)

    @form.article_id = article.id
    @form.tag        = tag.name

    result = nil
    assert_difference("Tag.count", 0) {
      assert_difference("Tagging.count", +1) {
        result = @form.execute(user)
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
        :tag_id     => tag.id,
      },
    }
    assert_equal(expected, result)
  end

  test "execute, new tag" do
    user     = users(:yuya)
    article  = articles(:mainichi1)
    tag_name = "新しいタグ"

    @form.article_id = article.id
    @form.tag        = tag_name

    result = nil
    assert_difference("Tag.count", +1) {
      assert_difference("Tagging.count", +1) {
        result = @form.execute(user)
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
        :tag_id     => tag.id,
      },
    }
    assert_equal(expected, result)
  end
end
