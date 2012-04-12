Rails.application.routes.draw do
  match '/editor(/*requested_uri)' => "FassetsPresentations::Frames#editor", :as => :mercury_editor
  scope '/mercury' do
    match ':type/:resource' => "mercury#resource"
  end
end
FassetsPresentations::Engine.routes.draw do
  match '/to_markdown' => 'Frames#to_markdown'
  match '/to_html' => 'Frames#to_html'
  match '/citation' => 'Frames#citation'
  match '/templates' => 'Frames#templates'
  match '/rename_frame' => 'Frames#rename_frame'
  get '/new' => 'Presentations#new', :as => 'new_presentation'
  post '/' => 'Presentations#create'
  get '/:id' => 'Presentations#show', :as => 'presentation'
  delete '/:id' => 'Presentations#destroy', :as => 'delete_presentation'
  get '/:id/edit' => 'Presentations#edit', :as => 'edit_presentation'
  post '/:id' => 'Presentations#update', :as => 'update_presentation'

  get '/:presentation_id/frames' => 'Frames#frames', :as => 'presentation_frames'
  post '/:presentation_id/frames' => 'Frames#create', :as => 'presentation_frames'
  get '/:presentation_id/frame/:id/edit' => 'Frames#edit', :as => 'edit_presentation_frame'
  get '/:presentation_id/frame/:id/edit_wysiwyg' => 'Frames#edit_wysiwyg', :as => 'edit_wysiwyg_presentation_frame'
  post '/:presentation_id/frame/:id/edit_wysiwyg' => 'Frames#edit_wysiwyg_save', :as => 'edit_wysiwyg_presentation_frame'
  get '/:presentation_id/frame/:id' => 'Frames#show', :as => 'presentation_frame'
  put '/:presentation_id/frame/:id' => 'Frames#update', :as => 'update_presentation_frame'
  get '/:presentation_id/frame/:id/show' => 'Frames#showFrame', :as => 'show_presentation_frame' 
  post '/:presentation_id/frame/:id/wysiwyg' => 'Frames#update_wysiwyg', :as => 'update_wysiwyg_presentation_frame'
  post '/:presentation_id/frame/:id/rename' => 'Frames#rename_frame'
  post '/:presentation_id/frame/:id/change_template' => 'Frames#change_template'
  get '/:presentation_id/frame/:id/reload_slots' => 'Frames#reload_slots'
  
  delete '/:presentation_id/frame/:id' => 'Frames#destroy', :as => 'delete_presentation_frame'
  post '/:presentation_id/frames/sort' => 'Frames#sort', :as => 'sort_presentation_frames'

  post '/copy/:id' => 'Presentations#copy', :as => 'presentation_copy'
  match 'markup/preview' => 'frames#markup_preview'
end
