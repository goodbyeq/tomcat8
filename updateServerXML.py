import sys;
from lxml import etree;

catalina_home = sys.argv[1];
serverxml = catalina_home + "/conf/server.xml";
parser = etree.XMLParser(remove_blank_text=True);
xml = etree.parse(serverxml, parser);
server = xml.getroot();

server.set("port", "${shutdown.port}");
server.set("shutdown", "NONDETERMINISTICVALUE");

service = server.find("Service");
connectors = service.findall("Connector");
for connector in connectors:
        connector.getparent().replace(connector, etree.Comment(etree.tostring(connector)));

connector8443 = etree.Element("Connector");
connector8443.set("port", "8443");
connector8443.set("protocol", "org.apache.coyote.http11.Http11NioProtocol");
connector8443.set("maxThreads", "150");
connector8443.set("SSLEnabled", "true");
connector8443.set("scheme", "https");
connector8443.set("secure", "true");
connector8443.set("clientAuth", "false");
connector8443.set("sslProtocol", "TLS");
connector8443.set("server", "Apache-Coyote/1.1");
connector8443.set("keystoreFile", "/usr/share/tomcat8/ssl/tomcat.keystore");
connector8443.set("keystorePass", "changeit");
connector8443.set("sslEnabledProtocols", "TLSv1.1,TLSv1.2");
connector8443.set("connectionTimeout", "60000");
service.insert(0, connector8443);

host = service.find("Engine").find("Host");
host.set("autoDeploy", "false");

with open(serverxml, 'w') as f:
    f.write(etree.tostring(xml, pretty_print=True));