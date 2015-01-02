module Centry
  module UsersHelper

    def get_user!
      user = User.find( params.id )
      error! "UserNotFound", 404 unless user
      user
    end

    def require_admin!
      error! "InsufficientRights" unless current_user.is_admin?
    end

    def require_admin_or_current_user!
      params.id.to_s == current_user.id.to_s || require_admin!
    end

    def require_current_user!
      unless params.id.to_s == current_user.id.to_s
        error! "InsufficientRights"
      end
    end

  end
end