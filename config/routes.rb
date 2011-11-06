Rails.application.routes.draw do
  resources :presentations ,:controller => 'FassetsPresentations::Presentations' do
  
  
      resources :frames, :controller => 'FassetsPresentations::Frames'  do
        collection do
          post :sort
        end    
      end
      post :copy
  end
  match 'presentations/markup/preview' => 'FassetsPresentations::frames#markup_preview'
end
