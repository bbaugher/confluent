# frozen_string_literal: true

default['confluent']['version'] = '2.0.1'
default['confluent']['scala_version'] = '2.11.7'

version_numbers = node['confluent']['version'].split('.')
archive_version = "#{version_numbers[0]}.#{version_numbers[1]}"

default['confluent']['artifact_url'] = File.join('http://packages.confluent.io/archive', archive_version, "confluent-#{node['confluent']['version']}-#{node['confluent']['scala_version']}.zip")
default['confluent']['install_dir'] = '/opt/confluent'
default['confluent']['user'] = 'confluent'
default['confluent']['group'] = 'confluent'

default['confluent']['pid_dir'] = '/opt/confluent/pid/'

default['confluent']['backup_templates'] = false

default['confluent']['kafka']['server.properties'] = {}
default['confluent']['kafka']['zookeepers'] = nil
default['confluent']['kafka']['zookeeper_chroot'] = nil
default['confluent']['kafka']['brokers'] = nil
default['confluent']['kafka']['env_vars'] = {}
default['confluent']['kafka']['class'] = 'kafka.Kafka'

default['confluent']['kafka']['log4j.properties']['log4j.rootLogger'] = 'CONSOLE,ROLLINGFILE'
default['confluent']['kafka']['log4j.properties']['log4j.appender.CONSOLE'] = 'org.apache.log4j.ConsoleAppender'
default['confluent']['kafka']['log4j.properties']['log4j.appender.CONSOLE.Threshold'] = 'INFO'
default['confluent']['kafka']['log4j.properties']['log4j.appender.CONSOLE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['kafka']['log4j.properties']['log4j.appender.CONSOLE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE'] = 'org.apache.log4j.RollingFileAppender'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE.Threshold'] = 'INFO'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE.File'] = '/var/log/confluent/kafka.log'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxFileSize'] = '10MB'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxBackupIndex'] = '10'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['kafka']['log4j.properties']['log4j.appender.ROLLINGFILE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'

default['confluent']['kafka-rest']['kafka-rest.properties'] = {}
default['confluent']['kafka-rest']['env_vars'] = {}
default['confluent']['kafka-rest']['class'] = 'kafkarest.KafkaRestMain'

default['confluent']['kafka-rest']['log4j.properties']['log4j.rootLogger'] = 'CONSOLE,ROLLINGFILE'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.CONSOLE'] = 'org.apache.log4j.ConsoleAppender'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.CONSOLE.Threshold'] = 'INFO'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.CONSOLE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.CONSOLE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE'] = 'org.apache.log4j.RollingFileAppender'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE.Threshold'] = 'INFO'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE.File'] = '/var/log/confluent/kafka-rest.log'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxFileSize'] = '10MB'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxBackupIndex'] = '10'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['kafka-rest']['log4j.properties']['log4j.appender.ROLLINGFILE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'

default['confluent']['schema-registry']['schema-registry.properties']['kafkastore.connection.url'] = 'localhost:2181'
default['confluent']['schema-registry']['env_vars'] = {}
default['confluent']['schema-registry']['class'] = 'io.confluent.kafka.schemaregistry.rest.SchemaRegistryMain'

default['confluent']['schema-registry']['log4j.properties']['log4j.rootLogger'] = 'CONSOLE,ROLLINGFILE'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.CONSOLE'] = 'org.apache.log4j.ConsoleAppender'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.CONSOLE.Threshold'] = 'INFO'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.CONSOLE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.CONSOLE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE'] = 'org.apache.log4j.RollingFileAppender'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE.Threshold'] = 'INFO'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE.File'] = '/var/log/confluent/schema-registry.log'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxFileSize'] = '10MB'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxBackupIndex'] = '10'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['schema-registry']['log4j.properties']['log4j.appender.ROLLINGFILE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'

default['confluent']['kafka-connect']['jar_urls'] = []
# Expects a hash where they keys are the file name and the values are hashes representing the property_name:value pairs
default['confluent']['kafka-connect']['properties_files'] = {}

default['confluent']['kafka-connect']['distributed_mode'] = true
default['confluent']['kafka-connect']['worker_properties_file_name'] = 'worker.properties'
default['confluent']['kafka-connect']['worker.properties']['bootstrap.servers'] = 'localhost:9092'
default['confluent']['kafka-connect']['worker.properties']['key.converter'] = 'io.confluent.connect.avro.AvroConverter'
default['confluent']['kafka-connect']['worker.properties']['key.converter.schema.registry.url'] = 'http://localhost:8081'
default['confluent']['kafka-connect']['worker.properties']['value.converter'] = 'io.confluent.connect.avro.AvroConverter'
default['confluent']['kafka-connect']['worker.properties']['value.converter.schema.registry.url'] = 'http://localhost:8081'
default['confluent']['kafka-connect']['worker.properties']['internal.key.converter'] = 'org.apache.kafka.connect.json.JsonConverter'
default['confluent']['kafka-connect']['worker.properties']['internal.value.converter'] = 'org.apache.kafka.connect.json.JsonConverter'
default['confluent']['kafka-connect']['worker.properties']['internal.key.converter.schemas.enable'] = 'false'
default['confluent']['kafka-connect']['worker.properties']['internal.value.converter.schemas.enable'] = 'false'
default['confluent']['kafka-connect']['worker.properties']['offset.storage.file.filename'] = '/tmp/connect.offsets'

# Distributed properties only. connect-standalone works with these as well, it just appears to ignore them
default['confluent']['kafka-connect']['worker.properties']['group.id'] = 'connect-cluster'
default['confluent']['kafka-connect']['worker.properties']['config.storage.topic'] = 'connect-configs'
default['confluent']['kafka-connect']['worker.properties']['offset.storage.topic'] = 'connect-offsets'

default['confluent']['kafka-connect']['env_vars'] = {}
default['confluent']['kafka-connect']['distributed_class'] = 'org.apache.kafka.connect.cli.ConnectDistributed'
default['confluent']['kafka-connect']['standalone_class'] = 'org.apache.kafka.connect.cli.ConnectStandalone'
default['confluent']['kafka-connect']['standalone_connectors'] = []

default['confluent']['kafka-connect']['log4j.properties']['log4j.rootLogger'] = 'CONSOLE,ROLLINGFILE'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.CONSOLE'] = 'org.apache.log4j.ConsoleAppender'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.CONSOLE.Threshold'] = 'INFO'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.CONSOLE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.CONSOLE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE'] = 'org.apache.log4j.RollingFileAppender'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE.Threshold'] = 'INFO'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE.File'] = '/var/log/confluent/kafka-connect.log'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxFileSize'] = '10MB'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxBackupIndex'] = '10'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE.layout'] = 'org.apache.log4j.PatternLayout'
default['confluent']['kafka-connect']['log4j.properties']['log4j.appender.ROLLINGFILE.layout.ConversionPattern'] = '[%d] %p %m (%c:%L)%n'

default['confluent']['zookeeper']['zookeeper.properties']['dataDir'] = '/tmp/zookeeper'
default['confluent']['zookeeper']['zookeeper.properties']['clientPort'] = '2181'
default['confluent']['zookeeper']['zookeeper.properties']['maxClientCnxns'] = '0'

# Kerberos configuration
default['confluent']['kerberos']['enable'] = false
# The keytab location and realm (or complete custom principal) are required if Kerberos is enabled with the above attribute
default['confluent']['kerberos']['keytab'] = nil
default['confluent']['kerberos']['realm'] = nil
default['confluent']['kerberos']['principal'] = "#{node['confluent']['user']}/#{node['fqdn']}@#{node['confluent']['kerberos']['realm']}"
default['confluent']['kerberos']['enable_zk'] = false
default['confluent']['kerberos']['krb5_properties']['useKeyTab'] = 'true'
default['confluent']['kerberos']['krb5_properties']['storeKey'] = 'true'
default['confluent']['kerberos']['zk_krb5_properties']['useKeyTab'] = 'true'
default['confluent']['kerberos']['zk_krb5_properties']['storeKey'] = 'true'
