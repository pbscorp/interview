<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.strEmail" default="">
<cfparam name="form.strName" default="">
<cfparam name="form.strInterviewer" default="">
<cfparam name="form.dtmInterviewDate" default="#dateFormat(now(), "yyyy-mm-dd")#">
<cfparam name="form.strPosition" default="">
<cfparam name="form.addressID" default="">
<cfparam name="form.intFinalScore" default="0">
<cfparam name="form.txtInterviewerComments" default="">
<cfparam name="url.evaluationID" default="1">
<cfparam name="url.interviewsID" default="">
<cfparam name="form.interviewsID" default="#url.interviewsID#">
<cfparam name="form.submitButton" default="">
<cfparam name="form.deleteButton" default="">
<cfparam name="form.blnHasError" default="0">
<cfparam name="strErrorMessage" default="">
<cfparam name="strSuccessMessage" default="">
<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfprocessingdirective suppressWhiteSpace = "yes">
<cfscript>
    objInterviews = createObject('component', 'interview-cfc.candidates');
    objUtilities = createObject('component', 'interview-cfc.utilities');
    //getQuestions = objInterviews.getQuestions(url.evaluationID);
    qryEvaluation = objInterviews.getEvaluation(url.evaluationID);
    lstGradesWt = qryEvaluation.lstWeight;
    strEvaluationHTML=qryEvaluation.strEvaluationText & "<span class='required'>asterisk = required entry</span>";
    lstWtLiterals = qryEvaluation.lstWtLiterals;
    intListLenWeights = listLen(lstGradesWt);
    qryAllInterviews = objInterviews.getInterview('all', url.evaluationID);
</cfscript>

<cfif len(form.submitButton) OR len(form.deleteButton) OR len(form.strPosition)>
    <cfinclude template = "act_candidates.cfm">
</cfif>

<cfscript>
    eForm = objUtilities.encodeFormForHTML(form);
    if ( (!len(strErrorMessage)) && (lCase(eForm.strTransaction) != "add")) {
        qryInterview = objInterviews.getInterview(eForm.interviewsID, url.evaluationID);
        eForm.strName = qryInterview.strName;
        eForm.addressID  = qryInterview.addressID;
        eForm.strEmail = qryInterview.strEmail;
        eForm.interviewsID  = qryInterview.interviewsID;
        eForm.dtmInterviewDate = qryInterview.dtmInterviewDate;
        eForm.strInterviewer = qryInterview.strInterviewer;
        eForm.strPosition = qryInterview.strPosition;
        eForm.intFinalScore = qryInterview.intScore;
        eForm.txtInterviewerComments = qryInterview.txtInterviewerComments;
    }
    qryPositions = objInterviews.getPositions(url.evaluationID, eForm.strPosition);
    if (!len(eForm.interviewsID )) {
        qryQuiz = objInterviews.getQuiz('new', url.evaluationID);
    } else {
        qryQuiz = objInterviews.getQuiz(eForm.interviewsID, url.evaluationID);
    }
</cfscript>

<HTML>
    <head>
        <cfoutput>
        <link rel="stylesheet" href="#application.applicationBaseURLPath#/css/stylesheet.css">
        </cfoutput>
        <style>
            body {
                width: 700px;
                margin: auto;
            }
            body.view-only {
                    /* background-color:rgba(192,192,192,0.3); */
                    background-image: url("../../images/view-only.png");
                    background-repeat: repeat;
                    background-color: #F8F8F8
            }
        </style>
    </head>
    <body id="bodyID" <cfif eForm.strTransaction EQ "view">class = "view-only"</cfif>>
        <cfoutput>
            <h2>Interview Review</h2>
            <div>
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#?evaluationID=#url.evaluationID#">
        </cfoutput>
                    <cfinclude template="incl_interview_header.cfm">
                    <cfif eForm.strTransaction NEQ "view">
                        <cfinclude template="incl_scoretable.cfm">
                    </cfif>
                    <cfinclude template="incl_interview_quiz.cfm">
        <cfoutput>
                    <input type="hidden" name="recordcount" id="recordcount" value="#qryQuiz.recordcount#">
                    <input type="hidden" name="strErrorMessage" id="strErrorMessage" value="#strErrorMessage#">
                    <input type="hidden" name="strSuccessMessage" id="strSuccessMessage" value="#strSuccessMessage#">
                    <input type="hidden" name="intFinalScore" id="intFinalScore" value="#eForm.intFinalScore#">
                    <input type="hidden" name="restMapping" id="restMapping" value="#application.applicationRestMapping#">
                    <input type="hidden" name="lstWtLiterals" id="lstWtLiterals" value="#lstWtLiterals#">
                    <input type="hidden" name="lstGradesWt" id="lstGradesWt" value="#lstGradesWt#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#eForm.strTransaction#">
                    <input type="hidden" name="qryAllInterviewsRecordcount" id="qryAllInterviewsRecordcount" value="#qryAllInterviews.recordcount#">
                    <input type="hidden" name="addressID" id="addressID" value="#eForm.addressID#">
                    <cfif eForm.strTransaction EQ "view">
                        <input type="hidden" name="submitButton" id="submitButton" value="">
                    <cfelse>
                        <input type="submit" name="submitButton" id="submitButton" value="submit" disabled>
                        <cfif len(eForm.interviewsID) GT 0>
                            <input type="submit" name="deleteButton" onClick="return fncConfirmDelete();"id="deleteButton" value="Delete">
                        </cfif>
                    </cfif>
                    <input type="button" name="closeButton" id="closeButton" value="close" onClick="window.close();">
                </form>
             </div>
            <script src="main.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" ></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" ></script>
            <script>
                <cfif lCase(eForm.strTransaction) EQ "update">
                    fncEditAddress();
                </cfif>
                <cfif len(eForm.interviewsID) GT 0>
                    function fncConfirmDelete () {
                        let m_blnDelete =  confirm("Delete interview record for #eForm.strName# \n interviewed on #dateFormat(eForm.dtmInterviewDate, 'mm-dd-yyyy')# by #eForm.strInterviewer# for #eForm.strPosition# OK");
                        if (m_blnDelete) {
                            document.getElementById("strTransaction").value = "delete";
                        }
                    };
                </cfif>
            </script>
        </cfoutput>
</body>
</cfprocessingdirective>
</HTML>