# (C) Copyright IBM Corporation 2016.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

property :source, kind_of: String, required: true
property :accept_license, kind_of: [TrueClass, FalseClass], default: false
property :packages, kind_of: Array, default: %w(MQSeriesServer MQSeriesGSKit)
property :primary, kind_of: [TrueClass, FalseClass], default: false
property :uid, kind_of: [String, Integer], default: nil
property :gid, kind_of: [String, Integer], default: nil

default_action :create

# This action does the following:
# * Downloads the MQ install package
# * Extracts the install package
# * Adds a Yum repository pointing at the MQ RPM files
# * Accepts the license, as specified
# * Installs the MQ packages, as specified
# * Sets the default MQ installation, as specified
action :create do
  fail 'You must accept the license to install IBM MQ.' unless accept_license
  fail 'Non-primary installations are not currently supported' unless primary

  # include_recipe 'sysctl::ohai_plugin'
  #
  # sysctl_param 'fs.file-max' do
  #   value 524_289
  #   only_if node['sys']['fs']['file-max'] < value
  # end

  download_dir = "#{Chef::Config[:file_cache_path]}/ibm_mq"
  download_path = "#{download_dir}/#{name}.tar.gz"
  unpack_dir = "#{download_dir}/extract-#{name}"

  directory download_dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  directory unpack_dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  package %w(rpm yum createrepo) do
    action :install
  end

  remote_file download_path do
    source new_resource.source
    action :create
    notifies :run, 'execute[extract-mq-package]', :immediately
    notifies :run, 'execute[createrepo-mq]', :immediately
    backup false
    action :create
  end

  execute 'extract-mq-package' do
    command "tar -xvf #{download_path}"
    cwd unpack_dir
    # Only run after notified by remote_file download
    action :nothing
  end

  execute 'createrepo-mq' do
    user 'root'
    cwd "#{unpack_dir}/MQServer"
    command 'createrepo .'
  end

  group 'mqm' do
    gid new_resource.gid
    action :create
  end

  user 'mqm' do
    uid new_resource.uid
    group 'mqm'
    home '/var/mqm'
    action :create
  end

  set_limit 'mqm' do
    type 'soft'
    item 'nofile'
    value 10_240
  end

  set_limit 'mqm' do
    type 'hard'
    item 'nofile'
    value 10_240
  end

  execute 'Accept the mqlicense' do
    user 'root'
    cwd "#{unpack_dir}/MQServer"
    command './mqlicense.sh -accept -text_only'
  end

  # Work around bug in 'yum' cookbook
  # See https://github.com/chef-cookbooks/yum/issues/144
  directory '/etc/yum.repos.d' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

  # Add a local yum repository
  yum_repository "ibm-mq-chef-#{name}" do
    description 'Packages for IBM MQ, used by Chef cookbook'
    baseurl "file://#{unpack_dir}/MQServer"
    gpgcheck false
    action :create
  end

  # Install MQ
  yum_package packages do
    action :install
  end

  # TODO: Unset as primary installation, if no longer primary
  execute 'setmqinst' do
    command '/opt/mqm/bin/setmqinst -n Installation1 -i'
    only_if { primary }
  end
end

action :remove do
  # Uninstall MQ
  yum_package packages do
    action :remove
  end

  # Remove our Yum repository
  yum_repository "ibm-mq-chef-#{name}" do
    action :remove
  end
end
