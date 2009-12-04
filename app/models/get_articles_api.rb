
# 記事取得API
class GetArticlesApi < ApiBase
  ArticleIdsFormat = /\A\d+(,\d+)*\z/

  column :article_ids, :type => :text

  validates_presence_of :article_ids
  validates_format_of :article_ids, :with => ArticleIdsFormat, :allow_blank => true

  def parsed_article_ids
    return self.article_ids.split(/,/).map(&:to_i)
  end

  def execute
    unless self.valid?
      return {:success => false}
    end

    # FIXME: まとめて取得する
    articles = {}
    self.parsed_article_ids.each { |article_id|
      # FIXME: エラー処理
      article = Article.find_by_id(article_id)
      articles[article_id] = {
        :title => article.title,
        :url   => article.url,
      }
    }

    result = {
      :success => true,
      :result  => articles,
    }
    return result
  end
end
