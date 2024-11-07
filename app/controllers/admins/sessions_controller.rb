# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  layout 'admin/application'

  # TODO: admin_root_pathに変更
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    new_admin_session_path
  end
end
