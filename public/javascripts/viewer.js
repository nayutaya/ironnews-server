
var adjustLayout = function() {
  var container  = $("#container");
  var controller = $("#controller");
  var browser    = $("#browser");

  container.width($(window).width());
  container.height($(window).height());

  controller.width(container.outerWidth());

  browser.width(container.outerWidth());
  browser.height(container.outerHeight() - controller.outerHeight())
};

var initLayout = function() {
  $(window).resize(adjustLayout);
  adjustLayout();
};

var articleRecords   = null; // Ajaxにより取得される
var currentArticleId = null;

var showArticle = function(id) {
  var url   = articleRecords[id].url;
  var title = articleRecords[id].title;
  $("#browser").attr("src", url);
  $("#url").text(url);
  document.title = title;

  currentArticleId = id;
};

var getNextArticleId = function() {
  var index = window.articleIds.indexOf(currentArticleId);
  if ( index < 0 ) return null;
  if ( index >= window.articleIds.length - 1 ) return null;
  return window.articleIds[index + 1];
};

var loadArticles = function() {
  $.ajax({
    type: "GET",
    url: "/home/get_info",
    data: {"article_ids": window.articleIds.join(",")},
    dataType: "jsonp",
    success: function(data){
      articleRecords = data;
      showArticle(window.articleIds[0]);
    }//,
  });
};

var addTagToCurrentArticle = function(tag, success) {
  //if ( success == null ) success = function() { /*nop*/ };

  $.ajax({
    type: "GET",
    url: "/api/add_tag",
    data: {
      article_id: currentArticleId,
      tag: tag//,
    },
    dataType: "jsonp",
    cache: true,
    success: success//,
  });
};

$(function() {
  initLayout();
  loadArticles();

  $("#next").click(function() {
    var next_id = getNextArticleId();
    if ( next_id != null )
    {
      showArticle(next_id);
    }
    else
    {
      alert("最後の記事です");
    }
  });

  $("#tag-read").click(function() {
    addTagToCurrentArticle("既読", function(data) {
      console.debug(data);
    });
  });
});
