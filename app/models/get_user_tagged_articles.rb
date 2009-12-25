
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

  def self.schema
    return {
      "type"       => "object",
      "properties" => {
        "success" => {"type" => "boolean"},
        "errors"  => {"type" => "array", "optional" => true},
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
      },
    }
  end

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

  def execute(user_id)
    unless self.valid?
      return {
        "success" => false,
        "errors"  => self.errors.full_messages,
      }
    end

    articles = self.search(user_id)

    return {
      "success" => true,
      "result"  => {
        "total_entries"    => articles.total_entries,
        "total_pages"      => articles.total_pages,
        "current_page"     => articles.current_page,
        "entries_per_page" => articles.per_page,
        "articles"         => articles.map { |article|
          {
            "article_id" => article.id,
            "title"      => article.title,
            "url"        => article.url,
          }
        },
      },
    }
  end
end
