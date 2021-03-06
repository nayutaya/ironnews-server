
# API
class ApiController < ApplicationController
  before_filter :authentication, :only => [:add_article, :add_tag, :add_tags, :remove_tags, :get_division_untagged_articles, :get_area_untagged_articles, :get_user_tagged_articles, :get_user_tags]

  def index
    redirect_to(:controller => "home")
  end

  def get_articles
    api = GetArticlesApi.from(params)
    render_json(api.execute)
  end

  def add_article   
    api = AddArticleApi.from(params)
    render_json(api.execute)
  end

  def add_tags
    api = AddTagsApi.from(params)
    render_json(api.execute(@user.id))

    # FIXME: 実験用コード
    CombinedTagging.incremental_update(10)
  end

  def remove_tags
    api = RemoveTagsApi.from(params)
    render_json(api.execute(@user.id))
  end

  def get_combined_tagged_articles
    api = GetCombinedTaggedArticlesApi.from(params)
    render_json(api.execute)
  end

  def get_division_untagged_articles
    api = GetDivisionUntaggedArticlesApi.from(params)
    render_json(api.execute(@user.id))
  end

  def get_area_untagged_articles
    api = GetAreaUntaggedArticlesApi.from(params)
    render_json(api.execute(@user.id))
  end

  def get_user_tagged_articles
    api = GetUserTaggedArticlesApi.from(params)
    render_json(api.execute(@user.id))
  end

  def get_user_tags
    api = GetUserTagsApi.from(params)
    render_json(api.execute(@user.id))
  end

  def get_combined_tags
    api = GetCombinedTagsApi.from(params)
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
    return true if @user

    render(:text => "Unauthorized", :status => 401)

    return false
  end

  def render_json(obj)
    callback = params[:callback]
    json     = obj.to_json
    output   = (callback.blank? ? json : "#{callback}(#{json})")
    send_data(output, :type => "text/javascript", :disposition => "inline")
  end
end
