require 'spec_helper'

["php5-mysql", "varnish"].each do |p|
  describe package(p) do
    it { should be_installed }
  end
end

describe file('/opt/www/wordpress.localdomain') do
  it { should be_directory }
  it { should be_owned_by 'wordpress' }
  it { should be_grouped_into 'www-data' }
  it { should be_mode 750 }
end

[6080, 6081, 6082, 5000].each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe service('varnish') do
  it { should be_running }
end

describe file('/etc/varnish/default.vcl') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
end
