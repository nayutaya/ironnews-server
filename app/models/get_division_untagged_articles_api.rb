
# 区分タグ未設定記事取得APIフォーム
class GetDivisionUntaggedArticlesApi < ApiBase
  column :page,     :type => :integer, :default =>  1
  column :per_page, :type => :integer, :default => 10

  validates_presence_of :page
  validates_presence_of :per_page
  validates_numericality_of :page, :greater_than_or_equal_to => 1, :only_integer => true
  validates_numericality_of :per_page, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100, :only_integer => true

  def search(user_id)
    return Article.
      division_untagged_by(user_id).
      paginate(
        :order    => "articles.created_at DESC, articles.id DESC",
        :page     => self.page,
        :per_page => self.per_page)
  end

  def execute(user_id)
    unless self.valid?
      return {
        :success => false,
        :errors  => self.errors.full_messages,
      }
    end

    articles = self.search(user_id)

    return {
      :success => true,
      :result  => {
        :page          => articles.current_page,
        :per_page      => articles.per_page,
        :total_entries => articles.total_entries,
        :articles      => articles.map { |article|
          {
            :article_id => article.id,
            :title      => article.title,
            :url        => article.url,
          }
        },
      },
    }
  end
end
