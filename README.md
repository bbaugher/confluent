Confluent Cookbook
==================

[![Cookbook Version](https://img.shields.io/cookbook/v/confluent.svg)](https://community.opscode.com/cookbooks/confluent)

Installs the [Confluent](http://confluent.io/) package and can run its services,

 * Kafka
 * Kafka REST
 * Schema Registry

View the [Change Log](CHANGELOG.md) to see what has changed.

Getting Started
---------------

### Install/Configure Confluent Package

If you include the `recipe[confluent]` this will install the Confluent package and nothing else.

You can find the package installed under `/opt/confluent` (by default) with the name `confluent-VERSION`.

You can also find the configuration under,

 * /etc/kafka
 * /etc/kafka-rest
 * /etc/schema-registry

### Kafka Service

If you include the `recipe[confluent::kafka]` this will install the Confluent package and start the Kafka service. 

You can configure the service using the attribtues `node["confluent"]["kafka"]["server.properties"][...] = ...`. 
Use Confluent's [Kafka doc](http://confluent.io/docs/current/kafka/deployment.html#important-configuration-options) 
to figure out the appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/kafka-rest` or `kafka-rest [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/kafka.log`.

### Kafka REST Service

If you include the `recipe[confluent::kafka-rest]` this will install the Confluent package and start the
Kafka REST service. 

You can configure the service using the attribtues `node["confluent"]["kafka-rest"]["kafka-rest.properties"][...] = ...`. 
Use Confluent's [Kafka REST doc](http://confluent.io/docs/current/kafka-rest/docs/config.html) to figure out the 
appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/kafka-rest` or `kafka-rest [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/kafka-rest.log`.

### Schema Registry Service

If you include the `recipe[confluent::schema-registry]` this will install the Confluent package and start the
Schema Registry service. 

You can configure the service using the attribtues `node["confluent"]["schema-registry"]["schema-registry.properties"][...] = ...`. 
Use Confluent's [Schema Registry doc](http://confluent.io/docs/current/schema-registry/docs/config.html) to figure out the 
appropriate configuration for yourself.

You can find the SysV script at `/etc/init.d/schema-registry` or `schema-registry [start|stop|restart|status]`.

You can find the logs at `/var/log/confluent/schema-registry.log`.

Attributes
----------

### Generic

 * `node["confluent"]["version"]` : The version of the Confluent package to install (default=`1.0`)
 * `node["confluent"]["scala_version"]` : The scala version of the Confluent package to install (default=`2.10.4`)
 * `node["confluent"]["artifact_url"]` : The URL to the Confluent package to install. This is generated using the `version` and `scala_version` attributes. It downloads from `packages.confluent.io`.
 * `node["confluent"]["install_dir"]` : The directory to install the Confluent package (default=`/opt/confluent`)
 * `node["confluent"]["user"]` : The user that owns the Confluent package files and runs the services
 * `node["confluent"]["group"]` : The group that owns the Confluent package files and runs the services

### Kafka

 * `node["confluent"]["kafka"]["server.properties"]` : A Hash of properties that configure the Kafka service (default=`{}`)
 * `node["confluent"]["kafka"]["log4j.properties"]` : A Hash of properties that configure log4j for the Kafka service (see attributes for defaults)

### Kafka REST

 * `node["confluent"]["kafka-rest"]["kafka-rest.properties"]` : A Hash of properties that configure the Kafka REST service (default=`{}`)
 * `node["confluent"]["kafka-rest"]["log4j.properties"]` : A Hash of properties that configure log4j for the Kafka REST service (see attributes for defaults)

### Schema Registry

 * `node["confluent"]["schema-registry"]["schema-registry.properties"]` : A Hash of properties that configure the Schema Registry service (default=`{}`)
 * `node["confluent"]["schema-registry"]["log4j.properties"]` : A Hash of properties that configure log4j for the Schema Registry service (see attributes for defaults)