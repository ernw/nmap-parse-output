<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>[port]
        Extracts a list of extra information about the given port in the following format:
        port;service-name;http-server-header;http title
</npo:comment>
<npo:category>extract</npo:category>
<npo:post-processor>sort | uniq</npo:post-processor>
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port">
        <xsl:if test="@portid=$param1 and state[@state = 'open']">
            <xsl:value-of select="service/@name"/><xsl:text>;</xsl:text>
            <xsl:value-of select="service/@product"/><xsl:text>;</xsl:text>
            <xsl:value-of select="script[@id='http-server-header']/@output"/><xsl:text>;</xsl:text>
            <xsl:value-of select="script[@id='http-title']/elem[@key='title']"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
