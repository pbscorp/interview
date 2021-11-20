<cfscript>
    public boolean function onApplicationStart() {
        application.blnAdobe = false;
        application.blnLFCHosting = false;
        application.blnLocalHosting = false;
		application.blnLucee = true;
		application.blnZenHosting = true;
        application.applicationBaseURLPath = "/samplecode/interview";
        application.applicationRestMapping = "www.epscodesolutions.com/rest/interview/";
        application.applicationBaseFilePath = "D:\home\epscodesolutions.com\wwwroot\samplecode\interview";
        application.applicationLogFilePath = "D:\home\epscodesolutions.com\wwwroot\WEB-INF\lucee\logs";
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
