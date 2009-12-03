#! ruby -Ku

require "cgi"
require "open-uri"

require "rubygems"
gem "nayutaya-wsse"
require "wsse"

username = "yuya"
password = "11111111111111111111111111111111"
wsse     = Wsse::UsernameToken.build(username, password).format
p wsse

url = "http://localhost:3000/api/add_article?url1=" + CGI.escape("http://www.asahi.com/")

open(url, {"X-WSSE" => wsse}) { |io|
  puts io.read
}
