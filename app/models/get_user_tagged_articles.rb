
# ユーザタグ設定済み記事取得API
class GetUserTaggedArticles < ApiBase
  column :tag,      :type => :text
  column :page,     :type => :integer, :default =>  1
  column :per_page, :type => :integer, :default => 10

  validates_presence_of :tag
  validates_presence_of :page
  validates_presence_of :per_page
  validates_numericality_of :page, :greater_than_or_equal_to => 1, :only_integer => true, :allow_blank => true
  validates_numericality_of :per_page, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100, :only_integer => true, :allow_blank => true

  def search(user_id)
    tag_id = Tag.get(self.tag).id
    scope = {
      :conditions => [
        "EXISTS (SELECT * FROM taggings WHERE (taggings.article_id = articles.id) AND (taggings.user_id = ?) AND (taggings.tag_id = ?))",
        user_id,
        tag_id,
      ],
    }
    return Article.
      scoped(scope).
      paginate(
        :order    => "articles.created_at DESC, articles.id DESC",
        :page     => self.page,
        :per_page => self.per_page)
  end
end
