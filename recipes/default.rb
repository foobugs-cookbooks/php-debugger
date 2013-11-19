#
# Cookbook Name:: php_debugger
# Recipe:: default
#
# Copyright 2013, foobugs Oelke & Eichner GbR
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
#

# Include php recipe
include_recipe "php"

# Set PHP extension directory from php-config
node.default[:php_debugger][:extension_dir] = `php-config --extension-dir`.gsub /\n$/, ""

# Include debugger recipe
include_recipe "php_debugger::#{node.default[:php_debugger][:name]}"

# CLI alias for php-debug
template "/etc/profile.d/php-aliases.sh" do
  source "etc/profile.d/php-aliases.sh.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
  )
end
