# more info:
# https://testinfra.readthedocs.io/en/latest
import pytest


def test_host_system(host):
    '''
    Check properties of the host system.
    '''
    system_type = 'linux'
    distribution = 'ubuntu'
    release = '18.04'

    assert system_type == host.system_info.type
    assert distribution == host.system_info.distribution
    assert release == host.system_info.release


def test_service_packages(host):
    '''
    Check package properties of the service installed.
    '''
    assert host.package("python").is_installed
    assert host.package("python-pip").is_installed
    assert host.package("vim").is_installed

