require 'spec_helper'

describe package('vsftpd') do
  it { should be_installed }
end

describe service('vsftpd') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/vsftpd.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }

  its(:content) { should match /^local_enable=YES/ }
  its(:content) { should match /^anonymous_enable=NO/ }

  # None of the requirements in the assigment say anything about security,
  # however I think it's a core responsibility to set up proper security
  # by default.
  its(:content) { should match /^ssl_enable=YES/ }
  its(:content) { should match /^force_local_logins_ssl=YES/ }
end

describe port(21) do
  it { should be_listening }
end

describe iptables do
  it { should have_rule('-p tcp -m tcp --dport 21 -j ACCEPT').with_chain('input') }
end
