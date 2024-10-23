#!/bin/bash

stackTemplate=$1
stackName=$2
resourceGroup=$3

# Deploy Azure Stack and keep the exit code without stopping the script 
az stack group create \
    --name ${stackName} \
    --resource-group ${resourceGroup} \
    --template-file ${stackTemplate} \
    --deny-settings-mode denyDelete \
    --action-on-unmanage deleteAll \
    --tags RG=${resourceGroup} \
    --yes || exit_code=$? 

# We could do something here before exit the script
exit $exit_code




