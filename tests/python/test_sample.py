import pytest

def add_numbers(a, b):
    return a + b

def test_add_numbers():
    assert add_numbers(2, 3) == 5
    assert add_numbers(-1, 1) == 0

def test_template_environment():
    # Testataan että testausympäristö pyörii ongelmitta
    assert True
