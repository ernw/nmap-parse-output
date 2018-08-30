<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts a list of all TLS ports in host:port format. Works only after a script scan. Can be used to do a testssl.sh scan.
        Example testssl.sh command (generates a text and HTML report for each host):
            for f in `cat ~/ssl-hosts.txt`; do ./testssl.sh --logfile ~/testssl.sh-results/$f.log --htmlfile ~/testssl.sh-results/$f.html $f; done
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port[script[@id='ssl-cert']]"><!-- Don't use service/@tunnel='ssl' because not all ssl ports has this attribute -->
        <xsl:value-of select="../../address/@addr"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="@portid"/>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
