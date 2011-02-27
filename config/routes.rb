ActionController::Routing::Routes.draw do |map|
  map.resources :users do |users|
    users.resources :tray_positions, :collection => {:replace => :put}
  end
  map.resource :session

  map.resources :catalogs do |catalog|
    catalog.resources :facets do |facet|
      facet.resources :labels, :collection => {:sort => :put}
    end
  end
  map.resources :classifications

  map.resources :file_assets, :as => "files", :member => {:thumb => :get, :preview => :get, :original => :get}
  map.resources :urls
  map.resources :presentations do |p|
    p.resources :slides, :collection => {:sort => :put}
  end

  map.root :controller => "catalogs"
end

