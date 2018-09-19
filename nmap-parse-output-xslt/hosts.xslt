<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Generates a line break separated list of all hosts with open ports. Can be used to perform an additional scan on this hosts.
</npo:comment>
<npo:category>extract</npo:category>
<npo:post-processor>sort | uniq</npo:post-processor>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />
    
    <xsl:template match="/nmaprun/host/ports/port">
    
        <xsl:if test="state/@state='open'">
            <xsl:value-of select="../../address/@addr"/>
            <xsl:text>
</xsl:text>
        </xsl:if>
        <!-- distinct port numbers, see https://stackoverflow.com/questions/2291567/how-to-use-xslt-to-create-distinct-values -->
<!--        <xsl:for-each select="/nmaprun/host/ports/portaddress/@addr[generate-id() = generate-id(key('hostid',.)[1])]"> -->
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
