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
