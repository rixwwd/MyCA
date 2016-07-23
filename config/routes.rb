Rails.application.routes.draw do

  resources :cas, only:[:index, :new, :create, :show, :destroy] do
    resources :certificates, only: [:index, :new, :create, :show, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'cas#index'
end
