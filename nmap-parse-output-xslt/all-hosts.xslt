<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Generates a line break separated list of all hosts. Can be used to perform an additional scan on this hosts.
        Can be useful to generate a list of IPs for masscan with nmap (masscan has a more limited support for IP lists):
          nmap -Pn -n -sL -iL input.lst -oX all-ips.xml; nmap-parse-output all-ips.xml all-hosts
</npo:comment>
<npo:category>extract</npo:category>
<npo:post-processor>sort | uniq</npo:post-processor>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    
    <xsl:template match="/nmaprun/host/address">
        <xsl:value-of select="@addr"/>
        <xsl:text>
</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" />
</xsl:stylesheet>
