<cfcomponent displayname="IllegalVerbController" output="false" extends="basecontroller">
	
	<!--- actions --->
	
	<cffunction name="default" access="public" output="false" returntype="void">

		<cfargument name="rc" type="struct" required="true" />
		
		<cfset rc.verb = getOAIService().illegalVerb() />
		
	</cffunction>

	<!--- only a restricted set of actions can be chosen from - all others should serve an error message --->
	<cffunction name="checkverb">
		
		<cfargument name="rc" type="struct" required="true">
		
		<cfset var legalVerbs = "GetRecord,Identify,ListIdentifiers,ListMetaDataFormats,ListRecords,ListSets,IllegalVerb,overview" />
		<cfset var verb = listFirst(arguments.rc.verb,".")/>	
		
		<cfif NOT listFindNoCase( legalVerbs, verb ) >
			<!---<cfset variables.fw.redirect( "illegalverb" ) /> do not use a client side redirect - harvesters may not follow --->
			<cfset rc.verb = getOAIService().illegalVerb() />
		</cfif>
	
	</cffunction>


</cfcomponent>