
<cfcomponent displayname="GetRecordVerb" extends="AbstractVerb" output="false">

	<cffunction name="configure" access="public" output="false" returntype="any">

		<cfargument name="gateway" type="legendoai.model.gateway.AbstractGateway" required="true" />
		<cfargument name="params" type="struct" required="true" />

		<cfset variables.instance.gateway = arguments.gateway />
		<cfset variables.instance.requestparams = arguments.params />
		<cfset variables.allowedParams =  "identifier,metadataPrefix" />

		<cfset initParams() />

		<cfreturn this/>

	</cffunction>

	<!--- @override --->
	<cffunction name="validate" access="public" output="false" returntype="boolean">

		<cfset var params = variables.instance.requestparams />

		<cfif NOT structKeyExists( params, "identifier" ) >
			<cfset addError('badArgument','no identifier provided') />
		</cfif>

		<cfif NOT structKeyExists( params, "metadataPrefix" ) >
			<cfset addError('badArgument','required argument metadataPrefix missing') />
		<cfelseif structKeyExists( params, "identifier" )>
			<cfset qMetadataFormats = variables.instance.gateway.qMetadataFormats( variables.instance.requestparams.identifier ) >
			<cfif not listFind( valueList(qMetadataFormats.format), params.metadataPrefix ) >
				<cfset addError('cannotDisseminateFormat','metadataPrefix not supported') />
			</cfif>
		</cfif>

		<cfreturn NOT hasErrors() />

	</cffunction>

	<!--- @override --->
	<cffunction name="execute" access="public" output="false" returntype="void">

		<cfset variables.instance.result = variables.instance.gateway.qRecord(
			  id = variables.instance.requestparams.identifier
			, metadataPrefix = variables.instance.params.metadataPrefix
		) />

		<cfif variables.instance.result.recordCount eq 0>
			<cfset addError( 'idDoesNotExist', variables.instance.requestparams.identifier ) />
		</cfif>

	</cffunction>

	<cffunction name="getName" access="public" output="false" returntype="string">

		<cfreturn "GetRecord" />

	</cffunction>


</cfcomponent>