
<cfcomponent displayname="BaseController" output="false">
	
	<cfset variables.fw = "">
	
	<cffunction name="init" access="public" output="false" returntype="any">

		<cfargument name="fw">
		<cfset variables.fw = arguments.fw>
		<cfreturn this>

	</cffunction>
	
	<!--- autowire --->
	<cffunction name="setSessionFacade" access="public" output="false">

		<cfargument name="sessionFacade" type="any" required="true" />
		<cfset variables.sessionFacade = arguments.sessionFacade />

	</cffunction>

	<cffunction name="getSessionFacade" access="public" returntype="any" output="false">

		<cfreturn variables.sessionFacade />

	</cffunction>
	
	<!--- autowire --->
	<cffunction name="setOAIService" access="public" output="false">

		<cfargument name="OAIService" type="any" required="true" />
		<cfset variables.OAIService = arguments.OAIService />

	</cffunction>

	<cffunction name="getOAIService" access="public" returntype="any" output="false">

		<cfreturn variables.OAIService />

	</cffunction>

	<!--- interceptor before controller method --->
	<cffunction name="before" access="public" output="false" returntype="void">
		
		<cfargument name="rc" type="struct" required="true">

		<cfset var requestVars=structNew()>
		<cfset qs = ''>
		
		<!--- put form or url vars in rc as a querystring --->
		<cfset structAppend(requestVars, url, "no")>
		<cfset structAppend(requestVars, form, "no")>
		
		<cfif structCount(requestVars)>
		 <cfloop collection="#requestVars#" item="field">
		  <cfset qs &= field & '=' & requestVars[field] & '&'>
		 </cfloop>
		</cfif>
		
		<!--- remove leading and trailing &'s --->
		<cfset qs = reReplace(qs,'^&','')>
		<cfset qs = reReplace(qs,'&$','')>
		
		<cfset rc.params = getRequestParams(qs) />
	
	</cffunction>
	
	<!--- 
		return queryString arguments, as listed in filterlist
	--->
	<cffunction name="getRequestParams" access="public" output="false" returntype="struct" hint="get additional query string parameters as a struct">
		
		<cfargument name="qs" required="true" type="string"/>
		<cfargument name="filterList" required="false" default="" type="string"/>
		
		<!--- arguments that must be removed or reset --->
		<cfset var removeList = listAppend( "verb", arguments.filterlist ) />
		<cfset var a = listToArray(arguments.qs,"&") />
		<cfset var c = 1 />
		<cfset var r = structNew() />
		<cfset var value = "" />

		<cfloop condition="c LTE arraylen(a)">
			
			<!--- remove ignorable params --->
			<cfif listFindNoCase( removeList, listGetAt(a[c],1,"=") )>	
				<cfset arrayDeleteAt(a,c) />
			<cfelse>
				<cfset c = c+1 />	
			</cfif>	
		
		</cfloop>

		<cfloop array="#a#" index="kv">
			
			<cfif listLen(kv,"=") eq 1>
				<cfset value = "" />
			<cfelse>	
				<cfset value = listGetAt(kv,2,"=")/>
			</cfif>
			<cfset r[listGetAt(kv,1,"=")] = value  />
		
		</cfloop>

		<cfreturn r />
		
	</cffunction>	
	
</cfcomponent>