Rails.application.routes.draw do
  root "clients#index"
  resources :clients, except: [:show]

  namespace :api do
    namespace :v1 do
      scope :clients, controller: :clients do
        get "/", action: :index
        get "/:id", action: :show
        post "/", action: :create
        put "/:id", action: :update
        delete "/:id", action: :destroy
      end
    end
  end
end