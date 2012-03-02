module FassetsPresentations
  class Engine < Rails::Engine
    isolate_namespace FassetsPresentations
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w(fassets_presentations/pres_edit_box.js fassets_presentations/pres_edit_box.css)
    end
  end
end
