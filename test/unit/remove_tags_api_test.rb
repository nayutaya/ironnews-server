
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

  end

  test "execute, no exist tag" do

  end
end
