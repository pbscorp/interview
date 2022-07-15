<cfscript>
	this.mappings["/interview-cfc"] = "C:\Users\EdwardSullivan\commandbox\interview\CFinterview\components/";
    public boolean function onApplicationStart() {
        application.blnLucee = false;
        application.blnZenHosting = false;
        application.blnLocalHosting = true;
		    application.blnAdobe = true;
		    application.blnLFCHosting = true;
        application.applicationBaseURLPath = "/interview/CFinterview/"
        application.applicationRestMapping =  "http://localhost:64335/rest/interview/";
        application.applicationBaseFilePath = "C:\Users\EdwardSullivan\commandbox\interview\CFinterview";
        application.applicationLogFilePath = "C:\Users\EdwardSullivan\cflogs";
        restInitApplication(
            "#application.applicationBaseFilePath#/rest\",
            "interview");
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
