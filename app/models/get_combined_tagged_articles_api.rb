
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
                "type"       => "object",
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

  def search
    articles = Article

    unless self.division_tag.blank?
      articles = articles.division(self.division_tag)
    end
    unless self.category_tag.blank?
      articles = articles.category(self.category_tag)
    end
    unless self.area_tag.blank?
      articles = articles.area(self.area_tag)
    end

    return articles.paginate(
      :order    => "articles.created_at DESC, articles.id DESC",
      :page     => self.page,
      :per_page => self.per_page)
  end
end
