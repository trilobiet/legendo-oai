<cfcomponent extends="framework" output="false">

	<!-- after changes: ?reload=true -->

	<cfscript>

	this.mappings["/oai"] = "/legendoai/";
	this.name = '#cgi.server_name#-' & reReplace(getDirectoryFromPath(cgi.script_name),'[^A-Za-z0-9]','','all');

	this.oaicontext = replace(cgi.server_name,".","_","ALL");
	variables.oaicontext = this.oaicontext;

	this.SessionManagement = true;
	this.SessionTimeout = CreateTimeSpan(7, 0, 0, 0);
	this.SetClientCookies = true;
	this.SetDomainCookies = false;
	this.ClientManagement = true;
	this.ClientStorage = 'cookie';

	// FW/1 - configuration:
	variables.framework = {
		  action = "verb"
		, home = "overview.default"
		, suppressImplicitService = true // this defaults to true in FW/1 2.0
	};

	function setupApplication() {
		try {
			setBeanFactory(createObject("component", "model.ObjectFactory").init(expandPath("./domains/#this.oaicontext#/beans.xml.cfm")));
			application.quota = structNew();
		}
		catch (any e) {
			writeOutput("<h2>Undefined OAI context!</h2>There is no oai context directory for this domain (/domains/#this.oaicontext#/).");
			cfheader(statuscode="404", statustext="Resource not found");
			abort;
		}
	}

	function onMissingView( rc ) {
		return view( "illegalverb/default" );
	}


	function setupRequest() {

 		controller( 'illegalverb.checkverb' );

 		// param name="application.lastRequest" default="#now()#";

 		if (structkeyExists(application.quota,CGI.remote_host)) {
 			checkQuota();
 			application.quota['#CGI.remote_host#'].count += 1;
 			application.quota['#CGI.remote_host#'].lastrequest = now();
 		}
 		else {
 			application.quota['#CGI.remote_host#'].count = 1;
 			application.quota['#CGI.remote_host#'].lastrequest = createDate(1970,1,1);
 		}


	}


	function checkQuota() {

		// NO MORE than so many requests per week per ip!

 		if ( application.quota['#CGI.remote_host#'].count > 1500) {

 			if ( datediff( "h", application.quota['#CGI.remote_host#'].lastrequest, now() ) LTE 168 ) {
		 		writeOutput( "request quota exceeded for this repository" );
				if ( not structKeyExists( application.quota['#CGI.remote_host#'], 'exceeded' ) ) {
			 		writeLog( text="#CGI.remote_host# #application.applicationname# Request quota exceeded for this repository", file="oai-quota" );
			 		application.quota['#CGI.remote_host#']['exceeded'] = true;
				}
	 			// writeDump(application.quota);
	 			abort;
 			}
 			else {
 				application.quota['#CGI.remote_host#'].count = 1;
 				structDelete( application.quota['#CGI.remote_host#'],'exceeded');
 				writeLog( text="#CGI.remote_host# #application.applicationname# Request quota reset for this repository", file="oai-quota" );
 			}
 		}

	}


	</cfscript>

	<cfinclude template="views/viewhelpers.cfm"/>

</cfcomponent>
