<cfcomponent displayname="OverviewController" output="false" extends="basecontroller">

	<!--- actions --->

	<cffunction name="default" access="public" output="false" returntype="void">

		<cfargument name="rc" type="struct" required="true" />

		<cfset structDelete(rc.params, "reload") />

		<cfset rc.metadataformats = getOAIService().listMetadataFormats( params=rc.params ) />

	</cffunction>

</cfcomponent>