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

include_recipe 'sysctl::default'

# This is done in the test cookbook (for now), so that we don't overwrite
# kernel settings without it being obvious what's happening
sysctl_param 'kernel.shmmni' do
  value 4096
end
sysctl_param 'kernel.shmmax' do
  value 268_435_456
end
sysctl_param 'kernel.shmall' do
  value 2_097_152
end
sysctl_param 'kernel.sem' do
  value '32 4096 32 128'
end
sysctl_param 'kernel.threads-max' do
  value 1000
end
sysctl_param 'kernel.pid_max' do
  value 12_000
end
sysctl_param 'fs.file-max' do
  value 524_288
end

include_recipe 'ibm_mq_test::install_mq'
