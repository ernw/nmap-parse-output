<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:npo="http://xmlns.sven.to/npo">
<npo:comment>
        Generates a comma-separated list of all open ports. Can be used to verify if open ports reachable from another host or generate port lists for specific environments. Closed/filtered ports are not shown in the list.
</npo:comment>
<npo:category>extract</npo:category>

    <xsl:output method="text" />
    <xsl:strip-space elements="*" />

    <xsl:key name="portid" match="/nmaprun/host/ports/port/state[@state = 'open']/../@portid" use="." />
    
    <xsl:template match="/">
        <!-- distinct port numbers, see https://stackoverflow.com/questions/2291567/how-to-use-xslt-to-create-distinct-values -->
        <xsl:for-each select="/nmaprun/host/ports/port/state[@state = 'open']/../@portid[generate-id() = generate-id(key('portid',.)[1])]">
            <xsl:if test="position() != 1">
                <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>
        
<!--        TODO: filter for filtered ports? <xsl:if test="state[@state != 'filtered']"> -->
    </xsl:template>

    <xsl:template match="text()" />
</xsl:stylesheet>
