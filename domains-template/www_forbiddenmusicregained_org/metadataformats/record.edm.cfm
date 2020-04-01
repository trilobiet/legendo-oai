<cfsilent>
	<cfprocessingdirective suppresswhitespace=true />
	<cfset compositionUrl = "http://www.forbiddenmusicregained.org/search/composition/id/" & inventorynr />
	<cfset composerUrl = "http://www.forbiddenmusicregained.org/search/composer/id/" & inventorynrComposer />
	<cfset mediaBaseUrl = "http://www.forbiddenmusicregained.org/media/" & inventorynr />

	<cfif type eq "biography">
		<cfset description = beschrijving />
	<cfelse>
		<cfset description = ripHTML(beschrijving) />
	</cfif>

</cfsilent>

<cfoutput>

	<header>
		<identifier>#xmlFormat(identifier)#</identifier>
		<datestamp>#UTCDateTimeFormat(datestamp)#</datestamp>
		<setSpec>#xmlFormat(archivecode)#</setSpec>
	</header>

	<metadata>

		<rdf:RDF
			xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns##"
		    xmlns:oai="http://www.openarchives.org/OAI/2.0/"
		    xmlns:dc="http://purl.org/dc/elements/1.1/"
		    xmlns:dcterms="http://purl.org/dc/terms/"
		    xmlns:ore="http://www.openarchives.org/ore/terms/"
		    xmlns:edm="http://www.europeana.eu/schemas/edm/"
		    xmlns:skos="http://www.w3.org/2004/02/skos/core##"
		    xmlns:rdaGr2="http://rdvocab.info/ElementsGr2/"
		    >

			<edm:ProvidedCHO rdf:about="#xmlFormat(compositionUrl)#">

				<!--- dc:title --->
				<dc:title>#xmlFormat(title)#</dc:title>
				<!--- dc:language --->
				<dc:language>en</dc:language>
	   			<!--- dc:identifier --->
				<dc:identifier>#xmlFormat(inventorynr)#</dc:identifier>
				<!--- dc:source --->
				<cfif archiveCode neq ''><dc:source>#xmlFormat(archivecode)# #xmlFormat(archive)#</dc:source></cfif>
				<!--- dc:date --->
				<cfif dateBegin neq ''><dc:date>#dateFormat(dateBegin,"yyyy-mm-dd")#</dc:date></cfif>
				<cfif dateEnd neq ''><dc:date>#dateFormat(dateEnd,"yyyy-mm-dd")#</dc:date></cfif>
				<!--- dc:type --->
				<dc:type>#xmlFormat(type)#</dc:type>
				<!--- dc:description --->
				<dc:description><![CDATA[#description#]]></dc:description>
				<dc:description><![CDATA[#ripHTML(samenvatting)#]]></dc:description>
				<cfif locatieVast neq ''><dc:description> <![CDATA[location of manuscript: #ripHTML(locatieVast)#]]></dc:description></cfif>
				<cfif transcriptie neq ''><dc:description><![CDATA[#ripHTML(transcriptie)#]]></dc:description></cfif>
				<cfif htmltekst neq ''><dc:description><![CDATA[#ripHTML(htmltekst)#]]></dc:description></cfif>
				<!--- dc:creator --->
				<cfif vervaardiger neq ''>
					<dc:creator rdf:resource="#xmlFormat(composerUrl)#"/>
				</cfif>
				<!--- dc:subject --->
				<cfif genre neq ''><cfloop list="#genre#" delimiters="|" index="r"><dc:subject>#xmlFormat(r)#</dc:subject></cfloop></cfif>
				<cfif bezetting neq ''><cfloop list="#bezetting#" delimiters="|" index="r"><dc:subject>#xmlFormat(r)#</dc:subject></cfloop></cfif>
				<!--- dcterms:medium --->
				<cfif status neq ''><dcterms:medium>#xmlFormat(status)#</dcterms:medium></cfif>
				<!--- dcterms:provenance --->
				<dcterms:provenance>#xmlFormat(organization)#</dcterms:provenance>
				<!--- dcterms:extent --->
				<cfif minuten neq ''><dcterms:extent>#xmlFormat(minuten)# minutes</dcterms:extent></cfif>
				<cfif paginas neq ''><dcterms:extent>#xmlFormat(paginas)#</dcterms:extent></cfif>

				<edm:rights rdf:resource="http://rightsstatements.org/vocab/InC/1.0/" />
				<edm:type>TEXT</edm:type>

			</edm:ProvidedCHO>

			<edm:WebResource rdf:about="#xmlFormat(compositionUrl)#">
			</edm:WebResource>

			<cfloop list="#images#" delimiters="|" index="r">
			<edm:WebResource rdf:about="#xmlFormat(mediaBaseUrl & '/' & r )#">
			</edm:WebResource>
			</cfloop>

			<cfloop list="#videos#" delimiters="|" index="r">
				<cfif find("youtube",r)>
					<edm:WebResource rdf:about="#xmlFormat(getYoutubeUrlfromEmbed(r))#">
					</edm:WebResource>
				</cfif>
			</cfloop>

			<cfloop list="#documents#" delimiters="|" index="r">
			<edm:WebResource rdf:about="#xmlFormat(mediaBaseUrl & '/' & r )#">
			</edm:WebResource>
			</cfloop>

			<!--- edm:Agent --->
			<cfif vervaardiger neq ''>
			<edm:Agent rdf:about="#xmlFormat(composerUrl)#">
				<skos:prefLabel>#xmlFormat(vervaardiger)#</skos:prefLabel>
				<rdaGr2:professionOrOccupation xml:lang="en">Composer</rdaGr2:professionOrOccupation>
			</edm:Agent>
			</cfif>

			<ore:Aggregation rdf:about="#xmlFormat(compositionUrl)#">

				<edm:aggregatedCHO rdf:resource="#xmlFormat(compositionUrl)#"/>
				<edm:dataProvider>#xmlFormat(organization)#</edm:dataProvider>
				<edm:provider>Forbidden Music Regained</edm:provider>
				<edm:rights rdf:resource="http://rightsstatements.org/vocab/InC/1.0/" />

				<cfif listLen( images, "|")><!--- preview image --->
					<cfset r = listGetAt(images, 1, "|")>
					<edm:object rdf:resource="#xmlFormat(mediaBaseUrl & '/' & r )#"/>
				</cfif>

				<edm:isShownAt rdf:resource="#xmlFormat(compositionUrl)#" />

				<cfset useShownBy = true /><!--- first medium must be displayed as isShownBy --->

				<cfloop list="#images#" delimiters="|" index="r">
					<cfif useShownBy>
						<edm:isShownBy rdf:resource="#xmlFormat(mediaBaseUrl & '/' & r )#" />
						<cfset useShownBy = false />
					<cfelse>
						<edm:hasView rdf:resource="#xmlFormat(mediaBaseUrl & '/' & r )#" />
					</cfif>
				</cfloop>

				<cfloop list="#documents#" delimiters="|" index="r">
					<cfif useShownBy>
						<edm:isShownBy rdf:resource="#xmlFormat(mediaBaseUrl & '/' & r )#" />
						<cfset useShownBy = false />
					<cfelse>
						<edm:hasView rdf:resource="#xmlFormat(mediaBaseUrl & '/' & r )#" />
					</cfif>
				</cfloop>

				<cfloop list="#videos#" delimiters="|" index="r">
					<cfif find("youtube",r)>
						<cfif useShownBy>
							<edm:isShownBy rdf:resource="#xmlFormat(getYoutubeUrlfromEmbed(r))#" />
							<cfset useShownBy = false />
						<cfelse>
							<edm:hasView rdf:resource="#xmlFormat(getYoutubeUrlfromEmbed(r))#" />
						</cfif>
					</cfif>
				</cfloop>

			</ore:Aggregation>

		</rdf:RDF>

	</metadata>

</cfoutput>