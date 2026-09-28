# [власний код] керування ролями та блокуванням користувачів (FR-4.7)
module Admin
  class UsersController < ApplicationController
    before_action :require_admin

    def index
      @users = User.order(:role, :name)
    end

    def update
      user = User.find(params[:id])
      if user == current_user
        redirect_to admin_users_path, alert: "Не можна змінювати власну роль.", status: :see_other
      elsif user.update(params.expect(user: [ :role, :blocked ]))
        redirect_to admin_users_path, notice: "Користувача #{user.name} оновлено.", status: :see_other
      else
        redirect_to admin_users_path, alert: user.errors.full_messages.to_sentence, status: :see_other
      end
    end
  end
end
