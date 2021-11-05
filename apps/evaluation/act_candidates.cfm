<!--- <cfdump var = "#form#"><cfabort> --->
<cfparam name="interviewsID" default="">
<cfif len(eForm.interviewsID)>
    <cfset interviewsID = eForm.interviewsID>
</cfif>
<cftransaction>
    <cfset strErrorMessage =  "">
    <cftry>
        <cfif lCase(eForm.strTransaction) EQ "delete">
            <cfquery name="deleteOldRows">
                DELETE FROM candidates.quiz
                    WHERE quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.interviewsID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">;
            </cfquery>
            <cfquery name="deleteOldInterview">
                DELETE FROM candidates.interviews
                    WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.interviewsID#">
                    AND interviews.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">;
            </cfquery>
        <cfelseif lCase(eForm.strTransaction) EQ "add">
            <cfquery name="addInterview">
                INSERT INTO candidates.interviews (
                    strPosition,
                    strInterviewer,
                    dtmInterviewDate,
                    txtInterviewerComments,
                    intScore,
                    evaluation_ID,
                    address_ID
                ) VALUES (
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#eForm.strPosition#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strInterviewer)#">,
                    <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(eForm.dtmInterviewDate, 'yyyy-mm-dd')#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#eForm.txtInterviewerComments#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.intFinalScore#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.addressID#">
                );
            </cfquery>
            <cfquery name="qryNewInterview">
                SELECT ID as interviewsID
                    FROM candidates.interviews
                    WHERE interviews.address_ID = "#eForm.addressID#" ORDER BY dtmAdded DESC; 
            </cfquery>
                <cfset interviewsID = qryNewInterview.interviewsID>
        <cfelse>
            <cfquery name="updateInterview">
                UPDATE candidates.interviews
                SET
                    strPosition =  <cfqueryparam cfsqltype="CF_sql_varchar" value="#eForm.strPosition#">,
                    strInterviewer = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strInterviewer)#">,
                    dtmInterviewDate = <cfqueryparam cfsqltype="cf_sql_date" value="#dateFormat(eForm.dtmInterviewDate, 'yyyy-mm-dd')#">,
                    txtInterviewerComments =  <cfqueryparam cfsqltype="CF_sql_varchar" value="#eForm.txtInterviewerComments#">,
                    intScore =  <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.intFinalScore#">
                WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.interviewsID#">;
            </cfquery>
            <cfquery name="deleteOldQuiz">
                DELETE FROM candidates.quiz
                    WHERE quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eForm.interviewsID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.evaluationID#">;
            </cfquery>
        </cfif>
        <cfif lCase(eForm.strTransaction) NEQ "delete">
            <cfset i = 1>
            <cfloop index="i" from="1" to ="#eForm.recordcount#">
                <cfif NOT structKeyExists(form, '#i#rdoResponse')>
                    <cfset form['#i#rdoResponse'] = "1">
                </cfif>
                <cfif NOT structKeyExists(form, '#i#strComment')>
                    <cfset form['#i#strComment'] = "">
                </cfif>
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
    </cftry>
    <cfif NOT len(strErrorMessage)>
        <cfif lCase(eForm.strTransaction) EQ "delete">
            <cfset strSuccessMessage = "record #eForm.interviewsID# deleted">    
            <cfset fncStructEmpty(form)>
            <cfset eForm.strTransaction = "update">
        <cfelseif lCase(eForm.strTransaction) EQ "add">
            <cfset strSuccessMessage = "record #eForm.interviewsID# added">
            <cfset eForm.strTransaction = "update">
            <cfset eForm.interviewsID = qryNewInterview.interviewsID>
        <cfelse>
            <cfset strSuccessMessage = "record #eForm.interviewsID# updated">
        </cfif>
    </cfif>
    
</cftransaction>
<cffunction name="fncStructEmpty" >
    <cfargument name="n_form" type="struct" required />
    <cfset eForm.interviewsID = "">
    <cfset eForm.addressID = "">
    <cfset eForm.strEmail = "">
    <cfset eForm.strName = "">
    <cfset eForm.strInterviewer = "">
    <cfset eForm.dtmInterviewDate = dateFormat(now(), "yyyy-mm-dd")>
    <cfset eForm.strPosition = "">
    <cfloop index="i" from="1" to ="#n_form.recordcount#">
        <cfset form['#i#rdoResponse'] =  "1"/>
        <cfset form['#i#strComment'] =  ""/>
    </cfloop>
</cffunction>
<cffunction name="uCaseFirst" access="private" output="false" returntype="String">
    <cfargument name="n_strText" required="false" type="String" default="" />
    <cfreturn reReplace(lCase(arguments.n_strText), "(\b\w)", "\u\1", "all") />
</cffunction>