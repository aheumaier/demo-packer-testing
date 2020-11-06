#!/usr/bin/env bash
set -eux

ssh_config() {
    echo "INFO teardown.sh: ssh_config()"
    grep -q '^StrictHostKeyChecking' ~/.ssh/config &&
        sed -i 's/^StrictHostKeyChecking.*/StrictHostKeyChecking no/' ~/.ssh/config ||
        echo 'StrictHostKeyChecking no' >>~/.ssh/config
}

run_pytest() {
    echo "INFO teardown.sh: run_pytest()"
    if [ ${PACKER_BUILDER_TYPE} == "azure-arm" ]; then
        pytest -vv --ssh-identity-file=/tmp/packer_rsa --hosts=ssh://${PACKER_USER}@${PACKER_HOST} ./test_build_integration.py
    elif [ ${PACKER_BUILDER_TYPE} == "docker" ]; then
        pytest -vv --hosts=docker://${PACKER_ID} ./test_build_integration.py
    fi
}

run_main() {
    echo "INFO teardown.sh: main()"
    # ssh_config
    run_pytest
}

run_main
