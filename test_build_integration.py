# more info:
# https://testinfra.readthedocs.io/en/latest
import pytest
import os

conn = os.getenv('PACKER_CONNECTION_TYPE', "ssh")


@pytest.mark.skipif(conn == "ssh" or conn == "docker",
                    reason="Skipping test_host_system_windows on Linux")
def test_host_system_windows(host):
    '''
    Check OS properties of the host system.
    '''
    system_type = 'windows'
    distribution = 'Microsoft Windows Server 2019 Datacenter'
    release = '10.0.17763 N/A Build 17763'

    assert system_type == host.system_info.type
    assert distribution == host.system_info.distribution
    assert release == host.system_info.release


@pytest.mark.skipif(conn == "winrm", reason="Skipping test_host_system_linux on Windows")
def test_host_system_linux(host):
    '''
    Check OS properties of the host system.
    '''
    system_type = 'linux'
    distribution = 'ubuntu'
    release = '18.04'

    assert system_type == host.system_info.type
    assert distribution == host.system_info.distribution
    assert release == host.system_info.release


@pytest.mark.skipif(conn == "winrm", reason="Skipping test_app_installed on Windows")
def test_app_installed(host):
    if conn == "winrm":
        assert host.file(
            r"C:\Users\packer\AppData\Local\Temp\app\requirements.txt").exists
        assert host.file(
            r"C:\Users\packer\AppData\Local\Temp\app\main.py").exists
    else:
        assert host.file("/opt/app/requirements.txt").exists
        assert host.file("/opt/app/main.py").exists


def test_service_packages(host):
    '''
    Check app package properties of the host system.
    '''
    assert host.package("python").is_installed
    assert host.package("python-pip").is_installed


@pytest.mark.skipif(conn == "winrm" or conn == "docker", reason="Skipping test_host_services on Windows")
def test_host_services(host):
    '''
    Check app service properties of the host system.
    '''
    assert host.service("flask").is_enabled
    assert host.service("flask").is_running
