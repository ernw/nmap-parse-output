<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts a list of all *open* ports in host:port format.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port">
        <xsl:if test="state[@state = 'open']">
            <xsl:value-of select="../../address/@addr"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="@portid"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
