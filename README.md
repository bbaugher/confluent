Confluent Cookbook
==================

[![Cookbook Version](https://img.shields.io/cookbook/v/confluent.svg)](https://community.opscode.com/cookbooks/confluent)
[![Build Status](https://travis-ci.org/bbaugher/confluent.svg?branch=master)](https://travis-ci.org/bbaugher/confluent)

Installs the [Confluent](http://confluent.io/) package and can run its services,

 * Kafka
 * Kafka REST
 * Schema Registry
 * Kafka Connect

View the [Change Log](CHANGELOG.md) to see what has changed.

Getting Started
---------------

### Install Confluent Package

If you include the `recipe[confluent]` this will install the Confluent package and nothing else.

You can find the package installed under `/opt/confluent` (by default) with the name `confluent-VERSION`.

You can also find the configuration under,

 * /etc/kafka
 * /etc/kafka-rest
 * /etc/schema-registry
 * /etc/kafka-connect

### Kafka Service

If you include the `recipe[confluent::kafka]` this will install the Confluent package, configure and start the Kafka service.

You can configure the service using the attribtues `node["confluent"]["kafka"]["server.properties"][...] = ...`.
Use Confluent's [Kafka doc](http://docs.confluent.io/current/kafka/deployment.html#important-configuration-options)
to figure out the appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/kafka-rest` or `service kafka-rest [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/kafka.log`.

### Kafka REST Service

If you include the `recipe[confluent::kafka-rest]` this will install the Confluent package, configure and start the
Kafka REST service.

You can configure the service using the attribtues `node["confluent"]["kafka-rest"]["kafka-rest.properties"][...] = ...`.
Use Confluent's [Kafka REST doc](http://docs.confluent.io/current/kafka-rest/docs/config.html) to figure out the
appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/kafka-rest` or `service kafka-rest [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/kafka-rest.log`.

### Schema Registry Service

If you include the `recipe[confluent::schema-registry]` this will install the Confluent package, configure and start the
Schema Registry service.

You can configure the service using the attribtues `node["confluent"]["schema-registry"]["schema-registry.properties"][...] = ...`.
Use Confluent's [Schema Registry doc](http://docs.confluent.io/current/schema-registry/docs/config.html) to figure out the
appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/schema-registry` or `service schema-registry [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/schema-registry.log`.

### Kafka Connect

If you include the `recipe[confluent::kafka-connect]` this will install the Confluent package, configure and start the
Kafka connector. This will listen on port 8083 exposing its rest api to control spinning up new connectors.

You can configure the service using the attribtues `node["confluent"]["kafka-connect"]["worker.properties"][...] = ...`.
Use Confluent's [Kafka Connect doc](http://docs.confluent.io/2.0.0/connect/userguide.html) to figure out the
appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/kafka-connect` or `service kafka-connect [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/kafka-connect.log`.

### Zookeeper (For development purposes only)

If you include the `recipe[confluent::zookeeper]` this will install the Confluent package and start a zookeeper process. It will listen on port 2181. This is a single zookeeper worker and is not recomended for production use. The primary purpose of this recipe is to get everything running inside vagrant as a self contained system without having to run process on the host machine.

### Kerberos

The cookbook helps to setup the services with kerberos enabled. To do so,

 * Set `node["confluent"]["kerberos"]["enable"]` to `true`
 * Set a value for `node["confluent"]["kerberos"]["keytab"]`
 * Set a value for `node["confluent"]["kerberos"]["realm"]` or `node["confluent"]["kerberos"]["principal"]`

The cookbook will create a JAAS configuration file to be used for the services and
automatically include the `-Djava.security.auth.login.config` java option.

The cookbook however will not handle creating and kerberos keytab files. That is
outside the scope of this cookbook.

ZooKeeper client authentication can additionally be enabled by setting
`node["kafka"]["kerberos"]["enable_zk"]` to `true`.

Custom Krb5LoginModule options can be set using the `node["kafka"]["kerberos"]["krb5_properties"]`
attribute hash for Kafka, or `node["kafka"]["kerberos"]["zk_krb5_properties"]`
for ZooKeeper (see attributes file for defaults).

Note that enabling Kerberos does not automatically set any configuration into
any of the service's property/config files. Those should be evaluated as well.

Attributes
----------

### Generic

 * `node["confluent"]["version"]` : The version of the Confluent package to install (default=`2.0.1`)
 * `node["confluent"]["scala_version"]` : The scala version of the Confluent package to install (default=`2.11.7`)
 * `node["confluent"]["artifact_url"]` : The URL to the Confluent package to install. This is generated using the `version` and `scala_version` attributes. It downloads from `packages.confluent.io`.
 * `node["confluent"]["install_dir"]` : The directory to install the Confluent package (default=`/opt/confluent`)
 * `node["confluent"]["user"]` : The user that owns the Confluent package files and runs the services (default=`confluent`)
 * `node["confluent"]["uid"]` : optional staticly assign a uid for above user (default=`unset` picks form system config)
 * `node["confluent"]["group"]` : The group that owns the Confluent package files and runs the services (default=`confluent`)
 * `node["confluent"]["gid"]` : optional staticly assign a gid for above group (default=`unset` picks form system config)
 * `node["confluent"]["backup_templates"]` : If template backups are desired set this to the number of backups to keep. (default=`false`)
 * `node["confluent"]["kerberos"]["enable"]` : if kerberos configuration should be applied (default=`false`)
 * `node["confluent"]["kerberos"]["keytab"]` : the path to the kerberos keytab file (default=`nil`)
 * `node["confluent"]["kerberos"]["realm"]` : the name of the kerberos realm to use (default=`nil`)
 * `node["confluent"]["kerberos"]["principal"]` : the kerberos principal to use (default is dynamically generated from other attributes. See attributes file)
 * `node["confluent"]["kerberos"]["enable_zk"]` : if zookeeper kerberos configuration should be applied (default=`false`)
 * `node["confluent"]["kerberos"]["krb5_properties"]` : a hash of krb5 key/values used for kerberos kafka server/client configuration (See attributes file for default)
 * `node["confluent"]["kerberos"]["zk_krb5_properties"]` : a hash of krb5 key/values used for kerberos zookeeper client configuration (See attributes file for default)

### Kafka

 * `node["confluent"]["kafka"]["server.properties"]` : A Hash of properties that configure the Kafka service (default=`{}`)
 * `node["confluent"]["kafka"]["env_vars"]` : A Hash of environment variables applied when running the service
 * `node["confluent"]["kafka"]["log4j.properties"]` : A Hash of properties that configure log4j for the Kafka service (see attributes for defaults)
 * `node['confluent']['kafka']['brokers']` : A single broker String or List of brokers by hostname, fqdn, or ipaddress
 * `node['confluent']['kafka']['zookeepers']` : A list of zookeeper hostname:port's to add to kafka config (default=`nil`)
 * `node['confluent']['kafka']['zookeeper_chroot']` : An optional chroot path for zookeeper hostname:port/chroot's to add to kafka config (default=`nil`)

### Kafka REST

 * `node["confluent"]["kafka-rest"]["kafka-rest.properties"]` : A Hash of properties that configure the Kafka REST service (default=`{}`)
 * `node["confluent"]["kafka-rest"]["env_vars"]` : A Hash of environment variables applied when running the service
 * `node["confluent"]["kafka-rest"]["log4j.properties"]` : A Hash of properties that configure log4j for the Kafka REST service (see attributes for defaults)

### Schema Registry

 * `node["confluent"]["schema-registry"]["schema-registry.properties"]` : A Hash of properties that configure the Schema Registry service (default=`{}`)
 * `node["confluent"]["schema-registry"]["env_vars"]` : A Hash of environment variables applied when running the service
 * `node["confluent"]["schema-registry"]["log4j.properties"]` : A Hash of properties that configure log4j for the Schema Registry service (see attributes for defaults)

### Kafka Connect
* `node["confluent"]["kafka-connect"]["jar_urls"]` : an array of urls to remote files to download and install in the directory `share/java/kafka-connect-all` located in the extracted confluent directory which is where connect looks by default.
* `node["confluent"]["kafka-connect"]["properties_files"]` : a hash where the key is a property file name, and the value is a hash of keys/values for the property file. This is can be used to drop in connector configuration for standalone mode via chef config as opposed to the rest api.
* `node["confluent"]["kafka-connect"]["distributed_mode"]` : Boolean used to decide if it should launch in standalone or distributed mode. Defaults to true
* `node["confluent"]["kafka-connect"]["worker_properties_file_name"]` : The name of the properties file to use when starting the connect service.
* `node["confluent"]["kafka-connect"]["worker.properties"]` : hash of properties to configure the connect properties with.
* `node["confluent"]["kafka-connect"]["env_vars"]` : A Hash of environment variables applied when running the service
* `node["confluent"]["kafka-connect"]["log4j.properties"]` : A Hash of properties that configure log4j for the Schema Registry service (see attributes for defaults)

### Zookeeper
* `node["confluent"]["zookeeper"]["zookeeper.properties"]` : a hash of properties to configure the zookeeper server with

Testing
-------

### Style
* `rake style` : runs foodcritic and rubocop
  * todo in .rubocop.yml
* `rake unit` : runs chefspec tests form ./spec
  * todo from untouched resources
* `rake kitchen` : runs kitchen tests
  * problem with gem version conflict in Rakefile.  Run kitchen from command line: `kitchen test`
