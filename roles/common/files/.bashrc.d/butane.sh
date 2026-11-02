#!/bin/bash
alias b=butane

butane() {
    podman run -iq --rm \
        -v "$PWD":/data:Z \
        -w /data \
        quay.io/coreos/butane:release --pretty --strict --files-dir . "$@"
}

bignite () {
    for f in $(ls butane/) ; do
        local HOSTNAME=$(echo $f | rev | cut -d'.' -f2- | rev)
        envsubst '$HOSTNAME' < butane/$f | butane -o _out/$(echo $f | rev | cut -d'.' -f2- | rev).ign
    done && croc --pass='-0o-0o-0o_)O_)O_)O' --relay=10.0.30.3 send _out/*
}
