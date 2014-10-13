#
# Cookbook Name:: sbp_xendesktop
# Attribute:: desktopserver
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

# XenDesktop Desktop Server installation variables
default['xendesktop']['XCX']['registry_name'] = 'Citrix Virtual Desktop Agent - x64'
default['xendesktop']['XCX']['setup_file']		= "#{node['xendesktop']['target_zip_path']}\\x64\\XenDesktop Setup\\XenDesktopVdaSetup.exe"

