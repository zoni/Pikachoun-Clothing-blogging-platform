require 'spec_helper'

describe package('mysql-server') do
  it { should be_installed }
end

describe service('mysql') do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

describe file('/root/.my.cnf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_mode 600 }
end
