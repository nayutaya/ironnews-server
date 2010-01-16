
require 'test_helper'

class CombinedTaggingTest < ActiveSupport::TestCase
  def setup
    @klass = CombinedTagging
    @basic = @klass.new(
      :serial     => 1,
      :article_id => articles(:mainichi2).id)
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

  test "validates_uniqueness_of :article_id, on create" do
    @basic.article_id = articles(:asahi1).id
    assert_equal(false, @basic.valid?)
  end

  test "validates_uniqueness_of :article_id, on update" do
    record = combined_taggings(:asahi1)
    record.article_id = articles(:asahi2).id
    assert_equal(false, record.valid?)
  end

  #
  # 関連
  #

  test "belongs_to :article" do
    assert_equal(
      articles(:asahi1),
      combined_taggings(:asahi1).article)

    assert_equal(
      articles(:asahi3),
      combined_taggings(:asahi3).article)
  end

  test "belongs_to :division_tag" do
    assert_equal(
      tags(:rail),
      combined_taggings(:asahi1).division_tag)

    assert_equal(
      nil,
      combined_taggings(:asahi2).division_tag)
  end

  test "belongs_to :category_tag1" do
    assert_equal(
      tags(:social),
      combined_taggings(:asahi1).category_tag1)

    assert_equal(
      nil,
      combined_taggings(:asahi3).category_tag1)
  end

  test "belongs_to :category_tag2" do
    assert_equal(
      tags(:economy),
      combined_taggings(:asahi1).category_tag2)

    assert_equal(
      nil,
      combined_taggings(:asahi3).category_tag2)
  end

  test "belongs_to :area_tag1" do
    assert_equal(
      tags(:kanto),
      combined_taggings(:asahi1).area_tag1)

    assert_equal(
      nil,
      combined_taggings(:asahi3).area_tag1)
  end

  test "belongs_to :area_tag2" do
    assert_equal(
      tags(:kinki),
      combined_taggings(:asahi1).area_tag2)

    assert_equal(
      nil,
      combined_taggings(:asahi3).area_tag2)
  end

  #
  # クラスメソッド
  #

  test "get_current_serial" do
    assert_equal(
      @klass.all.map(&:serial).max,
      @klass.get_current_serial)
  end

  test "get_current_serial, empty" do
    @klass.delete_all
    assert_equal(1, @klass.get_current_serial)
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
    assert_equal(
      @klass::DivisionTags,
      @klass.get_division_tags.map(&:name))
  end

  test "get_category_tags" do
    assert_equal(
      @klass::CategoryTags,
      @klass.get_category_tags.map(&:name))
  end

  test "get_area_tags" do
    assert_equal(
      @klass::AreaTags,
      @klass.get_area_tags.map(&:name))
  end

  test "create_tag_frequency_table" do
    article_ids = [
      articles(:asahi1).id,
      articles(:asahi2).id,
      articles(:mainichi1).id,
    ]
    expected = {
      articles(:asahi1).id => {
        tags(:rail).id    => 2,
        tags(:social).id  => 1,
        tags(:kanto).id   => 1,
      },
      articles(:asahi2).id => {
        tags(:rail).id    => 1,
        tags(:nonrail).id => 1,
        tags(:economy).id => 1,
        tags(:kinki).id   => 1,
      },
    }
    assert_equal(
      expected,
      @klass.create_tag_frequency_table(article_ids))
  end

  test "create_combined_tag_table, limit 1" do
    tag_frequency_table = {
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
        tags(:social).id  => 1,
      }
    }
    candidate_tag_ids = [
      tags(:rail).id,
      tags(:nonrail).id,
    ]
    expected = {
      articles(:asahi1).id    => [tags(:rail).id],
      articles(:asahi2).id    => [tags(:rail).id],
      articles(:asahi3).id    => [tags(:nonrail).id],
      articles(:mainichi1).id => [],
    }
    assert_equal(
      expected,
      @klass.create_combined_tag_table(tag_frequency_table, candidate_tag_ids, 1))
  end

  test "create_combined_tag_table, limit 2" do
    tag_frequency_table = {
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
    candidate_tag_ids = [
      tags(:rail).id,
      tags(:nonrail).id,
    ]
    expected = {
      articles(:asahi1).id => [tags(:rail).id],
      articles(:asahi2).id => [tags(:rail).id, tags(:nonrail).id],
      articles(:asahi3).id => [tags(:nonrail).id, tags(:rail).id],
    }
    assert_equal(
      expected,
      @klass.create_combined_tag_table(tag_frequency_table, candidate_tag_ids, 2))
  end

  # TODO: テストせよ
  test "incremental_update" do
    @klass.incremental_update
  end
end
