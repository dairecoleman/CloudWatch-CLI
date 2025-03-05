#!/usr/bin/env bash
sudo rm /usr/local/bin/aws && sudo rm /usr/local/bin/aws_completer
sudo rm -rf /usr/local/aws-cli
rm -rf aws
rm awscliv2.zip

sudo apt-get remove --purge amazon-cloudwatch-agent
sudo rm -rf /opt/aws/amazon-cloudwatch-agent/logs
sudo rm -rf /opt/aws/amazon-cloudwatch-agent/etc/
sudo rm -rf /opt/aws
