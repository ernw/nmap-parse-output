<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts a list of extra information about the HTTP ports from a script scan in the following format:
        host:port   service-name    service-tunnel  product  http-server-header  http-title   redirect_url
</npo:comment>
<npo:category>extract</npo:category>
<npo:post-processor>sort | uniq</npo:post-processor>
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port">
        <xsl:if test="script/@id='http-methods' and state[@state = 'open']">
            <xsl:value-of select="../../address/@addr"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="@portid"/><xsl:text>	</xsl:text>
            <xsl:value-of select="service/@name"/><xsl:text>	</xsl:text>
            <xsl:value-of select="service/@tunnel"/><xsl:text>	</xsl:text>
            <xsl:value-of select="service/@product"/><xsl:text>	</xsl:text>
            <xsl:value-of select="script[@id='http-server-header']/@output"/><xsl:text>	</xsl:text>
            <xsl:value-of select="script[@id='http-title']/elem[@key='title']"/><xsl:text>	</xsl:text>
            <xsl:value-of select="script[@id='http-title']/elem[@key='redirect_url']"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
