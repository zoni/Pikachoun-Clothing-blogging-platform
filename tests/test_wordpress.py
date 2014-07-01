import requests

def test_wp_main_page_responds():
    r = requests.get('http://wordpress.localdomain/')
    assert r.ok
    assert "Pikachoun Clothing" in r.text

def test_wp_admin_responds():
    r = requests.get('http://wordpress.localdomain/wp-admin', verify=False)
    assert r.ok
    assert "loginform" in r.text

def test_wp_admin_forces_https():
    r = requests.get('http://wordpress.localdomain/wp-admin', verify=False)
    assert r.url.startswith('https://')
