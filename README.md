sbp_xendesktop Cookbook
=======================

This cookbook can be used to install and configure the following Citrix components:

- Xendesktop Delivery Controller
- Xendesktop Storefront Server
- Xendesktop License Manager
- Xendesktop Xenapp Server

For both the Delivery Controller and the Storefront Server components there is an Install and a Configure recipe.

The Configure recipe for the Delivery Controller(s):

- will create the databases for the Xendesktop environment
- will create a Xendesktop / Xenapp site
- will add admin groups
- will connect Studio to the correct license server
- will connect to a Cloudstack where the Xenapp / Xenddesktop VMs will be hosted
- will add 2nd, 3rd, etc delivery controller to the site

The Configure recipe for the Storefront server(s)

- will create a Storefront store
- will install certificates and bind them to the default site
- will install the root certificate of the certificate that is bound to the remote access URL. This certificate is linked to the Virtual Server configured on the Netscaler.
- will add 2nd, 3rd, etc Storefront server
- will NOT add them to a Storefront server group (manual task)


Requirements
------------

- A Cloudstack / CloudPlatform environment. The recipes have been tested with Cloudstack 4.3
- A Storefront Certificate
- Root certificate of the certificate that is bound to the remote access URL.
- A Citrix Administrators domain group
- A SQL database server
- Xendesktop 7.x software stored in a zip in the software repository

The cookbook has been tested with Xendesktop 7.5 icw Windows 2012, SQL 2012 and Cloudstack 4.3. It will very likely work for any Xendesktop 7.x version, SQL 2008 and Windows 2008 R2.

Attributes
----------
Because we also configure the Citrix componenents there a are many specific variables. Only a few are really default. So this cookbook is generally used with a customer specific role cookbook in
which the many specific variables are set. This is the list of variables used and there purpose:

# generic variables, used by all or many recipes

default['xendesktop']['default_log_path'] => a directory where the logs are stored, e.g "C:\\LogFiles"
default['xendesktop']['script_path'] => a directory where the certificates and the powershell scripts used to configure the environment are stored, e.g. "C:\\Scripts\\XenDesktop"
default['xendesktop']['source_zip'] => the place where the Xendesktop binaries can be found in the software repository, e.g. "http://artifacts.webserver.com/artifacts/xendesktop/xendesktop75.zip"
default['xendesktop']['target_zip_path'] => the place where the Xendesktop binaries will be copied to, e.g. "C:\\temp\\Xendesktop"
default['xendesktop']['sitename'] => name of the Xendesktop site, e.g. "CompanyName-XD-Site"

# XenDesktop DeliveryController installation variables
default['xendesktop']['XDC']['windows_features'] => List of Windows Features to install, e.g. for Windows 2012:
[ "Microsoft-Windows-GroupPolicy-ServerAdminTools-Update", "Remote-Desktop-Services", "Licensing", "MicrosoftWindowsPowerShellISE" ]
or for Windows 2008 R2:
[ "NET-Framework-Core", "GPMC", "RDS-RD-Server", "RDS-Licensing", "PowerShell-ISE" ]


default['xendesktop']['XDC']['registry_name'] => The name to check in the registry to check for indempotence, e.g. "Citrix Broker Service"
default['xendesktop']['XDC']['setup_file'] => path to the Xendesktop setup file, e.g. "C:\\Temp\\Xendesktop\\x64\\XenDesktop Setup\\XenDesktopServerSetup.exe"
default['xendesktop']['XDC']['setup_options'] => the setup parameters used to install the Delivery Controller, e.g."/COMPONENTS CONTROLLER,DESKTOPSTUDIO,DESKTOPDIRECTOR /NOREBOOT /CONFIGURE_FIREWALL /PASSIVE /QUIET /NOSQL /LOGPATH C:\\Logfiles\\Xendesktop"

# XenDesktop DeliveryController configuration variables
default['xendesktop']['XDC']['deliverycontrollers'] => an array of FQDNs of servers that will become a Xendesktop Delivery Controller, e.g.[ "servername.domain.local" ]
default['xendesktop']['XDC']['databaseserver'] => the FQDN of the database server, e.g. "servername.domain.local"
default['xendesktop']['XDC']['fulladmingroups'] => an array of Active Directory groups that will get Full Control in Citrix Studio, e.g. [ "Administrators", "DOMAIN\\Domain Admins" ]
default['xendesktop']['XDC']['domain_admin'] => an account that has permissions to create the database, e.g. "DOMAIN\\svc_install"
default['xendesktop']['XDC']['domain_admin_password'] => password variable (recommended to use encrypted databags), e.g. "password"
default['xendesktop']['XDC']['databasename_site'] => name for the Xendesktop database, e.g. "XD-Database"
default['xendesktop']['XDC']['databasename_logging'] => name for the Xendesktop database, e.g. "XD-Logging"
default['xendesktop']['XDC']['databasename_monitor'] => name for the Xendesktop database, e.g. "XD-Monitor"
default['xendesktop']['XDC']['cdc_logging_folder'] => path where IIS will write the logs, e.g. "C:\\Windows\\Temp\\www"
default['xendesktop']['XDC']['template'] => name of the template that is used to configure the Delivery Controller(s), e.g. "deliverycontroller_cloud_config.ps1"
default['xendesktop']['XDC']['cloud_api'] => the API key used to communicate with CloudStack / Cloudplatform, e.g. "lotsofcharacters"
default['xendesktop']['XDC']['secret_api'] => the secret key used to communicate with Cloudstack / Cloudplatform (recommended to use encrypted databags), e.g. "lotsofcharacters"
default['xendesktop']['XDC']['connection_name'] => name for the connection, e.g. "Cloud"
default['xendesktop']['XDC']['connection_type'] => type of connection, e.g. "CloudPlatform"
default['xendesktop']['XDC']['hypervisoraddress'] => URL to connect to Cloudstack / Cloudplatform, e.g. "https://cloudstack.domain.local/client/api"
default['xendesktop']['XDC']['path'] => path used by the Delivery Controller to talk to Cloudstack / Cloudplatform, e.g. "XDHyp:\\Connections\\Cloud"
default['xendesktop']['XDC']['rootpath'] => Virtual Private Cloud path used by the Delivery Controller to talk to Cloudstack / Cloudplatform, e.g. "XDHyp:\\Connections\\Cloud\\VPC.virtualprivatecloud"
default['xendesktop']['XDC']['availabilityzonepath'] => Availability Zone Path used by the Delivery Controller to talk to Cloudstack / Cloudplatform, e.g. "XDHyp:\\Connections\\Cloud\\VPC.virtualprivatecloud\\AZ.availabilityzone"
default['xendesktop']['XDC']['networkpath'] => name of the network used by the Delivery Controller to provision the VDIs / Xenapp servers in within Cloudstack / Cloudplatform, e.g. "XDHyp:\\Connections\\Cloud\\VPC.virtualprivatecloud\\AZ.availabilityzone\\NETWORK_NAME(10.1.1.0``/24).network"
default['xendesktop']['XDC']['resourcename'] => name used by the Delivery Controller for the resources in Cloudstack / CloudPlatform, e.g. "XDHyp:\\HostingUnits\\BetaCloudResources"

# XenDesktop License Server configuration variables
default['xendesktop']['XDC']['licenseserver_port'] => port on which the license server daemon listens, e.g. "27000"
default['xendesktop']['XDC']['licenseserver_licensingmodel'] => name of the licensing model, e.g. "UserDevice" or "Concurrent"
default['xendesktop']['XDC']['licenseserver_productcode'] => type of license, e.g. "XDT" for Xendesktop or "MPS" for Xenapp
default['xendesktop']['XDC']['licenseserver_productedition'] => edition of license, e.g. "PLT" for Platinum, "ENT" for Enterprise, "STD" for Standard
default['xendesktop']['XDC']['licenseserver_productversion'] => version of the product, e.g. "7.5"
default['xendesktop']['XDC']['licenseserver_addresstype'] => type of address, e.g. "WSL" which stands for Web Services for Licensing
default['xendesktop']['XDC']['licenseserver'] => FQDN of the license server, e.g. "servername.domain.local"

# Xendesktop License Server installation variables
default['xendesktop']['XLC']['windows_features'] => list of Windows Features to install, e.g. for Windows 2008 [ "NET-Framework-Core", "PowerShell-ISE" ]
default['xendesktop']['XLC']['setup_file'] => path to the Xendesktop setup file, e.g. "C:\\Temp\\Xendesktop\\x64\\XenDesktop Setup\\XenDesktopServerSetup.exe"
default['xendesktop']['XLC']['setup_options'] => the setup parameters used to install the license server, e.g."/COMPONENTS LICENSESERVER,DESKTOPSTUDIO /NOREBOOT /PASSIVE /QUIET"
default['xendesktop']['XLC']['registry_name'] => The name to check in the registry to check for indempotence, e.g. "Citrix Licensing"

# XenDesktop IE 10 installation variables
default['xendesktop']['IE10']['target_zip_path'] => the place where the Internet Explorer 10 binaries will be copied to, e.g. "C:\\Windows\\temp\\IE10"
default['xendesktop']['IE10']['source_zip'] => the place where the IE 10 setup binaries can be found in the software repository, e.g. "http://artifacts.webserver.local/artifacts/xendesktop/ie10_upgrade.zip"
default['xendesktop']['IE10']['setup_file'] => name of the setup file, e.g. "C:\\Windows\\temp\\IE10\\IE10-Windows6.1-x64-en-us.exe"
default['xendesktop']['IE10']['setup_options'] => the setup parameters, e.g. "/PASSIVE /QUIET /NORESTART"

# Xendesktop DesktopServer installation variables
default['xendesktop']['XCX']['registry_name'] => The name to check in the registry to check for indempotence, e.g. "Citrix Virtual Desktop Agent - x64"

# XenDesktop Storefront configuration variables
default['xendesktop']['XSF']['wrapper_name'] => the name of the wrapper used to insert certficates, e.g. "customername_xendesktop_wrapper"
default['xendesktop']['XSF']['servers'] => an array of FQDNs of servers that will become a Xendesktop Storefront server, e.g. [ "servername.domain.local" ]
default['xendesktop']['XSF']['vipname'] => the name of the load balanced VIP for the Storefront servers, e.g. "storefront-vip.domain.local"
default['xendesktop']['XSF']['certpassword'] => the password linked to the certficate that is used for the VIP (recommended to use encrypted databags), e.g. "password"
default['xendesktop']['XSF']['nsrootcertname'] => the name of the root certificate that is in the chain of the certificate used to encrypt the traffic from the internet to the Virtual Server of the Netscaler. The Storefront performs a callback to that address and that must be executed without certificate warnings, e.g. "DigiCert SHA2 High Assurance Server CA"
default['xendesktop']['XSF']['nsrootcert'] => name of the root certificate, e.g. "DigiCertCA.crt"
default['xendesktop']['XSF']['nsrootcertstore'] => name of the Certificate store in which the root certificate for the Netscaler will be placed, e.g. "CA"
default['xendesktop']['XSF']['csf_logging_folder'] => path where IIS will write the logs, e.g. "C:\\Windows\\Temp\\www"
default['xendesktop']['XSF']['listnerport'] => the port on which the Storefront listens, e.g. "443" or "80"
default['xendesktop']['XSF']['xmlport'] => the port on which the Storefront servers listens for XML traffic to and from the Delivery Controllers, e.g. "80"
default['xendesktop']['XSF']['transporttype'] => the protocol that the Storefront uses to communicate, e.g. "https" or "http"
default['xendesktop']['XSF']['xmltransporttype'] => the protocol that the Storefront uses to communicate for XML trafficl, e.g. "https" or "http"
default['xendesktop']['XSF']['relayport'] => the port on which the Storefront listens for SSL Relay traffic, e.g. "443" or "80"
default['xendesktop']['XSF']['farmtype'] => the type of farm, e.g. "XenDesktop" or "Xenapp"
default['xendesktop']['XSF']['template']  => name of the template that is used to configure the Storefront Server(s), e.g. "xendesktop__config.ps1"

# XenDesktop Storefront installation variables
default['appp']['xendesktop']['XSF']['windows_features'] => list of Windows Features to install, e.g. for Windows 2008 [ "NET-Framework-Core", "PowerShell-ISE" ]
default['xendesktop']['XSF']['registry_name'] => The name to check in the registry to check for indempotence, e.g. "Citrix StoreFront"
default['xendesktop']['XSF']['setup_file']  => path to the Xendesktop setup file, e.g. "C:\\Temp\\Xendesktop\\x64\\XenDesktop Setup\\XenDesktopServerSetup.exe"
default['xendesktop']['XSF']['setup_options'] => the setup parameters, e.g. "/COMPONENTS STOREFRONT,DESKTOPSTUDIO /NOREBOOT /CONFIGURE_FIREWALL /PASSIVE /QUIET /LOGPATH C:\\Windows\\Temp\\Xendesktop"



Usage
-----

Make sure the certificates used are placed in the role cookbook/files/default

Just include `CUSTOMER_xendesktop_role::desktopserver` or `CUSTOMER_xendesktop_role::storefront` in your node's `run_list`:

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
