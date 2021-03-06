#!/usr/bin/env bash
set -eu

PACKAGES=(python3 python3-pip python3-pytest)

prep_docker() {
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq "${PACKAGES[@]}"
    mv /tmp/app/ /opt/app/
    python3 -m pip install -r /opt/app/requirements.txt
}

prep_azure() {
    sudo apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq "${PACKAGES[@]}"
    sudo mv /tmp/app/ /opt/app/
    python3 -m pip install -r /opt/app/requirements.txt

    sudo mv /opt/app/flask.service /etc/systemd/system/
    sudo systemctl daemon-reload
    sudo systemctl enable flask.service
    sudo systemctl start flask.service
    echo $(sudo systemctl status flask.service)
}

run_main() {
    echo "INFO bootstrap.sh: run_main()"
    if [ "${PACKER_BUILDER_TYPE}" == "docker" ]; then
        prep_docker
    elif [ "${PACKER_BUILDER_TYPE}" == "azure-arm" ]; then
        prep_azure
    fi
}

run_main
