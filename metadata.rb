# frozen_string_literal: true

name            'confluent'
maintainer       'Bryan Baugher'
maintainer_email 'Bryan.Baugher@Cerner.com'
license          'All rights reserved'
description      'Installs/Configures confluent'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

supports 'ubuntu'
supports 'centos'

depends 'java'

version '1.2.0'
