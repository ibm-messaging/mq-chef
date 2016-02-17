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

describe file('/opt/mqm') do
  it { should be_owned_by 'mqm' }
end

describe file('/var/mqm') do
  it { should be_owned_by 'mqm' }
end

describe command('crtmqm').exist? do
  it { should eq true }
end

# Can't use "describe package" on Ubuntu
describe command('rpm -q MQSeriesServer') do
  its('exit_status') { should eq 0 }
end

describe command('rpm -q MQSeriesGSKit') do
  its('exit_status') { should eq 0 }
end

# Not specified by recipe, but should still be installed
describe command('rpm -q MQSeriesRuntime') do
  its('exit_status') { should eq 0 }
end

describe command('dspmq -n') do
  its(:stdout) { should match %r{RUNNING} }
end
