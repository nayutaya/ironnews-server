
require "open-uri"

# ホーム
class HomeController < ApplicationController
  # TODO: テストせよ
  # GET /
  def index
    @articles = Article.all(:order => "articles.created_at DESC, articles.id DESC")
  end

  # FIXME: 検証コード
  def add
    params.delete(:commit)
    params.delete(:authenticity_token)
    params.delete(:controller)
    params.delete(:action)
    api = AddArticleApi.new(params)
    api.execute

    redirect_to(:action => "index")
  end

  def view
    @article_ids = params[:article_ids].split(/,/).map(&:to_i)
  end

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

  def get_info
    @article_ids = params[:article_ids].split(/,/).map(&:to_i)
    @callback    = params[:callback]

    articles = Article.all(:conditions => {:id => @article_ids})

    ret = articles.inject({}) { |memo, article|
      memo[article.id] = {
        "title" => article.title,
        "url"   => article.url,
      }
      memo
    }

    json = "#{@callback}(#{ret.to_json})"
    send_data(json, :type => "text/javascript", :disposition => "inline")
  end
end
