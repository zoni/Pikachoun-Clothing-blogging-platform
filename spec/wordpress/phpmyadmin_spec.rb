require 'spec_helper'

describe package('phpmyadmin') do
  it { should be_installed }
end

describe user('phpmyadmin') do
  it { should exist }
  it { should have_home_directory '/usr/share/phpmyadmin' }
  it { should have_login_shell '/bin/false' }
end

describe file('/var/run/php-fpm-phpmyadmin.sock') do
  it { should be_socket }
  it { should be_owned_by 'phpmyadmin' }
  it { should be_grouped_into 'www-data' }
  it { should be_mode 660 }
end
