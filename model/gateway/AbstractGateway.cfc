
<cfcomponent displayname="AbstractGateway" output="false" colddoc:abstract="true" hint="Base class for Gateways. [RPO].">

	<cfset variables.dsname = "">

	<cffunction name="init" access="public" output="false" returntype="any">

		<cfargument name="dsname" type="String" required="true" />
		<cfset variables.dsname = arguments.dsname />

		<cfreturn this/>

	</cffunction>

	<cffunction name="qRecord" access="public" output="false" returntype="query">

		<cfargument name="id" type="string" required="true"/>
		<cfargument name="metadataPrefix" type="string" required="false" />

		<cfset var qRes = "" />

		<!--- just get a list, but for a single record --->
		<cfreturn qList( bar_id = arguments.id, metadataPrefix = arguments.metadataPrefix ) />

	</cffunction>

	<!--- default implementation: sets are collections --->
	<cffunction name="qSets" access="public" output="false" returntype="query">

		<cfargument name="startrow" type="numeric" required="false" default="0"/>
		<cfargument name="rowcount" type="numeric" required="false" default="100"/>

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			SELECT
				  col_code as setSpec
				, col_naam as setName
				, col_beschrijving as setDescription

			FROM
				collectie

			WHERE
				col_publiceren = 1

			ORDER BY
				col_code

			LIMIT
				#arguments.startrow#, #arguments.rowcount#

		</cfquery>

		<cfreturn qRes />

	</cffunction>


	<cffunction name="getSetsCount" access="public" output="false" returntype="numeric">

		<cfargument name="metadataPrefix" type="numeric" required="false" />

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			SELECT
				  count(col_code) as count

			FROM
				collectie

			WHERE
				col_publiceren = 1

		</cfquery>

		<cfreturn qRes.count />

	</cffunction>



	<cffunction name="qMetadataFormats" access="public" output="false" returntype="query">

		<!--- argument only provided for future use --->
		<cfargument name="id" type="string" required="false" hint="provide id if metadata format for a single item is requested"/>

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			/* currently only supported format */
			SELECT
				 "oai_dc" as format
				,"http://www.openarchives.org/OAI/2.0/oai_dc.xsd" as "schema"
				,"http://www.openarchives.org/OAI/2.0/oai_dc/" as namespace

		</cfquery>

		<cfreturn qRes />

	</cffunction>

	<cffunction name="qSaveResumption" access="public" output="false" returntype="void">

		<cfargument name="token" type="string" required="true"/>
		<cfargument name="verb" type="string" required="true"/>
		<cfargument name="params" type="string" required="true"/>
		<cfargument name="startrow" type="numeric" required="true"/>
		<cfargument name="prevToken" type="string" required="false" default=""/>

		<cfquery datasource="#variables.dsname#">

			INSERT INTO OAIResumption
				( id, verb, params, startrow, prevId )
			VALUES
				(
					  <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.token#"/>
					, <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.verb#"/>
					, <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.params#"/>
					, "#arguments.startrow#"
					, <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.prevToken#"/>
				)

		</cfquery>

	</cffunction>


	<cffunction name="qDeleteResumption" access="public" output="false" returntype="void">

		<cfargument name="prevToken" type="string" required="false" default=""/>

		<cfquery name="qRes" datasource="#variables.dsname#">

			/* purge resumption record  */
			DELETE

			FROM
				OAIResumption
			WHERE
				id = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.prevToken#"/>

		</cfquery>

	</cffunction>


	<cffunction name="qGetResumption" access="public" output="false" returntype="query">

		<cfargument name="token" type="string" required="true"/>
		<cfargument name="verb" type="string" required="true"/>
		<!--- a resumption must not be used in the context of another verb! --->

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			SELECT
				*
			FROM
				OAIResumption
			WHERE
				id = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.token#"/>
				AND verb = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.verb#"/>

		</cfquery>

		<cfreturn qRes />

	</cffunction>


	<cffunction name="qGetPrevResumption" access="public" output="false" returntype="query">

		<cfargument name="token" type="string" required="true"/>

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			SELECT
				*
			FROM
				OAIResumption
			WHERE
				prevId = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.token#"/>
				AND prevId <> ""
				<!---
				* every 'session' has its own chain of id-prevId's,
				* but the first call has no prevId (prevId = '') so we can never know
				* if someone wants to pick up on this chain, so do not delete until after a long period
				--->

		</cfquery>

		<cfreturn qRes />

	</cffunction>


	<!--- @abstract --->
	<cffunction name="qIdentify" access="public" output="false" returntype="query" hint="ABSTRACT">

	</cffunction>


	<!--- @abstract --->
	<cffunction name="qList" access="public" output="false" returntype="query" hint="ABSTRACT">

		<cfargument name="startrow" type="numeric" required="false" default="0"/>
		<cfargument name="rowcount" type="numeric" required="false" default="100"/>
		<cfargument name="fromstamp" type="string" required="false" default=""/>
		<cfargument name="untilstamp" type="string" required="false" default=""/>
		<cfargument name="colcode" type="string" required="false" default="" hint="select from an optional set" />
		<cfargument name="idsOnly" type="boolean" required="false" default="false" hint="only return UIDs"/>
		<cfargument name="bar_id" type="string" required="false" default="" hint="to get a single record"/>
		<cfargument name="metadataPrefix" type="string" required="false" />

	</cffunction>


	<!--- @abstract --->
	<cffunction name="getMatchCount" access="public" output="false" returntype="numeric" hint="ABSTRACT">

		<cfargument name="fromstamp" type="string" required="false" default=""/>
		<cfargument name="untilstamp" type="string" required="false" default=""/>
		<cfargument name="colcode" type="string" required="false" default="" hint="select from an optional set" />
		<cfargument name="metadataPrefix" type="string" required="false" />

	</cffunction>



</cfcomponent>