default["confluent"]["version"] = "1.0"
default["confluent"]["scala_version"] = "2.10.4"
default["confluent"]["artifact_url"] = File.join("http://packages.confluent.io/archive", node["confluent"]["version"], "confluent-#{node["confluent"]["version"]}-#{node["confluent"]["scala_version"]}.zip")
default["confluent"]["install_dir"] = "/opt/confluent"
default["confluent"]["user"] = "confluent"
default["confluent"]["group"] = "confluent"

# TODO: Do proper logging
log4j_defaults = {
  "log4j.rootLogger" => "INFO, stdout",
  "log4j.appender.stdout" => "org.apache.log4j.ConsoleAppender",
  "log4j.appender.stdout.layout" => "org.apache.log4j.PatternLayout",
  "log4j.appender.stdout.layout.ConversionPattern" => "[%d] %p %m (%c:%L)%n"
}

default["confluent"]["kafka"]["server.properties"] = {}
default["confluent"]["kafka"]["log4j.properties"] = log4j_defaults

default["confluent"]["kafka-rest"]["kafka-rest.properties"] = {}
default["confluent"]["kafka-rest"]["log4j.properties"] = log4j_defaults

default["confluent"]["schema-registry"]["schema-registry.properties"] = {}
default["confluent"]["schema-registry"]["log4j.properties"] = log4j_defaults