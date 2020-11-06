# more info:
# https://testinfra.readthedocs.io/en/latest
import pytest
import platform


@pytest.mark.skipif(platform.system() == "Linux")
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


@pytest.mark.skipif(platform.system() == "Windows")
def test_host_system(host):
    '''
    Check OS properties of the host system.
    '''
    system_type = 'linux'
    distribution = 'ubuntu'
    release = '18.04'

    assert system_type == host.system_info.type
    assert distribution == host.system_info.distribution
    assert release == host.system_info.release


@pytest.mark.skipif(platform.system() == "Linux")
def test_host_system(host):
    '''
    Check OS properties of the host system.
    '''
    system_type = 'windows'
    assert system_type == host.system_info.type


@pytest.mark.skipif(platform.system() == "Windows")
def test_app_installed(host):
    assert host.file("/opt/app/requirements.txt").exists
    assert host.file("/opt/app/main.py").exists


def test_service_packages(host):
    '''
    Check app package properties of the host system.
    '''
    assert host.package("python").is_installed
    assert host.package("python-pip").is_installed


@pytest.mark.skipif(platform.system() == "Windows")
def test_host_services(host):
    '''
    Check app service properties of the host system.
    '''
    assert host.service("flask").is_enabled
    assert host.service("flask").is_running
