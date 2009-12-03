
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

  def authenticate_by_cookie
    user_id = session[:user_id]
    return nil if user_id.blank?
    return User.find_by_id(user_id)
  end

  # FIXME: createdの範囲を限定
  # FIXME: リピート攻撃に対処
  def authenticate_by_wsse
    wsse = request.env["HTTP_X_WSSE"]
    return nil if wsse.blank?
    token = Wsse::UsernameToken.parse(wsse)
    return nil unless token
    user = User.find_by_name(token.username)   
    return nil unless user
    return nil unless Wsse::Authenticator.authenticate?(token, user.name, user.api_token)
    return user
  end

  def authentication
    @user   = authenticate_by_cookie
    @user ||= authenticate_by_wsse
    return !!@user
  end

  def render_json(obj)
    callback = params[:callback]
    json     = obj.to_json
    output   = (callback.blank? ? json : "#{callback}(#{json})")
    send_data(output, :type => "text/javascript", :disposition => "inline")
  end
end
