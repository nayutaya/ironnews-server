
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
    @articles = Article.division(division).all(:order => "articles.created_at DESC")
    render(:template => "divisions/common")
  end
end
