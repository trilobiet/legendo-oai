
<!---
<cfdump var="#rc.verb.getResult()#"/>
<cfdump var="#rc.verb.getErrors()#"/>
<cfabort>
--->

<cfset qr = rc.verb.getResult() />

<cfif NOT rc.verb.hasErrors()>

	<cfoutput>
	
		<ListSets>
	
			<cfloop query="qr">
			
				<set>
					<setSpec>#xmlFormat(setSpec)#</setSpec>
					<setName>#xmlFormat(setName)#</setName>

					<!--- oai_dc --->
					<setDescription>
						<oai_dc:dc 
							xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" 
							xmlns:dc="http://purl.org/dc/elements/1.1/" 
							xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
							xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ 
							http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
							<dc:description>#xmlFormat(setDescription)#</dc:description>
						</oai_dc:dc>
					</setDescription>					
					
				</set>
			
			</cfloop>
			
			<cfif rc.verb.isResumptionTokenRequest()>

				<resumptionToken 
					completeListSize="#rc.verb.getMatchCount()#"
					cursor="#rc.verb.getCursor()#"
				>#rc.verb.getResumptionToken()#</resumptionToken>

			</cfif>
	
		</ListSets>
		
	</cfoutput>

</cfif>

