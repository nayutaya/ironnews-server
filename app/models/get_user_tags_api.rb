
# ユーザタグ取得API
class GetUserTagsApi < ApiBase
  ArticleIdsFormat = /\A\d+(,\d+)*\z/

  column :article_ids, :type => :text

  validates_presence_of :article_ids
  validates_format_of :article_ids, :with => ArticleIdsFormat, :allow_blank => true
end
