<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.strEmail" default="">
<cfparam name="form.strName" default="">
<cfparam name="form.strInterviewer" default="">
<cfparam name="form.dtmInterviewDate" default="#dateFormat(#now()#, "yyyy-mm-dd")#">
<cfparam name="form.strPosition" default="">
<cfparam name="form.evaluationID" default="1">
<cfparam name="url.interviewsID" default="">
<cfparam name="form.interviewsID" default="#url.interviewsID#">
<cfparam name="form.submitButton" default="">
<cfparam name="form.blnHasError" default="0">
<cfparam name="form.strErorMessage" default="">
<cfparam name="strSuccessMessage" default="">

<cfset aryErrorMessage = ArrayNew(1)>
<cfif len(form.submitButton)>
    <cfinclude template = "act_candidates.cfm">
</cfif>
<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfprocessingdirective suppressWhiteSpace = "yes">
<cfscript>
    objInterviews = createObject('component', 'interview-cfc.candidates');
    getQuestions = objInterviews.getQuestions();
    qryEvaluation = objInterviews.getEvaluation("#form.evaluationID#");
    qryAllInterviews = objInterviews.getInterview('all');
    if ( (!form.blnHasError) && (form.submitButton != "update") && (form.strTransaction != "add")) {
        qryInterview = objInterviews.getInterview(form.interviewsID );
        form.strName = qryInterview.strName;
        form.interviewsID  = qryInterview.interviewsID ;
        form.dtmInterviewDate = qryInterview.dtmInterviewDate;
        form.strInterviewer = qryInterview.strInterviewer;
        form.strPosition = qryInterview.strPosition;
    }
    strSuccessMessage = "";
</cfscript>

<HTML>
    <head>
        <cfoutput>
        <link rel="stylesheet" href="#application.applicationBaseURLPath#/css/stylesheet.css">
        </cfoutput>
    </head>
    <body id="bodyID">
        <h2>Interview Review</h2>
        <div>
            <cfoutput>
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#" onSubmit="fncRemoveBeforeUnloadEvent()"
                    onsubmit="return fncValidateForm()" target="_self">
                    <div id="errorMsgDiv">
                        <cfif arrayLen(aryErrorMessage)>
                            <ul>
                            <cfloop from = "1" to = "#arrayLen(aryErrorMessage)#" index = "i">
                                <li>#aryErrorMessage[#i#]#</li>
                            </cfloop>
                            </ul>
                        </cfif> 
                    </div>
                    <cfif len(strSuccessMessage)>
                        <div id="successMsgDiv">#strSuccessMessage#</div>
                    </cfif> 
                    <div>
                        <fieldset>
                            <Legend>Interview</legend>
                            <span class="interviewSpan">
                                <cfif lCase(strTransaction) EQ "add">
                                    <label>Email:</label>
                                    <input type="text" name="strEmail" id="strEmail"
                                            placeholder="example@mail.com"
                                            onChange="fncGetAddress(this);"
                                            value="#form.strEmail#">
                                    <input type="hidden" name="interviewsID " id="interviewsID "  value="">
                                <cfelse>
                                    <label>Interview:</label>
                                    <select size="1" name="interviewsID " id="interviewsID "
                                        onChange="fncChangeInterviews(this.options[this.selectedIndex]);">
                                        <option>Select an Interview</option>
                                    <cfoutput query = "qryAllInterviews">
                                        <option value="#qryAllInterviews.interviewsID #"
                                            title="#qryAllInterviews.strName# (#qryAllInterviews.strEmail#)
                                                interviewed on #dateFormat(qryAllInterviews.dtmInterviewDate, 'mm/dd/yyyy')#
                                                by #qryAllInterviews.strInterviewer#
                                                for #qryAllInterviews.strPosition#"
                                            <cfif qryAllInterviews.interviewsID  EQ form.interviewsID >
                                                selected
                                            </cfif>
                                            >
                                            #qryAllInterviews.strEmail#
                                        </option>
                                    </cfoutput>
                                        <option value="add">New Interview</option>
                                    </select>
                                </cfif> 
                            </span>

                            <span class="interviewSpan">
                                <label>Date:</label>
                                <input type="date" name="dtmInterviewDate" id="dtmInterviewDate"
                                    min="#dateFormat(#dateAdd('yyyy', -2, #now()#)#, "yyyy-mm-dd")#" max="#dateFormat(#now()#, "yyyy-mm-dd")#" 
                                    value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#"
                                    onBlur="fncValidateDate(this);"/>
                            </span>
                            <br/>
                            <label>  </label>
                            <span id="candidatesNameSpan" 
                                     style="font-size: smaller;vertical-align: top;font-style: italic;font-style: italic;" >
                                #form.strName#
                            </span>
                            <br/>

                            <span class="interviewSpan">
                                <label>Interviewer:</label>
                                <input type="text" name="strInterviewer" id="strInterviewer"  placeholder="Name"  value="#form.strInterviewer#"/>
                            </span>

                            
                            <span class="interviewSpan">
                                <label>Position:</label>
                                <input type="text" name="strPosition" id="strPosition" placeholder="Position"   value="#form.strPosition#"/>
                            </span>
                            <br/>
                            <br/>

                        </fieldset>
                        <br/>
                        <fieldset>
                            <Legend>Candidate Evaluation</legend>
                            <p >#qryEvaluation.strEvaluationText#</p>
                        </fieldset>
                    </div>

                    <cfset lstGradesWt = qryEvaluation.lstWeight>
                    <cfset lstWtLiterals = qryEvaluation.lstWtLiterals>
                    <cfset intListLenWeights = listLen(lstGradesWt)>
                    <cfif intListLenWeights GT listLen(lstGradesWt)>
                        <cfdump var="Error in elaluation table Grades Weight #lstGradesWt# #lstGradesWt#">
                        <cfabort>
                    </cfif> 

                    <div id="quizSectionID">
                        <table>
                            <thead>
                                <tr>
                                    <th>Please Rate The Following Categories</th>
                                    <cfloop index="i" from="1" to="#intListLenWeights#">
                                        <cfset intWtHdr = listGetAt(lstGradesWt, i)>
                                        <cfset strWtHdr = listGetAt(lstWtLiterals, i)>
                                        <th>
                                            <span<cfif intWtHdr LT 0 > class="red"</cfif>>#intWtHdr#</br></span>
                                            <span class="grades">#strWtHdr#</span>
                                        </th>
                                    </cfloop>
                                    <th class="grades" title="not observed">N/A</td>
                                    <th class="grades">Score</td>
                                    <th class="grades">Weight</th>
                                    <th class="grades">Tot wt</th>
                                    <th class="grades">Avg</th>
                                </tr>
                            </thead>
                            <cfif NOT len(form.interviewsID )>
                                <cfset qryQuiz = objInterviews.getQuiz('new')>
                            <cfelse>
                                <cfset qryQuiz = objInterviews.getQuiz(form.interviewsID )>
                            </cfif>
                            <tbody>
                                <cfoutput query="qryQuiz">
                                    <tr>
                                        <td class="left"><span class="bold">#qryQuiz.currentrow#. #qryQuiz.strCategory#</span>#qryQuiz.strQuestion#</td>
                                        <cfset intLineResponse = 0>
                                        <cfloop index="i" from="1" to="#intListLenWeights#">
                                            <td>
                                                <input type="radio" 
                                                name="#qryQuiz.currentrow#rdoResponse"
                                                title="#listGetAt(lstWtLiterals, i)#"
                                                value="#i#"
                                                <cfif qryQuiz.intResponse_value EQ i>
                                                    checked
                                                    <cfset intLineResponse = listGetAt(lstGradesWt, i)>
                                                </cfif>
                                                >
                                            </td>
                                        </cfloop>
                                        <td>
                                            <input type="radio" 
                                                name="#qryQuiz.currentrow#rdoResponse" 
                                                value="0"
                                                <cfif #qryQuiz.blnRequired#>
                                                    disabled
                                                <cfelseif intLineResponse EQ 0>
                                                    checked
                                                </cfif>
                                            >
                                        </td>
                                        <td>
                                            <span id="#qryQuiz.currentrow#score" value="#intLineResponse#">#intLineResponse#</span>
                                            <input type="hidden" name="#qryQuiz.currentrow#questionsID" id="#qryQuiz.currentrow#questionsID" value="#qryQuiz.questionsID#">
                                        </td>
                                        <td>
                                            <span id="#qryQuiz.currentrow#weight" value="#intWeight#">#intWeight#</span>
                                        </td>
                                        <td>
                                            <span id="#qryQuiz.currentrow#totWt"value="#intLineResponse#*#intWeight#">#round(#intLineResponse#*#intWeight#)#</span>
                                        </td>
                                        <td>
                                            <span id="#qryQuiz.currentrow#avg"></span>
                                        </td>
                                    </tr>
                                    
                                    <tr>
                                        <td class="left" colspan="100">
                                         Comments:
                                         </br>
                                        <textarea 
                                                title="#qryQuiz.strComment#"
                                                name="#qryQuiz.currentrow#strComment" id="#qryQuiz.currentrow#strComment"
                                                rows="2" cols="100"> 
                                            #qryQuiz.strComment#
                                        </textarea>
                                        <td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>
                    </div>
                    <input type="hidden" name="recordcount" id="recordcount" value="#qryQuiz.recordcount#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                    <input type="hidden" name="evaluationID" id="evaluationID" value="#form.evaluationID#">
                    <input type="submit" name="submitButton" id="submitButton" value="Post" disabled>
                </form>
            </cfoutput>
        </div>

        <cfoutput>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" defer></script>
            <script>
                function fncGetAddress (n_eleEmail) {
                    if (fncValidateEmail(n_eleEmail)) {
                        let m_strName=fncGetName(n_eleEmail);
                        if (m_strName && m_strName.length) {
                            alert(m_strName);
                            document.getElementById("candidatesNameSpan").innerHTML = m_strName;
                            return true;
                        }
                    }
                    return false;
                }
            </script>

            <script>
                function fncGetName (n_eleEmail) {
                    let xhttp = new XMLHttpRequest();
                    xhttp.open("GET", "#application.applicationBaseURLPath#/resources/get_address?strTransaction=getname&strEmail=" + n_eleEmail.value, false);
                    xhttp.send();
                    return xhttp.responseText;
                }
            </script>
            <script>
                function fncOpenAddressWindow (n_eleEmail) {
                    window.open("#application.applicationBaseURLPath#/apps/address/?strEmail=" + n_eleEmail.value, "winAddressWindow", "width=500,height=400");
                     
                }
            </script>
            <script>
                function fncChangeInterviews (n_eleSelect) {
                    let m_intInterviewsID = n_eleSelect.value;
                    let m_strThisURL = window.location.href.split("?")[0] + "?strTransaction=";
                    if (m_intInterviewsID.toLowerCase() == "add") {
                        m_strThisURL += "add";
                    } else {
                        m_strThisURL += "update&interviewsID=" + m_intInterviewsID;
                    }
                    window.location.href = m_strThisURL;
                }
            </script>
        </cfoutput>      
    </body> 
</cfprocessingdirective>
</HTML>