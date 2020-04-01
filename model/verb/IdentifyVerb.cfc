
<cfcomponent displayname="IdentifyVerb" extends="AbstractVerb" output="false">

	<cffunction name="configure" access="public" output="false" returntype="any">
	
		<cfargument name="gateway" type="legendoai.model.gateway.AbstractGateway" required="true" />
		<cfargument name="params" type="struct" required="true" />

		<cfset variables.instance.gateway = arguments.gateway />
		<cfset variables.instance.requestparams = arguments.params />
		<cfset variables.allowedParams = "" />
		
		<cfset initParams()/>
		
		<cfreturn this/>
	
	</cffunction>

	<!--- @override --->
	<cffunction name="validate" access="public" output="false" returntype="boolean">
		
		<cfset var params = variables.instance.requestparams />
		
		<cfreturn NOT hasErrors() />

	</cffunction>	
	
	<!--- @override --->
	<cffunction name="execute" access="public" output="false" returntype="void">
		
		<cfset variables.instance.result = variables.instance.gateway.qIdentify() />

	</cffunction>
	
	<cffunction name="getName" access="public" output="false" returntype="string">
		
		<cfreturn "Identify" />
		
	</cffunction>

</cfcomponent>