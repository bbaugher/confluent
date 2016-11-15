# rubocop:disable SingleSpaceBeforeFirstArg
name            'confluent'
maintainer       'Bryan Baugher'
maintainer_email 'Bryan.Baugher@Cerner.com'
license          'All rights reserved'
description      'Installs/Configures confluent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
# rubocop:enable SingleSpaceBeforeFirstArg

supports 'ubuntu'
supports 'centos'

depends 'java'

version '1.1.0'
