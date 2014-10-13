#
# Cookbook Name:: sbp_xendesktop
# Attribute:: deliverycontroller
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

# XenDesktop DeliveryController installation variables
if Gem::Version.new(node['os_version']) >= Gem::Version.new('6.2.0')
  default['xendesktop']['XDC']['windows_features'] = [ 'Microsoft-Windows-GroupPolicy-ServerAdminTools-Update', 'Remote-Desktop-Services', 'Licensing', 'MicrosoftWindowsPowerShellISE' ]
end

if Gem::Version.new(node['os_version']) >= Gem::Version.new('6.1.0') && Gem::Version.new(node['os_version']) < Gem::Version.new('6.2.0')
  default['xendesktop']['XDC']['windows_features'] = [ 'NET-Framework-Core', 'GPMC', 'RDS-RD-Server', 'RDS-Licensing', 'PowerShell-ISE' ]
end

default['xendesktop']['XDC']['registry_name'] = 'Citrix Broker Service'
default['xendesktop']['XDC']['setup_file']    = "#{node['xendesktop']['target_zip_path']}\\x64\\XenDesktop Setup\\XenDesktopServerSetup.exe"
default['xendesktop']['XDC']['setup_options'] = "/COMPONENTS CONTROLLER,DESKTOPSTUDIO,DESKTOPDIRECTOR /NOREBOOT /CONFIGURE_FIREWALL /PASSIVE /QUIET /NOSQL /LOGPATH #{node['xendesktop']['default_log_path']}\\Xendesktop"


# XenDesktop DeliveryController configuration variables
default['xendesktop']['XDC']['deliverycontrollers'] 	       = [ '' ]
default['xendesktop']['XDC']['databaseserver'] 		           = ''
default['xendesktop']['XDC']['fulladmingroups']		           = [ 'Administrators', 'Domain Admins' ]
default['xendesktop']['XDC']['domain_admin']			           = ''
default['xendesktop']['XDC']['domain_admin_password']	       = ''
default['xendesktop']['XDC']['databasename_site'] 		       = ''
default['xendesktop']['XDC']['databasename_logging'] 	       = ''
default['xendesktop']['XDC']['databasename_monitor'] 	       = ''
default['xendesktop']['XDC']['cdc_logging_folder']		       = ''
default['xendesktop']['XDC']['template']				             = 'deliverycontroller_cloud_config.ps1'
default['xendesktop']['XDC']['cloud_api']		                 = ''
default['xendesktop']['XDC']['secret_api']                   = ''
default['xendesktop']['XDC']['connection_name']		           = ''
default['xendesktop']['XDC']['connection_type']              = 'CloudPlatform'
default['xendesktop']['XDC']['hypervisoraddress']            = ''
default['xendesktop']['XDC']['path']                         = "XDHyp:\\Connections\\#{node['xendesktop']['XDC']['connection_name']}"
default['xendesktop']['XDC']['rootpath']			               = ''
default['xendesktop']['XDC']['availabilityzonepath']	       = ''
default['xendesktop']['XDC']['networkpath']		               = ''
default['xendesktop']['XDC']['resourcename']		             = ''
default['xendesktop']['XDC']['licenseserver_port']           = '27000'
default['xendesktop']['XDC']['licenseserver_licensingmodel'] = ''
default['xendesktop']['XDC']['licenseserver_productcode']    = ''
default['xendesktop']['XDC']['licenseserver_productedition'] = ''
default['xendesktop']['XDC']['licenseserver_productversion'] = ''
default['xendesktop']['XDC']['licenseserver_addresstype']    = ''
default['xendesktop']['XDC']['licensetype']                  = ''
default['xendesktop']['XDC']['licenseserver']                = ''
