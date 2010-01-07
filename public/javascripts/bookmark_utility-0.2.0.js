
var BookmarkUtility = {};

BookmarkUtility.HostPattern = /^http:\/\/(.+?)[\/:]/;

BookmarkUtility.CleanseTitleTable = {
//<CleanseTitleTable>
  "mainichi.jp": [/^(.+) - 毎日ｊｐ\(毎日新聞\)$/, "$1"],
  "sankei.jp.msn.com": [/^(.+) - MSN産経ニュース$/, "$1"],
  "www.asahi.com": [/^asahi\.com（朝日新聞社）：(.+)$/, "$1"],
  "www.yomiuri.co.jp": [/^(.+) : YOMIURI ONLINE（読売新聞）$/, "$1"],
//</CleanseTitleTable>
  end: null
};

BookmarkUtility.cleanse_title = function(url, title) {
  var host   = (url.match(BookmarkUtility.HostPattern) || [])[1];
  var record = BookmarkUtility.CleanseTitleTable[host];
  if ( record != null )
  {
    var pattern = record[0];
    var replace = record[1];
    title = title.replace(pattern, replace);
  }
  return title;
};
