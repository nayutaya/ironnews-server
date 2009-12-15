
class AreasController < ApplicationController
  def hokkaido
    @articles = Article.
      division("鉄道").
      area("北海道").
      all
  end
end
