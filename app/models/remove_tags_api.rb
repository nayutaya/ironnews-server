# == Schema Information
# Schema version: 20091215020439
#
# Table name: active_forms
#
#  article_id :integer
#  tag1       :string
#

# 複数タグ削除API
class RemoveTagsApi < ApiBase
  column :article_id, :type => :integer
  column :tag1,       :type => :string
  column :tag2,       :type => :string
  column :tag3,       :type => :string
  column :tag4,       :type => :string
  column :tag5,       :type => :string
  column :tag6,       :type => :string
  column :tag7,       :type => :string
  column :tag8,       :type => :string
  column :tag9,       :type => :string
  column :tag10,      :type => :string

  validates_presence_of :article_id
  validates_presence_of :tag1
  # FIXME: article_idの存在を検証
  # FIXME: tag1の長さを検証

  def tags
    return (1..10).
      map { |i| self.__send__("tag#{i}") }.
      reject(&:blank?)
  end

  def execute(user_id)
    tag_ids = self.tags.
      sort.uniq.
      map { |tag| Tag.get(tag, :create => false) }.
      compact.
      map(&:id)

    unless tag_ids.empty?
      Tagging.
        scoped_by_user_id(user_id).
        scoped_by_article_id(self.article_id).
        scoped_by_tag_id(tag_ids).
        each(&:destroy)
    end

    return {
      :success => true,
    }
  end
end
