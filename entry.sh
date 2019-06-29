#!/bin/bash
export GROOVY_HOME=/usr/groovy/groovy-2.3.0-beta-2
export PATH=$PATH:$GROOVY_HOME/bin

# Install Groovy
mkdir /usr/groovy
cd /usr/groovy/
wget http://dl.bintray.com/groovy/maven/groovy-binary-2.3.0-beta-2.zip
unzip groovy-binary-2.3.0-beta-2.zip && rm -f groovy-binary-2.3.0-beta-2.zip

# Accept VMWare scripts
mkdir -p /etc/vmware/vfabric/
echo 'I_ACCEPT_EULA_LOCATED_AT=http://www.vmware.com/download/eula/vfabric_app-platform_eula.html' > /etc/vmware/vfabric/accept-vfabric5.1-eula.txt

# Install SQLFire
rpm -ivhf http://repo.vmware.com/pub/rhel6/vfabric/5.1/vfabric-5.1-repo-5.1-1.noarch.rpm
yum install vfabric-sqlfire -y
mkdir /opt/vmware/vfabric-sqlfire/vFabric_SQLFire_103/locator1
mkdir /opt/vmware/vfabric-sqlfire/vFabric_SQLFire_103/server1

# Install RabbitMQ
rpm -Uvh https://download.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
yum install erlang -y

echo '127.0.0.1 centos6 nanodbserver springtrader rabbitmq' >> /etc/hosts

# Make sure SQLfire is up
echo 'GOING TO SLEEP'
sleep 35 
echo 'DONE SLEEPING'


cd /dist
echo 'createSqlfSchema'
./createSqlfSchema
echo 'SPRINGTRADER START'
/opt/vmware/vfabric-tc-server-standard/springtrader/bin/tcruntime-ctl.sh start springtrader
cd /dist
echo 'GENERATE DATA'
./generateData
tail -f /dev/null
