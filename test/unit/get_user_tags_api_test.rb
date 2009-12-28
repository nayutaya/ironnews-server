
require 'test_helper'

class GetUserTagsApiTest < ActiveSupport::TestCase
  def setup
    @klass = GetUserTagsApi
    @form  = @klass.new
    @basic = @klass.new(
      :article_ids => "1")
  end

  #
  # カラム
  #

  test "columns" do
    [
      [:article_ids, nil, "1", "1"],
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

  test "validates_presence_of :article_ids" do
    @basic.article_ids = ""
    assert_equal(false, @basic.valid?)
  end

  test "validates_format_of :article_ids" do
    [
      ["1234567890", true ],
      ["1,2",        true ],
      ["1,2,3",      true ],
      ["a",          false],
      ["1,",         false],
      [",1",         false],
    ].each { |value, expected|
      @basic.article_ids = value
      assert_equal(expected, @basic.valid?, value)
    }
  end

  #
  # クラスメソッド
  #

  test "self.from" do
    params = {
      :controller  => "a",
      :article_ids => "b",
    }
    form = @klass.from(params)
    assert_equal("b", form.article_ids)
  end

  test "self.schema" do
    assert_kind_of(Hash, @klass.schema)
  end

  #
  # インスタンスメソッド
  #

  test "parsed_article_ids" do
    @form.article_ids = ""
    assert_equal([], @form.parsed_article_ids)
    @form.article_ids = "1234567890"
    assert_equal([1234567890], @form.parsed_article_ids)
    @form.article_ids = "1,2,3"
    assert_equal([1, 2, 3], @form.parsed_article_ids)
  end

  test "search, yuya" do
    @form.article_ids = [
      articles(:asahi1),
      articles(:asahi2),
      articles(:mainichi1),
    ].map(&:id).join(",")

    expected = {
      articles(:asahi1).id =>
        [
          tags(:rail),
          tags(:social),
          tags(:kanto),
        ].sort_by(&:id).map(&:name),
      articles(:asahi2).id =>
        [
          tags(:rail),
          tags(:economy),
          tags(:kinki),
        ].sort_by(&:id).map(&:name),
      articles(:mainichi1).id => [],
    }
    actual = @form.search(users(:yuya).id)
    assert_equal(expected, actual)
  end

  test "search, risa" do
    @form.article_ids = [
      articles(:asahi1),
      articles(:mainichi1),
    ].map(&:id).join(",")

    expected = {
      articles(:asahi1).id    => [tags(:rail)].map(&:name),
      articles(:mainichi1).id => [],
    }
    actual = @form.search(users(:risa).id)
    assert_equal(expected, actual)
  end

  test "execute, yuya" do
    @form.article_ids = [
      articles(:asahi1),
      articles(:mainichi1),
    ].map(&:id).join(",")

    actual = @form.execute(users(:yuya).id)
    assert_valid_json(@klass.schema, actual)
    assert_equal(true, actual["success"])
    assert_equal(nil,  actual["errors"])

    expected = {
      articles(:asahi1).id.to_s =>
        [
          tags(:rail),
          tags(:social),
          tags(:kanto),
        ].sort_by(&:id).map(&:name),
      articles(:mainichi1).id.to_s => [],
    }
    assert_equal(expected, actual["result"])
  end

  test "execute, risa" do
    @form.article_ids = [
      articles(:asahi1),
      articles(:mainichi1),
    ].map(&:id).join(",")

    actual = @form.execute(users(:risa).id)
    assert_valid_json(@klass.schema, actual)

    expected = {
      articles(:asahi1).id.to_s    => [tags(:rail)].map(&:name),
      articles(:mainichi1).id.to_s => [],
    }
    assert_equal(expected, actual["result"])
  end

  test "execute, invalid" do
    @form.article_ids = ""
    assert_equal(false, @form.valid?)

    actual = @form.execute(users(:yuya).id)
    assert_valid_json(@klass.schema, actual)
    assert_equal(false, actual["success"])
    assert_equal(nil,   actual["result"])
    assert_equal(
      ["Article ids can't be blank"],
      actual["errors"])
  end
end
