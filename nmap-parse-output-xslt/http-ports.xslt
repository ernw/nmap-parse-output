<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Generates a line separated list of all HTTP(s) ports. Script scan output is recommended.
        Currently, the following services are detected as HTTP: http, https, http-alt, https-alt, http-proxy, sip, rtsp, soap, vnc-http, caldav (potentially incomplete) and to get a more reliable result all ports which which have output in the http-methods script. 
        On ports where HTTPs and HTTP is responding, the HTTPs port is preferred.
</npo:comment>
<npo:category>extract</npo:category>
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port[state/@state='open']">
        <xsl:if test="service/@name='http' or service/@name='https' or service/@name='http-alt' or service/@name='http-proxy' or service/@name='soap' or service/@name='sip' or service/@name='rtsp' or service/@name='vnc-http'  or service/@name='caldav' or script/@id='http-methods'">
            <xsl:choose>
                <xsl:when test="service/@tunnel='ssl' or script[@id='ssl-cert'] or script[@id='ssl-date']">
                    <xsl:text>https://</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>http://</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
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
