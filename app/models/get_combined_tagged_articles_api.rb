
# 合成タグ設定済み記事取得API
class GetCombinedTaggedArticlesApi < ApiBase
  column :division_tag, :type => :text
  column :category_tag, :type => :text
  column :area_tag,     :type => :text
  column :page,         :type => :integer, :default =>  1
  column :per_page,     :type => :integer, :default => 10

  validates_presence_of :page
  validates_presence_of :per_page
  validates_numericality_of :page, :greater_than_or_equal_to => 1, :only_integer => true, :allow_blank => true
  validates_numericality_of :per_page, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100, :only_integer => true, :allow_blank => true

  def search
    articles = Article

    unless self.division_tag.blank?
      articles = articles.division(self.division_tag)
    end
    unless self.category_tag.blank?
      articles = articles.category(self.category_tag)
    end

    return articles.all(
      :order => "articles.created_at DESC, articles.id DESC")
  end
end
