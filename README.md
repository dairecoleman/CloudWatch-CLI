# My Agent and CLI Tool

This package contains a command-line tool to Install and Configure AWS CloudWatch Agent

## Installation

1. Extract the package to a directory of your choice.
2. Run the install script for setup: source ./install.sh (MUST USE source)
3. Use the mycloudwatch.sh CLI tool (with -h for detailed intructions) 
4. Use simplescript.sh to generate a logfile for tracking e.g.  ./simplescript.sh [LOGFILEPATH]

## Notes
Store AWS IAM user credentials in ~/.aws/credentials
can use wizard for this:
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

Configuration is changed by editing, appending or removing config templates the agent uses

