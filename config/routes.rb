ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.resources :users do |users|
    users.resources :tray_positions, :collection => {:sort => :put}
  end
  map.resource :session

  map.resources :catalogs do |catalog|
    catalog.resources :facets, :has_many => :labels    
  end
  map.resources :classifications
  
  map.resources :file_assets, :as => "files", :member => {:thumb => :get, :preview => :get, :original => :get}
  map.resources :urls
  map.resources :presentations, :has_many => :slides
  
  map.root :controller => "catalogs"
end

