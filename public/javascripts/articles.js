
// [JavaScript][jQuery]ある要素が画面内に収まるようにスクロールするjQueryプラグイン
// http://d.hatena.ne.jp/JJX/20090227/1235768010
(function(){
    jQuery.fn.isinwindow = function(){
        var top    = $(window).scrollTop();
        var bottom = $(window).height() + $(window).scrollTop();
        var left   = $(window).scrollLeft();
        var right  = $(window).width() + $(window).scrollLeft();

        return this.offset().top  >= top   && this.offset().top  + this.height() <= bottom &&
               this.offset().left >= left  && this.offset().left + this.width()  <= right;
    };
    jQuery.fn.inwindow = function(){
        var top    = $(window).scrollTop();
        var bottom = $(window).height() + $(window).scrollTop();
        var left   = $(window).scrollLeft();
        var right  = $(window).width() + $(window).scrollLeft();

        if(!(this.offset().top  >= top)){
            $(window).scrollTop(this.offset().top);
        }
        if(!(this.offset().top  + this.height() <= bottom)){
            $(window).scrollTop(
                $(window).scrollTop() + this.offset().top  + this.height() - bottom
            );
        }
        if(!(this.offset().left  >= left)){
            $(window).scrollLeft(this.offset().left);
        }
        if(!(this.offset().left  + this.width() <= right)){
            $(window).scrollLeft(
                $(window).scrollLeft() + this.offset().left  + this.width() - right
            );
        }
        return this;
    };
})(jQuery);


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
  $($("ul.articles li")[0]).addClass("cursor");
};

// FIXME: 関数名を変更
manager.showCursor = function() {
  var view_height = $(window).height();
  var view_top    = $(window).scrollTop();
  var view_bottom = view_top + view_height;

  var target = $("ul.articles li.cursor:first");
  var target_top    = target.offset().top;
  var target_bottom = target.offset().top + target.height();

if ( target_top < view_top )
{
  $(window).scrollTop(target_top - 50);
}
if ( target_bottom > view_bottom )
{
  $(window).scrollTop(target_bottom - $(window).height() + 50);
}

}

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
        $(current).removeClass("cursor");
        $(next).addClass("cursor");
        manager.showCursor();
      }
    };
    var moveToPrevArticle = function() {
      var current = getCurrentArticleItemElement();
      var prev    = getPrevArticleItemElement(current);
      if ( prev != null )
      {
        $(current).removeClass("cursor");
        $(prev).addClass("cursor");
        manager.showCursor();
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
