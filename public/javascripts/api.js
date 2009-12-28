
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

api.getUserTags = function(article_ids, options) {
  if ( options == null ) options = {};

  $.ajax({
    type: "GET",
    url: "/api/get_user_tags",
    data: {
      article_ids: article_ids.join(",")//,
    },
    dataType: "jsonp",
    success: options.success//,
  });  
};

api.getCombinedTags = function(article_ids, options) {
  if ( options == null ) options = {};

  $.ajax({
    type: "GET",
    url: "/api/get_combined_tags",
    data: {
      article_ids: article_ids.join(",")//,
    },
    dataType: "jsonp",
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

api.removeTags = function(article_id, tags, options) {
  if ( options == null ) options = {};

  var params = {article_id: article_id};
  for ( var i = 0; i <= 9; i++ )
  {
    params["tag" + (i + 1)] = (tags[i] || "");
  }

  $.ajax({
    type: "GET",
    url: "/api/remove_tags",
    data: params,
    dataType: "jsonp",
    cache: true,
    success: options.success//,
  });
};
