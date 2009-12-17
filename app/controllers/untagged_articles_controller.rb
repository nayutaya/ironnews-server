
class UntaggedArticlesController < ApplicationController
  before_filter :auth

  def division
    target_tag_ids = CombinedTagging.get_division_tags.map(&:id).sort

    recent_article_ids = Article.all(
      :select => "articles.id",
      :order  => "articles.created_at DESC",
      :limit  => 500).map(&:id).sort

    tagged_article_ids = @user.taggings.all(
      :select     => "taggings.article_id",
      :conditions => ["taggings.tag_id IN (?)", target_tag_ids]).map(&:article_id).sort.uniq

    untagged_article_ids = recent_article_ids - tagged_article_ids

    @articles = Article.all(
      :conditions => ["articles.id IN (?)", untagged_article_ids],
      :order      => "articles.created_at DESC")
  end

  def category
    target_tag_ids = CombinedTagging.get_category_tags.map(&:id).sort

    recent_article_ids = Article.division("鉄道").all(
      :select => "articles.id",
      :order  => "articles.created_at DESC",
      :limit  => 500).map(&:id).sort

    tagged_article_ids = @user.taggings.all(
      :select     => "taggings.article_id",
      :conditions => ["taggings.tag_id IN (?)", target_tag_ids]).map(&:article_id).sort.uniq

    untagged_article_ids = recent_article_ids - tagged_article_ids

    @articles = Article.all(
      :conditions => ["articles.id IN (?)", untagged_article_ids],
      :order      => "articles.created_at DESC")
  end

  def area

  end

  private

  def auth
    @user = User.find_by_id(session[:user_id])
    unless @user
      flash[:notice] = "ログインが必要です"
      redirect_to(:controller => "home", :action => "index")
      return
    end
  end
end
