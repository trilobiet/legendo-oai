<cfcomponent displayname="IdentifyController" output="false" extends="basecontroller">
	
	<!--- actions --->
	
	<cffunction name="default" access="public" output="false" returntype="void">

		<cfargument name="rc" type="struct" required="true" />

		<cfset rc.verb = getOAIService().identify( params=rc.params ) />

	</cffunction>
	
</cfcomponent>