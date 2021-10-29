
    <div id="quizSectionID">
        <cfoutput>
            <fieldset>
                <Legend>Candidate Evaluation</legend>
                    <div id="evaluationTextID" class="evaluationTextScorecard">#strEvaluationHTML#</div>
            </fieldset>

            <cfif intListLenWeights GT listLen(lstWtLiterals)>
                <cfdump var="Error in evaluation table Grades Weight #lstGradesWt# #len(lstWtLiterals)#">
                <cfabort>
            </cfif>
        </cfoutput>

        <table>
            <cfoutput>
                <thead>
                    <tr>
                        <th style="width:300px">Please Rate The Following Categories</th>
                        <cfloop index="i" from="1" to="#intListLenWeights#">
                            <cfset intWtHdr = listGetAt(lstGradesWt, i)>
                            <cfset strWtHdr = listGetAt(lstWtLiterals, i)>
                            <th>
                                <span class="grades">#strWtHdr#</span><br>
                                <span<cfif intWtHdr LT 0 > class="grades red"<cfelse> class="grades"</cfif>>#intWtHdr#</span>
                            </th>
                        </cfloop>
                        <th class="grades">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                    </tr>
                </thead>
            </cfoutput>

            <tbody>
                <cfoutput query="qryQuiz">
                    <cfif structKeyExists(form, "#qryQuiz.currentrow#rdoResponse")>
                        <cfset qryQuiz.intResponse_value = form["#qryQuiz.currentrow#rdoResponse"]>
                    </cfif>
                    <cfif structKeyExists(form, "#qryQuiz.currentrow#strComment")>
                        <cfset qryQuiz.strComment = trim(form["#qryQuiz.currentrow#strComment"])>
                    </cfif>
                    <tr>
                        <td class="left  quizSummaryTD" >
                            <details id="#qryQuiz.currentrow#strDetail">
                                <summary id="#qryQuiz.currentrow#strSummary">
                                    <span 
                                    <cfif (qryQuiz.blnRequired EQ 1) >
                                        class = "required"
                                    </cfif>>
                                        #qryQuiz.currentrow#. #qryQuiz.strCategory#
                                    </span>
                                </summary>
                                <div>
                                    <div class="tooltip float-left"><img src="#application.applicationBaseURLPath#/images/explain.png" alt="explain">
                                        <span class="tooltiptext" id="#qryQuiz.currentrow#strToolTipText"></span>
                                    </div>
                                    <div class="float-left quizSummarySpan">
                                            #qryQuiz.strQuestion#<br/>Comment:
                                    </div>
                                </div>

                            </details>
                        </td>
                        <cfset intScore = 0>
                        <cfset blnResponseBtnChecked = 0>
                        <cfloop index="i" from="1" to="#intListLenWeights#">
                            <td class="center">
                                <input type="radio" 
                                name="#qryQuiz.currentrow#rdoResponse"
                                class="intQuiz intResponse"
                                title="#listGetAt(lstWtLiterals, i)#"
                                value="#i#"
                                onclick="fncShowCommentDetails('#qryQuiz.currentrow#', this.value);"
                                <cfif qryQuiz.intResponse_value EQ i>
                                    <cfset blnResponseBtnChecked = 1>
                                    checked
                                    <cfset intScore = listGetAt(lstGradesWt, i)>
                                </cfif>
                                <cfif (qryQuiz.blnRequired EQ 1) and i EQ 1>
                                    disabled
                                </cfif>
                                >
                            </td>
                        </cfloop>
                        <td>
                            <input type="hidden" name="#qryQuiz.currentrow#questionsID" id="#qryQuiz.currentrow#questionsID" value="#qryQuiz.questionsID#">
                            <input type="hidden" class="intQuiz blnResponseBtnChecked" name="#qryQuiz.currentrow#blnResponseBtnChecked" id="#qryQuiz.currentrow#blnRequired" value="#blnResponseBtnChecked#">
                            <input type="hidden" class="intQuiz blnRequired" name="#qryQuiz.currentrow#blnRequired" id="#qryQuiz.currentrow#blnRequired" value="#qryQuiz.blnRequired#">
                            <input type="hidden" size=4 class="intQuiz score" title="#qryQuiz.strCategory#" id="#qryQuiz.currentrow#score" value="#intScore#">
                            <input type="hidden" size=4 class="intQuiz weight" id="#qryQuiz.currentrow#weight" value="#qryQuiz.intWeight#">
                            <input type="hidden" size=4 class="intQuiz avg" id="#qryQuiz.currentrow#avg">
                        </td>
                    </tr>
                    
                    <tr>
                                <!--- col span entire table --->
                        <td class="left" colspan="100">
                            
                        <textarea 
                                title="Question #qryQuiz.currentrow#) #qryQuiz.strCategory# comments|#trim(qryQuiz.strComment)#"
                                name="#qryQuiz.currentrow#strComment"
                                <cfif NOT len(trim(qryQuiz.strComment))>
                                    style="display :none"
                                </cfif>
                                onChange="fncValidateInterview();"
                                onblur="fncHideCommentDetails('#qryQuiz.currentrow#')"
                                id="#qryQuiz.currentrow#strComment"
                                class="textQuizComments left"
                                rows="3"
                                cols="95">#trim(qryQuiz.strComment)#</textarea>
                        <td>
                    </tr>
                </cfoutput>
            </tbody>
        </table>
    </div>
    <div>
        <label for="txtInterviewerComments" class="required">Final Comments</label>
        <div>Final comments and recommendations for proceeding with the candidate.</div>
        <cfoutput>
            <textarea 
                    title="Overal Impression|#form.txtInterviewerComments#"
                    name="txtInterviewerComments"
                    id="txtInterviewerComments"
                    onChange="fncValidateInterview();"
                    rows="4"
                    cols="95">#trim(form.txtInterviewerComments)#</textarea>
        </cfoutput>
    </div>
<script>
    function fncShowCommentDetails(n_intRow, n_intResponse) {
        if (fncValidateInterview() ) {
            let m_eleTarget = document.getElementById(n_intRow + 'strComment');
            m_eleTarget.style.display = "initial";
            m_eleTarget.focus();
            fncCalcQuiz(n_intRow -1, n_intResponse);
        }
    }
</script>