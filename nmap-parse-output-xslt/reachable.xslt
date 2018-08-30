<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Removes all hosts where all ports a filtered. Can be used to generate a smaller HTML report.
        Example usage to generate HTML report:
            nmap-parse-output scan.xml reachable | nmap-parse-output - html &gt; scan.html
</npo:comment>
<npo:category>manipulate</npo:category>
<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*" />

<xsl:template match="@*|node()">
 <xsl:copy>
  <xsl:apply-templates select="@*|node()"/>
 </xsl:copy>
</xsl:template>

<xsl:template match="/nmaprun/host[descendant::status[@state='down']]" />
<!-- Ensure that to omit only hosts where _all_ ports are filtered -->
<xsl:template match="/nmaprun/host[not(./ports/port/state/@state='open') and not(./ports/port/state/@state='closed')]" />
<!-- and ./ports/extraports/@state='filtered'] -->

</xsl:stylesheet>
