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

desc "Setup a sample installation for wordpress"
task :sampleinstall do
  sh "ansible -s -m shell -a 'cp /vagrant/sample/wp-config.php /opt/www/wordpress.localdomain/wordpress/wp-config.php && chown wordpress:wordpress /opt/www/wordpress.localdomain/wordpress/wp-config.php' blog"
  sh "ansible -s -m mysql_db -a 'name=wordpress state=import target=/vagrant/sample/wordpress_pikachoun_clothing.sql.gz' blog"
end
