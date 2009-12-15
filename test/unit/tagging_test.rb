
require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  def setup
    @klass = Tagging
    @basic = @klass.new(
      :user_id    => users(:yuya).id,
      :article_id => articles(:asahi1).id,
      :tag_id     => tags(:nonrail).id)
  end

  #
  # 関連
  #

  test "belongs_to :user" do
    assert_equal(
      users(:yuya),
      taggings(:yuya_asahi1_rail).user)

    assert_equal(
      users(:risa),
      taggings(:risa_asahi2_nonrail).user)
  end

  test "belongs_to :article" do
    assert_equal(
      articles(:asahi1),
      taggings(:yuya_asahi1_rail).article)

    assert_equal(
      articles(:asahi2),
      taggings(:risa_asahi2_nonrail).article)
  end

  test "belongs_to :tag" do
    assert_equal(
      tags(:rail),
      taggings(:yuya_asahi1_rail).tag)

    assert_equal(
      tags(:nonrail),
      taggings(:risa_asahi2_nonrail).tag)
  end

  #
  # 検証
  #

  test "all fixtures are valid" do
    assert_equal(true, @klass.all.all?(&:valid?))
  end

  test "basic is valid" do
    assert_equal(true, @basic.valid?)
  end

  test "validates_presence_of :user_id" do
    @basic.user_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :article_id" do
    @basic.article_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_presence_of :tag_id" do
    @basic.tag_id = nil
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :tag_id, :scope => [:user_id, :article_id], on create" do
    [
      [users(:risa), articles(:asahi2), tags(:rail),    true ],
      [users(:yuya), articles(:asahi3), tags(:rail),    true ],
      [users(:yuya), articles(:asahi2), tags(:nonrail), true ],
      [users(:yuya), articles(:asahi2), tags(:rail),    false],
    ].each_with_index { |(user, article, tag, expected), index|
      @basic.user    = user
      @basic.article = article
      @basic.tag     = tag
      assert_equal(expected, @basic.valid?, index.to_s)
    }
  end

  test "validates_uniqueness_of :tag_id, :scope => [:user_id, :article_id], on update" do
    [
      [users(:risa), articles(:asahi2), tags(:rail),    true ],
      [users(:yuya), articles(:asahi3), tags(:rail),    true ],
      [users(:yuya), articles(:asahi2), tags(:nonrail), true ],
      [users(:yuya), articles(:asahi2), tags(:rail),    true ],
      [users(:yuya), articles(:asahi1), tags(:rail),    false],
    ].each_with_index { |(user, article, tag, expected), index|
      taggings = taggings(:yuya_asahi2_rail)
      taggings.user    = user
      taggings.article = article
      taggings.tag     = tag
      assert_equal(expected, taggings.valid?, index.to_s)
    }
  end

  #
  # クラスメソッド
  #

  test "create_tag_frequency_table" do
    ids = [
      taggings(:yuya_asahi1_rail),
      taggings(:yuya_asahi2_rail),
      taggings(:risa_asahi1_rail),
      taggings(:risa_asahi2_nonrail),
    ].map(&:id)
    expected = {
      articles(:asahi1).id => {
        tags(:rail).id    => 2,
      },
      articles(:asahi2).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 1,
      },
    }
    assert_equal(
      expected,
      @klass.scoped_by_id(ids).create_tag_frequency_table)
  end

  test "create_tag_frequency_table, empty" do
    assert_equal(
      {},
      @klass.scoped_by_id([]).create_tag_frequency_table)
  end
end
