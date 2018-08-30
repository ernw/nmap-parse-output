<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts a list of HTTP HTML titles in the following format:
        host:port	HTML title
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port/script[@id='http-title']">
            <xsl:value-of select="../../../address/@addr"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="../@portid"/>
            <xsl:text>;</xsl:text>
            <xsl:value-of select="elem[@key='title']"/>
            <xsl:text>
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
