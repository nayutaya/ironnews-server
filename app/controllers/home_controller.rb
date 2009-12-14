
require "open-uri"

# ホーム
class HomeController < ApplicationController
  # TODO: テストせよ
  # GET /
  def index
    @articles = Article.all(:order => "articles.created_at DESC, articles.id DESC", :limit => 100)
  end

  def add
    # nop
  end

  def login
    api_token = params[:api_token]
    user      = User.find_by_api_token(api_token)
    if user
      session[:user_id] = user.id
      flash[:notice] = "ログインしました #{user.id}"
    end
    redirect_to(:action => "index")
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to(:action => "index")
  end
end
