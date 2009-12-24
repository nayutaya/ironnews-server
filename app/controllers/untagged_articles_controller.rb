
class UntaggedArticlesController < ApplicationController
  before_filter :auth

  def division
    @articles = Article.
      division_untagged_by(@user.id).
      all(:order => "articles.created_at DESC")
  end

  def category
    @articles = Article.
      category_untagged_by(@user.id).
      all(:order => "articles.created_at DESC")
  end

  def area
    @articles = Article.
      area_untagged_by(@user.id).
      all(:order => "articles.created_at DESC")
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
