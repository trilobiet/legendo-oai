
<cfcomponent displayname="OAIService" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
		
		<cfargument name="gateway" type="legendoai.model.gateway.AbstractGateway" required="true" />
		<cfargument name="verbfactory" type="any" required="true" />

		<cfset variables.gateway = arguments.gateway />
		<cfset variables.verbfactory = arguments.verbfactory />
		
		<cfreturn this />

	</cffunction>
	
	<cffunction name="identify" access="public" output="false" returntype="any">

		<cfargument name="params" type="struct" required="true" />
		<cfreturn getVerb( "Identify", arguments.params ) />

	</cffunction>		

	<cffunction name="getRecord" access="public" output="false" returntype="any">

		<cfargument name="params" type="struct" required="true" />
		<cfreturn getVerb( "GetRecord", arguments.params ) />
			
	</cffunction>		

	<cffunction name="listIdentifiers" access="public" output="false" returntype="any">

		<cfargument name="params" type="struct" required="true" />
		<cfreturn getVerb( "ListIdentifiers", arguments.params ) />

	</cffunction>		

	<cffunction name="listMetadataFormats" access="public" output="false" returntype="any">

		<cfargument name="params" type="struct" required="true" />
		<cfreturn getVerb( "ListMetadataFormats", arguments.params ) />

	</cffunction>		

	<cffunction name="listRecords" access="public" output="false" returntype="any">

		<cfargument name="params" type="struct" required="true" />
		<cfreturn getVerb( "ListRecords", arguments.params ) />

	</cffunction>		

	<cffunction name="listSets" access="public" output="false" returntype="any">

		<cfargument name="params" type="struct" required="true" />
		<cfreturn getVerb( "ListSets", arguments.params ) />

	</cffunction>		

	<cffunction name="illegalVerb" access="public" output="false" returntype="any">
	
		<cfreturn variables.verbfactory.getVerb('whatever').configure() />
	
	</cffunction>

	<!--- generic private function to retrieve and initialize a verb transient --->
	<cffunction name="getVerb" access="private" output="false" returntype="any">

		<cfargument name="verbname" type="string" required="true" />
		<cfargument name="params" type="struct" required="true" />
		
		<cfset var verb = variables.verbfactory.getVerb(arguments.verbname).configure(
			 gateway = variables.gateway
			,params = arguments.params
		) />
		
		<cfif verb.validate()>
			<cfset verb.execute() />
		</cfif>
		
		<cfreturn verb />
			
	</cffunction>		

</cfcomponent>