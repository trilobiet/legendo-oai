
<cfcomponent displayname="AbstractVerb" output="false">
	
	<cffunction name="init" access="public" output="false" returntype="any">
	
		<cfset variables.instance = StructNew() />
		<cfset variables.instance.gateway = "" />		
		<cfset variables.instance.params = structNew() />
		<cfset variables.instance.requestparams = structNew() />
		<cfset variables.instance.errors = ArrayNew(1) />
		<cfset variables.instance.result = QueryNew("") />
		<cfset variables.instance.hasBadParams = false />
		<cfset variables.instance.matchCount = 0 />
		<cfset variables.instance.cursor = 0 />
		<cfset variables.instance.startrow = 0 />
		<cfset variables.instance.resumptionParams = "" />
		<cfset variables.allowedParams = "" />

		<cfreturn this/>
	
	</cffunction>
	
	<cffunction name="initParams" access="public" output="false" returntype="void">
		
		<!--- create all possible param fields --->
		<cfloop list="#variables.allowedparams#" index="param">
			<cfset variables.instance.params[param] = "" />
		</cfloop>
		
		<!--- check all given params for validity, if valid read in value --->
		<cfloop collection="#variables.instance.requestparams#" item="param">
			<cfif NOT listFindNoCase(variables.allowedParams,param)>
				<cfset addError( 'badArgument', "'" & param & "' is not a valid argument for this verb" ) />
				<cfset variables.instance.hasBadParams = true />
			<cfelse>
				<cfset variables.instance.params[param] = variables.instance.requestparams[param] />
			</cfif>
		</cfloop>	

		<!---<cfdump var="#variables.instance#"/><cfabort>--->
	
	</cffunction>

	<cffunction name="getResult" access="public" output="false" returntype="query">
		
		<cfreturn variables.instance.result />
		
	</cffunction>

	<cffunction name="isBadVerb" access="public" output="false" returntype="boolean" hint="is this a nonsense verb?">
		
		<cfreturn false />
		
	</cffunction>

	<cffunction name="hasBadParams" access="public" output="false" returntype="boolean" hint="contains forbidden params">
		
		<cfreturn variables.instance.hasBadParams />
		
	</cffunction>

	<cffunction name="getMatchCount" access="public" output="false" returntype="numeric" hint="returns list queries total count">
	
		<cfreturn variables.instance.matchCount />
	
	</cffunction>

	<cffunction name="getCursor" access="public" output="false" returntype="numeric" hint="returns first row number of current data chunk">
	
		<cfreturn variables.instance.startrow />
	
	</cffunction>


	<cffunction name="createResumptionToken" access="private" output="false" returntype="void">
		
		<cfargument name="startrow" type="numeric" required="true" />
		
		
		<cfset var prevResumptionToken = variables.instance.params.resumptionToken />
		
		<!--- maybe it's a reload of an already assigned token! --->
		<cfset var q = variables.instance.gateway.qGetPrevResumption( prevResumptionToken ) /> 
		
		<!---
		<cfdump var="#variables.instance#"><cfabort>
		--->
		
		<cfif q.recordCount>

			<!--- re-use the old one --->
			<cfset variables.instance.params.resumptionToken = q.id />	

		<cfelse>	

			<!--- create a new one --->
			<cfset variables.instance.params.resumptionToken = createUUID() />
			
			<!--- use the json serialized string from the db over and over again --->
			<cfif variables.instance.resumptionParams eq "">
				<cfset variables.instance.resumptionParams = serializeJSON( variables.instance.requestparams ) />
			</cfif>
			
			<cftry>
		
				<cfset variables.instance.gateway.qSaveResumption(
					 token = variables.instance.params.resumptionToken
					,verb = getName()
					,params = variables.instance.resumptionParams
					,startrow = arguments.startrow
					,prevToken = prevResumptionToken
				) />
				
				<cfcatch>
				</cfcatch>
		
			</cftry>	
			
		</cfif>	
		
	</cffunction>


	<cffunction name="resumeFromToken" access="private" output="false" returntype="void">
		
		<cfset var qRes = "" />
		<cfset var s = structNew() />
		
		<cftry>
		
			<cfset qRes = variables.instance.gateway.qGetResumption( variables.instance.params.resumptionToken, getName() ) />

			<cfif qRes.recordCount eq 0>
				<cfset addError('badResumptionToken','The value of the resumptionToken argument is invalid or expired.') />
			<cfelse>	
				<cfset variables.instance.resumptionParams = qRes.params />
				<cfset s = deserializeJSON( qRes.params ) />
				<cfloop collection="#s#" item="p">
					<cfset variables.instance.params[p] = s[p] />
				</cfloop>
				<cfset variables.instance.startrow = qRes.startrow />
			</cfif>

			<!--- throw away previous rsumption now that this one can be reloaded --->			
			<cfset variables.instance.gateway.qDeleteResumption( qRes.prevId ) />
			
			<cfcatch></cfcatch>

		</cftry>
		
	</cffunction>
	
	<cffunction name="isResumptionTokenRequest" access="public" output="false" returntype="boolean">
		
		<!--- a request that has items left OR a request that called on a resumption token MUST return a resumption token --->
		<cfif variables.instance.matchCount GT variables.instance.startrow + variables.instance.result.recordCount
			OR structKeyExists( variables.instance.requestparams, "resumptionToken" )>
				
			<cfreturn true />
		<cfelse>	
			<cfreturn false />
		</cfif>	
	
	</cffunction>
	
	<cffunction name="clearResumptionToken" access="public" output="false" returntype="void">
	
		<cfset variables.instance.params.resumptionToken = "" />
		<!--- Do not throw away the last resumptionToken from the DB: you must forever be able to repeat the last request! --->
	
	</cffunction>


	<cffunction name="getResumptionToken" access="public" output="false" returntype="string">
	
		<cfreturn variables.instance.params.resumptionToken />
	
	</cffunction>


	<cffunction name="getMetadataPrefix" access="public" output="false" returntype="string">
	
		<cfif structkeyExists(variables.instance.params, "metadataPrefix")>
			<cfreturn variables.instance.params.metadataPrefix />
		<cfelse>	
			<cfreturn "" />
		</cfif>
	
	</cffunction>


	<cffunction name="addError" access="private" output="false" returntype="array">
		
		<cfargument name="code" type="string" required="true"/>
		<cfargument name="description" type="string" required="true"/>
		
		<cfset var error = structNew() />
		<cfset error.code = arguments.code />
		<cfset error.description = arguments.description />
		
		<cfset arrayAppend( variables.instance.errors, error ) />
		
		<cfif error.code EQ "badVerb" OR error.code EQ "badArgument">
			<cfset variables.instance.hasBadParams = true />
		</cfif>

		<cfreturn variables.instance.errors />
		
		
	</cffunction>
	
	<cffunction name="getErrors" access="public" output="false" returntype="array">
		
		<cfreturn variables.instance.errors />
		
	</cffunction>


	<cffunction name="hasErrors" access="public" output="false" returntype="boolean">
		
		<cfreturn arrayLen( variables.instance.errors ) GT 0 />
		
	</cffunction>

	
	<!--- abstract methods --->
	<cffunction name="validate" access="public" output="false" returntype="boolean">
	</cffunction>	
	
	<cffunction name="execute" access="public" output="false" returntype="query">
	</cffunction>
	
	<cffunction name="getName" access="public" output="false" returntype="string">
	</cffunction>
		
</cfcomponent>