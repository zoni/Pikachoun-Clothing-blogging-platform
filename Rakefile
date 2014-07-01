require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

task :default => [:provision, :tests]

desc "Run serverspec tests"
task :serverspec => :spec do
end

desc "Run py.test integration tests"
task :pytest do
  sh "py.test"
end

desc "Run all tests"
task :tests => [:serverspec, :pytest] do
end

desc "Run ansible to provision the wordpress blog"
task :provision do
  sh "vagrant up"
  sh "ansible-playbook deploy-blog.yml"
end
