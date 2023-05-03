<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="text" />
  <xsl:strip-space elements="*" />

  <xsl:template match="/"
    ><xsl:apply-templates select="//div[@id='main']"
  /></xsl:template>

  <xsl:template match="h1"
    ># <xsl:value-of select="text()" /><xsl:text>&#xa;</xsl:text></xsl:template
  >

  <xsl:template match="h2"
    ><xsl:text>&#xa;</xsl:text>## <xsl:value-of select="text()" /><xsl:text
      >&#xa;</xsl:text
    ></xsl:template
  >

  <xsl:template match="h3"
    ><xsl:text>&#xa;</xsl:text>### <xsl:value-of select="text()" /><xsl:text
      >&#xa;</xsl:text
    ></xsl:template
  >

  <xsl:template match="p"
    ><xsl:apply-templates /><xsl:text>&#xa;</xsl:text></xsl:template
  >

  <xsl:template match="code[contains(@class, 'w3-codespan')]">
    <xsl:text>&#160;</xsl:text><xsl:apply-templates /><xsl:text
      >&#160;</xsl:text
    >
  </xsl:template>

  <xsl:template match="div[contains(@class, 'w3-code')]"
  ><xsl:choose><xsl:when test="contains(@class, 'jsHigh')"
      >```javascript<xsl:apply-templates />```</xsl:when
      ><xsl:when test="contains(@class, 'pythonHigh')"
      >```python<xsl:apply-templates />```</xsl:when
      ><xsl:otherwise>```<xsl:apply-templates 
      />```</xsl:otherwise></xsl:choose><xsl:text
      >&#xa;</xsl:text
    ></xsl:template
  >

  <xsl:template match="div[contains(@class, 'w3-code')]//text()"
    ><xsl:value-of select="." disable-output-escaping="yes"
      /><xsl:text>&#xa;</xsl:text
  ></xsl:template>

  <xsl:template match="*[contains(@class, 'nextprev')]" />
  <xsl:template match="*[contains(@class, 'w3-btn')]" />

  <xsl:template match="p/text()[normalize-space()]"
    ><xsl:value-of select="normalize-space()" /><xsl:text
      >&#xa;</xsl:text
    ></xsl:template
  >

  <xsl:template match="p/text()[not(normalize-space())]" />

  <xsl:template match="table"
    ><xsl:apply-templates /><xsl:text>&#xa;</xsl:text></xsl:template
  >

  <xsl:template match="tr"
  ><xsl:choose
      ><xsl:when test="position() = 1"
        ><xsl:choose
          ><xsl:when test="count(th) = 0"
          ><xsl:for-each select="following-sibling::tr[1]/td">| |</xsl:for-each
            ><xsl:text>&#xa;</xsl:text
            ><xsl:for-each select="following-sibling::tr[1]/td">|-|</xsl:for-each
            ><xsl:text>&#xa;</xsl:text>|<xsl:apply-templates /></xsl:when
          ><xsl:otherwise
            ><xsl:apply-templates /><xsl:text>&#xa;</xsl:text>|</xsl:otherwise
          ></xsl:choose
        ></xsl:when
      ><xsl:when test="position() != last()"
        ><xsl:apply-templates /><xsl:text>&#xa;</xsl:text>|</xsl:when
      ><xsl:otherwise><xsl:apply-templates /></xsl:otherwise></xsl:choose
  ></xsl:template>

  <xsl:template match="td"
    ><xsl:text>&#160;</xsl:text><xsl:apply-templates /><xsl:text
      >&#160;</xsl:text
    >|</xsl:template
  >
  <xsl:template match="th"
    ><xsl:text>&#160;</xsl:text><xsl:apply-templates /><xsl:text
      >&#160;</xsl:text
    >|</xsl:template
  >
</xsl:stylesheet>
