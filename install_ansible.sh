#!/bin/bash
sudo yum -y install epel-release
sudo yum -y install ansible
sudo yum -y install git
git clone <ansible-repo>
ansible-playbook setup_ecomm.yml -i aws.ini

