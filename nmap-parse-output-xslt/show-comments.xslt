<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:str="http://exslt.org/strings"
    extension-element-prefixes="str npo">
<npo:comment>
        Shows comments added by the comment-* commands.
</npo:comment>
<npo:category>extract</npo:category>
<!-- see http://exslt.org/str/index.html -->

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/npo-comment">
            <xsl:value-of select="../address/@addr"/>
            <xsl:text>	</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="/nmaprun/host/ports/port/npo-comment">
            <xsl:value-of select="../../../address/@addr"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="../@portid"/>
            <xsl:text>	</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="text()" />
</xsl:stylesheet>
