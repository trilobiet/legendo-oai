<cfsilent>
	<cfcontent type="text/xml" />
	<cfsetting enablecfoutputonly="true" />
	<cfsetting showdebugoutput="false" />
</cfsilent>

<cfoutput><?xml version="1.0" encoding="UTF-8"?>

	<OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" 
	        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	        xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/
	        http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">

		<responseDate>#UTCDateTimeFormat()#</responseDate>

		<request 
			<cfif NOT rc.verb.hasBadParams() AND NOT rc.verb.isBadVerb()>#struct2XMLattributes( getRequestArguments() )#</cfif>
		>#getUrl()#</request>

		<cfif rc.verb.hasErrors()>
			<cfset errors = rc.verb.getErrors()>
			<cfloop array="#errors#" index="error">
				<error code="#error.code#">#error.description#</error>
			</cfloop>
		<cfelse>
			<!--- output for a succesfully parsed verb --->
			#body#
		</cfif>

	</OAI-PMH>	

</cfoutput>
	
