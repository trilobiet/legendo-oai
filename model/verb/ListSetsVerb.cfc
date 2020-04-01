
<cfcomponent displayname="ListSetsVerb" extends="AbstractVerb" output="false">

	<cffunction name="configure" access="public" output="false" returntype="any">
	
		<cfargument name="gateway" type="legendoai.model.gateway.AbstractGateway" required="true" />
		<cfargument name="params" type="struct" required="true" />

		<cfset variables.instance.gateway = arguments.gateway />
		<cfset variables.instance.requestparams = arguments.params />
		<cfset variables.allowedParams = "resumptionToken" />
		
		<cfset initParams()/>
		
		<cfreturn this/>
	
	</cffunction>

	<!--- @override --->
	<cffunction name="validate" access="public" output="false" returntype="boolean">
		
		<!--- no params to validate --->
		<cfreturn NOT hasErrors() />

	</cffunction>	
	
	<!--- @override --->
	<cffunction name="execute" access="public" output="false" returntype="void">
		
		<cfif variables.instance.params.resumptionToken neq ''>
			<cfset resumeFromToken() />
		</cfif>
		
		<cftransaction>
		
			<cfset variables.instance.result = variables.instance.gateway.qSets( 
				startrow = variables.instance.startrow
			) />
			
			<cfset variables.instance.matchCount = variables.instance.gateway.getSetsCount() />
			
		</cftransaction>	
		
		<!--- not done yet --->
		<cfif variables.instance.matchCount GT variables.instance.startrow + variables.instance.result.recordCount>
			<cfset createResumptionToken( variables.instance.startrow + variables.instance.result.recordCount) />
		<cfelse>	
			<cfset clearResumptionToken() />
		</cfif>

	</cffunction>
	
	<cffunction name="getName" access="public" output="false" returntype="string">
		
		<cfreturn "ListSets" />
		
	</cffunction>

</cfcomponent>