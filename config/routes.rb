Fassets::Application.routes.draw do
  devise_for :users

  resources :users do
  
  
      resources :tray_positions do
        collection do
          put :replace
        end
    
    
    end
  end

  resources :catalogs do
  
  
      resources :facets do
    
    
          resources :labels do
            collection do
              put :sort
            end            
          end
      end
      put :add_asset
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
      resources :topics do
        collection do
          put :sort
        end
      end
  end
  match 'assets/:id/preview' => 'assets#preview'
  match 'assets/:id/edit' => 'assets#edit'
  match 'markup/preview' => 'assets#markup_preview'

  match '/' => 'catalogs#index'
  root :to => "catalogs#index"
end
