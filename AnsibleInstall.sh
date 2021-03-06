#!/bin/sh

# Ansible install script!
#
# Are you looking at this in your web browser, and would like to install Ansible?
# Just open up your terminal and type:
#
#
#   curl https://raw.githubusercontent.com/TalLannder/ansible/master/AnsibleInstall.sh | sh
#
#
# The script will install the required packages and will clone Ansible into
# /opt/ansible from the official repo (github.com/ansible) after the installation
# is done run:
#   source /opt/ansible/hacking/env-setup
#
# Tip: You can add this command to your ~/.bash_profile so you don't need to run it
#      everytime you login.
#
#
# Currently tested (Support only x86_64):
#   - Ubuntu       14.04
#   - Red Hat      7.1
#   - CentOS Linux 7
#
#
# We wrap this whole script in a function, so that we won't execute
# until the entire script is downloaded.
# That's good because it prevents our output overlapping with curl's.
# It also means that we can't run a partially downloaded script.
run_it () {

# Display everything on stderr.
exec 1>&2

UNAME=$(uname)
if [ "$UNAME" != "Linux" ] ; then
  echo "Sorry, this OS is not supported yet."
  exit 1
fi


if [ "$UNAME" = "Linux" ] ; then
  ### Linux ###
  LINUX_ARCH=$(uname -m)
  if [ "${LINUX_ARCH}" != "x86_64" ] ; then
    echo "Unusable architecture: ${LINUX_ARCH}"
    echo "Support only x86_64 for now."
    exit 1
  fi
fi


# Test for RedHat or CentOS
grep 'ID="centos"' /etc/os-release > /dev/null || grep 'ID="rhel"' /etc/os-release > /dev/null

if [ $? -eq 0 ]; then
  echo "Red Hat: Beginning installation"
  yum --assumeyes update || { echo '"yum update" exited with error' ; exit 1; }
  yum --assumeyes install git gcc python-setuptools python-devel || { echo 'Unable to finish installation of git gcc python-setuptools python-devel' ; exit 1; }
fi


# Test for Ubuntu OS
grep Ubuntu /etc/os-release > /dev/null

if [ $? -eq 0 ]; then
  echo "Ubuntu: Beginning installation"

  apt-get update --fix-missing || { echo '"apt-get update --fix-missing" exited with error' ; exit 1; }

  apt-get install -y git build-essential python-setuptools python-dev || { echo 'Unable to finish installation of git build-essential python-setuptools python-dev' ; exit 1; }
fi


easy_install pip || { echo '"easy_install pip" exited with error' ; exit 1; }


pip install paramiko PyYAML Jinja2 httplib2 simplejson six || { echo '"pip install paramiko PyYAML Jinja2 httplib2 simplejson six" exited with error' ; exit 1; }


cd /opt || { echo 'Unable to change directory to /opt' ; exit 1; }
git clone https://github.com/ansible/ansible.git --recursive || { echo '"git clone https://github.com/ansible/ansible.git --recursive exited with error' ; exit 1; }

}

run_it
