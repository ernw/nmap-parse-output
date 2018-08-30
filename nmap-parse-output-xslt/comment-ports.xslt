<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str npo">
<npo:comment>[ports] [comment]
        Comments a list of ports or hosts with port (in address:port format) in scan result. Expects a comma-separated list as input. The comment will be displayed in the HTML report.
        Example:
            nmap-parse-output scan.xml comment-ports '80,10.0.0.1:8080' 'allowed services' | nmap-parse-output - html > report.html
        You can comment services, too:
            nmap-parse-output scan.xml comment-ports $(./nmap-parse-output.sh scan.xml service http | tr "\n" ",") 'this is a http port'
</npo:comment>
<npo:category>manipulate</npo:category>
<!-- see http://exslt.org/str/index.html -->


<xsl:variable name="comment-ports" select="str:tokenize($param1, ',')" />

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
        <xsl:if test="$comment-ports = ./@portid or $comment-ports = concat(../../address/@addr, ':', ./@portid)">
            <npo-comment><xsl:value-of select="$param2"/></npo-comment>
        </xsl:if>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
