
<h1>Oeps...</h1>

<cfoutput>

	<p>
		Daar ging iets mis!
		<br/><br/>
		<blockquote class="warning">
			#request.exception.message#<br/>
			#request.exception.rootcause.message#<br/>
			#request.exception.rootcause.detail#<br/>
		</blockquote>
		<a href="javascript:history.go(-1);">&lsaquo; terug</a>
	</p>

	<!---
	<cfdump var="#request.exception#">
	--->

</cfoutput>


<!--- do not apply any XML layout --->
<cfset request.layout = false>
