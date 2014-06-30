require 'spec_helper'

describe package('php5-fpm') do
  it { should be_installed }
end

describe service('php5-fpm') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/var/run/php-fpm-www.sock') do
  it { should be_socket }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
  it { should be_mode 660 }
end
