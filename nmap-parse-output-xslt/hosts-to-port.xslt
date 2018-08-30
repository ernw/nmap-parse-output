<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>[port]
        Extracts a list of all hosts that have the given port open in 'host (hostname)' format.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port">
        <xsl:if test="@portid=$param1 and state[@state = 'open']">
            <xsl:value-of select="../../address/@addr"/>
            <xsl:if test="../../hostnames/hostname"> (<xsl:value-of select="../../hostnames/hostname/@name"/>)</xsl:if>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
