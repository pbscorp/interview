<cfscript>
    public boolean function onApplicationStart() {
        application.blnAdobe = false;
        application.blnZenHosting = false;
        application.blnLFCHosting = false;
		application.blnLucee = true;
		application.blnLocalHosting = true;
        application.applicationBaseURLPath = "/samplecode/interview";
        application.applicationRestMapping =  "http://localhost:8888/rest/interview/";
        application.applicationBaseFilePath = "C:\lucee\tomcat\webapps\ROOT\samplecode\interview";
        application.applicationLogFilePath = "C:\lucee\tomcat\webapps\ROOT\WEB-INF\lucee\logs";
        try {
            logFile = "#application.applicationLogFilePath#/applicationLog.txt";
            var logWriter = fileOpen(logFile, "append" );
            fileWriteLine(logWriter,"Application started on :- #now()#");
            fileClose(logWriter);
        } catch (any e) {
            writeOutput("Error: " & e.message);
        };
        return true;
    }
 </cfscript>
