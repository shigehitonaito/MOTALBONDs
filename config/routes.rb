Rails.application.routes.draw do
  devise_for :users

  root 'posts#top'
  resources :users, except: [:index] do
  	resource :relationships, only: [:create, :destroy]
    member do
      patch 'image_destroy'
      get 'followings'
      get 'followers'
    end
    collection do
      get 'bookmarks'
      get 'my_events'
      get 'dms'
    end
  end

  resource :rooms, only: [:create]
  resource :message, only: [:create]
  resources :posts, except: [:new] do
  	resources :post_comments, only: [:create, :destroy]
  	resource :post_favorites, only: [:create, :destroy]
  	resource :post_bookmarks, only: [:create, :destroy]
  end

  post 'users/my_events' => 'events#create', as: :events
  resources :events, except: [:index, :create]


  resources :spots do
  	resource :spot_favorites, only: [:create, :destroy]
  	resource :spot_bookmarks, only: [:create, :destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
