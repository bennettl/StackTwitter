Rails.application.routes.draw do
    
    devise_for :users

    root 'static_pages#index'

    get 'tweets', to: 'static_pages#tweets'

    devise_scope :user do 
        match '/sessions/user', to: 'devise/sessions#create', via: :post
        match '/sign_up', to: 'devise/registration#create', via: :post
    end

    # Resources
    resources :users

end
