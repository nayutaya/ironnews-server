
class UntaggedArticlesController < ApplicationController
  def division
    user = User.find_by_id(session[:user_id])
    unless user
      flash[:notice] = "ログインが必要です"
      redirect_to(:controller => "home", :action => "index")
      return
    end

    tags   = CombinedTagging.get_division_tags
    recent = Article.all(:select => "id", :order => "articles.created_at DESC", :limit => 500)

    taggings = user.taggings.all(
      :select     => "article_id",
      :conditions => ["taggings.tag_id IN (?)", tags.map(&:id).sort])

    tagged_article_ids   = taggings.map(&:article_id).sort.uniq
    untagged_article_ids = recent.map(&:id) - tagged_article_ids

    @articles = Article.all(
      :conditions => ["articles.id IN (?)", untagged_article_ids],
      :order      => "articles.created_at DESC")
  end

  def category

  end

  def area

  end
end
