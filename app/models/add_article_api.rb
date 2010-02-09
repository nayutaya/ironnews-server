# == Schema Information
# Schema version: 20091215020439
#
# Table name: active_forms
#
#  url1 :text
#  url2 :text
#

require "open-uri"

# 記事追加API
class AddArticleApi < ApiBase
  # FIXME: url3～url10を追加
  column :url1, :type => :text
  column :url2, :type => :text

  # FIXME: 複数のURLのタイトルを一度に取得する
  def self.get_title(url)
    api_url = "http://v4.latest.ironnews-helper2.appspot.com/hatena_bookmark/get_title?url=" + CGI.escape(url)
    json = open(api_url) { |io| io.read }
    obj  = ActiveSupport::JSON.decode(json)
    return obj["response"]["title"]
  end

  # FIXME: JSONスキーマを追加
  # FIXME: 検証処理を追加
  def execute
    result = {
      :success => true,
      :result  => {},
    }

    self.urls.each { |num, url|
      canonical_url = IronnewsUtility.get_canonical_url(url)

      article = Article.find_by_url(canonical_url)

      if article
        title = article.title
      else
        title = self.class.get_title(canonical_url)
      end

      unless article
        article = Article.create!(
          :title => title,
          :url   => canonical_url)
      end

      result[:result][num] = {
        :article_id => article.id,
        :url        => canonical_url,
        :title      => title,
      }
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
