
class AreasController < ApplicationController
  def okinawa
    show_articles("沖縄")
  end

  def hokkaido
    show_articles("北海道")
  end

  private

  def show_articles(area)
    @area     = area
    @articles = Article.division("鉄道").area(area).all(:order => "articles.created_at DESC")
    render(:template => "areas/common")
  end
end
