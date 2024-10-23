#!/bin/bash

stackTemplate=$1
stackName=$2
resourceGroup=$3
slackWebhookUrl=$4

# Example Message
# {
#     "text": "⚠️ Start Deploying Azure Stack!! ⚠️"
# }

curl -X POST -H 'Content-type: application/json' \
    --data "{\"text\":\"@here ⚠️ Start Deploying Azure Stack *${stackName}* to *${resourceGroup}* ⚠️\"}" \
    ${slackWebhookUrl}

# Deploy Azure Stack and keep the exit code without stopping the script 
az stack group create \
    --name ${stackName} \
    --resource-group ${resourceGroup} \
    --template-file ${stackTemplate} \
    --deny-settings-mode denyDelete \
    --action-on-unmanage deleteAll \
    --tags RG=${resourceGroup} \
    --yes || exit_code=$? 

if [[ -z $exit_code || $exit_code -eq 0 ]]; then
    # send success notification
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"@here ✅ Finish Deploying Azure Stack *${stackName}* to *${resourceGroup}* 🥳\"}" \
        ${slackWebhookUrl}
else
    # send failure notification
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"@here ❌ Failed Deploying Azure Stack *${stackName}* to *${resourceGroup}* 😨\"}" \
        ${slackWebhookUrl}

    exit 1
fi


