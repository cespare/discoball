desc "remove built gems"
task :clean do
  sh "rm discoball-*" rescue true
end

desc "build gem"
task :build do
  sh "gem build discoball.gemspec"
end

desc "install gem"
task :install => [:clean, :build] do
  sh "gem install `ls discoball-*`"
end
