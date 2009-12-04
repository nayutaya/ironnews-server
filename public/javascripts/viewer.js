
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

var articleDB = {};
var current = 0;

var showArticle = function(id) {
  var url   = articleDB[id].url;
  var title = articleDB[id].title;
  /*
  if ( /www\.asahi\.com/.test(url) ) url += "#HeadLine";
  else if ( /mainichi\.jp/.test(url) ) url += "#MainBody";
  */
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
      articleDB = data;
      showArticle(articleIds[0]);
    }//,
  });
};

$(function() {
  $(window).resize(adjustContainer);
  adjustContainer();

  loadArticles();

  $("#next").click(function() {
    if ( current < articleIds.length - 1 )
    {
      current += 1;
      showArticle(articleIds[current]);
    }
    else
    {
      alert("最後の記事です");
    }
  });

  $("#tag-read").click(function() {
    var article_id = articleIds[current];
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
