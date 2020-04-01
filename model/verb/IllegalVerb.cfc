
<cfcomponent displayname="IllegalVerb" extends="AbstractVerb" output="false">

	<cffunction name="configure" access="public" output="false" returntype="any">
	
		<cfset addError('badVerb','no such verb') />
		<cfreturn this/>
	
	</cffunction>

	<!--- @override --->
	<cffunction name="validate" access="public" output="false" returntype="boolean">
		
		<cfreturn false />

	</cffunction>	

	<cffunction name="isBadVerb" access="public" output="false" returntype="boolean" hint="is this a nonsense verb?">
		
		<cfreturn true />
		
	</cffunction>
	
	<cffunction name="getName" access="public" output="false" returntype="string">
		
		<cfreturn "" />
		
	</cffunction>

</cfcomponent>