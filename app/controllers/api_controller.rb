
# API
class ApiController < ApplicationController
  def index
    redirect_to(:controller => "home")
  end

  def add_article
    params.delete(:commit)
    params.delete(:authenticity_token)
    params.delete(:controller)
    params.delete(:action)
    
    api = AddArticleApi.new(params)
    result = api.execute

    json = result.to_json
    send_data(json, :type => "text/javascript", :disposition => "inline")
  end
end
