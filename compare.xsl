<xsl:stylesheet
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:exslt="http://exslt.org/common"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">

<xsl:param name="cssPath" select="''" />
<xsl:param name="oldPath" select="'INVALID_VALUE._NEED_TO_SET_oldPath'" />

<xsl:template name="diff">
  <xsl:param name="type"/>
  <xsl:param name="old"/>
  <xsl:param name="new"/>
  <xsl:param name="message">old="<xsl:value-of select="$old"/>" and new="<xsl:value-of select="$new"/>"</xsl:param>
  <xsl:message>DIFF: <xsl:value-of select="$type"/>: <xsl:value-of select="$message"/></xsl:message>
  <span class="message $type">[DIFF: <xsl:value-of select="$type"/>: <xsl:value-of select="$message"/>]</span>
</xsl:template>

<xsl:template match="/">
  <xsl:variable name="old" select="document($oldPath)"/>
  <xsl:choose>
    <xsl:when test="$oldPath = '' or count($old) = 0">
      <xsl:message> oldPath currently set to "<xsl:value-of select="$oldPath"/>" and csspath="<xsl:value-of select="$cssPath"/>"</xsl:message>
      <xsl:message>You must set the XSL param oldPath to point to a valid document to compare against</xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="children">
        <xsl:with-param name="old" select="$old"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="children">
  <xsl:param name="old"/>
  <xsl:variable name="newCount" select="count(node())"/>
  <xsl:for-each select="node()">
    <xsl:variable name="pos" select="position()"/>
    <xsl:apply-templates select=".">
      <xsl:with-param name="old" select="$old/node()[$pos]"/>
    </xsl:apply-templates>
  </xsl:for-each>
  <xsl:if test="count($old/node()) &gt; $newCount">
    <span class="removed">
      <xsl:call-template name="diff">
        <xsl:with-param name="type">remove</xsl:with-param>
        <xsl:with-param name="old" select="count($old/node()) - $newCount"/>
      </xsl:call-template>
      <xsl:apply-templates mode="ident" select="$old/node()[position() &gt; $newCount]"/>
    </span>
  </xsl:if>
</xsl:template>

<xsl:template match="@*">
  <xsl:copy/>
</xsl:template>
<xsl:template match="node()">
  <xsl:param name="old"/>
  <xsl:copy>
    <xsl:apply-templates select="@*"/>
    <xsl:call-template name="children">
      <xsl:with-param name="old" select="$old"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>

<xsl:template mode="ident" match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates mode="ident" select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!-- Inject a style so the Report is "colorful" -->
<xsl:template match="h:head">
  <xsl:copy>
    <xsl:apply-templates mode="ident" select="node()"/>
    <xsl:call-template name="head-styling"/>
  </xsl:copy>
</xsl:template>

<xsl:template name="head-styling">
  <xsl:choose>
    <xsl:when test="$cssPath != ''">
      <link rel="stylesheet" href="{$cssPath}"/>
    </xsl:when>
    <xsl:otherwise>
      <!-- <base href=".."/> -->
    </xsl:otherwise>
  </xsl:choose>
  <style>
    .message  { background-color: #ffffcc !important; border: 1px dashed; display: inherit; }
    .added    { background-color: #ccffcc !important; border: 1px dashed; display: inherit; }
    .removed  { background-color: #ffcccc !important; border: 1px dashed; display: inherit; }
  </style>
</xsl:template>

<xsl:template match="*">
  <xsl:param name="old"/>
  <xsl:if test="self::h:body and not(preceding-sibling::h:head)">
    <xsl:call-template name="head-styling"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="not($old)">
      <span class="added">
        <xsl:call-template name="diff">
          <xsl:with-param name="type">add</xsl:with-param>
          <xsl:with-param name="new">
            <xsl:value-of select="name(.)"/>
            <xsl:if test="@class"> class="<xsl:value-of select="@class"/>"</xsl:if>
            <xsl:if test="@style"> style="<xsl:value-of select="@style"/>"</xsl:if>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:apply-templates mode="ident" select="."/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="name(.) != name($old)">
        <xsl:call-template name="diff">
          <xsl:with-param name="type">tag</xsl:with-param>
          <xsl:with-param name="old" select="name($old)"/>
          <xsl:with-param name="new" select="name(.)"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:if test="string(./@class) != string($old/@class)">
          <xsl:call-template name="diff">
            <xsl:with-param name="type">class</xsl:with-param>
            <xsl:with-param name="old" select="$old/@class"/>
            <xsl:with-param name="new" select="./@class"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="string(./@style) != string($old/@style)">
          <xsl:call-template name="diff">
            <xsl:with-param name="type">style</xsl:with-param>
            <xsl:with-param name="old" select="$old/@style"/>
            <xsl:with-param name="new" select="./@style"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="children">
          <xsl:with-param name="old" select="$old"/>
        </xsl:call-template>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()">
  <xsl:param name="old"/>
  <xsl:choose>
    <xsl:when test="normalize-space(string(.)) != normalize-space(string($old))">
      <xsl:call-template name="diff">
        <xsl:with-param name="type">text</xsl:with-param>
        <xsl:with-param name="old" select="$old"/>
        <xsl:with-param name="new" select="string(.)"/>
      </xsl:call-template>
      <xsl:copy/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
