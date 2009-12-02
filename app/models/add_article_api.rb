
require "open-uri"

# 記事追加API
class AddArticleApi < ActiveForm
  column :url1, :type => :text
  column :url2, :type => :text

  def self.get_title(url)
    api_url = "http://v2.latest.ironnews-helper2.appspot.com/hatena-bookmark/get-title?url1=" + CGI.escape(url)
    json = open(api_url) { |io| io.read }
    obj  = ActiveSupport::JSON.decode(json)
    return obj[1]["title"]
  end

  def execute
    result = {
      :success => true,
      :result  => {},
    }

    self.urls.each { |num, url|
      title = self.class.get_title(url)
      result[:result][num] = {
        :url  => url,
        :title => title,
      }

      Article.create!(
        :title => title,
        :url   => url)
    }

    return result
  end

  def urls
    result = []
    result << [1, self.url1] unless self.url1.blank?
    result << [2, self.url2] unless self.url2.blank?
    return result
  end
end
