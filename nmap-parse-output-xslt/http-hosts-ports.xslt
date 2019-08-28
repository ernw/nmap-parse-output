<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Generates a line separated list of HTTP(s) all ports.
        Currently, the following services are detected as HTTP: http, https, http-alt, https-alt, http-proxy, sip, rtsp (potentially incomplete)
</npo:comment>
<npo:category>extract</npo:category>
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port">
        <xsl:if test="(service/@name='http' and not (service/@tunnel='ssl')) or service/@name='http-alt' or (service/@name='http-proxy' and not (service/@tunnel='ssl')) or (service/@name='sip' and not( script/@id='ssl-cert')) or (service/@name='rtsp' and not(script/@id='ssl-cert'))">
            <xsl:text>http://</xsl:text>
            <xsl:value-of select="../../hostnames/hostname/@name"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="@portid"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:if test="service/@name='https' or service/@name='https-alt' or (service/@name='sip' and script/@id='ssl-cert') or (service/@name='rtsp' and script/@id='ssl-cert') or (service/@name='http' and script/@id='ssl-cert') or (service/@name='http-alt' and script/@id='ssl-cert') or (service/@name='http-proxy' and script/@id='ssl-cert') or (service/@name='http' and (service/@tunnel='ssl')) or (service/@name='http-proxy' and (service/@tunnel='ssl')) ">
            <xsl:text>https://</xsl:text>
            <xsl:value-of select="../../hostnames/hostname/@name"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="@portid"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
