#
# Cookbook Name:: sbp_xendesktop
# Attribute:: storefront
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

# XenDesktop Storefront installation variables
if Gem::Version.new(node['os_version']) >= Gem::Version.new('6.2.0')
  default['xendesktop']['XSF']['windows_features'] = [ 'Microsoft-Windows-GroupPolicy-ServerAdminTools-Update', 'MicrosoftWindowsPowerShellISE' ]
end

if Gem::Version.new(node['os_version']) >= Gem::Version.new('6.1.0') && Gem::Version.new(node['os_version']) < Gem::Version.new('6.2.0')
  default['xendesktop']['XSF']['windows_features'] = [ 'NET-Framework-Core', 'GPMC', 'PowerShell-ISE' ]
end

default['xendesktop']['XSF']['registry_name'] = 'Citrix StoreFront'
default['xendesktop']['XSF']['setup_file']    = "#{node['xendesktop']['target_zip_path']}\\x64\\XenDesktop Setup\\XenDesktopServerSetup.exe"
default['xendesktop']['XSF']['setup_options'] = "/COMPONENTS STOREFRONT,DESKTOPSTUDIO /NOREBOOT /CONFIGURE_FIREWALL /PASSIVE /QUIET /LOGPATH #{node['xendesktop']['default_log_path']}\\Xendesktop"


# XenDesktop Storefront configuration variables

default['xendesktop']['XSF']['wrapper_name']		= ''
default['xendesktop']['XSF']['servers'] 			     = [ '' ]
default['xendesktop']['XSF']['vipname']	    	     = ''
default['xendesktop']['XSF']['cert_password']      = ''
default['xendesktop']['XSF']['cert_self_signed'] 	 = false
default['xendesktop']['XSF']['nsrootcertname']		 = ''
default['xendesktop']['XSF']['nsrootcert']         = ''
default['xendesktop']['XSF']['nsrootcertstore']    = 'CA'
default['xendesktop']['XSF']['csf_logging_folder'] = ''
default['xendesktop']['XSF']['listnerport']   	   = '443'
default['xendesktop']['XSF']['xmlport'] 	         = '80'
default['xendesktop']['XSF']['transporttype']      = 'https'
default['xendesktop']['XSF']['xmltransporttype']   = 'http'
default['xendesktop']['XSF']['relayport']   		   = '443'
default['xendesktop']['XSF']['farmtype']   			 	 = 'XenDesktop'
default['xendesktop']['XSF']['template']					 = 'storefront_config.ps1'
