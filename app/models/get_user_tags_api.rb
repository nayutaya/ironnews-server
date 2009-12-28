
# ユーザタグ取得API
class GetUserTagsApi < ApiBase
  ArticleIdsFormat = /\A\d+(,\d+)*\z/

  column :article_ids, :type => :text

  validates_presence_of :article_ids
  validates_format_of :article_ids, :with => ArticleIdsFormat, :allow_blank => true

  def self.schema
    return {
      "type"       => "object",
      "properties" => {
        "success" => {"type" => "boolean"},
        "errors"  => {"type" => "array", "optional" => true},
        "result"  => {
          "type"       => "object",
          "optional"   => true,
          # FIXME: キーが可変の場合のスキーマの記述方法がわからない
        },
      },
    }
  end

  def parsed_article_ids
    return self.article_ids.split(/,/).map(&:to_i)
  end

  def search(user_id)
    # FIXME: まとめて取得する
    result = {}
    self.parsed_article_ids.each { |article_id|
      article = Article.find(article_id)
      result[article_id] = article.taggings.all(
        :conditions => ["taggings.user_id = ?", user_id],
        :order      => "taggings.tag_id ASC").map(&:tag).map(&:name)
    }

    return result
  end

  def execute(user_id)
    unless self.valid?
      return {
        "success" => false,
        "errors"  => self.errors.full_messages,
      }
    end

    # FIXME: まとめて取得する
    result = {}
    self.parsed_article_ids.each { |article_id|
      article = Article.find(article_id)
      result[article_id.to_s] = article.taggings.all(
        :conditions => ["taggings.user_id = ?", user_id],
        :order      => "taggings.tag_id ASC").map(&:tag).map(&:name)
    }

    return {
      "success" => true,
      "result"  => result,
    }
  end
end
