<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:gpx="http://www.topografix.com/GPX/1/1" xmlns:gpxslt="http://github.com/dret/unstrava">
    <!-- 
    in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
    out: Sequence of total ascent per track, as many values as there are tracks.
    -->
    <xsl:function name="gpxslt:trk-ascent" as="xs:double*">
        <xsl:param name="gpx" as="element(gpx:gpx)"/>
        <xsl:for-each select="$gpx/gpx:trk">
            <xsl:variable name="eles" select="gpx:trkseg/gpx:trkpt/gpx:ele/text()"/>
            <xsl:value-of select="sum(
                for $i in 1 to count($eles)-1
                return if ( $eles[$i+1]-$eles[$i] gt 0.0 ) then $eles[$i+1]-$eles[$i] else 0.0 )"/>
        </xsl:for-each>
    </xsl:function>
    <!-- 
    in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
    out: Sequence of total descent per track, as many values as there are tracks.
    -->
    <xsl:function name="gpxslt:trk-descent" as="xs:double*">
        <xsl:param name="gpx" as="element(gpx:gpx)"/>
        <xsl:for-each select="$gpx/gpx:trk">
            <xsl:variable name="eles" select="gpx:trkseg/gpx:trkpt/gpx:ele/text()"/>
            <xsl:value-of select="sum(
                for $i in 1 to count($eles)-1
                return if ( $eles[$i]-$eles[$i+1] gt 0.0 ) then $eles[$i]-$eles[$i+1] else 0.0 )"/>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>