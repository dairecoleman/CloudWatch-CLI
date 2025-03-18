#!/usr/bin/env bash

# Install prerequisites
echo "Installing prerequisites needed to run this software"
sudo apt-get install curl # for downloading 
sudo apt-get install jq # for working with JSON

# Defining required path locations to run the cli and that are used by it
echo "Defining required path locations"
CW_CLI_TOOL_PATH="/usr/local/bin/mycloudwatch"
echo -n "$"
echo "CW_CLI_TOOL_PATH set to $CW_CLI_TOOL_PATH"
echo -n "Making current directory the directory for storing any custom configs: "
echo `pwd`
export CW_CLI_TOOL_CUSTOM_CONFIGS_PATH=`pwd`

#  making the cli executable and on path , providing initial instruction
echo "Copying CLI tool to $CW_CLI_TOOL_PATH and making executable"
sudo cp mycloudwatch.sh $CW_CLI_TOOL_PATH
sudo chmod +x $CW_CLI_TOOL_PATH
echo -e "\n"
echo "Run 'mycloudwatch --help' to get started"
echo -e "\n"
echo -e "\n"

