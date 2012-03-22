FassetsPresentations::Engine.routes.draw do
  match '/to_markdown' => 'frames#to_markdown'
  match '/to_html' => 'frames#to_html'
  get '/new' => 'Presentations#new', :as => 'new_presentation'
  post '/' => 'Presentations#create'
  get '/:id' => 'Presentations#show', :as => 'presentation'
  delete '/:id' => 'Presentations#destroy', :as => 'delete_presentation'
  get '/:id/edit' => 'Presentations#edit', :as => 'edit_presentation'
  post '/:id' => 'Presentations#update', :as => 'update_presentation'

  get '/:presentation_id/frames' => 'Frames#index', :as => 'presentation_frames'
  post '/:presentation_id/frames' => 'Frames#create', :as => 'presentation_frames'
  get '/:presentation_id/frame/:id/edit' => 'Frames#edit', :as => 'edit_presentation_frame'
  get '/:presentation_id/frame/:id/edit_wysiwyg' => 'Frames#edit_wysiwyg', :as => 'edit_wysiwyg_presentation_frame'
  get '/:presentation_id/frame/:id' => 'Frames#show', :as => 'presentation_frame'
  put '/:presentation_id/frame/:id' => 'Frames#update', :as => 'update_presentation_frame'
  post '/:presentation_id/frame/:id/wysiwyg' => 'Frames#update_wysiwyg', :as => 'update_wysiwyg_presentation_frame'
  
  delete '/:presentation_id/frame/:id' => 'Frames#destroy', :as => 'delete_presentation_frame'
  post '/:presentation_id/frames/sort' => 'Frames#sort', :as => 'sort_presentation_frames'

  post '/copy/:id' => 'Presentations#copy', :as => 'presentation_copy'
  match 'markup/preview' => 'frames#markup_preview'
end
