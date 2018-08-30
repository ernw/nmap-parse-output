<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str npo">
<npo:comment>[hosts] [comment]
        Comments a list of hosts in scan result. Expects a comma-separated list as input. The comment will be displayed in the HTML report.
        Example:
            nmap-parse-output scan.xml comment-hosts '10.0.0.1,192.168.10.1' 'allowed services' | nmap-parse-output - html > report.html
        You can comment hosts from another scan, too:
            nmap-parse-output scan.xml comment-hosts $(./nmap-parse-output.sh scan-subnet.xml hosts | tr "\n" ",") 'this host was scanned in subnet, too.'
</npo:comment>
<npo:category>manipulate</npo:category>
<!-- see http://exslt.org/str/index.html -->


<xsl:variable name="comment-hosts" select="str:tokenize($param1, ',')" />

<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="@*|node()">
 <xsl:copy>
  <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="/nmaprun/host">
    <xsl:copy>
        <xsl:apply-templates select="@*|node()"/>
        <xsl:if test="$comment-hosts = address/@addr">
            <npo-comment><xsl:value-of select="$param2"/></npo-comment>
        </xsl:if>
    </xsl:copy>
</xsl:template>

</xsl:stylesheet>
