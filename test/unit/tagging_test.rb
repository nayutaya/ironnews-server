
require 'test_helper'

class TaggingTest < ActiveSupport::TestCase
  def setup
    @klass = Tagging
    @basic = @klass.new(
      :user_id    => 1,
      :article_id => 1,
      :tag_id     => 1)
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
end
