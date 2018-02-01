FROM 634957622823.dkr.ecr.us-east-1.amazonaws.com/java8:latest
ARG VERSION=8.0.33
ARG NATIVE_VERSION=1.1.34-r0
ENV MAJOR 8

RUN apk update \
&& apk add curl

WORKDIR /usr/local 
ENV TOMCAT_URL https://archive.apache.org/dist/tomcat/tomcat-${MAJOR}/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz

RUN curl -kLO ${TOMCAT_URL} \
&& gunzip apache-tomcat-${VERSION}.tar.gz \
&& tar -xf apache-tomcat-${VERSION}.tar \
&& ln -s apache-tomcat-${VERSION} tomcat${MAJOR} \
&& rm -f apache-tomcat-${VERSION}.tar \
&& rm -rf tomcat${MAJOR}/webapps/* \
&& rm -rf tomcat${MAJOR}/LICENSE \
&& rm -rf tomcat${MAJOR}/NOTICE \
&& rm -rf tomcat${MAJOR}/RELEASE-NOTES \
&& rm -rf tomcat${MAJOR}/RUNNING.txt \
&& rm -rf tomcat${MAJOR}/bin/*.bat \
&& apk del -f curl

ENV CATALINA_HOME /usr/local/tomcat${MAJOR}
VOLUME ${CATALINA_HOME}

CMD ["/usr/local/tomcat8/bin/catalina.sh","run"]
