
# ビューア
class ViewerController < ApplicationController
  # GET /viewer
  # FIXME: テストせよ
  def index
    render(:layout => false)
  end
end
