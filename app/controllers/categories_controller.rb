
class CategoriesController < ApplicationController
  def social
    @articles = Article.
      division("鉄道").
      category("社会").
      all
  end
end
