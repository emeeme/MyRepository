Rails.application.routes.draw do
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end
  
  # これだけでcreate,new,edit,show,update,destroy作られる
  resources :receptions do
    collection do
      post :import 
      post :print
    end
  end

  # root 'posts#index'
  root 'receptions#index'
  
  


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
