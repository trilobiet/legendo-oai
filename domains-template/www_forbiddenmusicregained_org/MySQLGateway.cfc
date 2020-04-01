
<cfcomponent output="false" extends="legendoai.model.gateway.AbstractGateway">

	<!--- @override --->
	<cffunction name="qIdentify" access="public" output="false" returntype="query">

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			SELECT
				  'Forbidden Music Regained OAI Repository'			as repositoryName
				, '2.0'												as protocolVersion
				, 'xxx@yyy.nl,qqq@zzz.nl'		as adminEmail
				, MIN(bar_dtCreation)								as earliestDatestamp
				, 'no'												as deletedRecord
				, 'YYYY-MM-DDThh:mm:ssZ'							as granularity

			FROM
				beeldarchief

		</cfquery>

		<cfreturn qRes />

	</cffunction>



	<cffunction name="qSets" access="public" output="false" returntype="query">

		<cfargument name="startrow" type="numeric" required="false" default="0"/>
		<cfargument name="rowcount" type="numeric" required="false" default="100"/>

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">


			SELECT
				  'raw' as setSpec
				, 'raw' as setName
				, 'Comprehensive recordset containing all objects (with and without media): compositions, biographies and recordings' as setDescription

			UNION

			(
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
			)

			LIMIT
				#arguments.startrow#, #arguments.rowcount#

		</cfquery>

		<cfreturn qRes />

	</cffunction>



	<!--- @override --->
	<cffunction name="qMetadataFormats" access="public" output="false" returntype="query">

		<!--- argument only provided for future use --->
		<cfargument name="id" type="string" required="false" hint="provide id if metadata format for a single item is requested"/>

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			SELECT
				 "oai_dc" as format
				,"http://www.openarchives.org/OAI/2.0/oai_dc.xsd" as "schema"
				,"http://www.openarchives.org/OAI/2.0/oai_dc/" as namespace

			UNION
			SELECT
				 "edm" as format
				,"http://www.europeana.eu/schemas/edm/EDM.xsd" as "schema"
				,"http://www.europeana.eu/schemas/edm/" as namespace

		</cfquery>

		<cfreturn qRes />

	</cffunction>



	<!--- @override --->
	<cffunction name="qList" access="public" output="false" returntype="query">

		<cfargument name="startrow" type="numeric" required="false" default="0"/>
		<cfargument name="rowcount" type="numeric" required="false" default="100"/>
		<cfargument name="fromstamp" type="string" required="false" default=""/>
		<cfargument name="untilstamp" type="string" required="false" default=""/>
		<cfargument name="colcode" type="string" required="false" default="" hint="select from an optional set" />
		<cfargument name="idsOnly" type="boolean" required="false" default="false" hint="only return UIDs"/>
		<cfargument name="bar_id" type="string" required="false" default="" hint="to get a single record"/>

		<cfset var qRes = "" />

		<cfquery name="qRes" datasource="#variables.dsname#">

			/* do not use SQL_CALC_FOUND_ROWS it's too slow */

			SELECT

				<cfif arguments.idsOnly eq true AND arguments.bar_id EQ "">

					identifier, archivecode, datestamp

				<cfelse>

					identifier, inventorynr, inventorynrComposer
					, title, samenvatting, beschrijving, htmltekst, transcriptie
					, locatieVast, locatieUit
					, CASE type
						WHEN "compositie" THEN "composition"
						WHEN "biografie" THEN "biography"
						WHEN "opname" THEN "opname"
						ELSE type
						END  as type
					, status
					, bezetting, genre
					, 'Leo Smit Stichting' as organization
					, vervaardiger, archive, archivecode, dateBegin, dateEnd
					, minuten, paginas
					, datestamp
					, images, videos, documents, urls

				</cfif>

			FROM

				#_getDBViewForSet(colcode)# b

			WHERE

				1=1

				<cfif arguments.bar_id NEQ ''>

					<!--- get a single record --->
					<cfif arguments.bar_id NEQ ''>
						AND b.identifier = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.bar_id#"/>
					</cfif>

				<cfelse>

					/* date limits must be inclusive */
					<cfif isDate(arguments.fromstamp)>
						AND b.datestamp >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.fromstamp#"/>
					</cfif>
					<cfif isDate(arguments.untilstamp)>
						AND b.datestamp <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.untilstamp#"/>
					</cfif>
					<cfif arguments.colcode NEQ '' AND arguments.colcode NEQ 'raw'>
						AND b.archivecode = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.colcode#"/>
					</cfif>

				</cfif>


			LIMIT

				#arguments.startrow#, #arguments.rowcount#


		</cfquery>

		<!---<cfdump var="#qRes#"><cfabort>--->

		<cfreturn qRes />

	</cffunction>


	<!--- @override --->
	<cffunction name="getMatchCount" access="public" output="false" returntype="numeric" >

		<cfargument name="fromstamp" type="string" required="false" default=""/>
		<cfargument name="untilstamp" type="string" required="false" default=""/>
		<cfargument name="colcode" type="string" required="false" default="" hint="select from an optional set" />
		<cfargument name="metadataPrefix" type="string" required="false" />

		<cfset var qCount = '' />

		<!--- Count of all matching records --->
		<cfquery name="qCount" datasource="#variables.dsname#">

			SELECT
				count(identifier) as count

			FROM
				#_getDBViewForSet(colcode)# b

			WHERE

			1 = 1

			/* date limits must be inclusive */
			<cfif isDate(arguments.fromstamp)>
				AND b.datestamp >= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.fromstamp#"/>
			</cfif>
			<cfif isDate(arguments.untilstamp)>
				AND b.datestamp <= <cfqueryparam cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.untilstamp#"/>
			</cfif>
			<cfif arguments.colcode NEQ '' AND arguments.colcode NEQ 'raw'>
				AND b.archivecode = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#arguments.colcode#"/>
			</cfif>

		</cfquery>

		<cfreturn qCount.count />

	</cffunction>


	<!--- Private: get table or view to run query on --->
	<cffunction name="_getDBViewForSet" access="private" output="false" returntype="string">

		<cfargument name="colcode" type="string" required="true" />

		<!---
			A extended set shows all data form all beeldtypes with and without media.
			So we use a diffrent view here.
		--->
		<cfset var table = "vw_oai_beeldarchief_2">
		<cfif arguments.colcode eq "raw">
			<cfset table = "vw_oai_beeldarchief_fullset"/>
		</cfif>

		<cfreturn table />


	</cffunction>


</cfcomponent>



