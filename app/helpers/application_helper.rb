
module ApplicationHelper
  def article_link(article)
    return link_to(
      h(article.title),
      article.url,
      :id    => "article-#{article.id}",
      :title => article.created_at.strftime("%Y年%m月%d日%H時%M分: ") + article.title)
  end
end
