# [згенеровано] rails new + rails generate authentication (include Authentication)
# [власний код] current_user, перевірка ролей, жанри для бічної панелі
class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # ---- власний код ----
  helper_method :current_user
  before_action :load_sidebar_genres

  private

  # На публічних сторінках require_authentication пропускається, тому сесію відновлюємо тут
  def current_user
    resume_session
    Current.user
  end

  def require_staff
    redirect_to root_path, alert: "Ця дія доступна лише бібліотекарю" unless current_user&.staff?
  end

  def require_admin
    redirect_to root_path, alert: "Ця дія доступна лише адміністратору" unless current_user&.admin?
  end

  def load_sidebar_genres
    @sidebar_genres = Genre.ordered
  end
end
