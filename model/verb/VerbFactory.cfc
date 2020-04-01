
<cfcomponent displayname="VerbFactory" output="false" hint="A factory for Verb objects">
	
	<cffunction name="init" access="public" output="false" returntype="any">
	
		<cfreturn this />
	
	</cffunction>
	

	<cffunction name="getVerb" returntype="AbstractVerb">
	
		<cfargument name="type" type="string" required="true" />
		
		<cfswitch expression="#lcase(type)#">
		
			<cfcase value="getrecord">
				<cfreturn createObject('component','GetRecordVerb').init() />
			</cfcase>
			
			<cfcase value="identify">
				<cfreturn createObject('component','IdentifyVerb').init() />
			</cfcase>

			<cfcase value="listidentifiers">
				<cfreturn createObject('component','ListIdentifiersVerb').init() />
			</cfcase>

			<cfcase value="listmetadataformats">
				<cfreturn createObject('component','ListMetadataFormatsVerb').init() />
			</cfcase>

			<cfcase value="listrecords">
				<cfreturn createObject('component','ListRecordsVerb').init() />
			</cfcase>

			<cfcase value="listsets">
				<cfreturn createObject('component','ListSetsVerb').init() />
			</cfcase>

			<cfdefaultcase>
				<cfreturn createObject('component','IllegalVerb').init() />
			</cfdefaultcase>
		
		</cfswitch>
	
	</cffunction>

</cfcomponent>