import sys;
from lxml import etree;
errors = {
    "400": "/error/400.html",
    "401": "/error/401.html",
    "403": "/error/403.html",
    "404": "/error/404.html",
    "500": "/error/500.html",
    "503": "/error/503.html"
}

catalina_home = sys.argv[1];
webxml = catalina_home + "/conf/web.xml";
parser = etree.XMLParser(remove_blank_text=True);
xml = etree.parse(webxml, parser);
root = xml.getroot();

for port, location in errors.iteritems():
        errorElement = etree.Element("error-page");
        codeElement = etree.Element("error-code");
        codeElement.text = port;
        locationElement = etree.Element("location");
        locationElement.text = location;
        errorElement.append(codeElement);
        errorElement.append(locationElement);
        root.append(errorElement);

with open(webxml, 'w') as f:
    f.write(etree.tostring(xml, pretty_print=True));