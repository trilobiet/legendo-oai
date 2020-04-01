<cfcomponent displayname="ListSetsController" output="false" extends="basecontroller">
	
	<!--- actions --->
	
	<cffunction name="default" access="public" output="false" returntype="void">

		<cfargument name="rc" type="struct" required="true" />
		
		<cfset rc.verb = getOAIService().listSets( params=rc.params ) />

	</cffunction>
	
</cfcomponent>