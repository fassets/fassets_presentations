require "fassets_core"

module FassetsPresentations
  class Engine < Rails::Engine
    isolate_namespace FassetsPresentations
    initializer :assets do |config|
      Rails.application.config.assets.precompile += %w(fassets_presentations/pres_edit_box.js fassets_presentations/pres_edit_box.css fassets_presentations/presentations.js fassets_presentations/mercury.js fassets_presentations/mercury_overrides.css fassets_presentations/frames_wysiwyg.js fassets_presentations/frames.js fassets_presentations/templates/default/styles.css fassets_presentations/templates/default/editor.css fassets_presentations/templates/default/script.js fassets_presentations/templates/xmendel/styles.css fassets_presentations/templates/xmendel/editor.css fassets_presentations/templates/xmendel/script.js fassets_presentations/templates/uzl_corporate/styles.css fassets_presentations/templates/uzl_corporate/editor.css fassets_presentations/templates/uzl_corporate/script.js fancybox.css)
      Rails.application.config.autoload_paths += %W(#{config.root}/lib)
      Rails.application.config.autoload_paths += Dir["#{config.root}/lib/**/"]
    end
  end
end
