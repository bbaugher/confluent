default["confluent"]["version"] = "1.0"
default["confluent"]["scala_version"] = "2.10.4"
default["confluent"]["artifact_url"] = File.join("http://packages.confluent.io/archive", node["confluent"]["version"], "confluent-#{node["confluent"]["version"]}-#{node["confluent"]["scala_version"]}.zip")
default["confluent"]["install_dir"] = "/opt/confluent"
default["confluent"]["user"] = "confluent"
default["confluent"]["group"] = "confluent"

default["confluent"]["kafka"]["server.properties"] = {}
default["confluent"]["kafka"]["env_vars"] = {}

default["confluent"]["kafka"]["log4j.properties"]["log4j.rootLogger"] = "CONSOLE,ROLLINGFILE"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.CONSOLE"] = "org.apache.log4j.ConsoleAppender"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.CONSOLE.Threshold"] = "INFO"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.CONSOLE.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.CONSOLE.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE"] = "org.apache.log4j.RollingFileAppender"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE.Threshold"] = "INFO"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE.File"] = "/var/log/confluent/kafka.log"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxFileSize"] = "10MB"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxBackupIndex"] = "10"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["kafka"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"

default["confluent"]["kafka-rest"]["kafka-rest.properties"] = {}
default["confluent"]["kafka-rest"]["env_vars"] = {}

default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.rootLogger"] = "CONSOLE,ROLLINGFILE"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.CONSOLE"] = "org.apache.log4j.ConsoleAppender"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.CONSOLE.Threshold"] = "INFO"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.CONSOLE.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.CONSOLE.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE"] = "org.apache.log4j.RollingFileAppender"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE.Threshold"] = "INFO"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE.File"] = "/var/log/confluent/kafka-rest.log"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxFileSize"] = "10MB"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxBackupIndex"] = "10"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["kafka-rest"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"

default["confluent"]["schema-registry"]["schema-registry.properties"] = {}
default["confluent"]["schema-registry"]["env_vars"] = {}

default["confluent"]["schema-registry"]["log4j.properties"]["log4j.rootLogger"] = "CONSOLE,ROLLINGFILE"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.CONSOLE"] = "org.apache.log4j.ConsoleAppender"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.CONSOLE.Threshold"] = "INFO"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.CONSOLE.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.CONSOLE.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE"] = "org.apache.log4j.RollingFileAppender"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE.Threshold"] = "INFO"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE.File"] = "/var/log/confluent/schema-registry.log"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxFileSize"] = "10MB"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxBackupIndex"] = "10"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout"] = "org.apache.log4j.PatternLayout"
default["confluent"]["schema-registry"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout.ConversionPattern"] = "[%d] %p %m (%c:%L)%n"
