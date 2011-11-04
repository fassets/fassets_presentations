FassetsPresentations::Engine.routes.draw do
  resources :presentations do
  
  
      resources :frames do
        collection do
          post :sort
        end    
      end
      post :copy
  end
  match 'assets/:id/preview' => 'assets#preview'
  match 'markup/preview' => 'frames#markup_preview'
end
