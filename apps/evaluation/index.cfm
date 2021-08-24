<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.strEmail" default="">
<cfparam name="form.strName" default="">
<cfparam name="form.strInterviewer" default="">
<cfparam name="form.dtmInterviewDate" default="#dateFormat(#now()#, "yyyy-mm-dd")#">
<cfparam name="form.strPosition" default="">
<cfparam name="form.addressID" default="">
<cfparam name="url.evaluationID" default="1">
<cfparam name="url.interviewsID" default="">
<cfparam name="form.interviewsID" default="#url.interviewsID#">
<cfparam name="form.submitButton" default="">
<cfparam name="form.deleteButton" default="">
<cfparam name="form.blnHasError" default="0">
<cfparam name="strErrorMessage" default="">
<cfparam name="strSuccessMessage" default="">

<cfset aryErrorMessage = ArrayNew(1)>
<cfif len(form.submitButton) OR len(form.deleteButton)>
    <cfinclude template = "act_candidates.cfm">
</cfif>
<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfprocessingdirective suppressWhiteSpace = "yes">
<cfscript>
    objInterviews = createObject('component', 'interview-cfc.candidates');
    getQuestions = objInterviews.getQuestions(url.evaluationID);
    qryEvaluation = objInterviews.getEvaluation(url.evaluationID);
    qryAllInterviews = objInterviews.getInterview('all', url.evaluationID);
    if ( (!len(strErrorMessage)) && (lCase(form.strTransaction) != "add")) {
        qryInterview = objInterviews.getInterview(form.interviewsID, url.evaluationID);
        form.strName = qryInterview.strName;
        form.addressID  = qryInterview.addressID;
        form.strEmail  = qryInterview.strEmail;
        form.interviewsID  = qryInterview.interviewsID ;
        form.dtmInterviewDate = qryInterview.dtmInterviewDate;
        form.strInterviewer = qryInterview.strInterviewer;
        form.strPosition = qryInterview.strPosition;
    }
    if (!len(form.interviewsID )) {
        qryQuiz = objInterviews.getQuiz('new', url.evaluationID)
    } else {
        qryQuiz = objInterviews.getQuiz(form.interviewsID, url.evaluationID);
    }
</cfscript>

<HTML>
    <head>
        <cfoutput>
        <link rel="stylesheet" href="#application.applicationBaseURLPath#/css/stylesheet.css">
        </cfoutput>
    </head>
    <body id="bodyID">
        <cfoutput>
            <h2>Interview Review</h2>
            <div>
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#?evaluationID=#url.evaluationID#">
        </cfoutput>
                    <cfinclude template="incl_interview_header.cfm">
                    <cfinclude template="incl_interview_quiz.cfm">
        <cfoutput>
                    <input type="hidden" name="recordcount" id="recordcount" value="#qryQuiz.recordcount#">
                    <input type="hidden" name="strErrorMessage" id="strErrorMessage" value="#strErrorMessage#">
                    <input type="hidden" name="strSuccessMessage" id="strSuccessMessage" value="#strSuccessMessage#">
                    <input type="hidden" name="restMapping" id="restMapping" value="#application.applicationRestMapping#">
                    <input type="hidden" name="lstWtLiterals" id="lstWtLiterals" value="#lstWtLiterals#">
                    <input type="hidden" name="lstGradesWt" id="lstGradesWt" value="#lstGradesWt#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                    <input type="hidden" name="addressID" id="addressID" value="#form.addressID#">
                    <input type="submit" name="submitButton" id="submitButton" value="submit" disabled>
                    <cfif len(form.interviewsID) GT 0>
                        <input type="submit" name="deleteButton" onClick="return fncConfirmDelete();"id="deleteButton" value="Delete">
                    </cfif>
                    <input type="button" name="closeButton" id="closeButton" value="close" onClick="fncCloseWindow();">
                </form>
             </div>
            <script src="main.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" ></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" ></script>
            <script>
                function fncConfirmDelete () {
                    let m_blnDelete =  confirm("Delete interview record for #form.strName# \n interviewed on #dateFormat(form.dtmInterviewDate, 'mm-dd-yyyy')# by #form.strInterviewer# for #form.strPosition# OK");
                    if (m_blnDelete) {
                        document.getElementById("strTransaction").value = "delete";
                    }
                };
            </script>
        </cfoutput>
    </body> 
</cfprocessingdirective>
</HTML>