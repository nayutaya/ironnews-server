
class CategoriesController < ApplicationController
  def social
    @articles = CombinedTagging.
      division("鉄道").
      category("社会").
      all(:include => :article).map(&:article)
  end
end
