$:.push File.expand_path("../lib", __FILE__)

require "acts_as_rrranking/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_rrranking"
  s.version     = ActsAsRrranking::VERSION
  s.authors     = ["Weihu Chen"]
  s.email       = ["cctiger36@gmail.com"]
  s.homepage    = "https://github.com/cctiger36/acts_as_rrranking"
  s.summary     = "Redis Realtime Ranking"
  s.description = "A rails plugin use redis to sort models on real time."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.1.0"
  s.add_dependency "redis", ">= 3.0.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
