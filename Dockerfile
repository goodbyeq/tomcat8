FROM 634957622823.dkr.ecr.ap-south-1.amazonaws.com/java8:6
MAINTAINER goodbyeQ
USER root
ENV CATALINA_HOME /usr/share/tomcat8

RUN yum install -y tomcat8

RUN yum install -y python27-lxml 

COPY setenv.sh  ${CATALINA_HOME}/bin
RUN chmod 755 ${CATALINA_HOME}/bin/setenv.sh
RUN ${CATALINA_HOME}/bin/setenv.sh

RUN echo "shutdown.port=-1" >> ${CATALINA_HOME}/conf/catalina.properties

RUN mkdir /scripts

COPY addErrorPages.py /scripts
RUN python /scripts/addErrorPages.py $CATALINA_HOME

COPY updateServerXML.py /scripts
RUN python /scripts/updateServerXML.py $CATALINA_HOME

RUN mkdir ${CATALINA_HOME}/ssl

RUN $JAVA_HOME/bin/keytool -genkey -noprompt -alias tomcat -keyalg RSA -dname "CN=tomcat, OU=Goodbyeq, O=TECH, L=Hyderabad, S=AP, C=IN" -keypass changeit -keystore "/usr/share/tomcat8/ssl/tomcat.keystore" -storepass changeit -deststoretype pkcs12
