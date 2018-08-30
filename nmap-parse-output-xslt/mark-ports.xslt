<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str npo">
<npo:comment>[ports] [color]
        Marks a list of ports or hosts with port (in address:port format) with the given color in scan result. Expects a comma-separated list as input. The comment will be displayed in the HTML report.
        Example:
            nmap-parse-output scan.xml mark-ports '80,10.0.0.1:8080' red | nmap-parse-output - html > report.html
</npo:comment>
<npo:category>manipulate</npo:category>
<!-- see http://exslt.org/str/index.html -->


<xsl:variable name="mark-ports" select="str:tokenize($param1, ',')" />

<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="@*|node()">
 <xsl:copy>
  <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="/nmaprun/host/ports/port">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <xsl:if test="$mark-ports = ./@portid or $mark-ports = concat(../../address/@addr, ':', ./@portid)">
            <npo-color-annotation><xsl:value-of select="$param2"/></npo-color-annotation>
        </xsl:if>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
