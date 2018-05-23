Rails.application.routes.draw do
  devise_for :users
  resources :pins do
    resources :comments
    member do
      put "like", to: "pins#upvote"
    end
  end
get '/mypage' => 'pins#mypage'
  root "pins#index"
end
