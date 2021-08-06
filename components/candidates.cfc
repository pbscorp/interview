<c<cfcomponent name="candidates">
    <cffunction name="getQuestions" output="false" returntype="query">
        <cfargument name="n_ID" type="string" required="no" default="1">
        <cfquery name="qryQuestions">
            SELECT questions.ID,
                questions.intSequence,
                questions.strQuestion,
                questions.intWeight,
                questions.blnRequired
            FROM candidates.questions
                WHERE questions.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_ID#">
            ORDER BY  questions.intSequence ASC;
        </cfquery>
        <cfreturn qryQuestions>
    </cffunction>

    <cffunction name="getInterview" output="false" returntype="query">
        <cfargument name="n_ID" type="string" required="yes" default="0">
        <cfargument name="n_evaluation_ID" type="string" required="no" default="1">
        <cfquery name="qryInterview">
            SELECT interviews.ID as interviewsID,
                interviews.strInterviewer,
                interviews.dtmInterviewDate,
                interviews.strPosition,
                interviews.evaluation_ID,
                address.ID as addressID,
                CONCAT(address.strNameFirst, ' ', address.strNameMiddle, ' ', address.strNameLast) as strName,
                address.strAddressLine1,
                address.strAddressLine2,
                address.strCity,
                address.strState,
                address.strZip,
                address.strEmail,
                address.intPhone,
                address.intMobile
            FROM candidates.interviews,  candidates.address
                WHERE interviews.address_ID = address.ID
                    AND interviews.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
                <cfif lCase(arguments.n_ID) NEQ 'all'> 
                    AND interviews.ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_ID#">
                </cfif>
        </cfquery>
        <cfreturn qryInterview>
    </cffunction>

    <cffunction name="getstates" output="false" returntype="any">
        <cfscript>
            m_jsonStatesList = fileRead('../data/statecodes.json');
            r_stcStates = deserializeJson(m_jsonStatesList);
            return r_stcStates;
        </cfscript>
    </cffunction>

    <cffunction name="getEvaluation" output="false" returntype="query">
        <cfargument name="n_ID" type="string" required="yes" default="0">
        <cfquery name="qryEvaluation">
           SELECT evaluation.ID,
                    evaluation.strEvaluationText,
                    evaluation.lstWeight,
                    evaluation.lstWtLiterals
                FROM candidates.evaluation
                WHERE evaluation.ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_ID#">
        </cfquery>
        <cfreturn qryEvaluation>
    </cffunction>


    <cffunction name="getQuiz" output="false" returntype="query">
        <cfargument name="n_interviews_ID" type="string" default="">
        <cfargument name="n_evaluation_ID" type="numeric" default=1>
        <cfif lCase(arguments.n_interviews_ID) EQ "new">
            <cfset arguments.n_interviews_ID = fncSetTempQuiz(arguments.n_evaluation_ID)>
        </cfif>
        <cfquery name="qryQuiz">
            SELECT 
                quiz.ID,
                quiz.intResponse_value,
                quiz.strComment,
                quiz.dtmAdded,
                quiz.dtmModified,
                quiz.questions_ID,
                quiz.interviews_ID,
                quiz.evaluation_ID,
                
                questions.ID as questionsID,
                questions.intSequence,
                questions.strQuestion,
                questions.strCategory,
                questions.intWeight,
                questions.blnRequired
                
                FROM candidates.quiz,  candidates.questions

                WHERE quiz.questions_ID =  questions.ID
                    AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
                    AND quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_interviews_ID#">
                ORDER BY questions.intSequence ASC;

        </cfquery>
        <cfreturn qryQuiz>
    </cffunction>

    <cffunction name="fncSetTempQuiz" output="false" returntype="any">
        <cfargument name="n_evaluation_ID" type="numeric" default=1>
        <cfquery name="deleteOldRows">
            DELETE FROM candidates.quiz
                WHERE quiz.interviews_ID = 9999
                AND quiz.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">;
        </cfquery>
        <cfquery name="addTempRows">
            INSERT INTO candidates.quiz
            (questions_ID, interviews_ID, evaluation_ID)
                SELECT 
                questions.ID, 9999,  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
                FROM candidates.questions
                WHERE questions.evaluation_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
        </cfquery>
        <cfreturn 9999>
    </cffunction>

</cfcomponent>
