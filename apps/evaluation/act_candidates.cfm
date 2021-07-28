    <!--- <cfdump var = "#form#"><cfabort> --->
        <cfif len(form.candidatesID)>
            <cfquery name="deleteOldRows">
                DELETE FROM candidates.quiz
                    WHERE (quiz.candidates_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.candidatesID#">
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">);
            </cfquery>
        </cfif>
        <cfset i = 1>
        <cfloop index="i" from="1" to ="#form.recordcount#">
            <cfquery name="addTempRows">
                INSERT INTO candidates.quiz (
                    intResponse_value,
                    strComment,
                    questions_ID,
                    candidates_ID,
                    evaluation_ID
                ) VALUES (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form['#i#rdoResponse']#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#form['#i#strComment']#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form['#i#questionsID']#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.candidatesID#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.evaluationID#">
                );
            </cfquery>
        </cfloop>