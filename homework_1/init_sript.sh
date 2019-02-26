#! /bin/bash

##############################################################################################
# Run the following script to set up HDFS and Spark on a cluster of 
# 4 machines running Ubuntu. The script has to be executed on the 
# Master machine. 
# The following assumptions holds:
# - Private network IPs: 
# 		10.10.1.1 (leader)
# 		10.10.1.2 (follower-1)
# 		10.10.1.3 (follower-2)
# 		10.10.1.4 (follower-3)
# - parallel-ssh configured on all cluster machines
# - root privileges of the executor
#
# Author: Claudio Montanari 
# Mail: c.montanari.95@gmail.com
##############################################################################################


USER="$(whoami)"
ABS_PATH="$(pwd)"

echo 'Testing the parallel-ssh connection...'
if [ ! -f ./slaves ]; then
	echo 'Create a file named slaves with the list of the host-name present in the cluster'
	exit
fi

parallel-ssh -i -h slaves -O StrictHostKeyChecking=no hostname

# Update the system and download java

echo 'Updating the system and downloading java-jdk...'

parallel-ssh -h ./slaves -P sudo apt-get update --fix-missing
parallel-ssh -h ./slaves -P "yes | sudo apt-get install openjdk-8-jdk" 


echo 'Downloading hadoop...'
if [ ! -f ./hadoop-2.7.6.tar.gz ]; then
	# Download hadoop on all machines and unzip it
	parallel-ssh -h ./slaves -P wget http://apache.mirrors.hoobly.com/hadoop/common/hadoop-2.7.6/hadoop-2.7.6.tar.gz
fi
parallel-ssh -h ./slaves -P tar zvxf hadoop-2.7.6.tar.gz

echo 'Setting up the core-site.xml file...'

# Set up the core-site.xml file
CORE_SITE_CONF='<configuration>\
<property>\
<name>fs.default.name</name>\
<value>hdfs://10.10.1.1:9000</value>\
</property>'

CORE_SITE_PATH='hadoop-2.7.6/etc/hadoop/core-site.xml'

sed -i 's=<configuration>='"$CORE_SITE_CONF"'=' $CORE_SITE_PATH

scp $USER@leader:$ABS_PATH'/'$CORE_SITE_PATH $USER@follower-1:$ABS_PATH'/'$CORE_SITE_PATH
scp $USER@leader:$ABS_PATH'/'$CORE_SITE_PATH $USER@follower-2:$ABS_PATH'/'$CORE_SITE_PATH
scp $USER@leader:$ABS_PATH'/'$CORE_SITE_PATH $USER@follower-3:$ABS_PATH'/'$CORE_SITE_PATH


echo 'Setting up the hdfs-site.xml file...'

# Set up the hdfs-site.xml file
HDFS_SITE_CONF='<configuration>\
<property>\
<name>dfs.namenode.name.dir</name>\
<value>file:/users/'$USER'/hadoop-2.7.6/data/namenode/</value>\
</property>\
<property>\
<name>dfs.datanode.data.dir</name>\
<value>file:/users/'$USER'/hadoop-2.7.6/data/datanode/</value>\
</property>'

HDFS_SITE_PATH='hadoop-2.7.6/etc/hadoop/hdfs-site.xml'

sed -i 's=<configuration>='"$HDFS_SITE_CONF"'=' $HDFS_SITE_PATH

scp $USER@leader:$ABS_PATH'/'$HDFS_SITE_PATH $USER@follower-1:$ABS_PATH'/'$HDFS_SITE_PATH
scp $USER@leader:$ABS_PATH'/'$HDFS_SITE_PATH $USER@follower-2:$ABS_PATH'/'$HDFS_SITE_PATH
scp $USER@leader:$ABS_PATH'/'$HDFS_SITE_PATH $USER@follower-3:$ABS_PATH'/'$HDFS_SITE_PATH

# Create the namenode and datanode directories
BASE_PATH="/users/$USER/hadoop-2.7.6/data/namenode"
parallel-ssh -h ./slaves -P mkdir -p $BASE_PATH

BASE_PATH="/users/$USER/hadoop-2.7.6/data/datanode"
parallel-ssh -h ./slaves -P mkdir $BASE_PATH


echo 'Setting up the hadoop-env.xml file...'

# Find current java path and set up hadoop-env.sh file
JAVA_PATH="$(update-alternatives --display java | awk '/currently/ {print $5}' | sed 's=bin/java==' )"

JAVA_CONFIG_PATH='hadoop-2.7.6/etc/hadoop/hadoop-env.sh'

JAVA_CONF="export JAVA_HOME=$JAVA_PATH"

sed -i 's|export JAVA_HOME=${JAVA_HOME}|'"$JAVA_CONF"'|' $JAVA_CONFIG_PATH

scp $USER@leader:$ABS_PATH'/'$JAVA_CONFIG_PATH $USER@follower-1:$ABS_PATH'/'$JAVA_CONFIG_PATH
scp $USER@leader:$ABS_PATH'/'$JAVA_CONFIG_PATH $USER@follower-2:$ABS_PATH'/'$JAVA_CONFIG_PATH
scp $USER@leader:$ABS_PATH'/'$JAVA_CONFIG_PATH $USER@follower-3:$ABS_PATH'/'$JAVA_CONFIG_PATH


echo 'Setting up the slaves file...'

# Add the slaves config file on all machines
SLAVES="10.10.1.2\n10.10.1.3\n10.10.1.4"
SLAVES_PATH='hadoop-2.7.6/etc/hadoop/slaves'

printf $SLAVES > $SLAVES_PATH

scp $USER@leader:$ABS_PATH'/'$SLAVES_PATH $USER@follower-1:$ABS_PATH'/'$SLAVES_PATH
scp $USER@leader:$ABS_PATH'/'$SLAVES_PATH $USER@follower-2:$ABS_PATH'/'$SLAVES_PATH
scp $USER@leader:$ABS_PATH'/'$SLAVES_PATH $USER@follower-3:$ABS_PATH'/'$SLAVES_PATH

echo 'Installation of HDFS done, now starting namenode and datanode'

export PATH="/users/$USER/hadoop-2.7.6/bin/:/users/$USER/hadoop-2.7.6/sbin/":$PATH

hdfs namenode -format
yes | start-dfs.sh

echo 'Downloading spark...'

if [ ! -f ./spark-2.2.0-bin-hadoop2.7.tgz ]; then
	parallel-ssh -h ./slaves -P wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
fi
parallel-ssh -h ./slaves -P tar zvxf spark-2.2.0-bin-hadoop2.7.tgz


echo 'Setting up spark slaves file...'

# Add slaves file in spark
SLAVES_PATH_SPARK='spark-2.2.0-bin-hadoop2.7/conf/slaves'
printf $SLAVES > $SLAVES_PATH_SPARK

scp $USER@leader:$ABS_PATH'/'$SLAVES_PATH_SPARK $USER@follower-1:$ABS_PATH'/'$SLAVES_PATH_SPARK
scp $USER@leader:$ABS_PATH'/'$SLAVES_PATH_SPARK $USER@follower-2:$ABS_PATH'/'$SLAVES_PATH_SPARK
scp $USER@leader:$ABS_PATH'/'$SLAVES_PATH_SPARK $USER@follower-3:$ABS_PATH'/'$SLAVES_PATH_SPARK

echo 'Starting spark...'

spark-2.2.0-bin-hadoop2.7/sbin/start-all.sh

exit