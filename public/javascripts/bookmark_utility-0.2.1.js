
var BookmarkUtility = {};

BookmarkUtility.HostPattern = /^http:\/\/(.+?)[\/:]/;

BookmarkUtility.CleanseTitleTable = {
//<CleanseTitleTable>
  "mainichi.jp": [/^(.+) - 毎日ｊｐ\(毎日新聞\)$/, "$1"],
  "mytown.asahi.com": [/^asahi\.com:(.+)-マイタウン(.+)$/, "$1 - $2"],
  "sankei.jp.msn.com": [/^(.+) - MSN産経ニュース$/, "$1"],
  "www.47news.jp": [/^(.+) - 47NEWS（よんななニュース）$/, "$1"],
  "www.asahi.com": [/^asahi\.com（朝日新聞社）：(.+)$/, "$1"],
  "www.chunichi.co.jp": [/^中日新聞:(.+)\(CHUNICHI Web\)$/, "$1"],
  "www.yomiuri.co.jp": [/^(.+) : YOMIURI ONLINE（読売新聞）$/, "$1"],
  "www.jiji.com": [/^時事ドットコム：(.+)$/, "$1"],
  "slashdot.jp": [/^(.+) - スラッシュドット・ジャパン$/, "$1"],
  "www.tokyo-np.co.jp": [/^東京新聞:(.+)\(TOKYO Web\)$/, "$1"],
  "www.hokkaido-np.co.jp": [/^(.+)−北海道新聞\[青森からこんにちは\]$/, "$1"],
  "japan.cnet.com": [/^(.+) - CNET Japan$/, "$1"],
  "gigazine.net": [/^(.+) - GIGAZINE$/, "$1"],
  "www.kobe-np.co.jp": [/^神戸新聞｜(.+)$/, "$1"],
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
