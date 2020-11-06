#!/usr/bin/env bash
set -eux

# ssh_config() {
#     echo "INFO teardown.sh: ssh_config()"
#     grep -q '^StrictHostKeyChecking' ~/.ssh/config &&
#         sed -i 's/^StrictHostKeyChecking.*/StrictHostKeyChecking no/' ~/.ssh/config ||
#         echo 'StrictHostKeyChecking no' >>~/.ssh/config
# }

run_pytest() {
    echo "INFO teardown.sh: run_pytest()"
    if [ ${PACKER_BUILDER_TYPE} == "azure-arm" ]; then
    echo "INFO teardown.sh: Using ${PACKER_CONNECTION_TYPE}"
        if [ $PACKER_CONNECTION_TYPE == "winrm" ]; then
            pytest -vv --hosts=winrm://${PACKER_USER}:${PACKER_PASSWORD}@${PACKER_HOST}:5985?no_ssl=true\&no_verify_ssl=true
        else
            pytest -vv --ssh-identity-file=/tmp/packer_rsa --hosts=ssh://${PACKER_USER}@${PACKER_HOST}
        fi
    elif [ ${PACKER_BUILDER_TYPE} == "docker" ]; then
        pytest -vv --hosts=docker://${PACKER_ID}
    fi
}

run_main() {
    echo "INFO teardown.sh: main()"
    run_pytest
}

run_main
