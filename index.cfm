<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfprocessingdirective suppressWhiteSpace = "yes"><cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.ID" default="">
<cfparam name="form.strEmail" default="">
<cfparam name="form.strCandidatesName" default="">
<cfparam name="form.strName" default="#form.strCandidatesName#">
<cfparam name="form.strSelectedCandidateID" default="5">
<cfparam name="form.submitButton" default="">
<cfparam name="form.blnHasError" default="0">
<cfparam name="form.strErorMessage" default="">
<cfparam name="strSuccessMessage" default="">

<cfset aryErrorMessage = ArrayNew(1)>
<cfif len(form.submitButton)>
    <cfinclude template = "act_candidates.cfm">
</cfif>
<cfscript>
    objCandidates = createObject('component', 'interview-cfc.candidates');
    getQuestions = objCandidates.getQuestions();
    qryEvaluation = objCandidates.getEvaluation(1);
    qryAllCandidates = objCandidates.getCandidate('all');
    if ( (!form.blnHasError) && (form.submitButton != "update") && (form.strTransaction != "add")) {
        qryCandidate = objCandidates.getCandidate(form.strSelectedCandidateID);
        form.strName = qryCandidate.strName;
        form.ID = qryCandidate.ID;
    }
    strSuccessMessage = "record updated";
</cfscript>

<HTML>
    <head>
        <link rel="stylesheet" href="mystyle.css">
        <style>
            table {
                margin: auto;
            }
            th, td {
                padding: 5px;
                text-align: center;
            }
            th {
                font-weight: bold;
            }
            .grades {
                font-size: x-small;
            }
            p {
                padding: 5px;
                text-align: justify; 
                font-weight: bold;
                margin: auto;
            }
            h2 {
                text-align: center;
            }
            .left {
                text-align: left;
            }
            .red {
                color: red;
            }
            .bold {
                font-weight: bold;
            }
            #errorMsgDiv {
                text-align: left;
                color: red;
                font-weight: bold;
                max-width: 600px;
                padding: 5px;
            }
            #successMsgDiv {
                text-align: center;
                border-style: dotted;
                border-width: 2px;
                border-color: green;
                color: green;
                font-weight: bold;
                max-width: 200px;
                background-color: #CEFCF2;
                margin: auto;
                padding: 5px;
            }


        </style>
    </head>
    <body id="bodyID">
        <h2>Candidate Review</h2>
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
                    <div id="addressSectionID">
                        <fieldset>
                            <Legend>Candidate</legend>
                            <cfif lCase(strTransaction) EQ "add">
                            <span >Candidate: </span>
                                <input type="text" name="strCandidatesName" id="strCandidatesName"  value="#form.strName#">
                            <cfelse>
                            <span >Select Candidate: </span>
                                <select size="1" name="objNameSelect" id="objNameSelect" 
                                    onChange="fncChangeCandidates(this.options[this.selectedIndex]);">
                                    <option>Select a Candidate</option>
                                    <cfoutput query = "qryAllCandidates">
                                        <option value="#qryAllCandidates.ID#" 
                                            <cfif qryAllCandidates.ID EQ form.ID>selected</cfif>>#qryAllCandidates.strName#
                                        </option>
                                    </cfoutput>
                                    <option value="add">Add Candidate</option>
                                </select>
                            </cfif>
                        </fieldset>
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
                            <cfif NOT len(form.ID)>
                                <cfset qryQuiz = objCandidates.getQuiz('new')>
                            <cfelse>
                                <cfset qryQuiz = objCandidates.getQuiz(form.ID)>
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
                                                    selected
                                                    <cfset intLineResponse = listGetAt(lstGradesWt, i)>
                                                </cfif>
                                                >
                                            </td>
                                        </cfloop>
                                        <td>
                                            <input type="radio" 
                                                name="#qryQuiz.currentrow#rdoResponse" 
                                                value="N/A"
                                                <cfif #qryQuiz.blnRequired#>
                                                    disabled
                                                <cfelseif intLineResponse EQ 0>
                                                    checked
                                                </cfif>
                                            >
                                        </td>
                                        <td>
                                            <span id ="#qryQuiz.currentrow#score" value="#intLineResponse#">#intLineResponse#</span>
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
                    <input type="hidden" name="strSelectedCandidateID" id="strSelectedCandidateID" value="#form.strSelectedCandidateID#">
                    <input type="hidden" name="strCandidatesName" id="strCandidatesName" value="#form.strName#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                    <input type="submit" name="submitButton" id="submitButton" value="Post" disabled>
                </form>
            </cfoutput>
        </div>

        <script>
            function fncAddCandidates(n_strName) {
                let m_strName = n_strName.trim();
                document.getElementById('strCandidatesName').value = m_strName;
                document.getElementById('strSelectedCandidateID').value = '';
            }
            
            function fncChangeCandidates(n_objOption) {
                let m_strThisURL = window.location.href.split("?")[0] + "?strTransaction=";
                if (n_objOption.value.toLowerCase() == "add") {
                    m_strThisURL += "add";
                } else {
                    m_strThisURL += "update&strSelectedCandidateID=" + document.getElementById('strSelectedCandidateID').value;
                }
                window.location.href = m_strThisURL;
            }
        </script>
        <script src="/pbscorp/js/beforeunload.js" defer></script>
    </body>
</cfprocessingdirective>
</HTML>