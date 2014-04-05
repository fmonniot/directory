class Admin::InvitationsController < Devise::InvitationsController
  layout ->{ ['edit'].include?(action_name) ? 'admin_bare' : 'admin' }
end