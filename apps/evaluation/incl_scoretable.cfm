
        <style>
            .scorebord-container {
                overflow-x: auto;
                width: 675px;
                height: 180px;
                background-image: url("../../images/anger-tools-empty-chair.jpg");
                background-repeat: repeat;
                background-size: 150px;
                text-justify: center;
                text-align: center;
            }
             
            .scorebord-container div.scoreboard {
                list-style: none;
                float:left;
                padding: 0;
                margin: 8px;
                background-color: rgb(200, 245, 226);
                width: 142px;
                height: 152px; 
                border: 1px solid gray;
                transition: all .5s;
                text-align: center;
            }
             
            .scorebord-container div.scoreboard:hover { 
                transform: scale(1.05);
                transition: all .5s;
                border: 3px solid rgb(94, 90, 131);
                z-index: 100;
                box-shadow: 0 0 10px gray;
            }
            .scorecard-weight {
                font-size: 40px;
            }
            .evaluationTextScorecard {
                max-height: 140px;
                overflow: hidden;
                text-overflow: ellipsis; 
            }
        </style>
    <div class="scorebord-container" id="scorebord-container" style="display: none">
        <cfoutput>
            <div class="scoreboard" id="<cfoutput>#0#strScorecardName</cfoutput>">
                <div class="title"><b>Score</b><br />
                    <span name="strScorecardName"><cfoutput>#form.strName#</cfoutput></span>
                    <br/>
                </div>
                <div class="scorecard-weight">
                    <span name="strScorecardFinalScore"></span>
                </div>
                <div><em><span name="strScorecardCategory"></span></em>
                </div>
                <div>
                    <b><span name="strScorecardCategoryScore"></span></b>
                </div>
            </div></cfoutput>
        <cfset lstScoreboardCandidates = "">
        <cfset intScorecardCount = 0>
        <cfoutput query="qryAllInterviews">
            <cfif qryAllInterviews.interviewsID NEQ form.interviewsID>
                <cfif qryAllInterviews.strPosition EQ form.strPosition>
                    <cfset intScorecardCount = intScorecardCount + 1>
                    <div class="scoreboard" id="<cfoutput>#intScorecardCount#strScorecardName</cfoutput>" onClick="fncOpenCandidateWindow(#intScorecardCount#)">
                        <div class="title"><b>Score</b><br />
                            <span name="strScorecardName"><cfoutput>#qryAllInterviews.strName#</cfoutput></span>
                            <br/>
                        </div>
                        <div class="scorecard-weight">
                            <span name="strScorecardFinalScore"
                                    onmouseover="fncSwapInEvalationFinalScore(#intScorecardCount#);"
                                    onmouseout="fncSwapOutEvalation();">
                            </span>
                        </div>
                        <div><em><span name="strScorecardCategory"
                            onmouseover="fncSwapInEvalationCategory(#intScorecardCount#)"
                            onmouseout="fncSwapOutEvalation();">
                        </span></em></div>
                        <div>
                            <b><span name="strScorecardCategoryScore"></span></b>
                        </div>
                    </div>
                    <cfset lstScoreboardCandidates = listAppend(lstScoreboardCandidates, fncGetCandidateQuizScores(), "|")>
                </cfif>
            </cfif>
        </cfoutput>
    </div>
    <cffunction name="fncGetCandidateQuizScores" output="false" returntype="any">
        <cfset QryGetCandidateQuizScores = objInterviews.getCandidateQuizScores(qryAllInterviews.interviewsID)>
        <cfsavecontent variable="jsonCanddateCompition" >
                {
                <cfoutput>
                "name" : "#qryAllInterviews.strName#",
                "ID" : "#qryAllInterviews.interviewsID#",
                "final score" : "#qryAllInterviews.intScore#",
                "final comments" : "#JSStringFormat(qryAllInterviews.txtInterviewerComments)#",
                "interviewer" : "#JSStringFormat(qryAllInterviews.strInterviewer)#",
                "interviewDate" : "#JSStringFormat(dateFormat(qryAllInterviews.dtmInterviewDate, 'mm/dd/yyyy'))#",
                </cfoutput> 
                <cfoutput query="QryGetCandidateQuizScores">
                    "#QryGetCandidateQuizScores.strCategory#" : {"score" : "#listGetAt(lstWtLiterals, QryGetCandidateQuizScores.intResponse_value)#",
                        "comment" : "#JSStringFormat(QryGetCandidateQuizScores.strComment)#",
                        "comment date" : "#JSStringFormat(dateFormat(QryGetCandidateQuizScores.dtmModified, 'mm/dd/yyyy'))#"}
                    <cfif QryGetCandidateQuizScores.currentRow LT QryGetCandidateQuizScores.recordcount>,</cfif>
                </cfoutput>
                }
        </cfsavecontent>
        <cfreturn jsonCanddateCompition>
    </cffunction>
    
    <cfif len(lstScoreboardCandidates)>
        <cfset lstScoreboardCandidates = replace(lstScoreboardCandidates, '|', ',', 'all')>
    </cfif>
    <script>
        const g_jsonScoreboardCandidates = [<cfoutput>#lstScoreboardCandidates#</cfoutput>];
    </script>
    <script>
        const aryScorecardName = document.getElementsByName('strScorecardName');
        const aryScorecardFinalScore = document.getElementsByName('strScorecardFinalScore');
        const aryScorecardCategory = document.getElementsByName('strScorecardCategory');
        const aryScorecardCategoryScore = document.getElementsByName('strScorecardCategoryScore');

        for (var i = 0; i < aryScorecardName.length; i++) {
            aryScorecardName[( i + 1)].innerHTML = g_jsonScoreboardCandidates[i]['name'];
            aryScorecardFinalScore[( i + 1)].innerHTML = g_jsonScoreboardCandidates[i]['final score'];
        }
    </script>
    <script>
        function fncOpenCandidateWindow(n_intRow) {
            let m_interviewsID = g_jsonScoreboardCandidates[n_intRow - 1]['ID'];
            let m_strURL = "?strTransaction=view&interviewsID=" + m_interviewsID;
            winCandidatesWindow=window.open(m_strURL, "candidates", "width=710, height=700, left=400, top=300");
        }
    </script>
    <script>
        function fncSwapInEvalationFinalScore(n_intRow) {
            let ele_evaluationText = document.getElementById('evaluationTextID');
            let m_strInterviewer = g_jsonScoreboardCandidates[n_intRow - 1]['interviewer'];
            let m_strFinalText  = g_jsonScoreboardCandidates[n_intRow - 1]['final comments'];
            let m_strDate = g_jsonScoreboardCandidates[n_intRow - 1]['interviewDate'];
            let m_strText = "<b>Final comments from interview on " + m_strDate + " by " + m_strInterviewer + ":</b><hr/>";
            m_strText += m_strFinalText;
            ele_evaluationText.innerHTML = m_strText;
        }
        function fncSwapInEvalationCategory(n_intRow) {
            let ele_evaluationText = document.getElementById('evaluationTextID');
            let m_strCategory = document.getElementsByName('strScorecardCategory')[n_intRow].innerHTML.slice(0, -1);
            let m_strInterviewer = g_jsonScoreboardCandidates[n_intRow - 1]['interviewer'];
            let m_strCategoryText = g_jsonScoreboardCandidates[n_intRow - 1][m_strCategory]['comment'];
            let m_strDate = g_jsonScoreboardCandidates[n_intRow - 1][m_strCategory]['comment date'];
            let m_strText = "<b>" + m_strCategory + " comments from interview on " + m_strDate + " by " + m_strInterviewer + ":</b><hr/>";
            m_strText += m_strCategoryText;
            ele_evaluationText.innerHTML = m_strText;
        }
        function fncSwapOutEvalation() {
            let ele_evaluationText = document.getElementById('evaluationTextID');
            ele_evaluationText.innerHTML = "<cfoutput>#strEvaluationHTML#</cfoutput>";
        }
    </script>
