
class DivisionsController < ApplicationController
  def rail
    show_articles("鉄道")
  end

  def nonrail
    show_articles("非鉄")
  end

  private

  def show_articles(division)
    @division = division
    @articles = Article.
      division(division).
      paginate(
        :order    => "articles.created_at DESC",
        :page     => params[:page],
        :per_page => 100)
    render(:template => "divisions/common")
  end
end
