    <!--- <cfdump var = "#form#"><cfabort> --->
        <cfif len(form.interviewsID)>
            <cfquery name="deleteOldRows">
                DELETE FROM candidates.quiz
                    WHERE (quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">);
            </cfquery>
            <cfquery name="deleteOldInterview">
                DELETE FROM candidates.interviews
                    WHERE interviews.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.interviewsID#">
            </cfquery>
        </cfif>
        <cfquery name="addInterview">
            INSERT INTO candidates.interviews (
                strPosition,
                strInterviewer,
                dtmInterviewDate,
                address_ID
            ) VALUES (
                <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strPosition#">,
                <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strInterviewer#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#form.dtmInterviewDate#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.addressID#">
            );
        </cfquery>
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