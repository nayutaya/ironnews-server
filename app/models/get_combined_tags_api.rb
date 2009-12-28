
# 合成タグ取得API
class GetCombinedTagsApi < ApiBase
  ArticleIdsFormat = /\A\d+(,\d+)*\z/

  column :article_ids, :type => :text

  validates_presence_of :article_ids
  validates_format_of :article_ids, :with => ArticleIdsFormat, :allow_blank => true

  def parsed_article_ids
    return self.article_ids.split(/,/).map(&:to_i)
  end

  def search
    result = self.parsed_article_ids.mash { |article_id|
      tags = []
      combined_tagging = CombinedTagging.find_by_article_id(article_id)
      if combined_tagging
        tag_ids = []
        tag_ids << combined_tagging.division_tag_id
        tag_ids << combined_tagging.category_tag1_id
        tag_ids << combined_tagging.category_tag2_id
        tag_ids << combined_tagging.area_tag1_id
        tag_ids << combined_tagging.area_tag2_id
        tags = tag_ids.compact.sort.map { |tag_id| Tag.get(tag_id).name }
      end

      [article_id, tags]
    }
    return result
  end
end
