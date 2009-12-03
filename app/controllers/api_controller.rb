
# API
class ApiController < ApplicationController
  def index
    redirect_to(:controller => "home")
  end

  def add_article
    unless authentication
      render(:text => "error", :status => 401)
      return
    end
    
    api = AddArticleApi.from(params)
    render_json(api.execute)
  end

  private

  def authentication
    user = User.find_by_id(session[:user_id])
    return true if user

    # FIXME: createdの範囲を限定
    # FIXME: リピート攻撃に対処
    wsse = request.env["HTTP_X_WSSE"]
    token = Wsse::UsernameToken.parse(wsse)
    if token
      user = User.find_by_name(token.username)
      unless user
        return false
      end
      
      username = user.name
      password = user.api_token
      if Wsse::Authenticator.authenticate?(token, username, password)
        return true
      end
    end

    return false
  end

  def render_json(obj)
    callback = params[:callback]
    json     = obj.to_json
    output   = (callback.blank? ? json : "#{callback}(#{json})")
    send_data(output, :type => "text/javascript", :disposition => "inline")
  end
end
