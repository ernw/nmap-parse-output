<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts a list of TLS/SSL ports with the commonName and Subject Alternative Name in the following format:
        host:port	commonName	X509v3 Subject Alternative Name
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    <xsl:template match="/nmaprun/host/ports/port/script[@id='ssl-cert']">
            <xsl:value-of select="../../../address/@addr"/>
            <xsl:text>:</xsl:text>
            <xsl:value-of select="../@portid"/>
            <xsl:text>	</xsl:text>
            <xsl:value-of select="table[@key='subject']/elem[@key='commonName']"/>
            <xsl:text>	</xsl:text>
            <xsl:value-of select="table[@key='extensions']/table[elem[@key='name']='X509v3 Subject Alternative Name']/elem[@key='value']"/>
            <xsl:text>
</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
