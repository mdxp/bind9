name             'bind9'
maintainer       'Ram Akuka'
maintainer_email 'ram@akuka.com'
license          'All rights reserved'
description      'Installs/Configures bind9'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

%w{ ubuntu debian centos redhat }.each do |os|
  supports os
end
