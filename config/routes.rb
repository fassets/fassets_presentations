require "fassets-presentations/presentations_controller"
require "fassets-presentations/frames_controller"
FassetsPresentations::Engine.routes.draw do
  resources :presentations do
  
  
      resources :frames do
        collection do
          post :sort
        end    
      end
      post :copy
  end
end
