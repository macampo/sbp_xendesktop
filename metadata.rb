name             'sbp_xendesktop'
maintainer       'Schuberg Philis'
maintainer_email 'int-euc@schubergphilis.com'
license          'All rights reserved'
description      'Installs/Configures Citrix Xendesktop components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.0'

supports 	 'windows', ">= 6.1"

depends		 'windows'
depends 	 'euc_xendesktop_wrapper'
