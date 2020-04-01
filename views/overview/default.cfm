
<cfset qmdf = rc.metadataformats.getResult() />

<!---
<cfdump var="#rc.metadataformats.getResult()#"/><cfabort>
--->

<cfsetting showdebugoutput="false" />

<cfoutput>

	<h1>Legendo - #cgi.server_name#</h1>
	<h2>Open Archives Initiative repository</h2>

	<div class="freetext">

		<ul>
			<li><a rel="nofollow" href="?verb=Identify">Identify</a></li>
			<li><a rel="nofollow" href="?verb=ListSets">ListSets</a></li>
			<li><a rel="nofollow" href="?verb=ListMetadataFormats">ListMetadataFormats</a></li>
		</ul>

		<cfloop query="qmdf">
			<h3>#format#</h3>

			<ul>
				<li>schema: <a href="#schema#">#schema#</a></li>
				<li>namespace: <a href="#namespace#">#namespace#</a></li>
			</ul>

			<ul>
				<li><a rel="nofollow" href="?verb=ListIdentifiers&metadataPrefix=#format#">ListIdentifiers</a></li>
				<li><a rel="nofollow" href="?verb=ListRecords&metadataPrefix=#format#">ListRecords</a></li>
				<li>
					<a rel="nofollow" href="?verb=GetRecord&metadataPrefix=#format#"
						onclick="
					   		recId = document.getElementById('recid-#format#').value;
					   		if(recId=='') return false;
					   		else this.href = '?verb=GetRecord&metadataPrefix=#format#&identifier=' + recId;
						"
					>GetRecord</a>
					<input type="text" id="recid-#format#" value="enter id here" onfocus="this.value=''" style="border:dotted 1px ##666;width:20em"/>
				</li>
			</ul>
		</cfloop>


	</div>

	<cfif structKeyExists(rc, "reload")>
		<p>The framework cache (and application scope) have been reset.</p>
	</cfif>

	<hr/>

	<div style="text-align:left; font-size:90%">
		This repository is a service of <a href="http://www.legendo.nl">Legendo Media Collection Websites</a>
		<br/>
		Version: 2.1 (2018)<br/>
		System: <a href="http://www.trilobiet.nl">Trilobiet ID</a>
		<br/>
		<br/>
		<span style="color:##AAA">app-id: #application.applicationname#</span>
	</div>

</cfoutput>

<!---<cfdump var="#application.quota#"/>--->


