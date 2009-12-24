
# 区分タグ未設定記事取得APIフォーム
class GetDivisionUntaggedArticlesApi < ApiBase
  column :page,     :type => :integer, :default =>  1
  column :per_page, :type => :integer, :default => 10

  validates_presence_of :page
  validates_presence_of :per_page
  validates_numericality_of :page, :greater_than_or_equal_to => 1, :only_integer => true
  validates_numericality_of :per_page, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 100, :only_integer => true

  def execute(user_id)
    articles = Article.
      paginate(
        :page => 1,
        :per_page => 10)
    x = (1..2)

    return {
      :success => true,
      :result  => {
        :page          => 1,
        :per_page      => 10,
        :total_entries => 2,
        :articles      => x.map {
          {
            :article_id => 1,
            :title      => "x",
            :url        => "y",
          }
        },
      },
    }
  end
end
