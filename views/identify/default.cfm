
<!---
<cfdump var="#rc.verb.getResult()#">
<cfoutput>#rc.verb.getResumptionToken()#</cfoutput>
<cfdump var="#rc.verb.getErrors()#">
<cfabort>
--->

<cfif NOT rc.verb.hasErrors()>

	<cfoutput>
	
		<Identify>
	
				<repositoryName>#rc.verb.getResult().repositoryName#</repositoryName>
				<baseUrl>#getUrl()#</baseUrl>
				<protocolVersion>#rc.verb.getResult().protocolVersion#</protocolVersion>
				<cfloop list="#rc.verb.getResult().adminEmail#" index="r"><adminEmail>#r#</adminEmail></cfloop>
				<earliestDatestamp>#UTCDateTimeFormat(rc.verb.getResult().earliestDatestamp)#</earliestDatestamp>
				<deletedRecord>#rc.verb.getResult().deletedRecord#</deletedRecord>
				<granularity>#rc.verb.getResult().granularity#</granularity>
				
				<!--- maybe add a description element later --->
	
		</Identify>
		
	</cfoutput>

</cfif>