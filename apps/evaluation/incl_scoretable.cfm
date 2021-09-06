
        <style>
            .scorebord-container{
                /*display: flex;
                flex-wrap: wrap;
                justify-content:
                flex-wrap: nowrap; center;
                flex-direction: row; */
                overflow-x: auto;
                width: 675px;
                height: 180px;
               /* border-style: solid;
                border-width: 1px;*/
                <cfoutput>
                background-image: url("#application.applicationBaseURLPath#/images/anger-tools-empty-chair.jpg");
            </cfoutput>
                 background-repeat: repeat;
                background-size: 150px;
                text-justify: center;
                text-align: center;
            }
             
            .scorebord-container div.scoreboard{
               /* display: flex;
                flex: 0 0 auto;*/
                list-style: none;
                float:left;
                padding: 0;
                margin: 8px;
                background-color: rgb(200, 245, 226);
                /*
                margin: 0;
                margin-right: 5px; 
                margin-bottom: 1em;
                */
                width: 142px;
                height: 152px; 
                border: 1px solid gray;
                transition: all .5s;
                text-align: center;
            }
             
            .scorebord-container div.scoreboard:hover{ 
                transform: scale(1.05);
                transition: all .5s;
                border: 3px solid rgb(83, 70, 207);
                z-index: 100;
                box-shadow: 0 0 10px gray;
            }
            .scorecard-weight {
                font-size: 40px;
            }
             /* 
            .scorebord-container div.scoreboard:last-of-type{ remove right margin in very last table
                margin-right: 0;
            }
             
            .scorebord-container div.scoreboard div:last-of-type{
                text-align: center;
                margin-top: auto; lign last div (price botton div) to the very bottom of div
            }  
              */
             /* 
            @media only screen and (max-width: 600px) {
                .scorebord-container div.scoreboard{
                    border-radius: 0;
                    width: 100%;
                    margin-right: 0;
                }
             
                .scorebord-container div.scoreboard:hover{
                    transform: none;
                    box-shadow: none;
                }
                 
                .scorebord-container a.pricebutton{
                    display: block;
                }
            } */
        body {
            width: 700px;
            margin: auto;
        }
        </style>
    <!--- <script>
    aryBlnResponseBtnChecked = [{value : ''}];
    aryBlnRequired = [{value : ''}];
    aryScore = [{value : ''}];
    aryWeight = [{value : ''}];
    aryTotStdWt = [{value : ''}];
    aryTotWt = [{value : ''}];
    aryRunWt = [{value : ''}];
    aryRunScore = [{value : ''}];
    aryAvg = [{value : ''}];
    aryGradesWt = [{value : ''}];
    m_intQuestionsPct = [{value : ''}];
    intMaxGrades = [{value : ''}];
    intTotQuizWt = [{value : ''}];
    intMaxTotQuizStdWt = [{value : ''}];
    intTotQuizScore = [{value : ''}];
    aryBlnResponseBtnChecked[0].value = 1;
    aryBlnRequired[0].value = 0;
    aryScore[0].value = 3;
    aryWeight[0].value = 20;
    aryTotStdWt[0].value = 435;
    aryTotWt[0].value = 60;
    aryRunWt[0].value = 90;
    aryRunScore[0].value = 435;
    aryAvg[0].value = 100;
    aryGradesWt[0].value = undefined;
    m_intQuestionsPct[0] = 13.79;
    intMaxGrades = 3;
    intTotQuizWt = 435;
    intMaxTotQuizStdWt = 435;
    intTotQuizScore = 0;
        msg = "This question has a maximum weight of " + parseInt(aryWeight[0].value) * intMaxGrades;
        msg += "<br>(" + fncCalcQuestionsWeight(0) + "%) of the total possible of " + intMaxTotQuizStdWt;
       // document.getElementById('tooltiptext').innerHTML=msg;
    
        function fncCalcQuestionsWeight(n_inxQuestion) {
        let m_intQuestionsPct = 0;
        let m_intMaxQuestionStdWt = parseInt(aryWeight[n_inxQuestion].value) * intMaxGrades;
        if ( (aryBlnResponseBtnChecked[n_inxQuestion].value != 1) || (aryScore[n_inxQuestion].value == 0) && (aryBlnRequired[n_inxQuestion].value == 0)  ) {
            m_intQuestionsPct = ( m_intMaxQuestionStdWt / (intMaxTotQuizStdWt + m_intMaxQuestionStdWt) ) * 100;
        } else {
            m_intQuestionsPct = ( m_intMaxQuestionStdWt / intMaxTotQuizStdWt) * 100;
        }
        return m_intQuestionsPct.toFixed(2);
    }
    
    </script> --->

    <div class="scorebord-container" id="scorebord-container" style="display: none">

        <cfsavecontent variable="htmlScorebordDiv">
            <div class="scoreboard">
                <div class="title"><b>Score</b><br /><span name="strScorecardName"><cfoutput>#form.strName#</cfoutput></span><br/></div>
                <div class="scorecard-weight"><span name="strScorecardFinalScore"></span></div>
                <div><em><span name="strScorecardCategory"></span></em></div>
                <div><b><span name="strScorecardCategoryScore"></span></b></div>
            </div>
        </cfsavecontent>

        <cfoutput>#htmlScorebordDiv#</cfoutput>
        <cfset lstScoreboardCandidates = "">
        <cfoutput query="qryAllInterviews">
            <cfif qryAllInterviews.interviewsID NEQ form.interviewsID>
                <cfif qryAllInterviews.strPosition EQ form.strPosition>
                    #htmlScorebordDiv#
                    <cfset lstScoreboardCandidates = listAppend(lstScoreboardCandidates, fncGetCandidateQuizScores(), "|")>
                </cfif>
            </cfif>
        </cfoutput>
    </div>
    <cffunction name="fncGetCandidateQuizScores" output="false" returntype="any">
        <cfset QryGetCandidateQuizScores = getCandidateQuizScores(qryAllInterviews.interviewsID)>
        <cfsavecontent variable="jsonCanddateCompition" >
                {
                <cfoutput>
                "name" : "#qryAllInterviews.strName#",
                "final score" : "#qryAllInterviews.intScore#",
                </cfoutput> 
                <cfoutput query="QryGetCandidateQuizScores">
                    "#QryGetCandidateQuizScores.strCategory#" : "#listGetAt(lstWtLiterals, QryGetCandidateQuizScores.intResponse_value)#"
                    <cfif QryGetCandidateQuizScores.currentRow LT QryGetCandidateQuizScores.recordcount>
                        ,
                    </cfif>
                </cfoutput>
                }
        </cfsavecontent>
        <cfreturn jsonCanddateCompition>
    </cffunction>
    
    <cffunction name="getCandidateQuizScores" output="false" returntype="query">
        <cfargument name="n_interviews_ID" type="numeric" default="">
        <cfquery name="qryCandidateQuizScores">
            SELECT 
                quiz.ID,
                quiz.intResponse_value,
                questions.ID as questionsID,
                questions.strCategory,
                questions.intWeight
                
                FROM candidates.quiz,  candidates.questions

                WHERE quiz.interviews_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.n_interviews_ID#">
                AND quiz.questions_ID =  questions.ID
                ORDER BY questions.intSequence ASC;

        </cfquery>
        <cfreturn qryCandidateQuizScores>
    </cffunction>
    <cfif len(lstScoreboardCandidates)>
        <cfset lstScoreboardCandidates = replace(lstScoreboardCandidates, '|', ',', 'all')>
    </cfif>
    <script>
        const aryScorecardName = document.getElementsByName('strScorecardName');
        const aryScorecardFinalScore = document.getElementsByName('strScorecardFinalScore');
        const aryScorecardCategory = document.getElementsByName('strScorecardCategory');
        const aryScorecardCategoryScore = document.getElementsByName('strScorecardCategoryScore');
        const g_jsonScoreboardCandidates = [<cfoutput>#lstScoreboardCandidates#</cfoutput>];
        for (var i = 0; i < aryScorecardName.length; i++) {
            aryScorecardName[( i + 1)].innerHTML = g_jsonScoreboardCandidates[i]['name'];
            aryScorecardFinalScore[( i + 1)].innerHTML = g_jsonScoreboardCandidates[i]['final score'];
        }
    </script>
