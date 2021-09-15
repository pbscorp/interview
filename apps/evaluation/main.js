if (document.getElementById("strEmail") && document.getElementById("strEmail").value.length) {
    fncGetAddress(document.getElementById("strEmail"));
}
                
var aryBlnRequired = document.querySelectorAll('.blnRequired');
var aryBlnResponseBtnChecked = document.querySelectorAll('.blnResponseBtnChecked');
var aryQuizComments = document.querySelectorAll('.textQuizComments');
var aryScore = document.querySelectorAll('.score');
var aryWeight = document.querySelectorAll('.weight');
var aryAvg=document.querySelectorAll('.avg');
var aryGradesWt = document.getElementById('lstGradesWt').value.split(',');
var aryGradesWtText = document.getElementById('lstWtLiterals').value.split(',');
var intMaxGrades = Math.max(...aryGradesWt);
var intTotQuestionWt = 0;
var intTotQuizWt = 0;
var intMaxTotQuizStdWt = 0;
var intTotQuizScore = 0;

var myForm = document.getElementById('mainForm');

var blnKeepingScore = document.getElementById('scorebord-container');
function fncCalcQuiz(n_intCurRow, n_intResponse) {
    console.clear();
    console.log('n_intCurRow = ' + n_intCurRow);
    intTotQuizWt = 0;
    intMaxTotQuizStdWt = 0;
    let intFinalScore = 0;
    let i;
    if (n_intCurRow != undefined) {
        i = n_intCurRow;
        console.log('n_intCurRow = ' + i);
        aryScore[i].value = aryGradesWt[parseInt(n_intResponse) -1];
        aryBlnResponseBtnChecked[i].value = 1;
    }
    for ( i=0;  i < aryScore.length; i++) {

        if ( (aryBlnResponseBtnChecked[i].value == 1) && (aryScore[i].value > 0) || (aryBlnRequired[i].value == 1)  ) {
            intMaxTotQuizStdWt += parseInt(aryWeight[i].value) * intMaxGrades;// maxamum score possible
        }
        intTotQuestionWt = 0;
        if ( aryBlnResponseBtnChecked[i].value == 1 ) {
            intTotQuestionWt =  aryScore[i].value * aryWeight[i].value;
            intTotQuizWt += parseInt(intTotQuestionWt);
        }
    }
    for ( i=0;  i < aryScore.length; i++) {
        if (intMaxTotQuizStdWt != 0){
            intFinalScore =  Math.round( intTotQuizWt / intMaxTotQuizStdWt * 100);
        }
        fncPopulateToolTip(i);
        if (blnKeepingScore) {
            if (n_intCurRow == i || i == aryScore.length - 1 && !n_intResponse ) {
                document.getElementById('intFinalScore').value = intFinalScore;
                document.getElementsByName('strScorecardFinalScore')[0].innerHTML = intFinalScore;
                console.log(aryScore[i].title);
                if (n_intResponse) {
                    fncPopulateScoreCard(i, n_intResponse);
                }
            }
        }
    }
    if (blnKeepingScore) {
        console.log(document.getElementsByName('strScorecardCategory')[0].innerHTML);
        if (intFinalScore == 0) {
            document.getElementById('scorebord-container').style.display="none";
        } else if (g_jsonScoreboardCandidates.length > 1) {
            document.getElementById('scorebord-container').style.display="block";
        } else {
            document.getElementById('scorebord-container').style.display="inline";
        }
    }
}
fncCalcQuiz();

function fncPopulateScoreCard(n_inx, n_intResponse) {
    if (blnKeepingScore) {
        let m_strCategory = aryScore[n_inx].title;
        aryScorecardCategory[0].innerHTML = m_strCategory + ':';
        aryScorecardCategoryScore[0].innerHTML = aryGradesWtText[parseInt(n_intResponse) -1];
        // document.getElementById('evaluationTextID').className = "evaluationTextScorecard";
        for (var i = 0; i < aryScorecardName.length - 1; i++) {
            aryScorecardName[(i + 1)].innerHTML = g_jsonScoreboardCandidates[i]['name'];
            aryScorecardFinalScore[(i + 1)].innerHTML = g_jsonScoreboardCandidates[i]['final score'];
            aryScorecardCategory[(i + 1)].innerHTML = m_strCategory + ':';
            aryScorecardCategoryScore[(i + 1)].innerHTML = g_jsonScoreboardCandidates[i][m_strCategory]['score'];
        }
    }
}
function fncPopulateToolTip(n_inx) {
    let m_intQuestionsPct = 0;
    let m_intMaxTotQuizStdWt = intMaxTotQuizStdWt;
    let m_strExplainText = aryScore[n_inx].title; //"This question"
    let m_intMaxQuestionStdWt = parseInt(aryWeight[n_inx].value) * intMaxGrades;
    if ( (aryBlnResponseBtnChecked[n_inx].value != 1) || (aryScore[n_inx].value == 0) && (aryBlnRequired[n_inx].value == 0)  ) {
        m_intMaxTotQuizStdWt = intMaxTotQuizStdWt + m_intMaxQuestionStdWt;
    }
     m_intQuestionsPct = ( ( m_intMaxQuestionStdWt / m_intMaxTotQuizStdWt) * 100).toFixed(2);
    let m_intRow = n_inx + 1;
    if (aryBlnRequired[n_inx].value == 1) {
        m_strExplainText += " is required and";
    }
    
    m_strExplainText += " has a maximum weight of " + m_intMaxQuestionStdWt;
    m_strExplainText += " which is " + m_intQuestionsPct + "% of the total possible of " + m_intMaxTotQuizStdWt;
    document.getElementById(m_intRow + 'strToolTipText').innerHTML=m_strExplainText;
}

function fncChangeInterviews (n_eleSelect) {
    let m_intInterviewsID = n_eleSelect.value;
    let m_strThisURL = window.location.href.split("?")[0] + "?strTransaction=";
    if (m_intInterviewsID.toLowerCase() == "add") {
        m_strThisURL += "add";
    } else {
        m_strThisURL += "update&interviewsID=" + m_intInterviewsID;
    }
    window.open(m_strThisURL, '_self');
}

function fncEditAddress() {
    let m_addressID = document.getElementById("addressID").value;
    let m_interviewsID = document.getElementById("interviewsID").value;
    let m_strURL = "../../apps/address/?";
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

function fncGetTableValues (n_strDBTable, n_strKeyColumnName, n_strKeyColumnValue, n_lstColumns, n_strOrderByClause, n_fncCallback) {
    let m_xhttp = new XMLHttpRequest();
    m_xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            window[n_fncCallback](JSON.parse(this.responseText));
        }
    }
    let m_strURL = document.getElementById("restMapping").value;
    m_strURL += "api_candidates/get_address?strTable=" + n_strDBTable;
    m_strURL += "&strKeyColumnName=" + encodeURIComponent(n_strKeyColumnName);
    m_strURL += "&strKeyColumnValue=" + encodeURIComponent(n_strKeyColumnValue);
    m_strURL += "&lstColumns=" + encodeURIComponent(n_lstColumns);
    m_strURL += "&strOrderByClause=" + encodeURIComponent(n_strOrderByClause);
    m_xhttp.open("GET", m_strURL, true);
    m_xhttp.setRequestHeader("Content-type", "application/text");
    m_xhttp.send();
}

function fncShowCommentDetails(n_intRow) {
    let m_eleTarget = document.getElementById(n_intRow + 'strComment');
    //document.getElementById(n_intRow  + 'strDetail').open = true;
    m_eleTarget.style.display = "initial";
    m_eleTarget.focus();
}
function fncHideCommentDetails(n_intRow) {
    let m_eleTarget = document.getElementById(n_intRow + 'strComment');
    //document.getElementById(n_intRow  + 'strDetail').open = false;
    if (m_eleTarget.value.trim().length == 0) {
        if (aryBlnRequired[n_intRow -1].value == 1 ) {
            fncFormatError(m_eleTarget, "are required.", true);
        } else {
         m_eleTarget.style.display = "none";
        }
    }
}

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
            n_fncCallback = "fncAddressCallBack"
            );
    }
    return false;
}

function fncAddressCallBack(n_responseText) {
    let i = 0;
    let m_aryColNames;
    let m_strName;
    let m_strResponseText = n_responseText.trim();
    document.getElementById("candidatesNameSpan").style.visibility = "visible";
    if (m_strResponseText.substring(0, 1) != "[") {
        alert(m_strResponseText);
        //return;
    };
    m_aryColNames = JSON.parse(m_strResponseText);
    if (!m_aryColNames.length) {
        fncEditAddress();
    } else {
        m_strName = m_aryColNames[0].strNameFirst + ' ';
        m_strName += m_aryColNames[0].strNameMiddle + ' ';
        m_strName += m_aryColNames[0].strNameLast + ' ';
        document.getElementById("candidatesNameTextSpan").innerHTML = m_strName;
        document.getElementById("addressID").value = m_aryColNames[0].ID;
    } 
}
function fncValidateInterview() {
    let m_strTransaction = myForm.strTransaction.value;
    let m_eleEmail = myForm.strEmail;
    let m_eleInterviewsID = myForm.interviewsID;
    if (m_strTransaction == 'add') {
        if (!m_eleEmail.value.length) {
            fncFormatError(m_eleEmail, "must be entered.");
            return false;
        }
    } else if (!m_eleInterviewsID.value.length || isNaN(m_eleInterviewsID.value)) {
        fncFormatError(m_eleInterviewsID, "must be selected.");
        return false;
    }
    return true;
}

function fncValidateForm() {
    let m_intErrors = 0;
    let m_eleInterviewer = myForm.strInterviewer;
    let m_elePosition = myForm.strPosition;
    let m_eleInterviewsID = myForm.interviewsID;
    if (!fncValidateInterview() ){
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
        if ( aryBlnRequired[i].value == 1 )  {
            if ( aryScore[i].value == 0 ) {
                fncFormatError(aryScore[i], "is required.");
                m_intErrors++;
            }
            if ( aryQuizComments[i].value.length == 0 ) {
                fncFormatError(aryQuizComments[i], "are required.");
                m_intErrors++;
            }
        }
    }
    if (m_intErrors > 0) {
        //fncFormatError('', m_intErrors + " errors encountered.");
        return false;
    }
    return true;
}