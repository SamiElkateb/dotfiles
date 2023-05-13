<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output indent="yes" method="html" />
<xsl:strip-space elements="*" />
<xsl:template match="/">
<xsl:apply-templates select="//div[@id='sidenav']"/>
</xsl:template>
<xsl:template match="a">
<!-- <xsl:value-of select="text()" />&#160;<xsl:value-of select="@href" /> -->
<xsl:value-of select="text()" />;<xsl:value-of select="@href" />
<xsl:text>&#xa;</xsl:text>
</xsl:template>
<xsl:template match="a/text()[normalize-space()]">
<xsl:value-of select="normalize-space()"/>
</xsl:template>
<xsl:template match="a/text()[not(normalize-space())]" />
</xsl:stylesheet>
