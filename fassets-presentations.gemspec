$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fassets-presentations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fassets-presentations"
  s.version     = FassetsPresentations::VERSION
  s.authors     = ["Christopher Sharp", "Julian Bäume"]
  s.email       = ["cdsharp@gmail.com", "julian@svg4all.de"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FassetsPresentations."
  s.description = "TODO: Description of FassetsPresentations."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 3.1"
  s.add_dependency "pandoc-ruby"
  s.add_dependency "acts_as_tree_rails3"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
