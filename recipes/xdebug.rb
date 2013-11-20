#
# Cookbook Name:: php_debugger
# Recipe:: xdebug
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

case node[:php_debugger][:xdebug][:install_method]
when "package"
  package "php5-xdebug" do
    action :install
  end
when "pecl"
  include_recipe "build-essential"

  php_pear "xdebug" do
    action :install
  end
end

# Configuration for xdebug
local_ip = node[:network][:interfaces][:eth1][:addresses].detect{|k,v| v[:family] == "inet" }.first
remote_ip = local_ip.gsub /\.\d+$/, ".1"
default_conf = {
  "xdebug.default_enable" => 1,
  "xdebug.remote_enable" => 1,
  "xdebug.remote_autostart" => 0,
  "xdebug.remote_port" => 9000,
  "xdebug.remote_handler" => "dbgp",
  "xdebug.remote_host" => "#{remote_ip}"
}
template "#{node[:php][:ext_conf_dir]}/xdebug.ini" do
  source "etc/php5/conf.d/xdebug.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :conf => default_conf.merge(node[:php_debugger][:xdebug][:conf])
  )
end
link "/etc/php5/conf.d/20-xdebug.ini" do
  link_type :symbolic
  to "#{node[:php][:ext_conf_dir]}/xdebug.ini"
  action :create
  not_if {node[:php][:ext_conf_dir].include? "/etc/php5/conf.d"}
end
