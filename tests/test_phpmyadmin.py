import requests

def test_root_shows_login():
    r = requests.get('http://pma.localdomain/', verify=False)
    assert r.ok
    assert "phpMyAdmin" in r.text

def test_https_is_enforced():
    r = requests.get('http://pma.localdomain/', verify=False)
    assert r.url.startswith('https://')
