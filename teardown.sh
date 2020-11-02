#!/usr/bin/env bash
set -eu

ssh_config() {
    echo "INFO teardown.sh: ssh_config()"
    grep -q '^StrictHostKeyChecking' ~/.ssh/config &&
        sed -i 's/^StrictHostKeyChecking.*/StrictHostKeyChecking no/' ~/.ssh/config ||
        echo 'StrictHostKeyChecking no' >>~/.ssh/config
}

run_pytest() {
    echo "INFO teardown.sh: run_pytest()"
    pytest -vv --ssh-identity-file=/tmp/packer_rsa --hosts=ssh://${user}@${host}
}

run_main() {
    echo "INFO teardown.sh: main()"
    ssh_config
    run_pytest
}

run_main
