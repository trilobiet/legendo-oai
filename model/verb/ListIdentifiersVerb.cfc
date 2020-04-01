
<cfcomponent displayname="ListIdentifiersVerb" extends="AbstractVerb" output="false">

	<cffunction name="configure" access="public" output="false" returntype="any">

		<cfargument name="gateway" type="legendoai.model.gateway.AbstractGateway" required="true" />
		<cfargument name="params" type="struct" required="true" />

		<cfset variables.instance.gateway = arguments.gateway />
		<cfset variables.instance.requestparams = arguments.params />

		<cfset variables.idsOnly = true />
		<cfset variables.allowedParams = "from,until,set,metadataPrefix,resumptionToken" />

		<cfset initParams()/>

		<cfreturn this/>

	</cffunction>

	<!--- @override --->
	<cffunction name="validate" access="public" output="false" returntype="boolean">

		<cfset var params = variables.instance.requestparams />

		<cfif structKeyExists( params, "resumptionToken" )>

			<cfif structCount( params ) GT 1 >
				<cfset addError('badArgument','resumptionToken is an exclusive argument') />
			</cfif>

			<!--- is this an existing resumptionToken? --->
			<cfif variables.instance.gateway.qGetResumption( variables.instance.params.resumptionToken, getName() ).recordCount eq 0 >
				<cfset addError('badResumptionToken','The value of the resumptionToken argument is invalid or expired.') />
			</cfif>

		</cfif>

		<cfif NOT structKeyExists( params, "resumptionToken" )>

			<cfif NOT structKeyExists( params, "metadataPrefix" ) >
				<cfset addError('badArgument','required argument metadataPrefix missing') />
			<cfelse>
				<cfset qMetadataFormats = variables.instance.gateway.qMetadataFormats() >
				<cfif not listFind( valueList(qMetadataFormats.format), params.metadataPrefix ) >
					<cfset addError('cannotDisseminateFormat','metadataPrefix not supported') />
				</cfif>
			</cfif>

			<cfif variables.instance.params.from NEQ '' AND NOT isDate(variables.instance.params.from)>
				<cfset addError('badArgument','invalid argument: from') />
			</cfif>

			<cfif variables.instance.params.until NEQ '' AND NOT isDate(variables.instance.params.until)>
				<cfset addError('badArgument','invalid argument: until') />
			</cfif>

			<cfif variables.instance.params.from NEQ '' AND isDate(variables.instance.params.from)
			  AND variables.instance.params.until NEQ '' AND isDate(variables.instance.params.until)
			  AND variables.instance.params.until LT variables.instance.params.from
			>
				<cfset addError('badArgument','until date before from date') />
			</cfif>

		</cfif>

		<cfreturn NOT hasErrors() />

	</cffunction>

	<!--- @override --->
	<cffunction name="execute" access="public" output="false" returntype="void">

		<cfif variables.instance.params.resumptionToken neq ''>
			<cfset resumeFromToken() />
		</cfif>

		<!---
		<cflog file="oai"  text="#variables.instance.params.metadataPrefix#">
		--->

		<cftransaction>

			<cfset variables.instance.result = variables.instance.gateway.qList(
				  fromstamp = variables.instance.params.from
				, untilstamp = variables.instance.params.until
				, colcode = variables.instance.params.set
				, startrow = variables.instance.startrow
				, idsOnly = variables.idsOnly
				, metadataPrefix = variables.instance.params.metadataPrefix
			) />

			<cfset variables.instance.matchCount = variables.instance.gateway.getMatchCount(
				  fromstamp = variables.instance.params.from
				, untilstamp = variables.instance.params.until
				, colcode = variables.instance.params.set
				, metadataPrefix = variables.instance.params.metadataPrefix
			) />

		</cftransaction>

		<cfif variables.instance.result.recordCount eq 0>
			<cfset addError( 'noRecordsMatch', '' ) />
		</cfif>

		<!--- not done yet --->
		<cfif variables.instance.matchCount GT variables.instance.startrow + variables.instance.result.recordCount>
			<cfset createResumptionToken( variables.instance.startrow + variables.instance.result.recordCount ) />
		<cfelse>
			<cfset clearResumptionToken() />
		</cfif>

	</cffunction>

	<cffunction name="getName" access="public" output="false" returntype="string">

		<cfreturn "ListIdentifiers" />

	</cffunction>

</cfcomponent>