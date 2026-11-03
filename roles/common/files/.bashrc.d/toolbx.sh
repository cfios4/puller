#!/bin/bash
alias tbx="toolbox enter toolbx"

if [ -f /run/.toolboxenv ] ; then
	:
else
	podman container exists toolbx || toolbox --assumeyes create -i quay.io/cafio/toolbx:latest toolbx >/dev/null
fi
