Fassets::Application.routes.draw do
  devise_for :users

  resources :users do
  
  
      resources :tray_positions do
        collection do
          put :replace
        end
    
    
    end
  end

  #resource :session
  resources :catalogs do
  
  
      resources :facets do
    
    
          resources :labels do
            collection do
      put :sort
      end
      
      
      end
    end
  end

  resources :classifications
  resources :file_assets do
  
    member do
  get :thumb
  get :preview
  get :original
  end
  
  end

  resources :urls
  resources :presentations do
  
  
      resources :slides do
        collection do
          put :sort
        end
    
    
    end
  end

  match '/' => 'catalogs#index'
  root :to => "catalogs#index"
end
