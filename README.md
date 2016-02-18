IBM MQ cookbook
===============

The IBM MQ cookbook is a library cookbook that provides custom resources for use in your own recipes.  This cookbook is currently experimental, therefore we recommend that if you want to use this cookbook, that you either pin the version you use, or create your own fork first.

Requirements
------------
- Chef 12.6+
- Network accessible web server hosting the MQ installer package

Platform Support
----------------
The following platforms have been tested with Test Kitchen:

- Ubuntu 14.04

Cookbook Dependencies
---------------------
- [limits](https://supermarket.chef.io/cookbooks/limits)
- [yum](https://supermarket.chef.io/cookbooks/yum)

Usage
-----
1. Add ```depends 'ibm_mq'``` to your cookbook's metadata.rb
2. Use the resources shipped in cookbook in a recipe, the same way you'd
  use core Chef resources (file, template, directory, package, etc).

```ruby
ibm_mq_installation 'Installation1' do
  source 'http://10.0.2.15:8000/WS_MQ_V8.0.0.4_LINUX_ON_X86_64_IM.tar.gz'
  accept_license true
  primary true
end

ibm_mq_queue_manager 'qm1' do
  action [:create, :start]
end
```

Resources
---------

## ibm_mq_installation
The `ibm_mq_installation` resource downloads an IBM MQ download package file,
specified by a URI.

#### Example
```ruby
ibm_mq_installation 'Installation1' do
  source 'http://10.0.2.15:8000/WS_MQ_V8.0.0.4_LINUX_ON_X86_64_IM.tar.gz'
  accept_license true
  primary true
  action :create
end
```

#### Properties
- `source` - Path to network accessible IBM MQ installation package.
- `accept_license` - Set this to `true` if you accept the terms of the IBM MQ license.
- `primary` - Set this to `true` to make this the primary MQ installation.  Currently not supported to set this to `false`.
- `packages` - An array of package names to install.  Defaults to:
  `%w(MQSeriesServer MQSeriesGSKit)`
- `uid` - The UID to use for the `mqm` user
- `gid` - The GID to use for the `mqm` user

## ibm_mq_queue_manager
The `ibm_mq_queue_manager` resource creates and starts IBM MQ queue managers.

#### Example
```ruby
ibm_mq_queue_manager 'qm1' do
  action [:create, :start]
end
```

#### Properties
- `user` - User to run MQ commands as.  Defaults to `mqm`


## Maintainers

* Arthur Barr (<arthur.barr@uk.ibm.com>)

## Developing
If you do submit a Pull Request related to this cookbook, please indicate in the Pull Request that you accept and agree to be bound by the terms of the [IBM Contributor License Agreement](CLA.md).

In order to run the Test-Kitchen tests, you need to set an environment variable for the MQ download.  For example, on Linux, you might do the following:

```shell
export MQ_URI=http://10.0.2.15:8000/WS_MQ_V8.0.0.4_LINUX_ON_X86_64_IM.tar.gz
```

## License
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
