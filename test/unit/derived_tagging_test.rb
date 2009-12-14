
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
end
