<cfprocessingdirective suppresswhitespace=true />
<cfoutput>

	<header>
		<identifier>#xmlFormat(identifier)#</identifier>
		<datestamp>#UTCDateTimeFormat(datestamp)#</datestamp>
		<setSpec>#xmlFormat(archivecode)#</setSpec>
	</header>

	<metadata>

		<oai_dc:dc
		    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
		    xmlns:dc="http://purl.org/dc/elements/1.1/"
		    xmlns:dcterms="http://purl.org/dc/terms/"
		    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd
		    http://purl.org/dc/terms/ http://dublincore.org/schemas/xmls/qdc/dcterms.xsd">

			<!--- dc:title --->
			<dc:title>#xmlFormat(title)#</dc:title>
   			<!--- dc:identifier --->
			<dc:identifier>#xmlFormat(identifier)#</dc:identifier>
			<dc:identifier>#xmlFormat(inventorynr)#</dc:identifier>
			<!--- dc:source --->
			<cfif archiveCode neq ''><dc:source>#xmlFormat(archivecode)# #xmlFormat(archive)#</dc:source></cfif>
			<!--- dc:date --->
			<cfif dateBegin neq ''><dc:date>#dateFormat(dateBegin,"yyyy-mm-dd")#</dc:date></cfif>
			<cfif dateEnd neq ''><dc:date>#dateFormat(dateEnd,"yyyy-mm-dd")#</dc:date></cfif>
			<!--- dc:type --->
			<dc:type>#xmlFormat(type)#</dc:type>
			<!--- dc:description --->
			<dc:description><![CDATA[#beschrijving#]]></dc:description>
			<cfif transcriptie neq ''><dc:description><![CDATA[#transcriptie#]]></dc:description></cfif>
			<cfif htmltekst neq ''><dc:description><![CDATA[#htmltekst#]]></dc:description></cfif>
			<!--- dc:creator --->
			<cfif vervaardiger neq ''><cfloop list="#vervaardiger#" delimiters="|" index="r"><dc:creator>#xmlFormat(r)#</dc:creator></cfloop></cfif>
			<!--- dc:subject --->
			<cfif genre neq ''><cfloop list="#genre#" delimiters="|" index="r"><dc:subject>#xmlFormat(r)#</dc:subject></cfloop></cfif>
			<cfif bezetting neq ''><cfloop list="#bezetting#" delimiters="|" index="r"><dc:subject>#xmlFormat(r)#</dc:subject></cfloop></cfif>

			<!--- dcterms:abstract --->
			<dcterms:abstract><![CDATA[#samenvatting#]]></dcterms:abstract>
			<!--- dcterms:medium --->
			<cfif status neq ''><dcterms:medium>#xmlFormat(status)#</dcterms:medium></cfif>
			<!--- dcterms:provenance --->
			<dcterms:provenance>#xmlFormat(organization)#</dcterms:provenance>
			<!--- dcterms:spatial --->
			<cfif locatieVast neq ''><dcterms:spatial>#xmlFormat(trim(locatieVast))#</dcterms:spatial></cfif>
			<!--- dcterms:extent --->
			<cfif minuten neq ''><dcterms:extent>#xmlFormat(minuten)# minutes</dcterms:extent></cfif>
			<cfif paginas neq ''><dcterms:extent>#xmlFormat(paginas)#</dcterms:extent></cfif>

		</oai_dc:dc>

	</metadata>

	<about>

		<legendo:legendo
			xmlns:legendo="http://www.legendo.nl/oai/"
			xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://www.legendo.nl/oai/ http://www.legendo.nl/oai/xsd/legendo.xsd">

			<cfloop list="#images#" delimiters="|" index="r">
				<legendo:resource>
					<legendo:imglarge>#xmlFormat( "http://www.forbiddenmusicregained.org/media/" & inventorynr & "/" & r )#</legendo:imglarge>
					<cfif right(r,4) eq ".jpg">
						<legendo:imgmedium>#xmlFormat( "http://www.forbiddenmusicregained.org/media/" & inventorynr & "/" & replace(r,".jpg",".medium.jpg") )#</legendo:imgmedium>
						<legendo:imgthumb>#xmlFormat( "http://www.forbiddenmusicregained.org/media/" & inventorynr & "/" & replace(r,".jpg",".small.jpg") )#</legendo:imgthumb>
					</cfif>
				</legendo:resource>
			</cfloop>

			<cfloop list="#documents#" delimiters="|" index="r">
				<legendo:resource>
					<legendo:url>#xmlFormat( "http://www.forbiddenmusicregained.org/media/" & inventorynr & "/" & r )#</legendo:url>
				</legendo:resource>
			</cfloop>

			<legendo:url>#xmlFormat( "http://www.forbiddenmusicregained.org/search/composition/id/" & inventorynr )#</legendo:url>

		</legendo:legendo>

	</about>

</cfoutput>