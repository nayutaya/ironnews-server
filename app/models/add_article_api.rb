
# 記事追加API
class AddArticleApi < ActiveForm
  column :url1, :type => :text

  def execute
    article = Article.new
    article.title = "title"
    article.host  = "host"
    article.path  = "path"
    article.save!

    result = {
      :success => true,
    }

    return result
  end
end
