<cfscript>
	this.mappings["/interview-cfc"] = "E:/web/public_html/pbssecure/pbsmenu/pbsfragrance/samplecode/interview/components/";
    public boolean function onApplicationStart() {
        application.applicationBaseURLPath = "/pbsfragrance/samplecode/interview";
        application.applicationRestMapping =  "www.pbsmenu.com/rest/interview/";
        application.applicationBaseFilePath = "E:/web/public_html/pbssecure/pbsmenu/pbsfragrance/samplecode/interview";
        application.applicationLogFilePath = "E:/web/public_html/pbssecure/pbsmenu/logs";
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
