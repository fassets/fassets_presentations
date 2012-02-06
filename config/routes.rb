FassetsPresentations::Engine.routes.draw do
  get '/new' => 'Presentations#new', :as => 'new_presentation'
  post '/new' => 'Presentations#create'
  get '/:id' => 'Presentations#show', :as => 'presentation'
  get '/:id/edit' => 'Presentations#edit', :as => 'edit_presentation'
  put '/:id' => 'Presentations#update', :as => 'update_presentation'

  get '/:presentation_id/frames' => 'Frames#index', :as => 'presentation_frames'
  post '/:presentation_id/frames' => 'Frames#create', :as => 'presentation_frames'
  get '/:presentation_id/frame/:id/edit' => 'Frames#edit', :as => 'edit_presentation_frame'
  get '/:presentation_id/frame/:id' => 'Frames#show', :as => 'presentation_frame'
  put '/:presentation_id/frame/:id' => 'Frames#update', :as => 'update_presentation_frame'
  delete '/:presentation_id/frame/:id' => 'Frames#destroy', :as => 'delete_presentation_frame'
  post '/:presentation_id/frames/sort' => 'Frames#sort', :as => 'sort_presentation_frames'

  post :copy, :as => 'presentation_copy'
  match 'markup/preview' => 'frames#markup_preview'
end
