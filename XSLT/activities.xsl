<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:gpx="http://www.topografix.com/GPX/1/1" xmlns:saxon="http://saxon.sf.net/" version="3.0">
    <!-- -->
    <xsl:variable name="activities" select="'../../../Dropbox/training'"/>
    <!-- -->
    <xsl:template match="/">
        <xsl:for-each select="uri-collection(concat($activities, '?select=*.gpx'))">
            <xsl:value-of select="."/>
            <xsl:for-each select="doc(.)!saxon:discard-document(.)">
                <xsl:value-of select="/gpx:gpx/gpx:trk/gpx:name"/>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>