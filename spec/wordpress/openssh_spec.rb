require 'spec_helper'

describe package('openssh-server') do
  it { should be_installed }
end

describe service('ssh') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(22) do
  it { should be_listening }
end

describe file('/etc/ssh/sshd_config') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should match /^PermitRootLogin without-password/ }
end

describe iptables do
  it { should have_rule('-p tcp -m tcp --dport 22 -j ACCEPT').with_chain('input') }
end
