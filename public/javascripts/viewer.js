
var viewer = {};
viewer.articleIds       = null;
viewer.articleRecords   = null;
viewer.currentArticleId = null;
viewer.currentReadTimer = null;
viewer.userTags         = {};
viewer.combinedTags     = {};

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
    viewer.addTagsToCurrentArticle(["既読"]);
  }, 3000);

  viewer.currentArticleId = article_id;

  viewer.showTags();
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

viewer.loadUserTags = function() {
  var options = {
    success: function(data) {
      // FIXME: 置換ではなくマージする
      viewer.userTags = data["result"];
      viewer.showTags();
    }//,
  }
  api.getUserTags(viewer.articleIds, options);
};

viewer.loadCombinedTags = function() {
  var options = {
    success: function(data) {
      // FIXME: 置換ではなくマージする
      viewer.combinedTags = data["result"];
      viewer.showTags();
    }//,
  }
  api.getCombinedTags(viewer.articleIds, options);
};

viewer.showTags = function() {
  if ( viewer.currentArticleId == null ) return;

  var user_tags     = viewer.userTags[viewer.currentArticleId]     || [];
  var combined_tags = viewer.combinedTags[viewer.currentArticleId] || [];

  $("div.tags span").each(function() {
    var target = $(this);
    var tag = target.text();
    var user_tagged     = (user_tags.indexOf(tag) >= 0);
    var combined_tagged = (combined_tags.indexOf(tag) >= 0);
    if ( user_tagged     ) { target.addClass("user")     } else { target.removeClass("user")     }
    if ( combined_tagged ) { target.addClass("combined") } else { target.removeClass("combined") }
  });
};

viewer.addTagTo = function(table, article_id, tag) {
  var article_tags = table[article_id];
  if ( article_tags == null )
  {
    table[article_id] = article_tags = [];
  }
  if ( article_tags.indexOf(tag) < 0 )
  {
    article_tags.push(tag);
  }
};
viewer.removeTagFrom = function(table, article_id, tag) {
  var article_tags = table[article_id];
  if ( article_tags )
  {
    var index = article_tags.indexOf(tag);
    if ( index >= 0 )
    {
      article_tags.splice(index, 1);
    }
  }
};

viewer.addTagsToCurrentArticle = function(tags, success) {
  // FIXME: まとめて追加する
  $.each(tags, function(index, tag) {
    api.addTags(viewer.currentArticleId, tag, {success: success});
  });
};

viewer.removeTagsFromCurrentArticle = function(tags, success) {
  api.removeTags(viewer.currentArticleId, tags, {success: success});
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
  viewer.loadUserTags();
  viewer.loadCombinedTags();

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
      viewer.removeTagsFromCurrentArticle(remove_tags, function() {
        viewer.addTagsToCurrentArticle([add_tag], function() { /*nop*/ });
      });

      $.each(remove_tags, function(index, tag) {
        viewer.removeTagFrom(viewer.userTags, viewer.currentArticleId, tag)
      });
      viewer.addTagTo(viewer.userTags, viewer.currentArticleId, add_tag)
      viewer.showTags();
    });
  });

  $(document).bind("keydown", {combi: "t", disableInInput: true}, function() {
    $("div.tags span:contains('鉄道')").click();
  });
  $(document).bind("keydown", {combi: "h", disableInInput: true}, function() {
    $("div.tags span:contains('非鉄')").click();
  });
  $(document).bind("keydown", {combi: "n", disableInInput: true}, function() {
    $("#next-article").click();
  });
  $(document).bind("keydown", {combi: "p", disableInInput: true}, function() {
    $("#prev-article").click();
  });

});
