
var viewer = {};
viewer.articleIds       = null;
viewer.articleRecords   = null;
viewer.currentArticleId = null;
viewer.currentReadTimer = null;

viewer.initLayout = function() {
  var container  = $("#container");
  var controller = $("#controller");
  var browser    = $("#browser");

  var adjustLayout = function() {
    var window_width      = $(window).width();
    var window_height     = $(window).height();
    var controller_height = controller.outerHeight();

    container.width(window_width);
    container.height(window_height);
    controller.width(window_width);
    browser.width(window_width);
    browser.height(window_height - controller_height);
  };

  $(window).resize(adjustLayout);
  setTimeout(adjustLayout, 100); // Google Chromeで正常に動作させるために100msec遅延させる
};

viewer.showArticle = function(article_id) {
  var url   = viewer.articleRecords[article_id].url;
  var title = viewer.articleRecords[article_id].title;

  $("#browser").attr("src", url);
  $("#url").text(url);
  document.title = title;

  if ( viewer.currentReadTimer != null )
  {
    clearTimeout(viewer.currentReadTimer);
  }
  viewer.currentReadTimer = setTimeout(function() {
    viewer.addTagToCurrentArticle("既読");
  }, 3000);

  viewer.currentArticleId = article_id;
};

viewer.getArticleIndex = function(article_id) {
  var index = viewer.articleIds.indexOf(article_id);
  return (index >= 0 ? index : null);
};

viewer.getNextArticleId = function() {
  var index = viewer.getArticleIndex(viewer.currentArticleId);
  if ( index == null ) return null;
  if ( index >= viewer.articleIds.length - 1 ) return null;
  return viewer.articleIds[index + 1];
};

viewer.getPrevArticleId = function() {
  var index = viewer.getArticleIndex(viewer.currentArticleId);
  if ( index == null ) return null;
  if ( index <= 0 ) return null;
  return viewer.articleIds[index - 1];
};

viewer.loadArticles = function() {
  api.getArticles(viewer.articleIds, {
    success: function(data) {
      viewer.articleRecords = data["result"];
      viewer.showArticle(viewer.articleIds[0]);
    }//,
  });
};

viewer.addTagToCurrentArticle = function(tag, success) {
  api.addTags(viewer.currentArticleId, tag, {success: success});
};

viewer.removeTagOfCurrentArticle = function(tag, success) {
  api.removeTags(viewer.currentArticleId, tag, {success: success});
};

$(function() {
  viewer.initLayout();

  var fragment = location.hash;
  var ids      = (fragment.match(/^#(\d+(?:,\d+)*)$/) || [])[1];
  if ( ids == null )
  {
    alert("記事IDが取得できませんでした。");
    return;
  }
  viewer.articleIds = ids.split(",");

  viewer.loadArticles();

  $("#next-article").click(function() {
    var article_id = viewer.getNextArticleId();
    if ( article_id != null ) viewer.showArticle(article_id);
    else alert("最後の記事です");
  });

  $("#prev-article").click(function() {
    var article_id = viewer.getPrevArticleId();
    if ( article_id != null ) viewer.showArticle(article_id);
    else alert("最初の記事です");
  });

  $("div.tags span").each(function() {
    var add_tag = $(this).text();
    $(this).click(function() {
      var remove_tags = [];
      $("span", $(this).parent()).each(function() {
        var tag2 = $(this).text();
        if ( tag2 != add_tag ) remove_tags.push(tag2);
      });
      // FIXME: まとめて削除する
      $.each(remove_tags, function(index, remove_tag) {
        viewer.removeTagOfCurrentArticle(remove_tag, function() { /*nop*/ });
      });
      viewer.addTagToCurrentArticle(add_tag, function() { /*nop*/ });
    });
  });
});
