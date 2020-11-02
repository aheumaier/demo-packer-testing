# more info:
# https://testinfra.readthedocs.io/en/latest/examples.html#test-docker-images
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
