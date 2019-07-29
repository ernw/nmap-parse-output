<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo"
    xmlns:func="http://exslt.org/functions"
    xmlns:set="http://exslt.org/sets"
    extension-element-prefixes="func npo set">
<npo:comment>
        Groups hosts by open TCP ports and generates a human-readable list in the markdown format.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <func:function name="npo:portlist">
        <xsl:param name="host" />
        <xsl:variable name="result">
            <xsl:for-each select="$host/ports/port[@protocol = 'tcp']/state[@state = 'open']/../@portid">
                <xsl:if test="position() != 1">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <func:result select="$result" />
    </func:function>

    <xsl:key name="key" match="/nmaprun/host"
      use="npo:portlist(.)"/>

    <xsl:template match="/nmaprun">
        <xsl:for-each select=
     "host[generate-id(.)=generate-id(key('key', npo:portlist(.))[1])]">
            <xsl:choose>
                <xsl:when test="npo:portlist(.) = ''">
                    <xsl:text>- No open TCP ports</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>- Open TCP ports </xsl:text>
                    <xsl:value-of select="npo:portlist(.)"/>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:text> on:
</xsl:text>
            <xsl:for-each select="key('key', npo:portlist(.))">
                <xsl:text>  - </xsl:text><xsl:value-of select="address/@addr"/><xsl:if test="hostnames/hostname"> (<xsl:value-of select="hostnames/hostname/@name"/>)</xsl:if><xsl:text>
</xsl:text>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
