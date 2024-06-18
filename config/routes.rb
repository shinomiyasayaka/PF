Rails.application.routes.draw do

  devise_scope :customer do
    post "public/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  root to: "public/homes#top"

  # 顧客側ルーティング
  scope module: :public do
    scope '/customers' do
      get 'my_page/:id' => 'customers#show', as: 'mypage'
      get 'list' => 'customers#index', as: 'list'
      get 'information/edit' => 'customers#edit', as: 'edit_information'
      patch 'information' => 'customers#update', as: 'update_information'
      get 'unsubscribe' => 'customers#unsubscribe', as: 'confirm_unsubscribe'
      patch 'withdraw' => 'customers#withdraw', as: 'withdraw_customer'
    end

    resources :customers, only: [] do
      get :followings
      get :followers
      resource :relationships, only: [:create, :destroy]
      resources :favorites, only: [:index]
    end

    resources :posts, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
      resource :favorites, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end

    post 'chats' => 'chats#create'
    get 'chats/room/:id' => 'chats#show', as: 'chat'
    get 'search', to: 'searches#search'
    resources :notifications, only: [:update]
  end

  # 管理者側ルーティング
  namespace :admin do
    resources :posts, only: [:index, :show, :edit, :update, :destroy] do
      resources :post_comments, only: [:destroy]
    end
    resources :customers, only: [:index, :show, :edit, :update]
  end


end
