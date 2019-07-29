<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts a list of all TLS ports in host:port format. Works only reliable after a script scan. Can be used to do a testssl.sh scan.
        Example testssl.sh command (generates a text and HTML report for each host):
            for f in `cat ~/ssl-hosts.txt`; do ./testssl.sh --logfile ~/testssl.sh-results/$f.log --htmlfile ~/testssl.sh-results/$f.html $f; done
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <!-- Reliable SSL/TLS detection: Sometimes only one of the three TLS detection attributes is set. -->
    <xsl:template match="/nmaprun/host/ports/port[state/@state='open' and (service/@tunnel='ssl' or script[@id='ssl-cert'] or script[@id='ssl-date'])]">
        <xsl:value-of select="../../address/@addr"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="@portid"/>
        <xsl:text>
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
