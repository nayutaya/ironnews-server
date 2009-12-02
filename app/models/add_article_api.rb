
require "open-uri"

# 記事追加API
class AddArticleApi < ActiveForm
  # FIXME: url3～url10を追加
  column :url1, :type => :text
  column :url2, :type => :text

  # FIXME: 複数のURLのタイトルを一度に取得する
  def self.get_title(url)
    api_url = "http://v3.latest.ironnews-helper2.appspot.com/hatena-bookmark/get-title?url1=" + CGI.escape(url)
    json = open(api_url) { |io| io.read }
    obj  = ActiveSupport::JSON.decode(json)
    return obj["1"]["title"]
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

  # FIXME: ループで回す
  def urls
    result = []
    result << [1, self.url1] unless self.url1.blank?
    result << [2, self.url2] unless self.url2.blank?
    return result
  end
end
