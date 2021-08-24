<!--- <cfdump var = "#form#"><cfabort> --->
<cfparam name="interviewsID" default="">
<cfif len(form.interviewsID)>
    <cfset interviewsID = form.interviewsID>
</cfif>
<cftransaction>
    <cfset strErrorMessage =  "">
    <cftry>
        <cfif lCase(form.strTransaction) EQ "delete">
            <cfquery name="deleteOldRows">
                DELETE FROM candidates.quiz
                    WHERE quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">;
            </cfquery>
            <cfquery name="deleteOldInterview">
                DELETE FROM candidates.interviews
                    WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
                    AND interviews.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">;
            </cfquery>
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
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strInterviewer)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.addressID#">
                );
            </cfquery>
            <cfquery name="qryNewInterview">
                SELECT ID as interviewsID
                    FROM candidates.interviews
                    WHERE interviews.address_ID = "#form.addressID#" ORDER BY dtmAdded DESC; 
            </cfquery>
                <cfset interviewsID = qryNewInterview.interviewsID>
        <cfelse>
            <cfquery name="updateInterview">
                UPDATE candidates.interviews
                SET
                    strPosition =  <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strPosition#">,
                    strInterviewer = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strInterviewer)#">,
                    dtmInterviewDate = <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#">
                WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">;
            </cfquery>
            <cfquery name="deleteOldQuiz">
                DELETE FROM candidates.quiz
                    WHERE quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">;
            </cfquery>
        </cfif>
        <cfif lCase(form.strTransaction) NEQ "delete">
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
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#interviewsID#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">
                    );
                </cfquery>
            </cfloop>
        </cfif>
        <cfcatch>
            <cfinclude template="#application.applicationBaseURLPath#/resources/incl_cfcatchError.cfm">
            <cfset strErrorMessage= "See error log:#cfcatch.message#">
            <cftransaction action = "rollback"/>
        </cfcatch>
        <cfif NOT len(strErrorMessage)>
            <cfif lCase(form.strTransaction) EQ "delete">
                <cfset strSuccessMessage = "record #form.interviewsID# deleted">    
                <cfset fncStructEmpty(form)>
                <cfset form.strTransaction = "add">
            <cfelseif lCase(form.strTransaction) EQ "add">
                <cfset strSuccessMessage = "record #form.interviewsID# added">
                <cfset form.strTransaction = "update">
                <cfset form.interviewsID = qryNewInterview.interviewsID>
            <cfelse>
                <cfset strSuccessMessage = "record #form.interviewsID# updated">
            </cfif>
        </cfif>
    </cftry>
    
</cftransaction>
<cffunction name="fncStructEmpty" >
    <cfargument name="n_form" type="struct" required />
    <cfset form.interviewsID = "">
    <cfset form.addressID = "">
    <cfset form.strEmail = "">
    <cfset form.strName = "">
    <cfset form.strInterviewer = "">
    <cfset form.dtmInterviewDate = dateFormat(now(), "yyyy-mm-dd")>
    <cfset form.strPosition = "">
    <cfloop index="i" from="1" to ="#n_form.recordcount#">
        <cfset form['#i#rdoResponse'] =  "1"/>
        <cfset form['#i#strComment'] =  ""/>
    </cfloop>

</cffunction>