<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:func="http://exslt.org/functions"
    xmlns:set="http://exslt.org/sets"
    extension-element-prefixes="func npo set">
<npo:comment>
        Groups open ports by product name and generates a human-readable list in the markdown format. The command ignores ports with empty product name.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <func:function name="npo:product-name">
        <xsl:param name="port" />
        <xsl:variable name="result">
            <xsl:value-of select="$port/service/@product" />
        </xsl:variable>
        <func:result select="$result" />
    </func:function>

    <xsl:key name="key" match="/nmaprun/host/ports/port[state/@state = 'open' and service/@product]"
      use="npo:product-name(.)"/>

    <xsl:template match="/nmaprun">
        <xsl:for-each select=
     "host/ports/port[generate-id(.)=generate-id(key('key', npo:product-name(.))[1])]">
            <xsl:text>- Product </xsl:text>
            <xsl:value-of select="npo:product-name(.)"/>
            <xsl:text> on:
</xsl:text>
            <xsl:for-each select="key('key', npo:product-name(.))">
                <xsl:text>  - </xsl:text>
                <xsl:value-of select="../../address/@addr"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="@portid"/>
                <xsl:if test="../../hostnames/hostname"> (<xsl:value-of select="../../hostnames/hostname/@name"/>)</xsl:if>
                <xsl:if test="service/@version">; version: <xsl:value-of select="service/@version"/></xsl:if><xsl:text>
</xsl:text>

            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
