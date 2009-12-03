
# API
class ApiController < ApplicationController
  def index
    redirect_to(:controller => "home")
  end

  # FIXME: JSONPに対応
  def add_article
    api = AddArticleApi.from(params)
    result = api.execute

    json = result.to_json
    send_data(json, :type => "text/javascript", :disposition => "inline")
  end
end
