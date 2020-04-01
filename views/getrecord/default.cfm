
<!---
<cfdump var="#rc.verb.getResult()#">
<cfoutput>#rc.verb.getResumptionToken()#</cfoutput>
<cfdump var="#rc.verb.getErrors()#">
<cfabort>
--->

<cfset qr = rc.verb.getResult() />

<cfif NOT rc.verb.hasErrors()>

	<cfoutput>
	
		<GetRecord>
		
			<cfloop query="qr">
	
				<record>
	
					<cfinclude template="/legendoai/domains/#variables.oaicontext#/metadataformats/record.#rc.verb.getMetadataPrefix()#.cfm">
				
				</record>
			
			</cfloop>
			
		</GetRecord>
		
	</cfoutput>
	
</cfif>	