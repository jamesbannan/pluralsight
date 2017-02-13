#!/bin/bash

# Download Chef Server installation package from packagecloud.io
wget -P /tmp https://web-dl.packagecloud.io/chef/stable/packages/ubuntu/trusty/chef-server-core_12.1.2-1_amd64.deb

# Install Chef Server
sudo dpkg -i /tmp/chef-server-core_12.1.2-1_amd64.deb

# Configure Chef Server and start all services
sudo chef-server-ctl reconfigure

# Create administrative user and organization
sudo chef-server-ctl user-create chefadmin Chef Admin chefadmin@test.com P@ssw0rd --filename /home/chef/chefadmin.pem
sudo chef-server-ctl org-create pluralsightchef "Pluralsight Chef Lab" --association_user chefadmin --filename /home/chef/pluralsightchef-validator.pem

# Install and configure Chef Management console
sudo chef-server-ctl install opscode-manage
sudo chef-server-ctl reconfigure
sudo opscode-manage-ctl reconfigure

# Install and configure Chef Reporting
sudo chef-server-ctl install opscode-reporting
sudo chef-server-ctl reconfigure
sudo opscode-reporting-ctl reconfigure
