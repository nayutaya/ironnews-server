
# API
class ApiController < ApplicationController
  def index
    redirect_to(:controller => "home")
  end

  def add_article
    api = AddArticleApi.from(params)
    render_json(api.execute)
  end

  private

  def render_json(obj)
    callback = params[:callback]
    json     = obj.to_json
    output   = (callback.blank? ? json : "#{callback}(#{json})")
    send_data(output, :type => "text/javascript", :disposition => "inline")
  end
end
