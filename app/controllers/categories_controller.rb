
class CategoriesController < ApplicationController
  def social
    @rail     = Tag.get("鉄道")
    @category = Tag.get("社会")

    @articles = CombinedTagging.all(
      :include    => :article,
      :conditions => [
        "(combined_taggings.division_tag_id = ?) AND ((combined_taggings.category_tag1_id = ?) OR (combined_taggings.category_tag2_id = ?))",
        @rail.id,
        @category.id,
        @category.id,
      ]).map(&:article)
  end
end
