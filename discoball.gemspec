Gem::Specification.new do |s|
  s.name = "discoball"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">=0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 2 if s.respond_to? :specification_version=

  s.author = "Caleb Spare"
  s.email = "cespare@gmail.com"

  s.description = "A simple stream filter to highlight patterns"
  s.summary = "A simple stream filter to highlight patterns"
  s.homepage = "http://github.com/cespare/discoball"
  s.rubyforge_project = "discoball"

  s.executables = %w(discoball)
  s.files = %w(
    README.md
    discoball.gemspec
    lib/discoball.rb
    bin/discoball
  )
  s.add_dependency("colorize", ">=0.5.8")
  s.add_dependency("trollop", ">=1.16.2")
end
