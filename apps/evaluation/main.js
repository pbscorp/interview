if (document.getElementById("strEmail") && document.getElementById("strEmail").value.length) {
    fncGetAddress(document.getElementById("strEmail"));
}
                
var aryBlnRequired = document.querySelectorAll('.blnRequired');
var aryBlnResponseBtnChecked = document.querySelectorAll('.blnResponseBtnChecked');
var aryQuizComments = document.querySelectorAll('.textQuizComments');
var aryScore = document.querySelectorAll('.score');
var aryScoreText = document.querySelectorAll('#qryQuiz.currentrow#rdoResponse');
var aryWeight = document.querySelectorAll('.weight');
var aryTotStdWt = document.querySelectorAll('.totStdWt');
var aryTotWt = document.querySelectorAll('.totWt');
var aryRunWt = document.querySelectorAll('.runWt');
var aryRunScore = document.querySelectorAll('.runScore');
var aryAvg=document.querySelectorAll('.avg');
var aryGradesWt = document.getElementById('lstGradesWt').value.split(',');
var aryGradesWtText = document.getElementById('lstWtLiterals').value.split(',');
var intMaxGrades = Math.max(...aryGradesWt);
var intTotQuizWt = 0;
var intMaxTotQuizStdWt = 0;
var intTotQuizScore = 0;

var myForm = document.getElementById('mainForm');

function fncCalcQuiz(n_intCurRow, n_intResponse) {
    console.clear();
    console.log('n_intCurRow = ' + n_intCurRow);
    intTotQuizWt = 0;
    intMaxTotQuizStdWt = 0;
    let i;
    if (n_intCurRow != undefined) {
        i = n_intCurRow;
        console.log('n_intCurRow = ' + i);
        aryScore[i].value = aryGradesWt[parseInt(n_intResponse) -1];
        aryBlnResponseBtnChecked[i].value = 1;
        if (document.getElementById('qryAllInterviewsRecordcount').value > 1 ) {
            document.getElementById('scorebord-container').style.display="block";
        } else {
            document.getElementById('scorebord-container').style.display="inline";
        }
    }
    for ( i=0;  i < aryScore.length; i++) {

        if ( (aryBlnResponseBtnChecked[i].value == 1) && (aryScore[i].value > 0) || (aryBlnRequired[i].value == 1)  ) {
            intMaxTotQuizStdWt += parseInt(aryWeight[i].value) * intMaxGrades;// maxamum score possible
        }
        aryTotWt[i].value = 0;
        if ( aryBlnResponseBtnChecked[i].value == 1 ) {
            aryTotWt[i].value =  aryScore[i].value * aryWeight[i].value;
            intTotQuizWt += parseInt(aryTotWt[i].value);
        }
        aryRunWt[i].value =  intTotQuizWt;
        aryTotStdWt[i].value =  intMaxTotQuizStdWt;
    }
    for ( i=0;  i < aryScore.length; i++) {
        aryRunScore[i].value =  intTotQuizWt;
        aryTotStdWt[i].value =  intMaxTotQuizStdWt;
        if (intMaxTotQuizStdWt != 0){
            aryAvg[i].value =  Math.round( intTotQuizWt / intMaxTotQuizStdWt * 100);
        }
        fncPopulateToolTip(i);
        if (n_intCurRow == i) {
            console.log('n_intCurRow = ' + i);
            console.log('aryBlnResponseBtnChecked = ' + aryBlnResponseBtnChecked[i].value);
            console.log('aryBlnRequired = ' + aryBlnRequired[i].value);
            console.log('aryScore = ' + aryScore[i].value);
            console.log('aryWeight = ' + aryWeight[i].value);
            console.log('aryTotStdWt = ' + aryTotStdWt[i].value);
            console.log('aryTotWt = ' + aryTotWt[i].value);
            console.log('aryRunWt = ' + aryRunWt[i].value);
            console.log('aryRunScore = ' + aryRunScore[i].value);
            console.log('aryAvg = ' + aryAvg[i].value);
            document.getElementsByName('strScorecardCategory')[0].innerHTML = aryScore[i].title +':';
            document.getElementsByName('strScorecardCategoryScore')[0].innerHTML = aryGradesWtText[parseInt(n_intResponse) -1];
            document.getElementsByName('strScorecardWeight')[0].innerHTML = aryAvg[i].value;
            
        }
    }
    console.log('intMaxGrades = ' + intMaxGrades);
    console.log('intTotQuizWt = ' + intTotQuizWt);
    console.log('intMaxTotQuizStdWt = ' + intMaxTotQuizStdWt);
    console.log('intTotQuizScore = ' + intTotQuizScore);
}
fncCalcQuiz();

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

function fncShowHideDetails(n_intRow) {
    let m_eleTarget = document.getElementById(n_intRow + 'strComment');
    let n_blnShow = !document.getElementById(n_intRow  + 'strDetail').open;
    if (m_eleTarget.value.trim().length != 0) {
        n_blnShow = true;
    }
    if (n_blnShow) {
        m_eleTarget.style.display = "initial";
    } else {
        m_eleTarget.style.display = "none";
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
    m_strName = m_aryColNames[0].strNameFirst + ' ';
    m_strName += m_aryColNames[0].strNameMiddle + ' ';
    m_strName += m_aryColNames[0].strNameLast + ' ';
    document.getElementsByName('strScorecardName')[0].innerHTML = m_strName;
    document.getElementById("candidatesNameTextSpan").innerHTML = m_strName;
    document.getElementById("addressID").value = m_aryColNames[0].ID;
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