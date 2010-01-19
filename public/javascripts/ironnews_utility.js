
var IronnewsUtility = {};

IronnewsUtility.HostPattern = /^http:\/\/(.+?)[\/:]/;

IronnewsUtility.CleanseTitleTable = {
//<CleanseTitleTable>
  "gigazine.net": [[/^(.+) - GIGAZINE$/, "$1"]],
  "headlines.yahoo.co.jp": [[/^(.+) - Yahoo!ニュース$/, "$1"],[/^(.+)（.+）$/, "$1"]],
  "japan.cnet.com": [[/^(.+) - CNET Japan$/, "$1"]],
  "journal.mycom.co.jp": [[/^(.+) \| マイコミジャーナル$/, "$1"]],
  "kyushu.yomiuri.co.jp": [[/^(.+) : 九州発 : YOMIURI ONLINE（読売新聞）$/, "$1"]],
  "mainichi.jp": [[/^(.+) - 毎日ｊｐ\(毎日新聞\)$/, "$1"],[/^(.+) － 毎日ｊｐ\(毎日新聞\)$/, "$1"]],
  "mytown.asahi.com": [[/^asahi\.com:(.+)-マイタウン(.+)$/, "$1 - $2"]],
  "news.kanaloco.jp": [[/^(.+)：ローカルニュース : ニュース : カナロコ -- 神奈川新聞社$/, "$1"]],
  "news24.jp": [[/^(.+) \| 日テレNEWS24$/, "$1"]],
  "osaka.yomiuri.co.jp": [[/^(.+) : 関西発 : YOMIURI ONLINE（読売新聞）$/, "$1"],[/^(.+) : (経済　科学)$/, "$1"],[/^(.+) : (経済 ピックアップ|特集|ニュース|人 遊 食)$/, "$1"],[/^(.+) : 地域経済ニュース$/, "$1"]],
  "response.jp": [[/^(.+) \| レスポンス自動車ニュース（Response.jp）$/, "$1"]],
  "sankei.jp.msn.com": [[/^(.+) - MSN産経ニュース$/, "$1"],[/^(.+) \(\d+\/\d+ページ\)$/, "$1"]],
  "slashdot.jp": [[/^(.+) - スラッシュドット・ジャパン$/, "$1"]],
  "svr.sanyo.oni.co.jp": [[/^(.+) - 山陽新聞地域ニュース$/, "$1"]],
  "techon.nikkeibp.co.jp": [[/^(.+) - Tech-On！$/, "$1"]],
  "www.47news.jp": [[/^(.+) - 47NEWS（よんななニュース）$/, "$1"],[/^(.+) - 47NEWS \(よんななニュース\)$/, "$1"]],
  "www.afpbb.com": [[/^(.+)　国際ニュース : AFPBB News$/, "$1"]],
  "www.asahi.com": [[/^asahi\.com（朝日新聞社）：(.+)$/, "$1"],[/^asahi\.com （朝日新聞社）：(.+)$/, "$1"],[/^asahi\.com：(.+)$/, "$1"],[/^(.+) - ことばなるほどね！ - 学ぼう$/, "$1"],[/^(.+) - 最新ニュース - 読もう$/, "$1"],[/^(.+) - (社会|国際|トラベル|ビジネス・経済|政治|サイエンス)$/, "$1"],[/^(.+) - (関西|関西交通・旅ニュース)$/, "$1"]],
  "www.business-i.jp": [[/^(.+) - FujiSankei Business i\.／Bloomberg GLOBAL FINANCE$/, "$1"]],
  "www.chugoku-np.co.jp": [[/^(.+) - 中国新聞$/, "$1"]],
  "www.chunichi.co.jp": [[/^中日新聞:(.+)\(CHUNICHI Web\)$/, "$1"]],
  "www.cnn.co.jp": [[/^CNN\.co\.jp：(.+)$/, "$1"]],
  "www.fnn-news.com": [[/^FNNニュース: (.+)$/, "$1"]],
  "www.hokkaido-np.co.jp": [[/^(.+)−北海道新聞\[.+\]$/, "$1"]],
  "www.jiji.com": [[/^時事ドットコム：(.+)$/, "$1"]],
  "www.kahoku.co.jp": [[/^河北新報　東北のニュース／(.+)$/, "$1"],[/^河北新報 (.+)$/, "$1"]],
  "www.kobe-np.co.jp": [[/^神戸新聞｜(.+)$/, "$1"],[/^全国海外ニュース｜(.+)$/, "$1"],[/^事件・事故｜(.+)$/, "$1"]],
  "www.kyoto-np.co.jp": [[/^(.+)：京都新聞$/, "$1"]],
  "www.mutusinpou.co.jp": [[/^(.+) by 陸奥新報$/, "$1"]],
  "www.nagasaki-np.co.jp": [[/^龍〜なが　長崎新聞ホームページ：(.+)$/, "$1"]],
  "www.nhk.or.jp": [[/^NHKニュース　(.+)$/, "$1"]],
  "www.nishinippon.co.jp": [[/^(.+) \/ 西日本新聞$/, "$1"]],
  "www.tetsudo.com": [[/^(.+) - 鉄道コム$/, "$1"]],
  "www.tokyo-np.co.jp": [[/^東京新聞:(.+)\(TOKYO Web\)$/, "$1"]],
  "www.yomiuri.co.jp": [[/^(.+) : YOMIURI ONLINE（読売新聞）$/, "$1"],[/^(.+) : (社会|マネー・経済|国際|地域|旅ゅ〜ん！)$/, "$1"],[/^(.+) : 経済ニュース$/, "$1"]],
//</CleanseTitleTable>
  end: null
};

IronnewsUtility.cleanse_title = function(url, title) {
  var host     = (url.match(IronnewsUtility.HostPattern) || [])[1];
  var patterns = IronnewsUtility.CleanseTitleTable[host] || [];
  for ( var i = 0; i < patterns.length; i++ )
  {
    var pattern = patterns[i][0];
    var replace = patterns[i][1];
    title = title.replace(pattern, replace);
  }
  return title;
};
