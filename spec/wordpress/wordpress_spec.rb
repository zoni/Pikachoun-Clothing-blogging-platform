require 'spec_helper'

describe package('php5-mysql') do
  it { should be_installed }
end

describe file('/opt/www/wordpress.localdomain') do
  it { should be_directory }
  it { should be_owned_by 'wordpress' }
  it { should be_grouped_into 'www-data' }
  it { should be_mode 750 }
end

describe port(5000) do
  it { should be_listening }
end
