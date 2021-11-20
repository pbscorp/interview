component  displayname="Application" hint="Manages Application Flow" output="false" {
	// this.datasources["candidates"] = {
	// 	class: 'com.mysql.cj.jdbc.Driver'
	// 	, bundleName: 'com.mysql.cj'
	// 	, bundleVersion: '8.0.15'
	// 	, connectionString: 'jdbc:mysql://mysql7.loosefoot.com:3306/candidates?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Canada/Mountain&useLegacyDatetimeCode=true'
	// 	, username: 'cRemote'
	// 	, password: "encrypted:d4d49a1ad1610a1b1a4d5f9b0df6401543de1bd03b284500ca694b4039315e28"
		
	// 	// optional settings
	// 	, connectionLimit:100 // default:-1
	// 	, timezone:'Canada/Mountain'
	// 	, alwaysSetTimeout:true // default: false
	// 	, validate:false // default: false
	// };
	this.datasource="candidates";
  	this.Name = "interview";
	this.applicationTimeout = createTimeSpan(1,0,0,0);
	this.loginStorage = "cookie";
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,1,0,0);                          
	this.setClientCookies = true;
	this.ClientStorage = true;
	this.setDomainCookies = false;
	logFile = "applicationLog.txt";
	if (isDefined("application")) {
		if (structKeyExists(application, "applicationLogFilePath")) {
			logFile = "#application.applicationLogFilePath#/applicationLog.txt";
		}
	}
	application.blnLucee = false;
	application.blnAdobe = false;
	application.blnZenHosting = false;
	application.blnLFCHosting = false;
	application.blnLocalHosting = false;
	//writeDump(cgi)
	if (findNoCase("epscodesolutions", cgi.SERVER_NAME) > 0) {
		application.blnLucee = true;
		application.blnZenHosting = true;
        include "incl_appconfig_zen.cfm";
	} else if (findNoCase("pbsmenu", cgi.SERVER_NAME) > 0) {
		application.blnAdobe = true;
		application.blnLFCHosting = true;
        include "incl_appconfig_lfc.cfm";
	} else {
		application.blnLucee = true;
		application.blnLocalHosting = true;
        include "incl_appconfig_local.cfm";
	}


	public void function onSessionStart(){

		session.myvar = 10; //Setting Session scope variable
		application.myVar = 20; //Setting Application scope variable

		//File write during onSessionStart
		var logWriter = fileOpen(logFile, "append");
		fileWriteLine(logWriter,"Session started on :- #now()#");
		fileClose(logWriter);
		return;
	}

	public boolean function onRequestStart(string targetPage){
		return true;
	}

	public void function onRequest(string targetPage){
		//If appreset is defined in URL scope then reset the application by calling ApplicationStop
		if( structKeyExists(url, "appReset") ) {
			var logWriter = fileOpen(logFile, "append");
			fileWriteLine(logWriter,"Application stop is going to execute on :- #now()#");
			fileClose(logWriter);
			ApplicationStop();
			onApplicationStart();
		}

		//Include the Target Page
		include arguments.targetPage;
		return;
	}

	public void function onRequestEnd(){


		return;
	}

	public void function onSessionEnd(struct SessionScope, struct ApplicationScope){
		var logWriter = fileOpen(logFile, "append");
		fileWriteLine(logWriter,"Session ended on :- #now()#");
		fileClose(logWriter);
		return;
	}

	public void function onApplicationEnd(struct ApplicationScope){
		var logWriter = fileOpen(logFile, "append");
		fileWriteLine(logWriter,"Application ended on :- #now()#");
		fileClose(logWriter);
		return;
	}
	// if (application.blnLucee) {
	// 	this.mappings["/interview-cfc"] = "#application.applicationBaseFilePath#/interview/components/";
	// } else {
	// 	this.mappings["/interview-cfc"] = "#application.applicationBaseFilePath#pbsfragrance/samplecode/interview/components/";
	// };
}
