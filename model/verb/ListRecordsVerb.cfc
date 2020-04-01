
<cfcomponent displayname="ListRecordsVerb" extends="ListIdentifiersVerb" output="false">
	
	<cffunction name="configure" access="public" output="false" returntype="any">
	
		<cfargument name="gateway" type="legendoai.model.gateway.AbstractGateway" required="true" />
		<cfargument name="params" type="struct" required="true" />

		<cfset variables.instance.gateway = arguments.gateway />
		<cfset variables.instance.requestparams = arguments.params />

		<cfset variables.idsOnly = false />
		<cfset variables.allowedParams = "from,until,set,metadataPrefix,resumptionToken" />
		
		<cfset initParams()/>
		
		<cfreturn this/>
	
	</cffunction>
	
	<cffunction name="getName" access="public" output="false" returntype="string">
		
		<cfreturn "ListRecords" />
		
	</cffunction>

</cfcomponent>