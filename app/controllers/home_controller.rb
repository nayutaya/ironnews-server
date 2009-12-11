
require "open-uri"

# ホーム
class HomeController < ApplicationController
  # TODO: テストせよ
  # GET /
  def index
    @articles = Article.all(:order => "articles.created_at DESC, articles.id DESC")
  end

  def add
    # nop
  end

=begin
  def login
    session[:user_id] = User.find_by_name("yuya").id
    flash[:notice] = "ログインしました #{session[:user_id]}"
    redirect_to(:action => "index")
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to(:action => "index")
  end
=end
end
