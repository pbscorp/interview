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
	this.mappings["/interview-cfc"] = "E:/web/public_html/pbssecure/pbsmenu/pbsfragrance/samplecode/interview/components/";

	public boolean function onApplicationStart(){
		system=createObject("java", "java.lang.System");
		strJavaHome = system.getproperty("java.home");
		writeoutput(strJavaHome);
		writeoutput(findNoCase("lucee", strJavaHome));
		writeoutput(findNoCase("lucee", strJavaHome) == -1);
		if (findNoCase("lucee", strJavaHome) < 1) {
			application.blnLucee = false;
		} else {
			application.blnLucee = true;
		}
		if (!application.blnLucee) {
			application.applicationBaseURLPath = "/pbsfragrance/samplecode/interview";
			application.applicationRestMapping =  "www.pbsmenu.com/rest/interview/";
			application.applicationBaseFilePath = "E:/web/public_html/pbssecure/pbsmenu/pbsfragrance/samplecode/interview";
			//application.applicationBaseFilePath = "E:/web/public_html/pbssecure/pbsmenu/";// old
			application.applicationLogFilePath = "E:/web/public_html/pbssecure/pbsmenu/logs";
			writeDump(application);
			writeoutput(' yes this is adobe');
			restInitApplication(
				"#application.applicationBaseFilePath#/rest\",
				// "#application.applicationBaseFilePath#pbsfragrance/samplecode/interview/rest\",//old
				"interview");
		} else {
			writeoutput('adobe false');
			m_jsonAppConfig = fileRead('resources/appconfig.json');
			m_stcAppConfig = deserializeJson(m_jsonAppConfig);
			application.applicationBaseURLPath = "/samplecode/interview";
			application.applicationRestMapping =  "http://localhost:8888/rest/interview/";
			application.applicationBaseFilePath = "C:\lucee\tomcat\webapps\ROOT\samplecode\interview";
			application.applicationLogFilePath = "C:\lucee\tomcat\webapps\ROOT\WEB-INF\lucee\logs";
			//this.mappings["/interview-cfc"] = "#application.applicationBaseFilePath#/interview/components/";

			application.dirPath =   "C:\lucee\tomcat\webapps\ROOT\samplecode\interview\rest\";
			application.serviceMapping = "interview";
			application.luceepassword = "Lpatrick##1";
			include "fncLuceeMapping.cfml";
			
				// function fncLuceeMapping() {
				// 	restInitApplication(dirPath="#application.dirPath#", 
				// 		serviceMapping="#application.serviceMapping#", 
				// 		password="#application.luceepassword#");
				// }
				
			
			//localhost:8888/rest/interview/api_candidates/get_address?strTable=address&strKeyColumnName=strEmail&strKeyColumnValue=ss%2540pbsmenu.com&lstColumns=ID%7CstrNameFirst%7CstrNameMiddle%7CstrNameLast&strOrderByClause= 500
			
			//localhost:8888/rest/interview/api_candidates/get_address?strTable=address&strKeyColumnName=strEmail&strKeyColu
		}

		// :\lucee\jre-1falseadobe true
		try {
		var logWriter = FileOpen("#application.applicationLogFilePath#/testApplicationStop.txt", "append" );
		FileWriteLine(logWriter,"Application started on :- #now()#");
		FileClose(logWriter);
		} catch (any e) {
			writeOutput("Error: " & e.message);
		};
		// writeOutput("#application.applicationBaseFilePath#logs/testApplicationStop.txt ");
		// writeOutput(application.luceepassword);
		// writeOutput(" application.dirPath = #application.dirPath#");
		//writeDump(this.datasources);
			
		//abort;
		return true;

	}

	public void function onSessionStart(){

		session.myvar = 10; //Setting Session scope variable
		application.myVar = 20; //Setting Application scope variable

		//File write during onSessionStart
		var logWriter = FileOpen("testApplicationStop.txt", "append");
		FileWriteLine(logWriter,"Session started on :- #now()#");
		FileClose(logWriter);
		return;
	}

	public boolean function onRequestStart(string targetPage){
		return true;
	}

	public void function onRequest(string targetPage){

		//Include the Target Page
		include arguments.targetPage;
		return;
	}

	public void function onRequestEnd(){

		//If appreset is defined in URL scope then reset the application by calling ApplicationStop
		if( structKeyExists(url, "appReset") ) {
			var logWriter = FileOpen("testApplicationStop.txt", "append");
			FileWriteLine(logWriter,"Application stop is going to execute on :- #now()#");
			FileClose(logWriter);

			ApplicationStop();

			/*
				We can also call onApplicationStart() function here
			*/
		}

		return;
	}

	public void function onSessionEnd(struct SessionScope, struct ApplicationScope){
		//File write during onSessionEnd
		var logWriter = FileOpen("testApplicationStop.txt", "append");
		FileWriteLine(logWriter,"Session ended on :- #now()#");
		FileClose(logWriter);
		return;
	}

	public void function onApplicationEnd(struct ApplicationScope){
		//File write during onApplicationEnd
		var logWriter = FileOpen("testApplicationStop.txt", "append");
		FileWriteLine(logWriter,"Application ended on :- #now()#");
		FileClose(logWriter);
		return;
	}
	// if (application.blnLucee) {
	// 	this.mappings["/interview-cfc"] = "#application.applicationBaseFilePath#/interview/components/";
	// } else {
	// 	this.mappings["/interview-cfc"] = "#application.applicationBaseFilePath#pbsfragrance/samplecode/interview/components/";
	// };
}
