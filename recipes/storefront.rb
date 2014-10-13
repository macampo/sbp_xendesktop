#
# Cookbook Name:: sbp_xendesktop
# Recipe:: storefront
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

windows_zipfile node['xendesktop']['target_zip_path'] do
  source node['xendesktop']['source_zip']
  action :unzip
  not_if { ::File.directory?(node['xendesktop']['target_zip_path']) }
end

windows_package node['xendesktop']['XSF']['registry_name'] do
  source node['xendesktop']['XSF']['setup_file']
  options node['xendesktop']['XSF']['setup_options']
  timeout node = 1500
  installer_type :custom
  action :install
end

 directory node['xendesktop']['script_path']  do
  recursive true
  action :create
 end

 template "#{node['xendesktop']['script_path']}\\#{node['xendesktop']['XSF']['template']}" do
  source node['xendesktop']['XSF']['template']
  action :create
  variables(
    :recipe_file => (__FILE__).to_s.split("cookbooks/")[1],
    :template_file => source.to_s,
    :deliverycontrollers => node['xendesktop']['XDC']['deliverycontrollers'].map { |s| "\"#{s}\"" }.join(','),
    :cert_path => node['xendesktop']['script_path'],
    :sitename => node['xendesktop']['sitename'],
    :config => node['xendesktop']['XSF']
  )
end

cookbook_file "#{node['xendesktop']['script_path']}\\#{node['xendesktop']['XSF']['vipname']}.pfx" do
  source "#{node['xendesktop']['XSF']['vipname']}.pfx"
  cookbook node['xendesktop']['XSF']['wrapper_name']
  action :create
  only_if { run_context.has_cookbook_file_in_cookbook?(node['xendesktop']['XSF']['wrapper_name'], "#{node['xendesktop']['XSF']['vipname']}.pfx") }
end

cookbook_file "#{node['xendesktop']['script_path']}\\#{node['xendesktop']['XSF']['nsrootcert']}" do
  source node['xendesktop']['XSF']['nsrootcert']
  cookbook node['xendesktop']['XSF']['wrapper_name']
  action :create
  only_if { run_context.has_cookbook_file_in_cookbook?(node['xendesktop']['XSF']['wrapper_name'], node['xendesktop']['XSF']['nsrootcert']) }
end

powershell_script 'Add/Configure Citrix Storefront Server' do
  code <<-EOH
    write-host 'Add/Configure Citrix StoreFront Server'
    Invoke-Command -script { #{node['xendesktop']['script_path']}\\#{node['xendesktop']['XSF']['template']} }
  EOH
end
