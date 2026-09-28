# [згенеровано] rails generate authentication
# [власний код] українські повідомлення (FR-2.2), перевірка блокування (FR-4.7)
class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Забагато спроб. Спробуйте пізніше." }

  def new
  end

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))
    if user && !user.blocked?
      start_new_session_for user
      redirect_to after_authentication_url, notice: "Ви увійшли як #{user.name}."
    elsif user
      redirect_to new_session_path, alert: "Обліковий запис заблоковано адміністратором."
    else
      redirect_to new_session_path, alert: "Невірний email або пароль."
    end
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "Ви вийшли з системи.", status: :see_other
  end
end
