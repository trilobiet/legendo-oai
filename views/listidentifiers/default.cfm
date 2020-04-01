<!---
<cfdump var="#rc.verb.getResult()#">
<cfoutput>#rc.verb.getResumptionToken()#</cfoutput>
<cfdump var="#rc.verb.getErrors()#">
<cfabort>
--->

<cfset qr = rc.verb.getResult() />

<cfif NOT rc.verb.hasErrors()>

	<cfoutput>
	
		<ListIdentifiers>
	
			<cfloop query="qr">
				
				<header>
					<identifier>#xmlFormat(identifier)#</identifier>
					<datestamp>#UTCDateTimeFormat(datestamp)#</datestamp>
					<setSpec>#xmlFormat(archivecode)#</setSpec>
				</header>	
			
			</cfloop>
			
			<cfif rc.verb.isResumptionTokenRequest()>

				<resumptionToken 
					completeListSize="#rc.verb.getMatchCount()#"
					cursor="#rc.verb.getCursor()#"
				>#rc.verb.getResumptionToken()#</resumptionToken>

			</cfif>
	
		</ListIdentifiers>
		
	</cfoutput>
	
</cfif>	