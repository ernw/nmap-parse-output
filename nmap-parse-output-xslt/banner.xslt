<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>[service-name]
        Extracts a list of all ports with a specific service (e.g. http, ms-wbt-server, smtp) in host:port format.
        Note: This command is intended for the masscan XML output only.
</npo:comment>
<npo:category>extract</npo:category>
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port">
        <xsl:if test="service/@name=$param1">
            <xsl:value-of select="../../address/@addr"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="@portid"/>
            <xsl:text>	</xsl:text>
            <xsl:value-of select="service/@banner"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
