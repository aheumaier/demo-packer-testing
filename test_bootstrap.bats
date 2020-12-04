#!/usr/bin/env bats
# Usage: docker run -it -v "${PWD}:/code" aheumaier/bats:latest .
# 
load '/test_helper/bats-assert/load.bash'
load '/test_helper/bats-support/load.bash'
load '/test_helper/bats-mock/src/bats-mock.bash'

#  Load out test target
SOURCEFILE="bootstrap.sh"

#  Setup global test scopes
setup() {
    echo "Bats setup() called "
}

@test "run_main() should run sucessful" {
    source ${SOURCEFILE}
    function repo_install() { echo "*"; }
    export -f repo_install
    apt-get="$(mock_create)"
    export -f $apt-get
    run run_main
    assert_success
}

@test "Expect complete package list" {
    source ${SOURCEFILE}
    want="jq apt-transport-https ca-certificates curl gnupg-agent software-properties-common make python3-pip lsb-release"
    assert_equal "${PACKAGES[*]}" "${want}"     
}



