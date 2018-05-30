Rails.application.routes.draw do

  # rails routes
  devise_for :users
  resources :pins do
    resources :comments
    member do
      put "like", to: "pins#upvote"
    end
  end

  # custom
  get '/mypage' => 'pins#mypage'
    root "pins#index"
end
