<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:p="http://www.evolus.vn/Namespace/Pencil"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="/p:Document/p:Properties/p:Property[@name='fileName']/text()"/>
                </title>
                <LINK rel="stylesheet" type="text/css" href="Resources/Style.css"><xsl:text> </xsl:text></LINK>
                <SCRIPT type="text/javascript" src="Resources/jquery.js"><xsl:text> </xsl:text></SCRIPT>

                <SCRIPT type="text/javascript">
                  $(function(){

                    $('.Page')
                    .css({display:'none'})
                    .first()
                    .css({display:'block'});

                    $('map area').bind('click',function(){
                      var hrefArr = this.href.split('#');
                      var id = hrefArr[hrefArr.length-1];

                      $('.Page').css({display:'none'}) // all hide
                      $('#'+id).css({display:'block'}); // show

                      return false;
                    });

                  });
                </SCRIPT>
            </head>
            <body>
                <xsl:apply-templates select="/p:Document/p:Pages/p:Page" />
            </body>
        </html>
    </xsl:template>
    <xsl:template match="p:Page">
        <div class="Page" id="{p:Properties/p:Property[@name='fid']/text()}_page">
            <h2>
                <xsl:value-of select="p:Properties/p:Property[@name='name']/text()"/>
            </h2>
            <div class="ImageContainer">
                <img src="{@rasterized}"
                    width="{p:Properties/p:Property[@name='width']/text()}"
                    height="{p:Properties/p:Property[@name='height']/text()}"
                    usemap="#map_{p:Properties/p:Property[@name='fid']/text()}"/>
            </div>
            <xsl:if test="p:Note">
                <p class="Notes">
                    <xsl:apply-templates select="p:Note/node()" mode="processing-notes"/>
                </p>
            </xsl:if>
            <map name="map_{p:Properties/p:Property[@name='fid']/text()}">
                <xsl:apply-templates select="p:Links/p:Link" />
            </map>
        </div>
    </xsl:template>
    <xsl:template match="p:Link">
        <area shape="rect"
            coords="{@x},{@y},{@x+@w},{@y+@h}" href="#{@targetFid}_page" title="Go to page '{@targetName}'"/>
    </xsl:template>
    
    <xsl:template match="html:*" mode="processing-notes">
        <xsl:copy>
            <xsl:copy-of select="@*[local-name() != '_moz_dirty']"/>
            <xsl:apply-templates mode="processing-notes"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="html:a[@page-fid]" mode="processing-notes">
        <a href="#{@page-fid}_page" title="Go tp page '{@page-name}'">
            <xsl:copy-of select="@class|@style"/>
            <xsl:apply-templates mode="processing-notes"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
