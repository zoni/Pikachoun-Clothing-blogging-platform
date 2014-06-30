require 'spec_helper'

describe package('nginx-full') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

['fastcgi_params', 'koi-utf', 'koi-win', 'mime.types', 'nginx.conf',
 'proxy_params', 'scgi_params', 'uwsgi_params', 'win-utf'].each do |f|
  describe file('/etc/nginx/' + f) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
  end
end

describe file('/opt/www/') do
  it { should be_directory }
  it { should be_owned_by 'www-data' }
  it { should be_grouped_into 'www-data' }
  it { should be_mode 755 }
end

describe iptables do
  it { should have_rule('-p tcp -m tcp --dport 80 -j ACCEPT').with_chain('input') }
  it { should have_rule('-p tcp -m tcp --dport 443 -j ACCEPT').with_chain('input') }
end
