<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Extracts all detected product names.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <xsl:key name="serviceid" match="/nmaprun/host/ports/port/service/@product" use="." />
    
    <xsl:template match="/">
        <!-- distinct port numbers, see https://stackoverflow.com/questions/2291567/how-to-use-xslt-to-create-distinct-values -->
        <xsl:for-each select="/nmaprun/host/ports/port/service/@product[generate-id() = generate-id(key('serviceid',.)[1])]">
            <xsl:value-of select="."/>
            <xsl:text>
</xsl:text>
        </xsl:for-each>
        
<!--        TODO: filter for filtered ports? <xsl:if test="state[@state != 'filtered']"> -->
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
