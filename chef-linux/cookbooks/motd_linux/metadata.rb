name 'motd_linux'
maintainer 'James Bannan'
maintainer_email 'james@myemail.com'
license 'All Rights Reserved'
description 'Installs/Configures motd_linux'
version '0.1.0'
chef_version '>= 15.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/motd_linux/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/motd_linux'

depends 'motd', '~> 1.0.1'
depends 'motd_chef_status', '~> 1.0.3'
