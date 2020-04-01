<cfcomponent displayname="ListIdentifiersController" output="false" extends="basecontroller">
	
	<!--- actions --->
	
	<cffunction name="default" access="public" output="false" returntype="void">

		<cfargument name="rc" type="struct" required="true" />

		<cfset rc.verb = getOAIService().listIdentifiers( params=rc.params ) />
		
	</cffunction>
	
</cfcomponent>