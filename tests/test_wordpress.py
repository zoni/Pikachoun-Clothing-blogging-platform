import pytest
import requests
from sh import ansible, ansible_playbook
from time import sleep

def ansible_shell(command, servers="blog"):
    """Execute command through ansible's shell module"""
    ansible("-v", "-s", "-m", "shell", "-a", "{}".format(command), servers)

def service(name, state):
    """Change state of a service using ansible's service module"""
    ansible("-v", "-s", "-m", "service", "-a", "name={} state={}".format(name, state), "blog")

@pytest.fixture()
def low_ttl_varnish(request):
    """
    Lowers the Varnish object TTL so that we can make assertions about
    expired cache objects.
    """
    def finished():
        ansible_playbook("deploy-blog.yml", tags="varnish")

    ansible_playbook("deploy-blog.yml", tags="varnish", extra_vars="wordpress_varnish_ttl='3s'")
    request.addfinalizer(finished)

@pytest.fixture()
def varnish():
    """
    Clears the varnish cache before tests. Has the side benefit of
    ensuring Varnish is running
    """
    ansible_shell("varnishadm ban.url .")

@pytest.fixture()
def restore_mysql(request):
    """Starts mysql back up after tests complete"""
    def finished():
        service("mysql", "started")

    request.addfinalizer(finished)

@pytest.fixture()
def restore_varnish(request):
    """Starts varnish back up after tests complete"""
    def finished():
        service("varnish", "started")

    request.addfinalizer(finished)


def test_wp_main_page_responds():
    r = requests.get('http://wordpress.localdomain/')
    assert r.ok
    assert "Pikachoun Clothing" in r.text

def test_wp_admin_responds():
    r = requests.get('https://wordpress.localdomain/wp-admin', verify=False)
    assert r.ok
    assert "loginform" in r.text

def test_wp_admin_forces_https():
    r = requests.get('http://wordpress.localdomain/wp-admin', verify=False)
    assert r.url.startswith('https://')

def test_wordpress_works_when_varnish_down(restore_varnish):
    service("varnish", "stopped")
    r = requests.get('http://wordpress.localdomain/')
    assert r.ok
    assert "Pikachoun Clothing" in r.text

def test_varnish_caches_normal_pages(varnish):
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "MISS"
    r = requests.get('https://wordpress.localdomain/', verify=False)
    assert r.headers['x-cache'] == "MISS"
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "HIT"
    r = requests.get('https://wordpress.localdomain/', verify=False)
    assert r.headers['x-cache'] == "HIT"

    ansible_shell("varnishadm ban.url .")
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "MISS"
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "HIT"

def test_varnish_does_not_cache_admin(varnish):
    r = requests.get('https://wordpress.localdomain/wp-admin/', verify=False)
    assert r.headers['x-cache'] == "MISS"
    r = requests.get('https://wordpress.localdomain/wp-admin/', verify=False)
    assert r.headers['x-cache'] == "MISS"

def test_varnish_object_expiry(low_ttl_varnish, varnish):
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "MISS"
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "HIT"
    sleep(5)
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "MISS"

def test_varnish_caches_pages_past_expiry_on_backend_error(low_ttl_varnish, varnish, restore_mysql):
    r = requests.get('http://wordpress.localdomain/')
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "HIT"
    service("mysql", "stopped")
    sleep(5)  # low_ttl_varnish has a 3s object TTL
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "HIT"
    assert "Error establishing a database connection" not in r.text

    # Should get a fresh miss again soon after the database comes back up
    # as saintmode is set to 5 seconds
    service("mysql", "started")
    sleep(6)
    r = requests.get('http://wordpress.localdomain/')
    assert r.headers['x-cache'] == "MISS"
