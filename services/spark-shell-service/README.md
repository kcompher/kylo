Spark Shell Service
===================

#### [Wiki](https://wiki.thinkbiganalytics.com/display/~greg.hart/Real-Time+Data+Processing)

A REST API for transforming SQL tables in real-time. When creating a
feed in the Think Big NiFi UI, a user would be able to see a live
preview of how their data would look when stored in its final
destination. Any transformations would be translated into Scala which
could then be used in production to apply the same transformations.

Known Issues
------------

__A NoClassDefFoundError may be thrown on CDH 5.7__  
Add the following line to the bottom of `/etc/spark/conf/spark-env.sh`:  
`HADOOP_CONF_DIR="$HADOOP_CONF_DIR:/etc/hive/conf"`