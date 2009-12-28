# == Schema Information
# Schema version: 20091215020439
#
# Table name: active_forms
#
#  article_ids :text
#

# 記事取得API
class GetArticlesApi < ApiBase
  ArticleIdsFormat = /\A\d+(,\d+)*\z/

  column :article_ids, :type => :text

  validates_presence_of :article_ids
  validates_format_of :article_ids, :with => ArticleIdsFormat, :allow_blank => true

  def parsed_article_ids
    return self.article_ids.split(/,/).map(&:to_i)
  end

  # FIXME: JSONスキーマを追加
  # FIXME: 検証エラー時の結果に、エラーメッセージを追加
  def execute
    unless self.valid?
      return {:success => false}
    end

    # FIXME: 記事IDを文字列化
    articles = Article.find_all_by_id(self.parsed_article_ids.sort.uniq).mash { |article|
      [article.id, {
        :title => article.title,
        :url   => article.url,
      }]
    }

    return {
      :success => true,
      :result  => articles,
    }
  end
end
