#!/bin/sh
set -e

# start ssh-agent
eval `ssh-agent`

# export session and add mgmt key to ssh-agent
export BW_SESSION=$(bw unlock --raw)
bw sync
bw get item "Ansible Mgmt Private Key" | jq -r .notes | ssh-add -