# nmap-parse-output

Converts/manipulates/extracts data from a nmap scan output.

Needs [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html) as dependency.

**Demo**

![Demo](demo.gif)

**Table of Contents**
- [nmap-parse-output](#nmap-parse-output)
  - [Examples](#examples)
  - [Usage](#usage)
  - [Changelog](#changelog)
  - [Contribute](#contribute)
    - [Adding new Commands](#adding-new-commands)
  - [Installation](#installation)
    - [Bash Completion](#bash-completion)
    - [ZSH Completion](#zsh-completion)
    - [Arch Linux](#arch-linux)

## Examples

Write HTML output to scan.html:

    $ ./nmap-parse-output scan.xml html > scan.html

Generates a list of all HTTP(s) ports:

    $ ./nmap-parse-output scan.xml http-ports   
    http://192.168.0.1:8081
    https://192.168.0.1:8443

List all names of detected services and get a list of hosts with the port for the service http-proxy:

    $ ./nmap-parse-output scan.xml service-names
    http
    https
    http-proxy
    ms-wbt-server
    smtp
    $ ./nmap-parse-output scan.xml service http-proxy
    192.168.0.24:8085
    192.168.0.25:9000

Exclude some hosts from a scan and generate a list of ports:

    $ ./nmap-parse-output scan.xml exclude '192.168.1.1,192.168.1.20' | nmap-parse-output - ports
    22,80,443,8080

Filter `scan-all.xml` to include only hosts scanned in `scan-subnet.xml` and write the output to `filtered-scan.xml`:

    $ ./nmap-parse-output scan-all.xml include $(./nmap-parse-output.sh scan-subnet.xml hosts | tr "\n" ",") > filtered-scan.xml

Generate a subreport with results only from the networks 10.0.1.0/24 and 10.80.0.0/24 from `big-scan-result.xml`:

    $ ./nmap-parse-output big-scan-result.xml \
      include $(nmap -Pn -n -sL 10.0.1.0/24 10.80.0.0/24 -oX - | nmap-parse-output - all-hosts | tr "\n" ',') \
      > networks-10.0.1.0-24-and-10.80.0.0-24.xml

Add comments to a scan, mark specific ports red, and generate a HTML report with the annotations:

    $ ./nmap-parse-output scan.xml comment-ports '8080,10.0.20.4:443' 'this port should be filtered'
      | ./nmap-parse-output - mark-ports '8080,10.0.20.4:443' red
      | ./nmap-parse-output - comment-hosts '10.0.20.1' 'look further into this host'
      | ./nmap-parse-output - html > test.html

Remove all ports found in `scan-before.xml` from `scan-after.xml` and write the output to `filtered-scan.xml`:

    $ ./nmap-parse-output scan-after.xml exclude-ports $(./nmap-parse-output.sh scan-before.xml host-ports | tr "\n" ",") > filtered-scan.xml

Group hosts by open TCP ports:

    $ ./nmap-parse-output scan.xml group-by-ports
    - Open TCP ports 22,443 on:
      - 192.168.1.73 (web.local)
      - 192.168.1.74 (web2.local)
    - Open TCP ports 8080 on:
      - 192.168.1.135
    - No open TCP ports on:
      - 192.168.1.71 (db.local)
      - 192.168.1.81

Rerun TCP scan for all alive hosts but only scan open ports found in the previous scan:

      $ for host in ./nmap-parse-output scan.xml hosts; do nmap -sSVC -p $(./nmap-parse-output scan.xml include $host | nmap-parse-output - ports) -oA $host.xml -vv -Pn; done

## Usage

      Usage: ./nmap-parse-output [options]... <nmap-xml-output> <command> [command-parameters]...
      
      Converts/manipulates/extracts data from nmap scan XML output.
      
      Options:
        -u, --unfinished-scan			 try to read an unfinished scan output
      
      Extract Data Commands:
        all-hosts 
              Generates a line break separated list of all hosts. Can be used to perform an additional scan on this hosts.
              Can be useful to generate a list of IPs for masscan with nmap (masscan has a more limited support for IP lists):
                nmap -Pn -n -sL -iL input.lst -oX all-ips.xml; nmap-parse-output all-ips.xml all-hosts
      
        banner [service-name]
              Extracts a list of all ports with a specific service (e.g. http, ms-wbt-server, smtp) in host:port format.
              Note: This command is intended for the masscan XML output only.
      
        blocked-ports 
              Extracts all ports in host:port format, which either admin-prohibited or tcpwrapped.
      
        group-by-ports 
              Groups hosts by open TCP ports and generates a human-readable list in the markdown format.
      
        group-by-product 
              Groups open ports by product name and generates a human-readable list in the markdown format. The command ignores ports with empty product name.
      
        group-by-service 
              Groups open ports by service name and generates a human-readable list in the markdown format.
      
        host-ports-protocol 
              Extracts a list of all *open* ports in host:port format and marks the protocol type (tcp, udp)
      
        host-ports 
              Extracts a list of all *open* ports in host:port format.
      
        hosts-to-port [port]
              Extracts a list of all hosts that have the given port open in 'host (hostname)' format.
      
        hosts 
              Generates a line break separated list of all hosts with open ports. Can be used to perform an additional scan on this hosts.
      
        http-info 
              Extracts a list of extra information about the HTTP ports from a script scan in the following format:
              host:port   service-name    service-tunnel  product  http-server-header  http-title   redirect_url
      
        http-ports 
              Generates a line separated list of all HTTP(s) ports. Script scan output is recommended.
              Currently, the following services are detected as HTTP: http, https, http-alt, https-alt, http-proxy, sip, rtsp, soap, vnc-http, caldav (potentially incomplete) and to get a more reliable result all ports which which have output in the http-methods script. 
              On ports where HTTPs and HTTP is responding, the HTTPs port is preferred.
      
        http-title 
              Extracts a list of HTTP HTML titles in the following format:
              host:port	HTML title
      
        nmap-cmdline 
              Shows the parameters passed to nmap of the runned scan
      
        port-info [port]
              Extracts a list of extra information about the given port in the following format:
              port;service-name;http-server-header;http title
      
        ports-reachable 
              Generates a comma-separated list of all reachable ports (open and closed, unfiltered). Can be used to verify if ports reachable from another host or generate port lists for specific environments.
      
        ports 
              Generates a comma-separated list of all open ports. Can be used to verify if open ports reachable from another host or generate port lists for specific environments. Closed/filtered ports are not shown in the list.
      
        product 
              Extracts all detected product names.
      
        search-product 
              Search in product names (case sensitive).
      
        service-names 
              Extracts all detected service names (on open ports).
      
        service [service-name]
              Extracts a list of all *open* ports with a specific service (e.g. http, ms-wbt-server, smtp) in host:port format.
      
        show-comments 
              Shows comments added by the comment-* commands.
      
        ssl-common-name 
              Extracts a list of TLS/SSL ports with the commonName and Subject Alternative Name in the following format:
              host:port	commonName	X509v3 Subject Alternative Name
      
        tls-ports 
              Extracts a list of all TLS ports in host:port format. Works only reliable after a script scan. Can be used to do a testssl.sh scan.
              Example testssl.sh command (generates a text and HTML report for each host):
                  for f in `cat ~/ssl-hosts.txt`; do ./testssl.sh --logfile ~/testssl.sh-results/$f.log --htmlfile ~/testssl.sh-results/$f.html $f; done
      
      
      Manipulate Scan Commands:
        comment-hosts [hosts] [comment]
              Comments a list of hosts in scan result. Expects a comma-separated list as input. The comment will be displayed in the HTML report.
              Example:
                  nmap-parse-output scan.xml comment-hosts '10.0.0.1,192.168.10.1' 'allowed services' | nmap-parse-output - html &gt; report.html
              You can comment hosts from another scan, too:
                  nmap-parse-output scan.xml comment-hosts $(./nmap-parse-output.sh scan-subnet.xml hosts | tr "\n" ",") 'this host was scanned in subnet, too.'
      
        comment-ports [ports] [comment]
              Comments a list of ports or hosts with port (in address:port format) in scan result. Expects a comma-separated list as input. The comment will be displayed in the HTML report.
              Example:
                  nmap-parse-output scan.xml comment-ports '80,10.0.0.1:8080' 'allowed services' | nmap-parse-output - html &gt; report.html
              You can comment services, too:
                  nmap-parse-output scan.xml comment-ports $(./nmap-parse-output.sh scan.xml service http | tr "\n" ",") 'this is a http port'
      
        exclude-ports [ports]
              Excludes a list of ports or ports of a specific host (in address:port format) from a scan result. Expects a comma-separated list as input.
              You can pipe the output, for instance:
                  nmap-parse-output scan.xml exclude '80,443,192.168.0.2:80' | nmap-parse-output - service-names
      
        exclude [hosts]
              Excludes a list of hosts from scan result by its IP address. Expects a comma-separated list as input.
              You can pipe the output, for instance:
                  nmap-parse-output scan.xml exclude '192.168.1.1,192.168.1.20' | nmap-parse-output - service-names
      
        include-ports [ports]
              Filter a scan by a list of ports or ports of a specific host (in address:port format) so that only the specified ports are in the output. Expects a comma-separated list as input.
              You can pipe the output, for instance:
                  nmap-parse-output scan.xml include-ports '80,443,192.168.0.2:8080' | nmap-parse-output - http-title
      
        include [hosts]
              Filter a scan by a list of hosts so that only the specified hosts are in the output.
              Filter a list of hosts from scan result by its IP address. Expects a comma-separated list as input.
              You can pipe the output, for instance:
                  nmap-parse-output scan.xml include '192.168.1.1,192.168.1.20' | nmap-parse-output - service-names
      
        mark-ports [ports] [color]
              Marks a list of ports or hosts with port (in address:port format) with the given color in scan result. Expects a comma-separated list as input. The comment will be displayed in the HTML report.
              Example:
                  nmap-parse-output scan.xml mark-ports '80,10.0.0.1:8080' red | nmap-parse-output - html &gt; report.html
      
        reachable 
              Removes all hosts where all ports a filtered. Can be used to generate a smaller HTML report.
              Example usage to generate HTML report:
                  nmap-parse-output scan.xml reachable | nmap-parse-output - html &gt; scan.html
      
      
      Convert Scan Commands:
        html-bootstrap 
              Converts the XML output into a fancy HTML report based on Bootstrap.
              Note: This HTML report requests JS/CSS libs from CDNs. However, the generated file uses the no-referrer meta tag and subresource integrity to protect the confidentiality.
      
        html 
              Converts a XML output into a HTML report
      
        to-json 
              Converts a nmap scan output to JSON
      
      
      Misc Commands:
      
      [v1.5.1]

## Changelog

* v1.5.1
  * More reliable SSL/TLS detection
  * More reliable HTTP(s) port detection
  * Added group-by-service command
  * Added group-by-product command
  * Added http-info command
  * Added http-server-header to port-info command
  * Added hostname to group-by-ports command
* v1.4.6
  * Added search-product command
  * Added group-by-ports command
  * Added examples for generating subreports, group-by-ports command, and rerun scans
* v1.4.5
  * Show only service-names of open ports
  * Splitted ports command in: ports and ports-reachable
  * Added show-comments command
* v1.4.4
  * Fixed bug in [bash completion](_nmap-parse-output) when installed system-wide
  * Improved documentation
* v1.4.3
  * Fixed bug in [include-ports command](nmap-parse-output-xslt/include-ports.xslt)
* v1.4.2
  * Added [nmap-bootstrap-xsl](https://github.com/honze-net/nmap-bootstrap-xsl) as [html-bootstrap command](nmap-parse-output-xslt/html-bootstrap.xslt)
  * Added [nmap-cmdline command](nmap-parse-output-xslt/nmap-cmdline.xslt)
  * Added [host-ports-protocol command](nmap-parse-output-xslt/host-ports-protocol.xslt)
* v1.4.1
  * Improved error handling
  * Bugfix in ports command
* v1.4.0
  * Support for unfinished scans
  * Commands are categorized as convert, manipulate, extract and misc now
* v1.3.0
  * First public release

## Contribute

### Adding new Commands

Commands are written as [XSLT](https://en.wikipedia.org/wiki/XSLT). See [nmap-parse-output-xslt/](nmap-parse-output-xslt/) if you want to add new commands. A good way is mostly copying an existing script that does something similar.

The documentation printed in the help page can be written with the ``<comment>`` tag (XML namespace: http://xmlns.sven.to/npo). A command can have one of the following categories: convert, manipulate or extract. You can set it with the ``<category>`` tag. It is not necessary to set a category, uncategorized commands are will be shown as a misc command in the help page. Commands with an invalid category will not be shown on the help page.

Parameters will be passed as variables named ``$param1``, ``$param2`` and so on. An post processing command can be added with the ``<post-processor>`` tag.

Example XSLT file:

    <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
    <npo:comment>
            <!-- Added documentation here -->
    </npo:comment>
    <npo:category>extract</npo:category>
    <npo:post-processor>sort | uniq</npo:post-processor>
    
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    
    <xsl:template match="/nmaprun/host/ports/port">
        <!-- add your template here -->
        <xsl:if test="state/@state = $param1">
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

## Installation

Requierements:
* bash
* [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html)

Check out the repository and run it:

      git clone https://github.com/ernw/nmap-parse-output.git
      cd nmap-parse-output
      ./nmap-parse-output

You can create a link to the ``nmap-parse-output`` script in your local bin directory or add the directory into your path if you want to execute it directly. Add the following line into your ``~/.bash_profile`` or your ``~/.zshrc`` file:

      export PATH="$PATH:$PATH_TO_YOUR_NMAP_PARSE_OUTPUT_DIR"

### Bash Completion

Bash completion can be enabled by adding the following line to your `~/.bash_profile` or `.bashrc`:

    source ~/path/to/nmap-parse-output/_nmap-parse-output

### ZSH Completion

ZSH completion can be enabled by adding the following line to your `~/.zshrc`:

    autoload bashcompinit && bashcompinit && source ~/path/to/nmap-parse-output/_nmap-parse-output

### Arch Linux

You can use the [AUR](https://aur.archlinux.org) package: https://aur.archlinux.org/packages/nmap-parse-output