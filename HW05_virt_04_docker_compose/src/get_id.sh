#!/bin/bash
echo "{\"id\": \"$(yc compute image get --name ubuntu-2004-lts | awk '/^id/ {print $2}')\"}"
