$:.push File.expand_path("../lib", __FILE__)

require "acts_as_rrranking/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_rrranking"
  s.version     = ActsAsRrranking::VERSION
  s.authors     = ["Weihu Chen"]
  s.email       = ["cctiger36@gmail.com"]
  s.homepage    = "https://github.com/cctiger36/acts_as_rrranking"
  s.summary     = "Redis Realtime Ranking"
  s.description = "A rails plugin use redis to sort active_records on real time."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "redis", "~> 3.0.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
