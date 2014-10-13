#
# Cookbook Name:: sbp_xendesktop
# Recipe:: ie10
#
# Copyright 2014, Schuberg Philis
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

windows_reboot 60 do
  reason 'CHEF: reboot needed after IE 10 install'
  action :nothing
end

windows_zipfile node['xendesktop']['IE10']['target_zip_path'] do
  source node['xendesktop']['IE10']['source_zip']
  action :nothing
  not_if { ::File.directory?(node['xendesktop']['IE10']['target_zip_path']) }
end

batch 'install_ie10_prerequisite_patch' do
  code <<-EOH
  wusa #[node['xendesktop']['IE10']['target_zip_path']\\Windows6.1-KB2670838-x64.msu /quiet /passive /norestart
  exit 0
  EOH
  not_if { `wmic qfe get | findstr KB2670838` =~ /KB2670838/ }
  notifies :request, 'windows_reboot[60]'
end

windows_package "Internet Explorer 10" do
  source  node['xendesktop']['IE10']['setup_file']
  options node['xendesktop']['IE10']['setup_options']
  timeout node = 1500
  installer_type :custom
  action :install
  not_if { Registry.get_value('HKLM\\Software\\microsoft\\internet explorer','svcversion').to_i >= 10 }
  notifies :request, 'windows_reboot[60]'
end
