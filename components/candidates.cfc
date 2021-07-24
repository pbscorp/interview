<c<cfcomponent name="candidates">
    <cffunction name="getQuestions" output="false" returntype="query">
        <cfquery name="qryQuestions">
            SELECT `questions`.`ID`,
                `questions`.`intSequence`,
                `questions`.`strQuestion`,
                `questions`.`intWeight`,
                `questions`.`blnRequired`
            FROM `candidates`.`questions`
            ORDER BY  `questions`.`intSequence` ASC;
        </cfquery>
        <cfreturn qryQuestions>
    </cffunction>

    <cffunction name="getCandidate" output="false" returntype="query">
        <cfargument name="n_ID" type="string" required="yes" default="0">
        <cfquery name="qryCandidate">
            SELECT `candidates`.`ID`,
                `candidates`.`strName`,
                `address`.`ID`,
                `address`.`strNameFirst`,
                `address`.`strNameMiddle`,
                `address`.`strNameLast`,
                `address`.`strAddressLine1`,
                `address`.`strAddressLine2`,
                `address`.`strCity`,
                `address`.`strState`,
                `address`.`strZip`,
                `address`.`strEmail`,
                `address`.`intPhone`,
                `address`.`intMobile`
            FROM `candidates`.`candidates`,  `candidates`.`address`
                WHERE `candidates`.`Address_ID` = `address`.`ID`
                <cfif lCase(arguments.n_ID) NEQ 'all'> 
                    AND `candidates`.`ID`= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_ID#">
                </cfif>
        </cfquery>
        <cfreturn qryCandidate>
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
           SELECT `evaluation`.`ID`,
                    `evaluation`.`strEvaluationText`,
                    `evaluation`.`lstWeight`,
                    `evaluation`.`lstWtLiterals`
                FROM `candidates`.`evaluation`
                WHERE `evaluation`.`ID`= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_ID#">
        </cfquery>
        <cfreturn qryEvaluation>
    </cffunction>


    <cffunction name="getQuiz" output="false" returntype="query">
        <cfargument name="n_candidates_ID" type="string" default="">
        <cfargument name="n_evaluation_ID" type="numeric" default=1>
        <cfif lCase(arguments.n_candidates_ID) EQ "new">
            <cfset arguments.n_candidates_ID = fncSetTempQuiz(arguments.n_evaluation_ID)>
        </cfif>
        <cfquery name="qryQuiz">
            SELECT 
                `quiz`.`ID`,
                `quiz`.`intResponse_value`,
                `quiz`.`strComment`,
                `quiz`.`dtmAdded`,
                `quiz`.`dtmModified`,
                `quiz`.`questions_ID`,
                `quiz`.`candidates_ID`,
                `quiz`.`evaluation_ID`,
                
                `questions`.`intSequence`,
                `questions`.`strQuestion`,
                `questions`.`strCategory`,
                `questions`.`intWeight`,
                `questions`.`blnRequired`
                
                FROM `candidates`.`quiz`,  `candidates`.`questions`

                WHERE `quiz`.`questions_ID` =  `questions`.`ID`
                    AND `quiz`.`evaluation_ID` =  `questions`.`evaluation_ID`
                    AND `quiz`.`evaluation_ID` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
                    AND `quiz`.`candidates_ID` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_candidates_ID#">
                ORDER BY `questions`.`intSequence` ASC;

        </cfquery>
        <cfreturn qryQuiz>
    </cffunction>

    <cffunction name="fncSetTempQuiz" output="false" returntype="any">
        <cfargument name="n_evaluation_ID" type="numeric" default=1>
        <cfquery name="deleteOldRows">
            DELETE FROM `candidates`.`quiz`
                WHERE `quiz`.`candidates_ID` = 9999
                AND `quiz`.`evaluation_ID` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">;
        </cfquery>
        <cfquery name="addTempRows">
            INSERT INTO `candidates`.`quiz`
            (questions_ID, candidates_ID, evaluation_ID)
                SELECT 
                `questions`.`ID`, 9999,  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
                FROM `candidates`.`questions`
                WHERE `questions`.`evaluation_ID` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_evaluation_ID#">
        </cfquery>
        <cfreturn 9999>
    </cffunction>
</cfcomponent>
