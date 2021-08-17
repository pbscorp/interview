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
            <div id="errorMsgDiv">
                <cfif len(strErrorMessage)>
                    <ul><li>#strErrorMessage#</li></ul>
                </cfif>
            </div>
            <cfif len(strSuccessMessage)>
                <div id="successMsgDiv"><ul><li>#strSuccessMessage#</li></ul></div>
            </cfif>
            <h2>Interview Review</h2>
            <div>
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#?evaluationID=#url.evaluationID#">
        </cfoutput>
                    <cfinclude template="incl_interview_header.cfm">
                    <cfinclude template="incl_interview_quiz.cfm">
        <cfoutput>
                    <input type="hidden" name="recordcount" id="recordcount" value="#qryQuiz.recordcount#">
                    <input type="hidden" name="lstWtLiterals" id="lstWtLiterals" value="#lstWtLiterals#">
                    <input type="hidden" name="lstGradesWt" id="lstGradesWt" value="#lstGradesWt#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                    <input type="hidden" name="addressID" id="addressID" value="#form.addressID#">
                    <input type="submit" name="submitButton" id="submitButton" value="submit" disabled>
                    <cfif len(form.interviewsID) GT 0>
                        <input type="submit" name="deleteButton" onClick="return fncConfirmDelete();"id="deleteButton" value="Delete">
                    </cfif>
                </form>
             </div>
            <script src="main.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" ></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" ></script>
            <script src="#application.applicationBaseURLPath#/js/ajax.js" ></script>
            <script>
                function fncConfirmDelete () {
                    let m_blnDelete =  confirm("Delete interview record for #form.strName# \n interviewed on #dateFormat(qryAllInterviews.dtmInterviewDate, 'mm-dd-yyyy')# by #form.strInterviewer# for #form.strPosition# OK");
                    if (m_blnDelete) {
                        document.getElementById("strTransaction").value = "delete";
                    }
                };
                function fncEditAddress() {
                    let m_addressID = document.getElementById("addressID").value;
                    let m_interviewsID = document.getElementById("interviewsID").value;
                    let m_strURL = "#application.applicationBaseURLPath#/apps/address/?";
                    if (document.getElementById("strEmail") && document.getElementById("strEmail").value.length) {
                        let m_strEmail = document.getElementById("strEmail").value;
                        m_strURL += "&strEmail=" + encodeURIComponent(m_strEmail);
                    }
                    if (m_addressID.length) {
                        m_strURL += "&addressID=" + m_addressID;
                    } else {
                        m_strURL += "&strTransaction=Add";
                    }
                    winAddressWindow=window.open(m_strURL, "adresses", "width=500, height=300, left=300, top=200");
                }
                function fncValidateForm() {
                    let myForm = document.getElementById('mainForm');
                    let m_intErrors = 0;
                    let m_eleInterviewer = myForm.strInterviewer;
                    let m_elePosition = myForm.strPosition;
                    let m_eleInterviewsID = myForm.interviewsID;
                    let m_strTransaction = myForm.strTransaction.value;
                    let m_eleEmail = myForm.strEmail;
                    if (m_strTransaction == 'add' && !m_eleEmail.value.length) {
                        fncFormatError(m_eleEmail, "must be entered.");
                        m_intErrors++;
                    } else if (!m_eleInterviewsID.value.length || isNaN(m_eleInterviewsID.value)) {
                        fncFormatError(m_eleInterviewsID, "must be selected.");
                        m_intErrors++;
                    } 
                    if (!m_eleInterviewer.value.length) {
                        fncFormatError(m_eleInterviewer, "must be entered.");
                        m_intErrors++;
                    }
                    if (!m_elePosition.value.length) {
                        fncFormatError(m_elePosition, "must be entered.");
                        m_intErrors++;
                    }
                    for ( i=0;  i < aryScore.length; i++) {
                        if ( (aryScore[i].value == 0) && (aryBlnRequired[i].value == 1) ) {
                            fncFormatError(aryScore[i], "is required.");
                            m_intErrors++;
                        }
                    }
                    if (m_intErrors > 0) {
                        //fncFormatError('', m_intErrors + " errors encountered.");
                        return false;
                    }
                    return true;
                }
            </script>
        </cfoutput>      
    </body> 
</cfprocessingdirective>
</HTML>