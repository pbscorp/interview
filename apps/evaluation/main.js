var aryBlnRequired = document.querySelectorAll('.blnRequired');
var aryBlnResponseBtnChecked = document.querySelectorAll('.blnResponseBtnChecked');
var aryScore = document.querySelectorAll('.score');
var aryWeight = document.querySelectorAll('.weight');
var aryTotStdWt = document.querySelectorAll('.totStdWt');
var aryTotWt = document.querySelectorAll('.totWt');
var aryRunWt = document.querySelectorAll('.runWt');
var aryRunScore = document.querySelectorAll('.runScore');
var aryAvg=document.querySelectorAll('.avg');
var aryAvgSpan=document.querySelectorAll('.avgSpan');
var aryGradesWt = document.getElementById('lstGradesWt').value.split(',');
var intMaxGrades = Math.max(...aryGradesWt);
var intTotQuizWt = 0;
var intTotQuizStdWt = 0;
var intTotQuizScore = 0;

function fncCalcQuiz(n_intCurRow, n_intResponse) {
    //console.clear();
    console.log('n_intCurRow = ' + n_intCurRow);
    intTotQuizWt = 0;
    intTotQuizStdWt = 0;
    intTotQuizScore = 0;
    let i;
    if (n_intCurRow != undefined) {
        i = n_intCurRow;
        console.log('n_intCurRow = ' + i);
        aryScore[i].value = aryGradesWt[parseInt(n_intResponse) -1];
        aryBlnResponseBtnChecked[i].value = 1;
    }
    for ( i=0;  i < aryScore.length; i++) {

        if ( (aryBlnResponseBtnChecked[i].value == 1) && (aryScore[i].value > 0) || (aryBlnRequired[i].value == 1)  ) {
            intTotQuizStdWt += parseInt(aryWeight[i].value) * intMaxGrades;// maxamum score possible
        }
        aryTotWt[i].value = 0;
        if ( aryBlnResponseBtnChecked[i].value == 1 ) {
            aryTotWt[i].value =  aryScore[i].value * aryWeight[i].value;
            intTotQuizWt += parseInt(aryTotWt[i].value);
        }
        aryRunWt[i].value =  intTotQuizWt;
        aryTotStdWt[i].value =  intTotQuizStdWt;
    }
    for ( i=0;  i < aryScore.length; i++) {
        aryRunScore[i].value =  intTotQuizWt;
        aryTotStdWt[i].value =  intTotQuizStdWt;
        if (intTotQuizStdWt != 0){
            aryAvg[i].value =  Math.round( intTotQuizWt / intTotQuizStdWt * 100);
        }
        aryAvgSpan[i].innerText = aryAvg[i].value;
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
            console.log('aryGradesWt = ' + aryAvgSpan[i].value);
        }
    }
    console.log('intMaxGrades = ' + intMaxGrades);
    console.log('intTotQuizWt = ' + intTotQuizWt);
    console.log('intTotQuizStdWt = ' + intTotQuizStdWt);
    console.log('intTotQuizScore = ' + intTotQuizScore);
}
fncCalcQuiz();

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

if (document.getElementById("strEmail") && document.getElementById("strEmail").value.length) {
    fncGetAddress(document.getElementById("strEmail"));
}

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