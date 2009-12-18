# == Schema Information
# Schema version: 20091215020439
#
# Table name: active_forms
#
#  article_id :integer
#  tag1       :string
#

# 複数タグ追加API
class AddTagsApi < ApiBase
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
  # FIXME: tagの長さを検証

  def tags
    return (1..10).
      map { |i| self.__send__("tag#{i}") }.
      reject(&:blank?)
  end

  def execute(user_id)
    tag_ids = self.tags.
      sort.uniq.
      map { |tag| Tag.get(tag) }.
      compact.
      map(&:id)

    unless tag_ids.empty?
      tag_ids.each { |tag_id|
        Tagging.find_or_create_by_user_id_and_article_id_and_tag_id(
          user_id, self.article_id, tag_id)
      }
    end

    tag = Tag.get(self.tag1)

    tagging = Tagging.find_or_create_by_user_id_and_article_id_and_tag_id(
      user_id, self.article_id, tag.id)

    result = {
      :success => true,
      :result  => {
        :article_id => tagging.article_id,
        :tag1_id    => tagging.tag_id,
      },
    }

    return result
  end
end
