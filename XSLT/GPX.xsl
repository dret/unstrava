<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:gpx="http://www.topografix.com/GPX/1/1" xmlns:gpxslt="http://github.com/dret/unstrava" xmlns:math="http://www.w3.org/2005/xpath-functions/math">
    <!-- -->
    <!-- A set of helper functions to work with GPX files. Please keep in mind that all units are metric. There is no option for other units of measurements. -->
    <!-- -->
    <xsl:function name="gpxslt:trk-ascent" as="xs:double*">
        <!-- 
        in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
        out: Sequence of total ascent per track, as many values as there are tracks.
        -->
        <xsl:param name="gpx" as="element(gpx:gpx)"/>
        <xsl:for-each select="$gpx/gpx:trk">
            <xsl:variable name="eles" select="gpx:trkseg/gpx:trkpt/gpx:ele/text()"/>
            <xsl:value-of select="sum(
                for $i in 1 to count($eles)-1
                return if ( $eles[$i+1]-$eles[$i] gt 0.0 ) then $eles[$i+1]-$eles[$i] else 0.0
                )"/>
        </xsl:for-each>
    </xsl:function>
    <!-- -->
    <xsl:function name="gpxslt:trk-descent" as="xs:double*">
        <!-- 
        in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
        out: Sequence of total descent per track, as many values as there are tracks.
        -->
        <xsl:param name="gpx" as="element(gpx:gpx)"/>
        <xsl:for-each select="$gpx/gpx:trk">
            <xsl:variable name="eles" select="gpx:trkseg/gpx:trkpt/gpx:ele/text()"/>
            <xsl:value-of select="sum(
                for $i in 1 to count($eles)-1
                return if ( $eles[$i]-$eles[$i+1] gt 0.0 ) then $eles[$i]-$eles[$i+1] else 0.0
                )"/>
        </xsl:for-each>
    </xsl:function>
    <!-- -->
    <xsl:function name="gpxslt:trk-distance" as="xs:double*">
        <!-- 
        in:  GPX document, using the GPX 1.1 schema/namespace and passed via the gpx:gpx element.
        out: Sequence of total distance per track, as many values as there are tracks.
        -->
        <xsl:param name="gpx" as="element(gpx:gpx)"/>
        <xsl:for-each select="$gpx/gpx:trk">
            <xsl:variable name="trkpts" select="gpx:trkseg/gpx:trkpt"/>
            <xsl:value-of select="sum(
                for $i in 1 to count($trkpts)-1
                return gpxslt:haversine($trkpts[$i]/@lat, $trkpts[$i]/@lon, $trkpts[$i+1]/@lat, $trkpts[$i+1]/@lon)
                )"/>
        </xsl:for-each>
    </xsl:function>
    <!-- -->
    <xsl:function name="gpxslt:haversine" as="xs:double">
        <!-- 
        in:  Two points in decimal coordinates.
        out: The distance between the points (in meters) according to the Haversine formula as described by http://stackoverflow.com/questions/365826/calculate-distance-between-2-gps-coordinates
        -->
        <xsl:param name="lat1" as="xs:double"/>
        <xsl:param name="lon1" as="xs:double"/>
        <xsl:param name="lat2" as="xs:double"/>
        <xsl:param name="lon2" as="xs:double"/>
        <xsl:variable name="dlat" select="($lat2 - $lat1) * math:pi() div 180"/>
        <xsl:variable name="dlon" select="($lon2 - $lon1) * math:pi() div 180"/>
        <xsl:variable name="rlat1" select="$lat1 * math:pi() div 180"/>
        <xsl:variable name="rlat2" select="$lat2 * math:pi() div 180"/>
        <xsl:variable name="a" select="math:sin($dlat div 2) * math:sin($dlat div 2) + math:sin($dlon div 2) * math:sin($dlon div 2) * math:cos($rlat1) * math:cos($rlat2)"/>
        <xsl:variable name="c" select="2 * math:atan2(math:sqrt($a), math:sqrt(1-$a))"/>
        <xsl:value-of select="xs:double($c * 6371000.0)"/>
    </xsl:function>
    <!-- -->
</xsl:stylesheet>