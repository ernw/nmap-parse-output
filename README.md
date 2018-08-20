# nmap-parse-output

Converts/manipulates/extracts data from a nmap scan output.

Needs [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html) as dependency.

## Examples

Write HTML output to scan.html:

    $ ./nmap-parse-output scan.xml html > scan.html

Generates a list of all http(s) ports:

    $ ./nmap-parse-output scan.xml http-ports   
    http://192.168.0.1:8081
    https://192.168.0.1:8443

List all names of detected services:

    $ ./nmap-parse-output scan.xml service-names
    http
    https
    http-proxy
    ms-wbt-server
    smtp

Exclude some hosts from scan and generate a list of ports:

    $ ./nmap-parse-output scan.xml exclude '192.168.1.1,192.168.1.20' | nmap-parse-output - ports
    22,80,443,8080


 Filter `scan-all.xml` to include only hosts scanned in `scan-subnet.xml` and write output to `filtered-scan.xml`:

    $ ./nmap-parse-output scan-all.xml include $(./nmap-parse-output.sh scan-subnet.xml hosts | tr "\n" ",") > filtered-scan.xml

## Usage

      $ ./nmap-parse-output
      Usage: ./nmap-parse-output NMAP_XML_OUTPUT COMMAND [OPTIONS]

      Converts/manipulates/extracts data from nmap scan output

      Commands:
      banner [service-name]
            Extracts a list of all ports with a specific service (e.g. http, ms-wbt-server, smtp) in host:port format.
            Note: This command is intended for the masscan XML output only.
      blocked-ports 
            Extracts all ports in host:port format, which either admin-prohibited or tcpwrapped.
      exclude [hosts]
            Excludes a list of hosts from scan result by its IP address. Expects a comma-separated list as input.
            You can pipe the output, for instance:
                  nmap-parse-output scan.xml exclude '192.168.1.1,192.168.1.20' | nmap-parse-output - service-names
      host-ports 
            Extracts a list of all *open* ports in host:port format.
      hosts-to-port [port]
            Extracts a list of all hosts that has the given port open in 'host (hostname)' format.
      hosts 
            Generates a line break seperated list of all hosts with open ports. Can be useful to perform an additional scan on this hosts.
      html 
            Converts XML output into an HTML report
      http-ports 
            Generates a line seperated list of http(s) all ports.
            Currently the following services are detected as http: http, https, http-alt, https-alt, http-proxy, sip, rtsp (potentially incomplete)
      http-title 
            Extracts a list of HTTP HTML titles in the following format:
            host:port	HTML title
      include [hosts]
            Filter a list of hosts from scan result by its IP address. Expects a comma-separated list as input.
            You can pipe the output, for instance:
                  nmap-parse-output scan.xml exclude '192.168.1.1,192.168.1.20' | nmap-parse-output - service-names
      port-info [port]
            Extracts a list of extra information about the given port in the following format:
            port;service name;http title
      ports 
            Generates a comma seperated list of all ports. Can be useful to verify if open/closed ports reachable from another host or generate port lists for specific enviroments. Filter closed/filtered ports.
      product 
            Extracts all detected product names.
      reachable 
            Removes all hosts where all ports a filtered. Can be usefull to generate a smaller HTML report.
            Example usage to generate HTML report:
                  nmap-parse-output scan.xml reachable | nmap-parse-output - html &gt; scan.html
      service-names 
            Extracts all detected service names.
      service [service-name]
            Extracts a list of all *open* ports with a specific service (e.g. http, ms-wbt-server, smtp) in host:port format.
      ssl-common-name 
            Extracts a list of TLS/SSL ports with the commonName and Subject Alternative Name in the following format:
            host:port	commonName	X509v3 Subject Alternative Name
      tls-ports 
            Extracts a list of all TLS ports in host:port format. Works only after script scan. Can be used to do a testssl.sh scan.
            Example testssl.sh command (generates a text and HTML report for each host):
                  for f in `cat ~/ssl-hosts.txt`; do ./testssl.sh --logfile ~/testssl.sh-results/$f.log --htmlfile ~/testssl.sh-results/$f.html $f; done

      [v1.2.0]


## Adding new Commands

Commands are written as [XSLT](https://en.wikipedia.org/wiki/XSLT). See [nmap-parse-output-xslt/](nmap-parse-output-xslt/) if you want to add new commands. A good way is mostly copying an existing script that does something similar.

The documentation printed in the help page can be written with he ``<comment>`` tag (XML namespace: http://xmlns.sven.to/npo).

An post processing command can be added with the ``<post-processor>`` tag.

Example XSLT file:

    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
    <npo:comment>
            <!-- Added documentation here -->
    </npo:comment>
    <npo:post-processor>sort | uniq</npo:post-processor>
    
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
        
    <xsl:template match="/nmaprun/host/ports/port">
        <!-- add your template here -->
        <xsl:if test="state/@state='open'">
            <xsl:value-of select="../../address/@addr"/>
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="text()" />
    </xsl:stylesheet>

More information about XSLT and writing new commands can be found here:
- http://xmlsoft.org/XSLT/
- http://www.w3.org/TR/xslt
- http://www.exslt.org/
- http://xmlsoft.org/XSLT/xsltproc.html

## Bash Completion

Bash completion can by enabled by adding the following line to your `~/.bash_profile` or `.bashrc`:

    source ~/path/to/misc-tools/_nmap-parse-output

## ZSH Completion

ZSH completion can by enabled by adding the following line to your `~/.zshrc`:

    autoload bashcompinit && bashcompinit && source ~/path/to/misc-tools/_nmap-parse-output