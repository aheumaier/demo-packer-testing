#!/usr/bin/env bash
set -eux

ssh_config() {
    echo "INFO teardown.sh: ssh_config()"
    mkdir -p ~/.ssh/config
    echo 'StrictHostKeyChecking no' >~/.ssh/config
}

run_pytest() {
    echo "INFO teardown.sh: run_pytest()"
    if [ ${PACKER_BUILDER_TYPE} == "azure-arm" ]; then
        echo "INFO teardown.sh: Using ${PACKER_CONNECTION_TYPE}"
        if [ $PACKER_CONNECTION_TYPE == "winrm" ]; then
            python3 -m pytest -vv --hosts=winrm://${PACKER_USER}:${PACKER_PASSWORD}@${PACKER_HOST}:5986?no_verify_ssl=true
        else
            python3 -m pytest -vv --ssh-identity-file=/tmp/packer_rsa --hosts=ssh://${PACKER_USER}@${PACKER_HOST}
        fi
    elif [ ${PACKER_BUILDER_TYPE} == "docker" ]; then
        python3 -m pytest -vv --hosts=docker://${PACKER_ID}
    fi
}

install_agent_runtime() {
    echo "INFO teardown.sh: install_agent_runtime()"
    python3 -m pip install pytest-testinfra
}

run_main() {
    echo "INFO teardown.sh: main()"
    install_agent_runtime
    ssh_config
    run_pytest
}

run_main
