Confluent Cookbook
==================

Installs the [Confluent](http://confluent.io/) package and can run its services,

 * Kafka REST

Getting Started
---------------

### Install/Configure Confluent Package

If you include the default recipe `recipe[confluent]` this will install the Confluent package and nothing else.

### Start Kafka REST Service

If you include the recipe `recipe[confluent::kafka-rest]` this will install the Confluent package and start the
Kafka REST service. 

You can configure the service using the attribtues `node["confluent"]["kafka-rest"]["kafka-rest.properties"][...] = ...`. 
Use Confluent's [Kafka REST doc](http://confluent.io/docs/current/kafka-rest/docs/config.html) to figure out the 
appropriate configuration for yourself.

Attributes
----------

### Generic

 * `node["confluent"]["version"]` : The version of the Confluent package to install (default=`1.0`)
 * `node["confluent"]["scala_version"]` : The scala version of the Confluent package to install (default=`2.10.4`)
 * `node["confluent"]["artifact_url"]` : The URL to the Confluent package to install. This is generated using the `version` and `scala_version` attributes. It downloads from `packages.confluent.io`.
 * `node["confluent"]["install_dir"]` : The directory to install the Confluent package (default=`/opt/confluent`)
 * `node["confluent"]["user"]` : The user that owns the Confluent package files and runs the services
 * `node["confluent"]["group"]` : The group that owns the Confluent package files and runs the services

### Kafka REST

 * `node["confluent"]["kafka-rest"]["kafka-rest.properties"]` : A Hash of properties that configure the Kafka REST service (default=`{}`)
 * `node["confluent"]["kafka-rest"]["log4j.properties"]` : A Hash of properties that configure log4j for the Kafka REST service