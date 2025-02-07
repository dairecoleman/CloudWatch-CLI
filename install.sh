#!/usr/bin/env bash

# Install prerequisites
sudo apt-get install curl
sudo apt-get install jq

# Define locations
CW_CLI_TOOL_PATH="/usr/local/bin/mycloudwatch.sh"
export CW_CLI_TOOL_CUSTOM_CONFIGS_PATH=`pwd`


echo "Copying CLI tool to $CW_CLI_TOOL_PATH"
sudo cp mycloudwatch.sh $CW_CLI_TOOL_PATH
sudo chmod +x $CW_CLI_TOOL_PATH

