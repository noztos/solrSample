#!/bin/sh

# following require as preprocess
#
# > cd ${SOLR_REPO}
# > ant ivy-bootstrap
# > ant compile
# > cd solr
# > ant dist
#

HOME=/home/tos

CATALINA_HOME=/usr/pkg/share/tomcat
SOLR_REPO=${HOME}/github/lucene-solr
SOLR_HOME=/usr/pkg/share/solr
TOMCAT_USR=tomcat
TOMCAT_GRP=tomcat

if [ ! -e ${SOLR_HOME} ]; then
  mkdir ${SOLR_HOME}
  chown -R ${TOMCAT_USR}:${TOMCAT_GRP} ${SOLR_HOME}
fi

sudo -u ${TOMCAT_USR} cp -pR ${SOLR_REPO}/solr/example/solr ${SOLR_HOME}/..
sudo cp -pR ${SOLR_REPO}/solr/example/lib/ext/*.jar ${CATALINA_HOME}/lib
sudo -u ${TOMCAT_USR} cp -p ${SOLR_REPO}/solr/dist/solr*.war ${CATALINA_HOME}/webapps/solr.war

TOMCAT_SOLR_XML=${CATALINA_HOME}/conf/Catalina/localhost/solr.xml
if [ ! -e ${TOMCAT_SOLR_XML} ]; then
  sudo -u ${TOMCAT_USR} cat > ${TOMCAT_SOLR_XML} <<EOT
<?xml version="1.0" encoding="utf-8"?>
<Context docBase="${CATALINA_HOME}/webapps/solr.war" debug="0" crossContext="true">
  <Environment name="solr/home" type="java.lang.String" value="${SOLR_HOME}" override="true"/>
</Context>
EOT
fi
