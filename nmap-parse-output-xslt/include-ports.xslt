<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str npo">
<npo:comment>[ports]
        Filter a scan by a list of ports or ports of a specific host (in address:port format) so that only the specified ports are in the output. Expects a comma-separated list as input.
        You can pipe the output, for instance:
            nmap-parse-output scan.xml include-ports '80,443,192.168.0.2:8080' | nmap-parse-output - http-title
</npo:comment>
<npo:category>manipulate</npo:category>
<!-- see http://exslt.org/str/index.html -->


<xsl:variable name="include-ports" select="str:tokenize($param1, ',')" />

<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="@*|node()">
 <xsl:copy>
  <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="/nmaprun/host/ports/port">
    <xsl:if test="($include-ports = ./@portid) or ($include-ports = concat(../../address/@addr, ':', ./@portid))">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>
