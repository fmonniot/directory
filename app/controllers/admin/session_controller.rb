class Admin::SessionController < Devise::SessionsController
  layout 'admin_bare'

  def after_sign_in_path_for(user)
    admin_index_path
  end
end