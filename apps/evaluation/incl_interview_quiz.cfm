
<cfoutput>
    <div id="quizSectionID">
        <fieldset>
            <Legend>Candidate Evaluation</legend>
            <p>#qryEvaluation.strEvaluationText#</p>
        </fieldset>

        <cfif intListLenWeights GT listLen(lstWtLiterals)>
            <cfdump var="Error in elaluation table Grades Weight #lstGradesWt# #len(lstWtLiterals)#">
            <cfabort>
        </cfif> 

        <table>
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

            <tbody>
                <cfoutput query="qryQuiz">
                    <cfif structKeyExists(form, "#qryQuiz.currentrow#rdoResponse")>
                        <cfset qryQuiz.intResponse_value = form["#qryQuiz.currentrow#rdoResponse"]>
                    </cfif>
                    <cfif structKeyExists(form, "#qryQuiz.currentrow#strComment")>
                        <cfset qryQuiz.strComment = form["#qryQuiz.currentrow#strComment"]>
                    </cfif>
                    <tr>
                        <td class="left  quizSummaryTD" >
                            <details id="#qryQuiz.currentrow#strDetail">
                                <summary 
                                        onClick="fncShowHideDetails('#qryQuiz.currentrow#')" 
                                        id="#qryQuiz.currentrow#strSummary">
                                    <span >
                                        #qryQuiz.currentrow#. #qryQuiz.strCategory#
                                    </span>
                                </summary>
                                <div>
                                    <div class="tooltip float-left"><img src="#application.applicationBaseURLPath#/images/explain.png" alt="explain">
                                        <span class="tooltiptext" id="#qryQuiz.currentrow#strToolTipText">Lorem, ipsum dolor sit amet consectetur adipisicing elit. Magnam, itaque! Ipsa cumque quasi, nisi qui nobis in maiores dolorem exercitationem animi fugit voluptatum quis deserunt placeat veritatis et rem quam.</span>
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
                                onclick="fncValidateInterview();fncCalcQuiz(#(#qryQuiz.currentrow# -1)#, this.value);"
                                <cfif qryQuiz.intResponse_value EQ i>
                                    <cfset blnResponseBtnChecked = 1>
                                    checked
                                    <cfset intScore = listGetAt(lstGradesWt, i)>
                                </cfif>
                                <cfif (qryQuiz.blnRequired == 1) and i EQ 1>
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
                            <input type="hidden" size=4 class="intQuiz totStdWt" id="#qryQuiz.currentrow#totStdWt"value="">
                            <input type="hidden" size=4 class="intQuiz totWt" id="#qryQuiz.currentrow#totWt"value="#round(#intScore#*#qryQuiz.intWeight#)#">
                            <input type="hidden" size=4 class="intQuiz runWt" id="#qryQuiz.currentrow#runWt"value="0">
                            <input type="hidden" size=4 class="intQuiz runScore" id="#qryQuiz.currentrow#runScore"value="0">
                            <input type="hidden" size=4 class="intQuiz avg" id="#qryQuiz.currentrow#avg">
                            <span class="intQuiz avgSpan" id="#qryQuiz.currentrow#avgSpan"></span>
                        </td>
                    </tr>
                    
                    <tr>
                                <!--- col span entire table --->
                        <td class="left" colspan="100">
                            
                        <textarea 
                                title="Question #qryQuiz.currentrow#) #qryQuiz.strCategory# comments|#qryQuiz.strComment#"
                                name="#qryQuiz.currentrow#strComment"
                                <cfif NOT len(qryQuiz.strComment)>
                                    style="display :none"
                                </cfif>
                                onChange="fncValidateInterview();"
                                id="#qryQuiz.currentrow#strComment"
                                class="textQuizComments"
                                rows="3"
                                cols="95">
                            #qryQuiz.strComment#
                        </textarea>
                        <td>
                    </tr>
                </cfoutput>
            </tbody>
        </table>
    </div>
</cfoutput>