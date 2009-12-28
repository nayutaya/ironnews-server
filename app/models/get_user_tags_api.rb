
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
=begin
        "result"  => {
          "type"       => "object",
          "optional"   => true,
          "properties" => {
            "total_entries"    => {"type" => "integer"},
            "total_pages"      => {"type" => "integer"},
            "current_page"     => {"type" => "integer"},
            "entries_per_page" => {"type" => "integer"},
            "articles"         => {
              "type"  => "array",
              "items" => {
                "type" => "object",
                "properties" => {
                  "article_id" => {"type" => "integer"},
                  "title"      => {"type" => "string"},
                  "url"        => {"type" => "string"},
                },
              },
            },
          },
        },
=end
      },
    }
  end

  def parsed_article_ids
    return self.article_ids.split(/,/).map(&:to_i)
  end

  def execute(user_id)
    unless self.valid?
      return {
        "success" => false,
        "errors"  => self.errors.full_messages,
      }
    end

    return {
      "success" => true,
    }
  end
end
