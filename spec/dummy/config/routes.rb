Rails.application.routes.draw do
  devise_for :users

  mount FassetsPresentations::Engine => '/presentations'

  root :to => "FassetsCore::Catalogs#index"
end
