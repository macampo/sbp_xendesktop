#
# Cookbook Name:: sbp_xendesktop
# Recipe:: desktopserver
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

deliverycontrollers = node['xendesktop']['XDC']['deliverycontrollers'].map { |s| "\"#{s}\"" }.join(',')

windows_zipfile node['xendesktop']['target_zip_path'] do
  source node['xendesktop']['source_zip']
  action :unzip
  not_if { ::File.directory?(node['xendesktop']['target_zip_path']) }
end

windows_package node['xendesktop']['XCX']['registry_name'] do
  source node['xendesktop']['XCX']['setup_file']
  options "/quiet /LOGPATH #{node['xendesktop']['default_log_path']}\\Xendesktop /controllers #{deliverycontrollers} /enable_remote_assistance /optimize /masterimage /nodesktopexperience"
  installer_type :custom
  action :install
end

