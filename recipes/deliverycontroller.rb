#
# Cookbook Name:: sbp_xendesktop
# Recipe:: deliverycontroller
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

# install required windows features
node['xendesktop']['XDC']['windows_features'].each do |feature|
  windows_feature feature
end

windows_zipfile node['xendesktop']['target_zip_path'] do
  source node['xendesktop']['source_zip']
  action :unzip
  not_if { ::File.directory?(node['xendesktop']['target_zip_path']) }
end

windows_package node['xendesktop']['XDC']['registry_name'] do
  source node['xendesktop']['XDC']['setup_file']
  options node['xendesktop']['XDC']['setup_options']
  timeout node = 1500
  installer_type :custom
  action :install
end

directory node['xendesktop']['script_path'] do
  recursive true
  action :create
end

template "#{node['xendesktop']['script_path']}\\#{node['xendesktop']['XDC']['template']}" do
  source node['xendesktop']['XDC']['template']
  action :create
  variables(
    :recipe_file => (__FILE__).to_s.split("cookbooks/")[1],
    :template_file => source.to_s,
    :sitename => node['xendesktop']['sitename'],
    :config => node['xendesktop']['XDC']
  )
end

powershell_script "Execute powerhell" do
  code <<-EOH
    write-host "[INFO] Add/Configure Citrix Delivery Controller Database and Site for CloudStack"
    Invoke-Command -script {#{node['xendesktop']['script_path']}\\#{node['xendesktop']['XDC']['template']} -DatabaseUsr #{node['xendesktop']['XDC']['domain_admin']} -DatabasePasswd #{node['xendesktop']['XDC']['domain_admin_password']} }
  EOH
end
