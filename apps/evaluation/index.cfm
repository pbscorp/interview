<cfparam name="url.strTransaction" default="update">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.strEmail" default="">
<cfparam name="form.strName" default="">
<cfparam name="form.strInterviewer" default="">
<cfparam name="form.dtmInterviewDate" default="#dateFormat(#now()#, "yyyy-mm-dd")#">
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
<cfif len(form.submitButton) OR len(form.deleteButton) OR len(form.strPosition)>
    <cfinclude template = "act_candidates.cfm">
</cfif>
<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfprocessingdirective suppressWhiteSpace = "yes">
<cfscript>
    objInterviews = createObject('component', 'interview-cfc.candidates');
    getQuestions = objInterviews.getQuestions(url.evaluationID);
    qryEvaluation = objInterviews.getEvaluation(url.evaluationID);
    lstGradesWt = qryEvaluation.lstWeight;
    strEvaluationHTML=qryEvaluation.strEvaluationText & "<span class='required'>asterisk = required entry</span>";
    lstWtLiterals = qryEvaluation.lstWtLiterals;
    intListLenWeights = listLen(lstGradesWt);
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
        form.intFinalScore = qryInterview.intScore;
        form.txtInterviewerComments = qryInterview.txtInterviewerComments;
    }
    qryPositions = objInterviews.getPositions(url.evaluationID, form.strPosition);
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
    <body id="bodyID" <cfif form.strTransaction EQ "view">class = "view-only"</cfif>>
        <cfoutput>
            <h2>Interview Review</h2>
            <div>
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#?evaluationID=#url.evaluationID#">
        </cfoutput>
                    <cfinclude template="incl_interview_header.cfm">
                    <cfif form.strTransaction NEQ "view">
                        <cfinclude template="incl_scoretable.cfm">
                    </cfif>
                    <cfinclude template="incl_interview_quiz.cfm">
        <cfoutput>
                    <input type="hidden" name="recordcount" id="recordcount" value="#qryQuiz.recordcount#">
                    <input type="hidden" name="strErrorMessage" id="strErrorMessage" value="#strErrorMessage#">
                    <input type="hidden" name="strSuccessMessage" id="strSuccessMessage" value="#strSuccessMessage#">
                    <input type="hidden" name="intFinalScore" id="intFinalScore" value="#form.intFinalScore#">
                    <input type="hidden" name="restMapping" id="restMapping" value="#application.applicationRestMapping#">
                    <input type="hidden" name="lstWtLiterals" id="lstWtLiterals" value="#lstWtLiterals#">
                    <input type="hidden" name="lstGradesWt" id="lstGradesWt" value="#lstGradesWt#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                    <input type="hidden" name="qryAllInterviewsRecordcount" id="qryAllInterviewsRecordcount" value="#qryAllInterviews.recordcount#">
                    <input type="hidden" name="addressID" id="addressID" value="#form.addressID#">
                    <cfif form.strTransaction EQ "view">
                        <input type="hidden" name="submitButton" id="submitButton" value="">
                    <cfelse>
                        <input type="submit" name="submitButton" id="submitButton" value="submit" disabled>
                        <cfif len(form.interviewsID) GT 0>
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
                function fncConfirmDelete () {
                    let m_blnDelete =  confirm("Delete interview record for #form.strName# \n interviewed on #dateFormat(form.dtmInterviewDate, 'mm-dd-yyyy')# by #form.strInterviewer# for #form.strPosition# OK");
                    if (m_blnDelete) {
                        document.getElementById("strTransaction").value = "delete";
                    }
                };
            </script>
        </cfoutput>

    <script>
    var blnListMode = false;
    function fncFormatError(n_element, n_strError, n_blnNoFucus) {
        function fncAddListItem(n_strErrMsg) {
            var node = document.createElement("LI");
            var textnode = document.createTextNode(n_strErrMsg);
            node.appendChild(textnode);
            document.getElementById("errMessageUL").appendChild(node);
        }
        function fncIsInUnorderedList(n_strErrMsg) {
            m_aryErrMsgs = document.getElementById('errMessageUL').getElementsByTagName('li');
            for (let i = 0; i < m_aryErrMsgs.length; i++) {
                if (m_aryErrMsgs[i].innerHTML == n_strErrMsg) {
                    return true;
                }
            }
            return false;
        }
        let m_blnNoFucus = false;
        let m_strErrMsg = "";
        if (n_element  != '') {
            m_strErrMsg += n_element.title.split('|')[0];
        }
        m_strErrMsg += ' ' + n_strError;
        if (n_blnNoFucus) {
            m_blnNoFucus = true;
        }
        if (blnListMode) {
            if (!fncIsInUnorderedList(m_strErrMsg)) {
                fncAddListItem(m_strErrMsg);
            }
        } else {
            alert(m_strErrMsg);
        }
        
        if (!m_blnNoFucus) {
            if (n_element.select) {
                n_element.select();
                n_element.focus();
            }
        }
    }
    
    function fncValidateEmail(n_elementEmail) {
        let m_strMailformat = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
        if (n_elementEmail.value.match(m_strMailformat)) {
            return true;
        } else {
            fncFormatError(n_elementEmail, "invalid format");
            return false;
        }
    }
</script>
</body>
</cfprocessingdirective>
</HTML>