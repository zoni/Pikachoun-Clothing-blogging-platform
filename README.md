Pikachoun Clothing blogging platform
====================================

*Pikachoun Clothing* is a fictional company that needs their Wordpress
blogging platform automated. This is part of an assessment from Rackspace
for people applying for the role of Automation Engineer.

Pikachoun Clothing has provided a list of requirements that their platform
needs to adhere to, but to discourage other people taking the same assessment
I have chosen not to publish them here. Study the structure of the project
and the history of the repository and you will get a good sense of what is
asked, though. :)

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

A rake task, `rake provision` has been provided which does both for you.

*Note: The following hosts entry is assumed to be present on the host machine:
`192.168.98.10 wordpress.localdomain pma.localdomain`*

Sample database
---------------

A sample config and database for wordpress has been provided for testing
purposes. These may be installed by running the rake task `sampleinstall`.

Please note that this is *a sample database only*! The admin account has
username `admin` and password `admin`.

Running tests
-------------

This projects makes use of two seperate test suites. It uses serverspec to
make assertions about the state of the machine and uses a *py.test* testsuite
to do some higher-level integration testing.

A rake task, `rake tests` has been provided which runs both of these testsuites
for you. You can also use the individual `rake serverspec` and `rake pytest` to
run them individually.

*Note: It is assumed that the sample config and database are installed*

A note on Varnish caching
-------------------------

Varnish is set up to cache aggressively which means that, without a plugin to
purge the cache at the right times, stale content will be served (for example
after a user comments or a new post is made). It is assumed a plugin such as
[Varnish HTTP Purge](http://wordpress.org/plugins/varnish-http-purge/) or
[WordPress Varnish](https://wordpress.org/plugins/wordpress-varnish/) is installed
to selectively purge the cache when needed.

If installing such a plugin is out of the question, then one may choose to set a
low value (such as 5 minutes) for `wordpress_varnish_ttl` (the default is a
moderately low 1 hour) in order to have some caching benefits but keep content
from becoming too stale.
