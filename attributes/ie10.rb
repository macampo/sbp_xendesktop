#
# Cookbook Name:: sbp_xendesktop
# Attribute:: ie10
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

# XenDesktop IE 10 installation variables
default['xendesktop']['IE10']['target_zip_path'] = 'C:\\Windows\\Temp\\ie10_upgrade'
default['xendesktop']['IE10']['source_zip']			 = ''
default['xendesktop']['IE10']['setup_file']			 = "#{node['xendesktop']['IE10']['target_zip_path']}\\IE10-Windows6.1-x64-en-us.exe"
default['xendesktop']['IE10']['setup_options']	 = '/PASSIVE /QUIET /NORESTART'
