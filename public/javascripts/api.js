
var api = {};

api.getInfo = function(article_ids, options) {
  if ( options == null ) options = {};

  $.ajax({
    type: "GET",
    url: "/home/get_info",
    data: {
      article_ids: article_ids.join(",")//,
    },
    dataType: "jsonp",
    cache: true,
    success: options.success//,
  });
};

api.addTag = function(article_id, tag, options) {
  if ( options == null ) options = {};

  $.ajax({
    type: "GET",
    url: "/api/add_tag",
    data: {
      article_id: article_id,
      tag: tag//,
    },
    dataType: "jsonp",
    cache: true,
    success: options.success//,
  });
};
