
# 記事
class ArticlesController < ApplicationController
  def index
    @articles = Article.paginate(
      :order    => "articles.created_at DESC",
      :page     => params[:page],
      :per_page => 25)
  end
end
