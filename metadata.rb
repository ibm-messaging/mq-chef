name 'ibm_mq'
maintainer 'IBM'
maintainer_email 'arthur.barr@uk.ibm.com'
license 'Apache 2.0'
description 'Installs/Configures IBM MQ'
long_description 'Installs/Configures IBM MQ'
source_url 'https://github.com/ibm-messaging/mq-chef'
issues_url 'https://github.com/ibm-messaging/mq-chef/issues'

version '0.1.2'

supports 'ubuntu'

depends 'limits'
depends 'yum'

chef_version '>= 12.6' if respond_to?(:chef_version)
