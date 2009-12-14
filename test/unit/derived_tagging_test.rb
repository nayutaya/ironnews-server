
require 'test_helper'

class DerivedTaggingTest < ActiveSupport::TestCase
  def setup
    @klass = DerivedTagging
    @basic = @klass.new(
      :serial     => 1,
      :article_id => 1,
      :tag_id     => 1)
  end

  #
  # 関連
  #

  test "belongs_to :article" do
    assert_equal(
      articles(:asahi1),
      derived_taggings(:asahi1_rail).article)

    assert_equal(
      articles(:asahi3),
      derived_taggings(:asahi3_nonrail).article)
  end

  test "belongs_to :tag" do
    assert_equal(
      tags(:rail),
      derived_taggings(:asahi1_rail).tag)

    assert_equal(
      tags(:nonrail),
      derived_taggings(:asahi3_nonrail).tag)
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

  test "validates_presence_of :serial" do
    @basic.serial = nil
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

  test "validates_uniqueness_of :tag_id, :scope => [:article_id], on create" do
    [
      [articles(:asahi1), tags(:nonrail), true ],
      [articles(:asahi3), tags(:rail),    true ],
      [articles(:asahi1), tags(:rail),    false],
    ].each_with_index { |(article, tag, expected), index|
      @basic.article = article
      @basic.tag     = tag
      assert_equal(expected, @basic.valid?, index.to_s)
    }
  end

  test "validates_uniqueness_of :tag_id, :scope => [:article_id], on update" do
    [
      [articles(:asahi1), tags(:rail),    true ],
      [articles(:asahi1), tags(:nonrail), true ],
      [articles(:asahi3), tags(:rail),    true ],
      [articles(:asahi2), tags(:rail),    false],
    ].each_with_index { |(article, tag, expected), index|
      derived_taggings = derived_taggings(:asahi1_rail)
      derived_taggings.article = article
      derived_taggings.tag     = tag
      assert_equal(expected, derived_taggings.valid?, index.to_s)
    }
  end

  #
  # クラスメソッド
  #

  test "get_maximum_serial, empty" do
    @klass.delete_all
    assert_equal(1, @klass.get_maximum_serial)
  end

  test "get_maximum_serial, normal" do
    assert_equal(
      @klass.all.map(&:serial).max,
      @klass.get_maximum_serial)
  end

  test "get_target_taggings, all" do
    assert_equal(
      Tagging.all.sort_by(&:id),
      @klass.get_target_taggings(0, 10))
  end

  test "get_target_taggings, part" do
    taggings = Tagging.all.sort_by(&:id)
    serial   = taggings.delete_at(0).id
    assert_equal(
      taggings,
      @klass.get_target_taggings(serial, 10))
    assert_equal(
      taggings[0, 2],
      @klass.get_target_taggings(serial, 2))
  end

  test "get_division_tags" do
    tags = @klass.get_divition_tags
    assert_equal(2, tags.size)
    assert_equal(
      %w[鉄道 非鉄],
      tags.map(&:name))
  end

  test "create_tag_table" do
    article_ids = [
      articles(:asahi1).id,
      articles(:asahi2).id,
      articles(:mainichi1).id,
    ]
    expected = {
      articles(:asahi1).id => {
        tags(:rail).id => 2,
      },
      articles(:asahi2).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 1,
      },
      articles(:mainichi1).id => {},
    }
    assert_equal(
      expected,
      @klass.create_tag_table(article_ids))
  end

  test "create_derive_tag_table, limit 1" do
    tag_table = {
      articles(:asahi1).id => {
        tags(:rail).id    => 2,
      },
      articles(:asahi2).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 1,
      },
      articles(:asahi3).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 2,
      },
      articles(:mainichi1).id => {
        Tag.get("新しいタグ").id => 1,
      }
    }
    tag_ids = [tags(:rail).id, tags(:nonrail).id]
    expected = {
      articles(:asahi1).id    => [tags(:rail).id],
      articles(:asahi2).id    => [tags(:rail).id],
      articles(:asahi3).id    => [tags(:nonrail).id],
      articles(:mainichi1).id => [],
    }
    assert_equal(
      expected,
      @klass.create_derive_tag_table(tag_table, tag_ids, 1))
  end

  test "create_derive_tag_table, limit 2" do
    tag_table = {
      articles(:asahi1).id => {
        tags(:rail).id    => 2,
      },
      articles(:asahi2).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 1,
      },
      articles(:asahi3).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 2,
      },
    }
    tag_ids = [tags(:rail).id, tags(:nonrail).id]
    expected = {
      articles(:asahi1).id => [tags(:rail).id],
      articles(:asahi2).id => [tags(:rail).id, tags(:nonrail).id],
      articles(:asahi3).id => [tags(:nonrail).id, tags(:rail).id],
    }
    assert_equal(
      expected,
      @klass.create_derive_tag_table(tag_table, tag_ids, 2))
  end

  # TODO: テストせよ
  test "update" do
    @klass.update
  end
end
