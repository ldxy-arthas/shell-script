:: 用于go的logAgent项目启动服务
:: etcd kafka zookeeper influxdb

color 9
@echo off
chcp 65001

set kafkaPath=E:\Go\kafka_2.12-3.3.1
set etcdPath=E:\Go\etcd\etcd-v3.4.23-windows-amd64
set influxdbPath=E:\Go\influxDB\influxdb-1.7.7-1

@echo script is running......
IF EXIST %kafkaPath% (echo kafka path exist) else (echo kafka path error)
IF EXIST %etcdPath% (echo etcd path exist) else (echo etcd path error)
IF EXIST %influxdbPath% (echo influxdb path exist) else (echo influxdb path error)

@echo start service......
start cmd /k "cd /d %kafkaPath%&&bin\windows\zookeeper-server-start.bat config\zookeeper.properties"
start cmd /k "cd /d %etcdPath%&&etcd.exe"
start cmd /k "cd /d %influxdbPath%&&influxd.exe"

:: 睡眠一会，避免zookeeper节点未完全启动导致 kafka 节点启动失败
timeout /nobreak /t 5
start cmd /k "cd /d %kafkaPath%&&bin\windows\kafka-server-start.bat config\server.properties"

@echo start kafka consumer......
start cmd /k "cd /d %kafkaPath%&&bin\windows\kafka-console-consumer.bat --bootstrap-server 127.0.0.1:9092 --topic shopping --from-beginning"
@echo start influxdb cli......
start cmd /k "cd /d %influxdbPath%&&influx.exe"

if errorlevel 0 (
    @echo script run success
) else (
    @echo script run failed
)

pause

