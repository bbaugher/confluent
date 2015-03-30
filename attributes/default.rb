default["confluent"]["version"] = "1.0"
default["confluent"]["scala_version"] = "2.10.4"
default["confluent"]["artifact_url"] = File.join("http://packages.confluent.io/archive", node["confluent"]["version"], "confluent-#{node["confluent"]["version"]}-#{node["confluent"]["scala_version"]}.zip")
default["confluent"]["install_dir"] = "/opt/confluent"
default["confluent"]["user"] = "confluent"
default["confluent"]["group"] = "confluent"

default["confluent"]["kafka-rest"]["kafka-rest.properties"] = {}

# TODO: Do proper logging
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.rootLogger"] = "INFO, stdout"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.stdout"] = "org.apache.log4j.ConsoleAppender"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.stdout.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.stdout.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"

default["confluent"]["schema-registry"]["schema-registry.properties"] = {}

# TODO: Do proper logging
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.rootLogger"] = "INFO, stdout"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.stdout"] = "org.apache.log4j.ConsoleAppender"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.stdout.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.stdout.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"