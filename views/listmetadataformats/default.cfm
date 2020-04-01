
<!---
<cfdump var="#rc.verb.getResult()#"/>
<cfdump var="#rc.verb.getErrors()#"/>
<cfabort>
--->


<cfset qr = rc.verb.getResult() />

<cfif NOT rc.verb.hasErrors()>

	<cfoutput>
	
		<ListMetadataFormats>
	
			<cfloop query="qr">
	
				<metadataFormat>
					<metadataPrefix>#xmlFormat(format)#</metadataPrefix>
					<schema>#xmlFormat(schema)#</schema>
					<metadataNamespace>#xmlFormat(namespace)#</metadataNamespace>	
				</metadataFormat>

			</cfloop>
	
		</ListMetadataFormats>
		
	</cfoutput>
	
</cfif>	