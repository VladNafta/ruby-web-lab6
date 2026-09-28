Rails.application.routes.draw do
  # [власний код] головна сторінка
  root "home#index"

  # [згенеровано] rails generate scaffold (resources :books, :authors, :genres)
  # [власний код] вкладені маршрути бронювань і відгуків
  resources :books do
    resources :reservations, only: :create
    resources :reviews, only: %i[ create destroy ]
  end
  resources :authors
  resources :genres

  # [згенеровано] rails generate authentication
  resource :session
  resources :passwords, param: :token

  # ---- власний код ----
  resource :registration, only: %i[ new create ]
  resources :reservations, only: %i[ index destroy ]
  resources :reviews, only: :index
  resources :shelf_items, only: %i[ index create destroy ], path: "shelves"

  # Розділ бібліотекаря: /library/reservations
  namespace :library do
    resources :reservations, only: :index do
      member do
        patch :issue
        patch :return_book
      end
    end
  end

  # Розділ адміністратора: /admin/users
  namespace :admin do
    resources :users, only: %i[ index update ]
  end
  # ---------------------

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
