
# 合成タグ取得API
class GetCombinedTagsApi < ApiBase
  ArticleIdsFormat = /\A\d+(,\d+)*\z/

  column :article_ids, :type => :text

  validates_presence_of :article_ids
  validates_format_of :article_ids, :with => ArticleIdsFormat, :allow_blank => true

  def parsed_article_ids
    return self.article_ids.split(/,/).map(&:to_i)
  end

=begin
  def search
    return {}
  end
=end
end
