class Admin::AdminController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  layout 'admin.html.erb'
  respond_to :html

  before_filter :authenticate_user!
end