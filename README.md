# Packer image testing with [testinfra](https://github.com/pytest-dev/pytest-testinfra)

## Introduction
Since working on a packer remote host in a local manner is not always sufficient packer provides hook functions like `build` to access the random generated attributes at run time. Take a look here to read the full documentation.

So we can easily use expression like the following to retrieve `Host`, `User`, `SSHPrivateKey` information:

``` json
{
    "type": "shell-local",
    "environment_vars": [
        "key={{build `SSHPrivateKey`}}"
    ],
    "inline": [
        "echo '{{ build `SSHPrivateKey`}}' > /tmp/packer_rsa",
        "chmod 600 /tmp/packer_rsa",
        "ssh-add /tmp/packer_rsa"
        ]
},
{
    "type": "shell-local",
    "environment_vars": [
        "user={{build `User`}}",
        "host={{build `Host`}}"
    ],
    "script": "teardown.sh"
}
```

## Setup

We run the following cycle to setup and relaese images calling `make`: 

```json
=> packer validate
=> packer build:
    => "setup.sh"
    => "prepare ssh connection via ssh-agent"
    => "teardown.sh" - includes running testinfra against the image
=> finish after successful integration run
```

## Testing

We are runnig testinfa using pytest at the last teardown stage:
`pytest --ssh-identity-file=/tmp/packer_rsa --hosts=ssh://${user}@${host}`
picking up all infra test files starting with `test_` like `test_build_integration.py`

```python
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

```
