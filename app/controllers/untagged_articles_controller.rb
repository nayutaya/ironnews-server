
class UntaggedArticlesController < ApplicationController
  before_filter :auth

  def division
    @articles = Article.
      division_untagged_by(@user.id).
      paginate(
        :order    => "articles.created_at DESC",
        :page     => params[:page],
        :per_page => 100)
  end

  def category
    @articles = Article.
      division("鉄道").
      category_untagged_by(@user.id).
      paginate(
        :order    => "articles.created_at DESC",
        :page     => params[:page],
        :per_page => 100)
  end

  def area
    @articles = Article.
      division("鉄道").
      area_untagged_by(@user.id).
      paginate(
        :order    => "articles.created_at DESC",
        :page     => params[:page],
        :per_page => 100)
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
