
var manager = {};

manager.setFavicon = function() {
  $("ul.articles li a").each(function() {
    var favicon = "http://favicon.hatena.ne.jp/?url=" + encodeURIComponent(this.href);
    $(this).css("background-image", "url(" + favicon + ")");
  });
};

manager.createViewerPath = function(articleIds) {
  return "/viewer#" + articleIds.join(",");
};

manager.replaceLink = function() {
  $("ul.articles li a").each(function() {
    var articleId = manager.getArticleId(this.id);
    if ( articleId == null ) return;
    this.href = manager.createViewerPath([articleId]);
  });
};

manager.initCursor = function() {
  $("ul.articles li:first").addClass("cursor");
};

manager.moveCursorTo = function(target) {
  $("ul.articles li.cursor").removeClass("cursor")
  $(target).addClass("cursor");
  manager.adjustScrollPosition();
};

manager.adjustScrollPosition = function() {
  var view        = $(window);
  var view_height = view.height();
  var view_top    = view.scrollTop();
  var view_bottom = view_top + view_height;

  var target        = $("ul.articles li.cursor:first");
  var target_top    = target.offset().top;
  var target_bottom = target_top + target.height();

  var margin = 100;

  if ( target_top < view_top )
  {
    view.scrollTop(target_top - margin);
  }
  else if ( target_bottom > view_bottom )
  {
    view.scrollTop(target_bottom - view_height + margin);
  }
};

manager.getAllArticles = function() {
  return $("ul.articles li");
};
manager.getCurrentArticle = function() {
  return $("ul.articles li.cursor:first");
};

manager.getArticleId = function(id) {
  return (/^article-(\d+)$/.exec(id) || [])[1];
};

manager.moveToNextArticle = function() {
  var all     = manager.getAllArticles();
  var current = manager.getCurrentArticle();
  var next    = all.get(all.index(current) + 1);
  if ( next == null ) return;
  manager.moveCursorTo(next);
};
manager.moveToPrevArticle = function() {
  var all     = manager.getAllArticles();
  var current = manager.getCurrentArticle();
  var prev    = all.get(all.index(current) - 1);
  if ( prev == null ) return;
  manager.moveCursorTo(prev);
};
manager.togglePinOfArticle = function() {
  var current = manager.getCurrentArticle();
  current.toggleClass("pinned");
};
manager.openCurrentArticle = function() {
  var current   = $("ul.articles li.cursor a")[0];
  var articleId = manager.getArticleId(current.id);
  var path = manager.createViewerPath([articleId]);
  window.open(path);
};
manager.openPinnedArticles = function() {
  var articleIds = $("ul.articles li.pinned a").map(function() {
    return manager.getArticleId(this.id);
  });
  if ( articleIds.length > 0 )
  {
    var path = manager.createViewerPath($.makeArray(articleIds))
    window.open(path);
  }
};
manager.setPinOfAllArticles = function() {
  if ( confirm("すべての記事にピンを設定します。よろしいですか？") )
  {
    $("ul.articles li").each(function() {
      $(this).addClass("pinned");
    });
  }
};
manager.clearPinOfAllArticles = function() {
  if ( confirm("すべての記事のピンを解除します。よろしいですか？") )
  {
    $("ul.articles li.pinned").each(function() {
      $(this).removeClass("pinned");
    });
  }
};

$(function() {
  manager.setFavicon();
  manager.replaceLink();
  manager.initCursor();

  $(document).bind("keydown", {combi: "j", disableInInput: true}, manager.moveToNextArticle);
  $(document).bind("keydown", {combi: "k", disableInInput: true}, manager.moveToPrevArticle);
  $(document).bind("keydown", {combi: "p", disableInInput: true}, manager.togglePinOfArticle);
  $(document).bind("keydown", {combi: "v", disableInInput: true}, manager.openCurrentArticle);
  $(document).bind("keydown", {combi: "o", disableInInput: true}, manager.openPinnedArticles);
  $(document).bind("keydown", {combi: "a", disableInInput: true}, manager.setPinOfAllArticles);
  $(document).bind("keydown", {combi: "c", disableInInput: true}, manager.clearPinOfAllArticles);
});
