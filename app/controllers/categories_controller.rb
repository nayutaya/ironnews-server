
class CategoriesController < ApplicationController
  def social
    show_articles("社会")
  end

  def accident
    show_articles("事件事故")
  end

  def molestation
    show_articles("痴漢")
  end

  def economy
    show_articles("政治経済")
  end

  def science
    show_articles("科学技術")
  end

  def vehicle
    show_articles("車両")
  end

  private

  def show_articles(category)
    @category = category
    @articles = Article.division("鉄道").category(category).all(:order => "articles.created_at DESC")
    render(:template => "categories/common")
  end
end
