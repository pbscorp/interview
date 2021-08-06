<!--- <cfdump var = "#form#"><cfabort> --->
<cftransaction>
    <cftry>
        <cfif len(form.deleteButton) >
            <cfquery name="deleteOldRows">
                DELETE FROM candidates.quiz
                    WHERE quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">;
            </cfquery>
            <cfquery name="deleteOldInterview">
                DELETE FROM candidates.interviews
                    WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
                    AND interviews.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">;
            </cfquery>
            <cfset form.strTransaction = "Add">
            <cfset strSuccessMessage = "record #form.interviewsID# deleted">
            <cfset form.interviewsID = ''>
        <cfelseif lCase(form.strTransaction) EQ "add">
            <cfquery name="addInterview">
                INSERT INTO candidates.interviews (
                    strPosition,
                    strInterviewer,
                    dtmInterviewDate,
                    evaluation_ID,
                    address_ID
                ) VALUES (
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strPosition#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strInterviewer#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.addressID#">
                );
            </cfquery>
            <cfquery name="qryNewInterview">
                SELECT ID as interviewsID
                    FROM candidates.interviews
                    WHERE interviews.address_ID = "#form.addressID#" ORDER BY dtmAdded DESC; 
            </cfquery>
            <cfset form.interviewsID = qryNewInterview.interviewsID>
        <cfelse>
            <cfquery name="updateInterview">
                UPDATE candidates.interviews
                SET
                    strPosition =  <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strPosition#">,
                    strInterviewer = <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strInterviewer#">,
                    dtmInterviewDate = <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#">
                WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">;
            </cfquery>
        </cfif>
        <cfif len(form.submitButton) >
            <cfset i = 1>
            <cfloop index="i" from="1" to ="#form.recordcount#">
                <cfquery name="addQuiz">
                    INSERT INTO candidates.quiz (
                        intResponse_value,
                        strComment,
                        questions_ID,
                        interviews_ID,
                        evaluation_ID
                    ) VALUES (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form['#i#rdoResponse']#">,
                        <cfqueryparam cfsqltype="CF_sql_varchar" value="#form['#i#strComment']#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form['#i#questionsID']#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">
                    );
                </cfquery>
            </cfloop>
            <cfif lCase(form.strTransaction) EQ "add">
                <cfset strSuccessMessage = "record #form.interviewsID# added">
                <cfset form.strTransaction = "update">
            <cfelse>
                <cfset strSuccessMessage = "record #form.interviewsID# updated">
            </cfif>
        </cfif>
        <cfcatch>
            <cfsavecontent variable = "stcCatchDump"> 
                <cfdump var="#cfcatch#">
            </cfsavecontent>
                <cffile action = "write" 
                    file = "C:\lucee\tomcat\logs\CFerror\Catch_error#dateFormat(now(), 'yyyy-mm-dd')##timeFormat(now(), 'HHmmss')#.html" 
                    output = "Created By: #cgi.SCRIPT_NAME# 
                    Date: #dateFormat(#now()#, 'mm/dd/yy')# 
                    #cfcatch#">
        <cfset strErrorMessage= "See error log:#cfcatch.message#">
        </cfcatch>
    </cftry>
    
</cftransaction>