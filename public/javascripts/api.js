
var api = {};

api.get_info = function(article_ids, options) {
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
