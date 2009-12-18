
var manager = {};

manager.setFavicon = function() {
  $("ul.articles li a").each(function() {
    var favicon = "http://favicon.hatena.ne.jp/?url=" + encodeURIComponent(this.href);
    $(this).css("background-image", "url(" + favicon + ")");
  });
};

manager.replaceLink = function() {
  $("ul.articles li a").each(function() {
    var articleId = manager.getArticleIdFromAnchorElement(this);
    if ( articleId != null )
    {
      this.href = "/viewer#" + articleId;
    }
  });
};

manager.getArticleIdFromAnchorElement = function(anchor) {
  return (/^article-(\d+)$/.exec(anchor.id) || [])[1];
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

$(function() {
  manager.setFavicon();
  manager.replaceLink();
  manager.initCursor();

  var getArticleIdFromAnchorElement = function(anchor) {
    return (/^article-(\d+)$/.exec(anchor.id) || [])[1];
  };

  (function() {
    var articleList = $("ul.articles li");

    var getCurrentArticleItemElement = function() {
      return $("ul.articles li.cursor")[0];
    };
    var getCurrentAnchorElement = function() {
      return $("ul.articles li.cursor a")[0];
    };
    var getArticleIndex = function(itemElement) {
      var index = articleList.get().indexOf(itemElement);
      return (index >= 0 ? index : null);
    };
    var getNextArticleItemElement = function(currentElement) {
      var index = getArticleIndex(currentElement);
      if ( index == null ) return null;
      if ( index >= articleList.length - 1 ) return null;
      return articleList[index + 1];
    };
    var getPrevArticleItemElement = function(currentElement) {
      var index = getArticleIndex(currentElement);
      if ( index == null ) return null;
      if ( index <= 0 ) return null;
      return articleList[index - 1];
    };

    var moveToNextArticle = function() {
      var current = getCurrentArticleItemElement();
      var next    = getNextArticleItemElement(current);
      if ( next != null )
      {
        manager.moveCursorTo(next);
      }
    };
    var moveToPrevArticle = function() {
      var current = getCurrentArticleItemElement();
      var prev    = getPrevArticleItemElement(current);
      if ( prev != null )
      {
        manager.moveCursorTo(prev);
      }
    };
    var togglePinOfArticle = function() {
      var current = getCurrentArticleItemElement();
      $(current).toggleClass("pinned");
    };
    var openCurrentArticle = function() {
      var current   = getCurrentAnchorElement();
      var articleId = getArticleIdFromAnchorElement(current);
      var path = "/viewer#" + articleId;
      var win = window.open(path);
    };
    var openPinnedArticles = function() {
      var articleIds = [];
      $("ul.articles li.pinned a").each(function() {
        var articleId = getArticleIdFromAnchorElement(this);
        articleIds.push(articleId);
      });
      if ( articleIds.length > 0 )
      {
        var path = "/viewer#" + articleIds.join(",");
        var win = window.open(path);
      }
    };
    var setPinOfAllArticles = function() {
      if ( confirm("すべての記事にピンを設定します。よろしいですか？") )
      {
        $("ul.articles li").each(function() {
          $(this).addClass("pinned");
        });
      }
    };
    var clearPinOfAllArticles = function() {
      if ( confirm("すべての記事のピンを解除します。よろしいですか？") )
      {
        $("ul.articles li.pinned").each(function() {
          $(this).removeClass("pinned");
        });
      }
    };

    $(document).bind("keydown", {combi: "j", disableInInput: true}, moveToNextArticle);
    $(document).bind("keydown", {combi: "k", disableInInput: true}, moveToPrevArticle);
    $(document).bind("keydown", {combi: "p", disableInInput: true}, togglePinOfArticle);
    $(document).bind("keydown", {combi: "v", disableInInput: true}, openCurrentArticle);
    $(document).bind("keydown", {combi: "o", disableInInput: true}, openPinnedArticles);
    $(document).bind("keydown", {combi: "a", disableInInput: true}, setPinOfAllArticles);
    $(document).bind("keydown", {combi: "c", disableInInput: true}, clearPinOfAllArticles);
  })();
});
