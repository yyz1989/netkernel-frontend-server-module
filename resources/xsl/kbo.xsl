<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:kbo="http://data.kbodata.be/def#"
	xmlns:locn="http://www.w3.org/ns/locn#"
	xmlns:org="http://www.w3.org/ns/org#"
	xmlns:oslo="http://purl.org/oslo/ns/localgov#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:rov="http://www.w3.org/ns/regorg#"
	xmlns:schema="http://schema.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:void="http://rdfs.org/ns/void#"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:nk="http://1060.org"
	xmlns:pt="http://www.proxml.be/xpath/functions/"
	xmlns:dct="http://purl.org/dc/terms/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcat="http://www.w3.org/ns/dcat#"
	xmlns:cc="http://creativecommons.org/ns#"
	xmlns:pav="http://purl.org/pav/"
	exclude-result-prefixes="foaf kbo locn org oslo owl rdf rdfs rov schema skos vcard xsd xsl void prov nk dct pt dc dcat cc pav"
	version="2.0">
	<xsl:output
		indent="yes"
		method="xhtml"
		encoding="UTF-8"/>
	<xsl:key
		name="label"
		match="rdf:Description"
		use="@rdf:about"/>
	<xsl:function
		name="pt:q2uri">
		<xsl:param
			name="q"/>
		<xsl:sequence
			select="concat(namespace-uri($q),local-name($q))"/>
	</xsl:function>
	<xsl:variable name="titles" as="element()+">
			<rdfs:label/>
			<skos:preflabel/>
			<dct:title/>
	</xsl:variable>
	<xsl:template
		match="/">
		<xsl:apply-templates
			select="rdf:RDF/rdf:Description[rdf:type]"/>
	</xsl:template>
	<xsl:template
		match="rdf:Description[rdf:type]">
		<xsl:variable
			name="identifier">
			<xsl:value-of
				select="descendant::rdf:Description[rdf:type]/@rdf:about"/>
		</xsl:variable>
		<xsl:variable
			name="docid">
			<xsl:value-of
				select="substring-before(@rdf:about,'#')"/>
		</xsl:variable>
		<html>
			<head>
				<title>
					<xsl:choose>
						<xsl:when
							test="org:identifier">
							<xsl:value-of
								select="concat('Vlaanderen: ', org:identifier)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat('Vlaanderen: ', rdfs:label[1])"/>
						</xsl:otherwise>
					</xsl:choose>

				</title>
				<meta
					name="viewport"
					content="width=device-width, minimum-scale=1.0, maximum-scale=1.0"/>
				<link
					rel="alternate"
					type="application/rdf+xml"
					href="{$docid}.rdf"/>
				<link
					rel="alternate"
					type="text/turtle"
					href="{$docid}.ttl"/>
				<link
					rel="alternate"
					type="text/plain"
					href="{$docid}.nt"/>
				<link
					rel="alternate"
					type="application/ld+json"
					href="{$docid}.jsonld"/>
				<style type="text/css">
					@import url(/css/page.css);
					@import url(/css/resource.css);
					@import url(/css/responsive.css);
					@import url(/css/print.css);</style>
				<link
					rel="shortcut icon"
					href="/img/favicon.png"/>
			</head>
			<body>
				<div
					id="header">
					<div
						id="logo">
						<a
							href="/">
							<span>LOD VL</span>
						</a>
					</div>
					<!--<div id="lang-nav">
						<a href="#nl" data-lang="nl">NL</a>
						<a href="#fr" data-lang="fr">FR</a>
					</div>-->
				</div>
				<div
					id="content">
					<div
						class="export-options">
						<a
							href="">HTML</a>
						<a
							href="{$docid}.jsonld">JSON-LD</a>
						<a
							href="{$docid}.ttl">TURTLE</a>
						<a
							href="{$docid}.nt">N-TRIPLES</a>
						<a
							href="{$docid}.rdf">XML</a>
					</div>
					<h1>
						<xsl:variable name="title">
							<xsl:choose>
								<xsl:when test="rdfs:label">
									<xsl:value-of select="rdfs:label"/>
								</xsl:when>
								<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="skos:prefLabel">
										<xsl:value-of select="skos:prefLabel"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="dct:title"/>
									</xsl:otherwise>
								</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when
								test="$title[@xml:lang]">
								<xsl:for-each
									select="$title[@xml:lang]">
									<span
										xml:lang="{@xml:lang}">
										<xsl:value-of
											select="normalize-space(.)"/>
									</span>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of
									select="$title"/>
							</xsl:otherwise>
						</xsl:choose>
					</h1>
					<div
						class="properties">
						<xsl:for-each-group
							select="/descendant::rdf:Description[rdf:type]/rdfs:label|skos:prefLabel|dct:title"
							group-by="node-name(.)">
							<xsl:sort select="local-name(.)"/>
							<div
								class="predicate">
								<a
									class="label"
									href="{concat(namespace-uri(.),local-name(.))}">
									<xsl:value-of
										select="current-grouping-key()"/>
								</a>
								<div
									class="objects">
									<xsl:for-each
										select="current-group()">
										<xsl:sort/>
										<span>
											
											<xsl:if test="@xml:lang">
												<xsl:attribute name="xml:lang">
													<xsl:value-of select="@xml:lang"/>
												</xsl:attribute>
											</xsl:if>
											
											<xsl:value-of select="."/>
										</span>		
									</xsl:for-each>
								</div>
							</div>
						</xsl:for-each-group>	
					</div>
					<div
						class="properties">
						<xsl:for-each-group
							select="/descendant::rdf:Description[rdf:type]/*[not(@rdf:resource)] except (dct:title|rdfs:label|skos:prefLabel)"
							group-by="node-name(.)">
							<xsl:sort select="local-name(.)"/>
							<div
								class="predicate">
								<a
									class="label"
									href="{concat(namespace-uri(.),local-name(.))}">
									<xsl:value-of
										select="current-grouping-key()"/>
								</a>
								<div
									class="objects">
									<xsl:for-each
										select="current-group()">
										<xsl:sort/>
										<span>
					
											<xsl:if test="@xml:lang">
												<xsl:attribute name="xml:lang">
													<xsl:value-of select="@xml:lang"/>
												</xsl:attribute>
											</xsl:if>
								
													<xsl:value-of select="."/>
										</span>		
									</xsl:for-each>
								</div>
							</div>
						</xsl:for-each-group>	
					</div>
					<div
						class="links outbound">
						<xsl:for-each-group
							select="/descendant::rdf:Description[rdf:type]/*[@rdf:resource] except rdfs:isDefinedBy"
							group-by="node-name(.)">
							<xsl:sort select="local-name(.)"/>
							<div
								class="predicate">
								<a
									class="label"
									href="{concat(namespace-uri(.),local-name(.))}">
									<xsl:value-of
										select="current-grouping-key()"/>
								</a>
								<div
									class="objects">
									<xsl:for-each
										select="current-group()">
										<xsl:sort/>
										<xsl:choose>
											<xsl:when test="not(contains(@rdf:resource,'bnode'))">
												<a href='{@rdf:resource}'>
													<xsl:choose>
														<xsl:when test="/descendant::rdf:Description[not(rdf:type)][@rdf:about = current()/@rdf:resource][rdfs:label]">
															<xsl:value-of select="/descendant::rdf:Description[not(rdf:type)][@rdf:about = current()/@rdf:resource]/rdfs:label"/>
														</xsl:when>
														<xsl:otherwise><xsl:value-of
															select="@rdf:resource"/></xsl:otherwise>
													</xsl:choose>
												</a>	
											</xsl:when>
											<xsl:otherwise>
												
												<xsl:choose>
													<xsl:when test="/descendant::rdf:Description[not(rdf:type)][@rdf:about = current()/@rdf:resource][rdfs:label]">
														<xsl:value-of select="/descendant::rdf:Description[not(rdf:type)][@rdf:about = current()/@rdf:resource]/rdfs:label"/>
													</xsl:when>
													<xsl:otherwise><xsl:value-of
														select="@rdf:resource"/></xsl:otherwise>
												</xsl:choose>
												
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</div>
							</div>
						</xsl:for-each-group>
					</div>
					<xsl:if
						test="/descendant::rdf:Description[not(rdf:type) and *[@rdf:resource]]">
						<h2
							class="links-heading">References from other resources</h2>
						<div
							class="links inbound">
							<xsl:for-each-group
								select="/descendant::rdf:Description[not(rdf:type)]/*[@rdf:resource and namespace-uri() != 'http://purl.org/dc/terms/']"
								group-by="node-name(.)">
								<!--<xsl:sort select="current-grouping-key()"/>-->
								<div
									class="predicate">
									<a
										class="label"
										href="{concat(namespace-uri(.),local-name(.))}">
										<xsl:value-of
											select="current-grouping-key()"/>
									</a>
									<div
										class="objects">
										<xsl:variable
											name="list"
											as="node()*">
											<xsl:for-each
												select="current-group()">
												<xsl:for-each
												select="following-sibling::rdfs:label">
												<xsl:copy>
												<xsl:copy-of
												select="@*"/>
												<xsl:attribute
												name="parentid"
												select="parent::rdf:Description/@rdf:about"/>
												<xsl:attribute
												name="value"
												select="text()"/>
												</xsl:copy>
												</xsl:for-each>
											</xsl:for-each>
										</xsl:variable>
										<xsl:for-each
											select="$list">
											<xsl:sort
												select="@value"/>
											<p><a
												href="{@parentid}">
												<xsl:if
												test="@xml:lang">
												<xsl:copy-of
												select="@xml:lang"/>
												</xsl:if>
												<xsl:value-of
												select="@value"/>
											</a></p>
										</xsl:for-each>
									</div>
								</div>
							</xsl:for-each-group>
						</div>
					</xsl:if>
				</div>
				<div
					id="footer">
					<!--<div>
						<span class="copyright">
							<span>© 2014</span>
							<a class="proxml" href="http://www.proxml.be"><span>ProXML</span></a>
							<a class="elephantbird" href="http://netkernelbook.org"><span>Elephant Bird Consulting</span></a>
						</span>
						<span class="powered-by">
							<a class="netkernel" href="http://www.1060research.com"><span>NetKernel</span></a>
							<a class="stardog" href="http://stardog.com"><span>Stardog</span></a>
						</span>
					</div>-->
				</div>
				<script type="text/javascript" src="/lib/jquery/jquery-1.11.0.min.js"/>
				<script type="text/javascript" src="/lib/jquery/jquery.cookie.js"/>
				<script type="text/javascript" src="/js/kbodata.js"/>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
