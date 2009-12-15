
class AreasController < ApplicationController
  def hokkaido
    @articles = CombinedTagging.
      division("鉄道").
      area("北海道").
      all(:include => :article).map(&:article)
  end
end
