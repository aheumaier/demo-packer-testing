#!/usr/bin/env bash
set -eux

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

install_runtime() {
    python3 -m pip install --upgrade pytest testinfra
} 

run_main() {
    echo "INFO teardown.sh: main()"
    install_runtime
    run_pytest
}

run_main
