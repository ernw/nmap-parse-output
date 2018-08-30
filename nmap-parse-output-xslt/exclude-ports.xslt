<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str npo">
<npo:comment>[ports]
        Excludes a list of ports or ports of a specific host (in address:port format) from a scan result. Expects a comma-separated list as input.
        You can pipe the output, for instance:
            nmap-parse-output scan.xml exclude '80,443,192.168.0.2:80' | nmap-parse-output - service-names
</npo:comment>
<npo:category>manipulate</npo:category>
<!-- see http://exslt.org/str/index.html -->


<xsl:variable name="exclude-ports" select="str:tokenize($param1, ',')" />

<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="@*|node()">
 <xsl:copy>
  <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="/nmaprun/host/ports/port">
    <xsl:if test="not($exclude-ports = ./@portid) and not($exclude-ports = concat(../../address/@addr, ':', ./@portid))">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
