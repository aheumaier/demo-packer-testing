# more info:
# https://testinfra.readthedocs.io/en/latest
import pytest


def test_host_system(host):
    '''
    Check OS properties of the host system.
    '''
    system_type = 'windows'
    distribution = 'Microsoft Windows Server 2019 Datacenter'
    release = '10.0.17763 N/A Build 17763'

    assert system_type == host.system_info.type
    assert distribution == host.system_info.distribution
    assert release == host.system_info.release


def test_service_packages(host):
    '''
    Check app package properties of the host system.
    '''
    assert host.package("python").is_installed
    assert host.package("python-pip").is_installed
    assert host.package("vim").is_installed
