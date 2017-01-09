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

property :user, kind_of: String, default: 'mqm'

default_action :start

action :create do
  execute 'crtmqm' do
    command "crtmqm #{new_resource.name}"
    user new_resource.user
    group 'mqm'
    creates '/var/mqm/qmgrs/qm1/'
    not_if "dspmq | grep -o #{new_resource.name}"
  end
end

action :start do
  execute 'strmqm' do
    command "strmqm #{new_resource.name}"
    user new_resource.user
    group 'mqm'
    not_if "dspmq -m #{new_resource.name} -n | grep RUNNING"
  end
end
