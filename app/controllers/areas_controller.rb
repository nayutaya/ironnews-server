
class AreasController < ApplicationController
  def hokkaido
    @rail     = Tag.get("鉄道")
    @hokkaido = Tag.get("北海道")

    @articles = CombinedTagging.all(
      :include    => :article,
      :conditions => [
        "(combined_taggings.division_tag_id = ?) AND ((combined_taggings.area_tag1_id = ?) OR (combined_taggings.area_tag2_id = ?))",
        @rail.id,
        @hokkaido.id,
        @hokkaido.id,
      ]).map(&:article)
  end
end
