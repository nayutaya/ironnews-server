
var api = {};

api.getArticles = function(article_ids, options) {
  if ( options == null ) options = {};

  $.ajax({
    type: "GET",
    url: "/api/get_articles",
    data: {
      article_ids: article_ids.join(",")//,
    },
    dataType: "jsonp",
    cache: true,
    success: options.success//,
  });
};

api.addTags = function(article_id, tag1, options) {
  if ( options == null ) options = {};

  $.ajax({
    type: "GET",
    url: "/api/add_tags",
    data: {
      article_id: article_id,
      tag1: tag1//,
    },
    dataType: "jsonp",
    cache: true,
    success: options.success//,
  });
};
