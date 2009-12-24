
class AreasController < ApplicationController
  def okinawa
    show_articles("沖縄")
  end

  def kyushu
    show_articles("九州")
  end

  def shikoku
    show_articles("四国")
  end

  def chugoku
    show_articles("中国")
  end

  def kinki
    show_articles("近畿")
  end

  def chubu
    show_articles("中部")
  end

  def kanto
    show_articles("関東")
  end

  def tohoku
    show_articles("東北")
  end

  def hokkaido
    show_articles("北海道")
  end

  def world
    show_articles("海外")
  end

  private

  def show_articles(area)
    @area     = area
    @articles = Article.
      division("鉄道").
      area(area).
      paginate(
        :order    => "articles.created_at DESC",
        :page     => params[:page],
        :per_page => 100)
    render(:template => "areas/common")
  end
end
