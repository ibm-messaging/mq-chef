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

ibm_mq_installation 'default' do
  source node['ibm_mq_test']['source']
  accept_license node['ibm_mq_test']['accept_license']
  primary true
  uid node['ibm_mq_test']['uid']
  gid node['ibm_mq_test']['gid']
  action :create
end

qmgr = node['ibm_mq_test']['queue_manager']['name']

ibm_mq_queue_manager qmgr do
  # mqsc IO.read('password-security.erb')
  action [:create, :start]
end

execute 'runmqsc' do
  command "echo 'define qlocal(foo) replace' | runmqsc #{qmgr}"
  user 'mqm'
  group 'mqm'
end
