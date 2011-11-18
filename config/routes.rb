FassetsPresentations::Engine.routes.draw do
  get '/:id' => 'Presentations#show', :as => 'presentation'
  get '/:id/edit' => 'Presentations#edit', :as => 'edit_presentation'
  get '/new' => 'Presentations#new', :as => 'new_presentation'
  put '/:id' => 'Presentations#update', :as => 'update_presentation'

  resources :presentations do
    resources :frames do
     collection do
        post :sort
      end
    end
  end

  post :copy, :as => 'presentation_copy'
  match 'markup/preview' => 'frames#markup_preview'
end
