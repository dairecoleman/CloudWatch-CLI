#!/usr/bin/env bash
__help="
command-line shell script which automates collection of logs and metrics in an Ubuntu machine.

Usage: $(basename $0) [OPTIONS]

Options:
	-h,--help                          Displays this message
	   --install                       Download and install the agent if it is not already installed.
	   --start                         Start the CloudWatch agent.
	   --stop                          Stop the CloudWatch agent.
	   --track-logs file1 file2 fileN  Configures the agent to collect all log files specified.
	   --untrack-logs                  Configures the agent to stop collecting any log files.
	   --track-cpu                     Configures the agent to collect CPU usage metrics.
	   --untrack-cpu                   Configures the agent to stop collecting CPU usage metrics.
	   --track-mem                     Configures the agent to collect memory usage metrics.
	   --untrack-mem                   Configures the agent to stop collecting memory usage metrics.
"

# option parsing
while [[ $# -gt 0 ]]; do
  case $1 in
	-h|--help)
	  echo "$__help"
	  shift
	  ;;
	--install)
      INSTALL=YES
      shift
      ;;
    --start)
	  START=YES
  	  shift
	  ;;
	--stop)
      STOP=YES
	  shift
	  ;;
    --track-logs)
      TRACKLOGS=YES
	  shift
	  logfiles=($@)
	  shift $#
      ;;
    --untrack-logs)
	  UNTRACKLOGS=YES
  	  shift
	  ;;
	--track-cpu)
      TRACKCPU=YES
	  shift
	  ;;
	--untrack-cpu)
      UNTRACKCPU=YES
      shift
      ;;
    --track-mem)
	  TRACKMEM=YES
  	  shift
	  ;;
	--untrack-mem)
      UNTRACKMEM=YES
	  shift
	  ;;
	  -*|--*)
      echo "Unknown option $1"
      exit 1
	  ;;
  esac
done

# install option
if [ ! -z "${INSTALL}" ]; then
	if aws --version; then
		echo aws cli version found
	else
		echo no aws cli version found, attempting to install
		curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
		unzip awscliv2.zip
		sudo ./aws/install
		if aws --version; then
			echo successfully installed aws cli
		else
			echo There was a problem installing aws cli
		fi
	fi
	if /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status; then
		echo CloudWatch Agent installed
	else
		echo no CloudWatch Agent installed, attempting to install
		wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
		sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
		if /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status; then
			echo CloudWatch Agent successfully installed
		else
			echo There was a problem installing Cloudwatch Agent
		fi
	fi
fi

# check required packages are installed and working as expected
if  ! (aws --version && /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status) ; then
	echo "Need to install aws cli and cloudwatch before using any other features of this script. Do so with --install option."
	exit 1
fi

# Start the CloudWatch agent.
if [ ! -z "${START}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/user-config.json
fi

# Stop the CloudWatch agent.
if [ ! -z "${STOP}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m onPremise -a stop
fi

# Configures the agent to collect all log files specified. in $logfiles
if [ ! -z "${TRACKLOGS}" ]; then
	__logs_config_json_template='
		{
		"logs": {
		   "logs_collected": {
			   "files": {
				   "collect_list": []
			   }
		   }
		}
	}'

	# put files in __logs_config_json_template and save as ./custom-configs/logs-config.json
	for file in "${logfiles[@]}"
	do
		if [ -f $file ]; then
    		__logs_config_json_template=$(echo "$__logs_config_json_template" | jq --arg file "$file" '.logs.logs_collected.files.collect_list += [{"file_path": $file}]')
		else
			echo "$file is not a file, won't be configured to tracking" 
		fi

	done
	echo $__logs_config_json_template > $CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/logs-config.json
	
	# configure cloudagent with it
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/logs-config.json
fi

# Configures the agent to stop collecting any log files.
if [ ! -z "${UNTRACKLOGS}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a remove-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/logs-config.json
fi

# Configures the agent to collect CPU usage metrics.
if [ ! -z "${TRACKCPU}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/metrics-cpu-config.json
fi

# Configures the agent to stop collecting CPU usage metrics.
if [ ! -z "${UNTRACKCPU}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a remove-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/metrics-cpu-config.json
fi

# Configures the agent to collect memory usage metrics.
if [ ! -z "${TRACKMEM}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/metrics-mem-config.json
fi

# Configures the agent to stop collecting memory usage metrics.
if [ ! -z "${UNTRACKMEM}" ]; then
	sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a remove-config -m onPremise -s -c file:$CW_CLI_TOOL_CUSTOM_CONFIGS_PATH/custom-configs/metrics-mem-config.json
fi



