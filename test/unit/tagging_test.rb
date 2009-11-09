
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

  # TODO: 関連を実装せよ

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
