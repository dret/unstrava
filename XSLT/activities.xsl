<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:gpx="http://www.topografix.com/GPX/1/1" xmlns:saxon="http://saxon.sf.net/" xmlns:gpxslt="http://github.com/dret/unstrava">
    <!-- -->
    <xsl:include href="GPX.xsl"/>
    <!-- -->
    <xsl:variable name="data" select="'../GPX/'"/>
    <xsl:variable name="geojson" select="'../GeoJSON/'"/>
    <xsl:variable name="user" select="'chris'"/>
    <!-- -->
    <xsl:template match="/">
        <xsl:variable name="activities">
            <activities xsl:exclude-result-prefixes="xs gpx saxon gpxslt">
                <xsl:for-each select="uri-collection(concat($data, $user, '/', '?select=*.gpx'))">
                    <xsl:variable name="file" select="."/>
                    <xsl:for-each select="doc(.)!saxon:discard-document(.)">
                        <activity>
                            <xsl:attribute name="date" select="substring(/gpx:gpx/gpx:metadata/gpx:time, 1, 10)"/>
                            <xsl:variable name="track-name" select="replace($file, '.*/(.*?)', '$1')"/>
                            <xsl:attribute name="file" select="$track-name"/>
                            <xsl:attribute name="name" select="/gpx:gpx/gpx:trk/gpx:name"/>
                            <xsl:attribute name="type" select="substring-before(replace($track-name, '.*-(.*?)', '$1'), '.gpx')"/>
                            <xsl:attribute name="trk" select="count(/gpx:gpx/gpx:trk)"/>
                            <xsl:attribute name="trkseg" select="count(/gpx:gpx/gpx:trk/gpx:trkseg)"/>
                            <xsl:attribute name="trkpt" select="count(/gpx:gpx/gpx:trk/gpx:trkseg/gpx:trkpt)"/>
                            <xsl:if test="count(/gpx:gpx/gpx:trk/gpx:trkseg/gpx:trkpt) gt 2">
                                <xsl:attribute name="duration" select="xs:dateTime(/gpx:gpx/gpx:trk/gpx:trkseg/gpx:trkpt[last()]/gpx:time) - xs:dateTime(/gpx:gpx/gpx:trk/gpx:trkseg/gpx:trkpt[1]/gpx:time)"/>
                                <xsl:attribute name="ascent" select="gpxslt:trk-ascent(/gpx:gpx)"/>
                                <xsl:attribute name="descent" select="gpxslt:trk-descent(/gpx:gpx)"/>
                            </xsl:if>
                        </activity>
                    </xsl:for-each>
                </xsl:for-each>
            </activities>
        </xsl:variable>
        <xsl:result-document href="{$user}.xml" method="xml" indent="yes" exclude-result-prefixes="xs gpx saxon gpxslt">
            <xsl:sequence select="$activities"/>
        </xsl:result-document>
        <xsl:result-document href="{$user}.csv" method="text">
            <xsl:for-each select="$activities/activities/activity">
                <xsl:value-of select="@date"/>
                <xsl:text>,"</xsl:text>
                <xsl:value-of select="@name"/>
                <xsl:text>",</xsl:text>
                <xsl:value-of select="@type"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="concat(hours-from-duration(@duration), ':', minutes-from-duration(@duration), ':', seconds-from-duration(@duration))"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="@ascent"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="@descent"/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>