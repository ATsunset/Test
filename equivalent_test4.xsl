<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:owl="http://www.w3.org/2002/07/owl#"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns="http://graphml.graphdrawing.org/xmlns"
                xmlns:x="http://www.yworks.com/xml/yfiles-common/markup/3.0"
                xmlns:y="http://www.yworks.com/xml/yfiles-common/3.0" 
                xmlns:yfj="http://www.yworks.com/xml/yfiles-for-java/3.1"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml.java/3.1/ygraphml.xsd ">

  <!-- Stylesheet that transforms OWL web ontology files (http://www.w3.org/TR/owl-ref) to
       GraphML files (http://www.yworks.com/products/graphml).
       The resulting diagram depicts OWL classes as nodes and class relationships as edges.
       Currently, three kinds of relationships are considered: 
         rdfs:subClassOf, owl:equivalentClass.
  -->

  <xsl:output method="xml" indent="yes"/>
  <xsl:template match="/rdf:RDF">
    <graphml
xmlns="http://graphml.graphdrawing.org/xmlns"
xmlns:x="http://www.yworks.com/xml/yfiles-common/markup/3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:y="http://www.yworks.com/xml/yfiles-common/3.0" xmlns:yfj="http://www.yworks.com/xml/yfiles-for-java/3.1" xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns http://www.yworks.com/xml/schema/graphml.java/3.1/ygraphml.xsd ">
  <key attr.name="NodeLabels" for="node" id="d0" y:attr.uri="http://www.yworks.com/xml/yfiles-common/2.0/NodeLabels"/>

      <graph id="G" edgedefault="directed">
        <xsl:apply-templates select="owl:Class"/>
        <xsl:apply-templates
            select="owl:Class/rdfs:subClassOf[@rdf:resource]"/>
        <xsl:apply-templates select="owl:Class/owl:equivalentClass[owl:Class/owl:intersectionOf/rdf:Description]"/>
      </graph>
    </graphml>
  </xsl:template>
  <xsl:template match="/rdf:RDF/owl:Class">
    <xsl:element name="node">
      <xsl:attribute name="id">
        <xsl:call-template name="extractIdentifier">
          <xsl:with-param name="ofElement" select="."/>
        </xsl:call-template>
      </xsl:attribute>
	<data key="d0">
	 <x:List>
       <y:Label>
	    <y:Label.Text>
            <xsl:call-template name="extractLabel">
              <xsl:with-param name="ofElement" select="."/>
            </xsl:call-template>
        </y:Label.Text>
        </y:Label>
        </x:List>
	</data>
    </xsl:element>
  </xsl:template>
  <xsl:template match="/rdf:RDF/owl:Class/rdfs:subClassOf">
    <xsl:element name="edge">
      <xsl:attribute name="target">
          <xsl:value-of select="substring(@rdf:resource,1)"/>
      </xsl:attribute>
      <xsl:attribute name="source">
        <xsl:call-template name="extractIdentifier">
          <xsl:with-param name="ofElement" select="parent::node()"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template match="/rdf:RDF/owl:Class/owl:equivalentClass">
    <xsl:element name="edge">
      <xsl:attribute name="target">
        <xsl:call-template name="extractIdentifier">
          <xsl:with-param name="ofElement" select="./owl:Class/owl:intersectionOf/rdf:Description"/>
        </xsl:call-template>      </xsl:attribute>
      <xsl:attribute name="source">
        <xsl:call-template name="extractIdentifier">
          <xsl:with-param name="ofElement" select="parent::node()"/>
        </xsl:call-template>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>
  <xsl:template name="extractIdentifier">
      <xsl:param name="ofElement"/>
    <xsl:choose>
      <xsl:when test="$ofElement/@rdf:ID">
        <xsl:value-of select="$ofElement/@rdf:ID"/>
      </xsl:when>
      <xsl:when test="$ofElement/@rdf:about">
        <xsl:choose>
          <xsl:when test="substring($ofElement/@rdf:about,1,1) = '#'">
            <xsl:value-of select="substring($ofElement/@rdf:about,2)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$ofElement/@rdf:about"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-unknown-identifier-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="extractLabel">
  	  <xsl:param name="ofElement"/>
    <xsl:choose>
      <xsl:when test="$ofElement/@rdf:ID">
        <xsl:value-of select="$ofElement/@rdf:ID"/>
      </xsl:when>
      <xsl:when test="$ofElement/rdfs:label[@xml:lang = 'en']">
        <xsl:value-of select="$ofElement/rdfs:label[@xml:lang = 'en']"/>
      </xsl:when>
      <xsl:when test="$ofElement/@rdf:about">
        <xsl:choose>
          <xsl:when test="substring($ofElement/@rdf:about,1,1) = '#'">
            <xsl:value-of select="substring($ofElement/@rdf:about,2)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="substring-after(@rdf:about,'#')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-unknown-Label-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    <xsl:template name="extractSuperClassFromEquivalent">
  	  <xsl:param name="ofElement"/>
    <xsl:choose>
      <xsl:when test="$ofElement/owl:Class/owl:intersectionOf/rdf:Description/@rdf:about">
        <xsl:value-of select="$ofElement/owl:Class/owl:intersectionOf/rdf:Description/@rdf:about"/> 
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>-unknown-SuperClass-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
