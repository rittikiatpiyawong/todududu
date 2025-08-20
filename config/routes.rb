Rails.application.routes.draw do
  root "todos#index"

  resources :todos, only: [ :index, :create, :destroy ] do
    member do
      patch :toggle
    end
  end

  get "brag-document", to: "pages#brag_document", as: "brag_document"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  get "*path", to: redirect("/")
end
