<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:func="http://exslt.org/functions"
    xmlns:set="http://exslt.org/sets"
    extension-element-prefixes="func npo set">
<npo:comment>
        Groups open ports by service name and generates a human-readable list in the markdown format.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <func:function name="npo:service-name">
        <xsl:param name="port" />
        <xsl:variable name="result">
            <xsl:value-of select="$port/service/@name" />
        </xsl:variable>
        <func:result select="$result" />
    </func:function>

    <xsl:key name="key" match="/nmaprun/host/ports/port[state/@state = 'open']"
      use="npo:service-name(.)"/>

    <xsl:template match="/nmaprun">
        <xsl:for-each select=
     "host/ports/port[generate-id(.)=generate-id(key('key', npo:service-name(.))[1])]">
            <xsl:choose>
                <xsl:when test="npo:service-name(.) = ''">
                    <xsl:text>- No service detected</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>- Service </xsl:text>
                    <xsl:value-of select="npo:service-name(.)"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text> on:
</xsl:text>
            <xsl:for-each select="key('key', npo:service-name(.))">
                <xsl:text>  - </xsl:text>
                <xsl:value-of select="../../address/@addr"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="@portid"/>
                <xsl:if test="../../hostnames/hostname"> (<xsl:value-of select="../../hostnames/hostname/@name"/>)</xsl:if>
                <xsl:if test="service/@product">; product: <xsl:value-of select="service/@product"/></xsl:if>
                <xsl:if test="service/@version">; version: <xsl:value-of select="service/@version"/></xsl:if>
                <xsl:text>
</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
