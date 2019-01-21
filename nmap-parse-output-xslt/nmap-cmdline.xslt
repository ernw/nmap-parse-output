<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Shows the parameters passed to nmap of the runned scan
</npo:comment>
<npo:category>extract</npo:category>
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun">
        <xsl:value-of select="@scanner"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@args"/>
        <xsl:text>
</xsl:text>
        <xsl:text># </xsl:text>
        <xsl:text>started: </xsl:text><xsl:value-of select="@startstr"/>
        <xsl:text>; version: </xsl:text><xsl:value-of select="@version"/>
        <xsl:text>
</xsl:text>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
