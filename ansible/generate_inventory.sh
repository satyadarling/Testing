#!/bin/bash

terraform output -json instance_ips > ips.json
jq -r '.[] | .[]' ips.json > ansible/inventory.txt
