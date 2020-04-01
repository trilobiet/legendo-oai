<cfsilent>

	<cffunction name="UTCDateTimeFormat" access="public" output="false" returntype="string" hint="">

		<cfargument name="datetime" type="string" required="no" default="#now()#" />

		<cfset var r = ""/>
		<cfset var dt = arguments.datetime />

		<cfset dt = dateAdd("h",getTimeZoneInfo().utcHourOffset,dt) />
		<cfset dt = dateAdd("n",getTimeZoneInfo().utcMinuteOffset,dt) />

		<cfset r &= dateFormat( dt, "yyyy-mm-dd" ) />
		<cfset r &= "T" />
		<cfset r &= timeFormat( dt, "HH:mm:ss" ) />

		<cfset r &= "Z" />

		<cfreturn r />

	</cffunction>

	<cffunction name="getUrl" access="public" output="false" returntype="string" hint="">

		<!--- Get request from ColdFusion page contenxt. --->
		<cfset var objRequest = GetPageContext().GetRequest() />

		<!--- Get requested URL from request object. --->
		<cfset var strUrl = objRequest.GetRequestUrl() />
		<cfset strUrl = replace( strUrl, "index.cfm", "") />

		<cfreturn xmlFormat(strUrl) />

	</cffunction>

	<cffunction name="getRequestArguments" access="public" output="false" returntype="any" hint="">

		<cfargument name="arg" type="string" required="no" default="" />

		<!--- Get request from ColdFusion page context. --->
		<cfset var res = structNew() />
		<cfset var objRequest = GetPageContext().GetRequest() />

		<cfloop list="#objRequest.GetQueryString()#" index="kv" delimiters="&">

			<cfif listLen(kv,"=") GT 1 >
				<cfset value = listGetAt(kv,2,'=') />
			<cfelse>
				<cfset value = "" />
			</cfif>

			<cfset res["#listGetAt(kv,1,'=')#"] = value />

		</cfloop>

		<cfif arguments.arg eq "">
			<cfreturn res />
		<cfelseif structKeyExists( res, arguments.arg )>
			<cfreturn res[arguments.arg] />
		<cfelse>
			<cfreturn "" />
		</cfif>

	</cffunction>

	<cffunction name="struct2XMLattributes" access="public" output="false" returntype="string">

		<cfargument name="arg" type="struct" required="yes" />

		<cfset var r = "" />

		<cfloop collection="#arguments.arg#" item="key">

			<cfset r &= '#xmlFormat(key)#="#xmlFormat(arguments.arg[key])#" ' />

		</cfloop>

		<cfreturn r />

	</cffunction>


	<cfscript>

		// replaces empty string with default value
		function unEmpty(cIn, cDefault) {

			if (trim(cIn) eq "") return cDefault;
			else return cIn;
		}

	</cfscript>


	<!---
		Returns the current URL for the page.

		@return Returns a string.
		@author Topper (topper@cftopper.com)
		@version 1, September 5, 2008
	--->
	<cffunction name="getCurrentURL" output="No" access="public" returnType="string">
		<cfset var theURL = getPageContext().getRequest().GetRequestUrl().toString()>
		<cfif len( CGI.query_string )><cfset theURL = theURL & "?" & CGI.query_string></cfif>
		<cfreturn theURL>
	</cffunction>


	<cfscript>

		function getYoutubeUrlfromEmbed( embed, autoplay ) {

			if ( not structKeyExists( arguments, 'autoplay' ) ) arguments.autoplay="false";

			var q = reFind( 'embed\/([^"]+)"', embed, 0, true);
			if ( arrayLen(q.len) gte 2 AND arrayLen(q.pos) gte 2 ) {
				var r = mid ( embed, q.pos[2], q.len[2] );
			}
			else {
				var r = "unknown";
			}

			r = "https://www.youtube.com/embed/" & r;
			if (autoplay eq true) r &= "?rel=0&autoplay=1";

			return r;
		}

	</cfscript>


	<!---
		Rip HTML tags from string. Also maps html entities (&eacute;) to their utf8 form (é).
	--->
	<cfscript>

		function ripHTML(text) {

			/* remove html tags */
			text = reReplace( text, "<[^>]*>", "", "all" );
			/* remove incomplete html tags which may result from abbreviation */
			text = reReplace( text, "<[^$]*$", "", "all" );

			StrEscUtils = createObject( "java", "org.apache.commons.lang.StringEscapeUtils" );
			text = StrEscUtils.unescapeHTML( text );

			return text;
		}

	</cfscript>




</cfsilent>