# [власний код] реєстрація читача (SRS, п. 3.1.1, FR-1.1–FR-1.3)
class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.expect(user: [ :name, :email_address, :password, :password_confirmation ]))
    @user.role = "reader" # новий користувач завжди читач (FR-1.3)

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "Вітаємо, #{@user.name}! Обліковий запис створено."
    else
      render :new, status: :unprocessable_content
    end
  end
end
