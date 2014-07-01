Pikachoun Clothing blogging platform
====================================

Pikachoun Clothing is a fictional company that needs their Wordpress
blogging platform automated. This is part of an assessment by Rackspace
for Automation Engineers.

Requirements
------------

This project makes use of a mix of Python and Ruby libraries. Because it
uses Ansible, you must use Python 2, Python 3 is not supported.

Python requirements can be installed like this:

```
# Not strictly necessary, but highly recommended
virtualenv --python /usr/bin/python2 virtualenv
source virtualenv/bin/activate

pip install -r requirements.txt
```

Ruby requirements can be installed like this (this assumes you have bundler
installed already):

```
bundle install
```

Additionally, [Vagrant](http://vagrantup.com/) also needs to be installed.

Provisioning
------------

By running `vagrant up`, a fresh Ubuntu 14.04 LTS machine will be created
and booted up, ready to be provisioned for Pikachoun's blog. Once the Vagrant
machine has booted, the Ansible `deploy-blog.yml` playbook can be played in
order to provision it:

```
vagrant up
ansible-playbook deploy-blog.yml
```

Running tests
-------------

This projects makes use of two seperate test suites. It uses serverspec to
make assertions about the state of the machine and uses a *py.test* testsuite
to do some higher-level integration testing.

The serverspec tests may be run by executing `bundle exec rake spec`.
The python *py.test* tests may be run by executing `py.test`.
