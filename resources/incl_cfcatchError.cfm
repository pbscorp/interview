<cfsavecontent variable = "stcCatchDump"> 
    <cfdump var="#cfcatch#" label="cfcatch">
    <cfif isStruct(form)>
        <cfdump var="#form#" label="form">
    </cfif>
    <cfif isStruct(url)>
        <cfdump var="#url#" label="url">
    </cfif>
</cfsavecontent>

<cffile action = "write" 
    file = "#application.applicationLogFilePath#\Catch_error#dateFormat(now(), 'yyyy-mm-dd')#at#timeFormat(now(), 'HHmmss')#.html" 
    output = "Created By: #cgi.SCRIPT_NAME# 
    Date: #dateFormat(now(), 'mm/dd/yy')# time: #timeFormat(now())#
    #stcCatchDump#">