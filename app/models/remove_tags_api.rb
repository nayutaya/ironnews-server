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
    tags = self.tags.map { |tag| Tag.get(tag, :create => false) }.compact
    unless tags.empty?
      #taggings = Tagging.find_all_by_user_id_and_article_id_and_tag_id(user_id, self.article_id, tags.map(&:id))
      taggings = Tagging.all(
        :conditions => [
          "(taggings.user_id = :user_id) AND (taggings.article_id = :article_id) AND (taggings.tag_id IN (:tag_ids))",
          {
            :user_id    => user_id,
            :article_id => self.article_id,
            :tag_ids    => tags.map(&:id),
          }
        ])
      taggings.each(&:destroy)
    end

    tag = Tag.get(self.tag1, :create => false)
    if tag
      tagging = Tagging.find_by_user_id_and_article_id_and_tag_id(user_id, self.article_id, tag.id)
      tagging.destroy if tagging
    end

    return {
      :success => true,
    }
  end
end
