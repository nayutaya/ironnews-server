
var viewer = {};

viewer.adjustLayout = function() {
  var container  = $("#container");
  var controller = $("#controller");
  var browser    = $("#browser");

  container.width($(window).width());
  container.height($(window).height());

  controller.width(container.outerWidth());

  browser.width(container.outerWidth());
  browser.height(container.outerHeight() - controller.outerHeight())
};

viewer.initLayout = function() {
  $(window).resize(viewer.adjustLayout);
  viewer.adjustLayout();
};

viewer.articleRecords   = null; // Ajaxにより取得される
viewer.currentArticleId = null;
viewer.currentReadTimer = null;

viewer.showArticle = function(id) {
  var url   = viewer.articleRecords[id].url;
  var title = viewer.articleRecords[id].title;
  $("#browser").attr("src", url);
  $("#url").text(url);
  document.title = title;

  viewer.currentArticleId = id;

  if ( viewer.currentReadTimer != null ) clearTimeout(viewer.currentReadTimer);
  viewer.currentReadTimer = setTimeout(function() {
    viewer.addTagToCurrentArticle("既読");
  }, 3000);
};

viewer.getNextArticleId = function() {
  var index = window.articleIds.indexOf(viewer.currentArticleId);
  if ( index < 0 ) return null;
  if ( index >= window.articleIds.length - 1 ) return null;
  return window.articleIds[index + 1];
};

viewer.getPrevArticleId = function() {
  var index = window.articleIds.indexOf(viewer.currentArticleId);
  if ( index < 0 ) return null;
  if ( index <= 0 ) return null;
  return window.articleIds[index - 1];
};

viewer.loadArticles = function() {
  $.ajax({
    type: "GET",
    url: "/home/get_info",
    data: {"article_ids": window.articleIds.join(",")},
    dataType: "jsonp",
    success: function(data){
      viewer.articleRecords = data;
      viewer.showArticle(window.articleIds[0]);
    }//,
  });
};

viewer.addTagToCurrentArticle = function(tag, success) {
  $.ajax({
    type: "GET",
    url: "/api/add_tag",
    data: {
      article_id: viewer.currentArticleId,
      tag: tag//,
    },
    dataType: "jsonp",
    cache: true,
    success: success//,
  });
};

$(function() {
  viewer.initLayout();
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

  $("#tag-read").click(function() {
    viewer.addTagToCurrentArticle("既読", function(data) {
      console.debug(data);
    });
  });
});
