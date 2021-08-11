<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.strEmail" default="">
<cfparam name="form.strName" default="">
<cfparam name="form.strInterviewer" default="">
<cfparam name="form.dtmInterviewDate" default="#dateFormat(#now()#, "yyyy-mm-dd")#">
<cfparam name="form.strPosition" default="">
<cfparam name="form.addressID" default="">
<cfparam name="form.evaluationID" default="1">
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
    getQuestions = objInterviews.getQuestions(form.evaluationID);
    qryEvaluation = objInterviews.getEvaluation(form.evaluationID);
    qryAllInterviews = objInterviews.getInterview('all', form.evaluationID);
    if ( (!len(strErrorMessage)) && (lCase(form.strTransaction) != "add")) {
        qryInterview = objInterviews.getInterview(form.interviewsID, form.evaluationID);
        form.strName = qryInterview.strName;
        form.addressID  = qryInterview.addressID;
        form.interviewsID  = qryInterview.interviewsID ;
        form.dtmInterviewDate = qryInterview.dtmInterviewDate;
        form.strInterviewer = qryInterview.strInterviewer;
        form.strPosition = qryInterview.strPosition;
    }
    if (!len(form.interviewsID )) {
        qryQuiz = objInterviews.getQuiz('new', form.evaluationID)
    } else {
        qryQuiz = objInterviews.getQuiz(form.interviewsID, form.evaluationID );
    }
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
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#"
                                        onsubmit="return fncValidateForm()" target="_self">
                    <div id="errorMsgDiv">
                        <cfif len(strErrorMessage)>
                            <ul><li>#strErrorMessage#</li></ul>
                        </cfif> 
                    </div>
                    <cfif len(strSuccessMessage)>
                        <div id="successMsgDiv"><ul><li>#strSuccessMessage#</li></ul></div>
                    </cfif> 
                </cfoutput>
                <cfinclude template="incl_interview_header.cfm">
                <cfinclude template="incl_interview_quiz.cfm">
                <cfoutput>
                    <input type="hidden" name="recordcount" id="recordcount" value="#qryQuiz.recordcount#">
                    <input type="hidden" name="lstWtLiterals" id="lstWtLiterals" value="#lstWtLiterals#">
                    <input type="hidden" name="lstGradesWt" id="lstGradesWt" value="#lstGradesWt#">
                    <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                    <input type="hidden" name="evaluationID" id="evaluationID" value="#form.evaluationID#">
                    <input type="hidden" name="addressID" id="addressID" value="#form.addressID#">
                    <input type="submit" name="submitButton" id="submitButton" value="submit" disabled>
                    <cfif len(form.interviewsID) GT 0>
                        <input type="submit" name="deleteButton" onClick="return fncConfirmDelete();"id="deleteButton" value="Delete">
                    </cfif>
                </form>
            </cfoutput>
        </div>
        <!--- <cfif len(strErrorMessage)>
            <cfdump var="#form#">
            <cfdump var="#qryQuiz#">
        </cfif> --->

        <cfoutput>
            <script src="main.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/ajax.js" defer></script>
            <script>
                function fncConfirmDelete () {
                    return confirm("Delete interview record for #form.strName# \n interviewed on #dateFormat(qryAllInterviews.dtmInterviewDate, 'mm-dd-yyyy')# by #form.strInterviewer# for #form.strPosition# OK");
                };
                function fncGetAddress (n_eleEmail) {
                    if (fncValidateEmail(n_eleEmail)) {
                        document.getElementById("candidatesNameSpan").style.visibility = "visible";
                        document.getElementById("candidatesNameTextSpan").innerHTML = "";
                        document.getElementById("addressID").value = "";
                        let m_strEmailAddress = encodeURIComponent(n_eleEmail.value);
                        fncGetTableValues ( 
                            n_strDBTable = 'address', 
                            n_strKeyColumnName ='strEmail',
                            n_strKeyColumnValue = m_strEmailAddress,
                            n_lstColumns = 'ID|strNameFirst|strNameMiddle|strNameLast',
                            n_strOrderByClause = '',
                            n_fncCallback = "fncAddressCallBack");
                    }
                    return false;
                }
            </script>
            <script>
                function fncAddressCallBack(n_responseText) {
                    let i = 0;
                    let m_aryColNames;
                    let m_strName;
                    document.getElementById("candidatesNameSpan").style.visibility = "visible";
                    if (n_responseText.trim().substring(0, 1) != "[") {
                        alert(n_responseText.trim());
                        return;
                    };
                    m_aryColNames = JSON.parse(n_responseText);
                    m_strName = m_aryColNames[0].strNameFirst + ' ';
                    m_strName += m_aryColNames[0].strNameMiddle + ' ';
                    m_strName += m_aryColNames[0].strNameLast + ' ';
                    document.getElementById("candidatesNameTextSpan").innerHTML = m_strName;
                    document.getElementById("addressID").value = m_aryColNames[0].ID;
                }
            </script>
            <script>
                function fncEditAddress() {
                    let m_addressID = document.getElementById("addressID").value;
                    let m_interviewsID = document.getElementById("interviewsID").value;
                    let m_blnInterviewsID = !isNaN(m_interviewsID);
                    let m_strURL = "#application.applicationBaseURLPath#/apps/address/?";
                    if (m_addressID.length) {
                        m_strURL += "addressID=" + m_addressID;
                    } else {
                        m_strURL += "&strTransaction=Add";
                        if (document.getElementById("strEmail") && document.getElementById("strEmail").value.length) {
                            let m_strEmail = document.getElementById("strEmail").value;
                            m_strURL += "&strEmail=" + m_strEmail;
                        }
                    }
                    winAddressWindow=window.open(m_strURL, "adresses", "width=500, height=300, left=300, top=200");
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