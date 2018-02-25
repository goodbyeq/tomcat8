FROM 634957622823.dkr.ecr.us-east-1.amazonaws.com/java8:latest
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

RUN chmod 755 ${CATALINA_HOME} && \
    chown -R tomcat:tomcat ${CATALINA_HOME} && \
    chmod 750 ${CATALINA_HOME}/conf && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf && \
    chmod 750 ${CATALINA_HOME}/logs && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/logs && \
    chmod 770 ${CATALINA_HOME}/temp && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/temp && \
    chmod 750 ${CATALINA_HOME}/bin && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/bin && \
    chmod 750 ${CATALINA_HOME}/webapps && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/webapps && \
    chmod 770 ${CATALINA_HOME}/conf/catalina.policy && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/catalina.policy && \
    chmod 750 ${CATALINA_HOME}/conf/catalina.properties && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/catalina.properties && \
    chmod 750 ${CATALINA_HOME}/conf/context.xml && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/context.xml && \
    chmod 750 ${CATALINA_HOME}/conf/logging.properties && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/logging.properties && \
    chmod 750 ${CATALINA_HOME}/conf/server.xml && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/server.xml && \
    chmod 750 ${CATALINA_HOME}/conf/tomcat-users.xml && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/tomcat-users.xml && \
    chmod 750 ${CATALINA_HOME}/conf/web.xml && \
    chown -R tomcat:tomcat ${CATALINA_HOME}/conf/web.xml
