
require "open-uri"

# 記事追加API
class AddArticleApi < ActiveForm
  column :url1, :type => :text

  def self.get_title(url)
    api_url = "http://v2.latest.ironnews-helper2.appspot.com/hatena-bookmark/get-title?url1=" + CGI.escape(url)
    json = open(api_url) { |io| io.read }
    obj  = ActiveSupport::JSON.decode(json)
    return obj[1]["title"]
  end

  def execute
    url   = self.url1
    title = self.class.get_title(url)

    result = {
      :success => true,
      :result  => {
        1 => {
          :url   => url,
          :title => title,
        },
      },
    }

    article = Article.new
    article.title = title
    article.host  = URI.parse(url).host
    article.path  = URI.parse(url).path
    article.save!

    return result
  end
end
