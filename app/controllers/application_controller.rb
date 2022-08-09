class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authorize_user(user_id)
    redirect_to root_path unless current_user.id == user_id
  end
end
