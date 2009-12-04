
var adjustContainer = function() {
  var container  = $("#container");
  var controller = $("#controller");
  var browser    = $("#browser");

  container.width($(window).width());
  container.height($(window).height());

  controller.width(container.outerWidth());

  browser.width(container.outerWidth());
  browser.height(container.outerHeight() - controller.outerHeight())
};

var articleRecords = {};
var currentArticleIndex = 0;

var showArticle = function(id) {
  var url   = articleRecords[id].url;
  var title = articleRecords[id].title;
  $("#browser").attr("src", url);
  $("#url").text(url);
  document.title = title;
};

var loadArticles = function() {
  $.ajax({
    type: "GET",
    url: "/home/get_info",
    data: {"article_ids": articleIds.join(",")},
    dataType: "jsonp",
    success: function(data){
      articleRecords = data;
      showArticle(articleIds[0]);
    }//,
  });
};

$(function() {
  $(window).resize(adjustContainer);
  adjustContainer();

  loadArticles();

  $("#next").click(function() {
    if ( currentArticleIndex < articleIds.length - 1 )
    {
      currentArticleIndex += 1;
      showArticle(articleIds[currentArticleIndex]);
    }
    else
    {
      alert("最後の記事です");
    }
  });

  $("#tag-read").click(function() {
    var article_id = articleIds[currentArticleIndex];
    var tag        = "既読";

    $.ajax({
      type: "GET",
      url: "/api/add_tag",
      data: {
        article_id: article_id,
        tag: tag
      },
      dataType: "jsonp",
      cache: true,
      success: function(data){
        console.debug(data);
      }//,
    });
  });
});
