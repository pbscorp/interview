window.addEventListener('load', fncSetMesageDivs);
    function fncSetMesageDivs () {
        let m_eleErrorDiv = document.createElement("div");
        m_eleErrorDiv.id = "errorMsgDiv";
        document.body.prepend(m_eleErrorDiv);
        let m_strSuccessMessage = document.getElementById("strSuccessMessage").value;
        let strErrorMessage = document.getElementById("strErrorMessage").value;
        if (m_strSuccessMessage.length) {
            let m_eleSuccessDiv = document.createElement("div");
            m_eleSuccessDiv.id = "successMsgDiv";
            m_eleSuccessDiv.innerHTML='<ul><li>' + m_strSuccessMessage + '</li></ul>';
            document.body.prepend( m_eleSuccessDiv);
            setTimeout(function(){  
                document.getElementById("successMsgDiv").innerHTML = "";
            }, 5000);
        } else if (strErrorMessage.length) {
            fncFormatError('', strErrorMessage);
        }
    }

    document.getElementById("mainForm").addEventListener('submit', fncRunValidateForm);
    function fncRunValidateForm (event) {
        blnListMode = true;
        document.getElementById("errorMsgDiv").innerHTML = "<UL id='errMessageUL'>";
        if (!fncValidateForm() ) {
            g_blnFormHasUnsubmittedData = true;
            event.preventDefault();
            setTimeout(function(){  
                g_blnFormHasUnsubmittedData = true;
            }, 2000);
        }
    }
    document.getElementById("mainForm").addEventListener('change', fncClearErrorMessage);
    function fncClearErrorMessage () {
        if (blnListMode) {
            if (document.getElementById("errorMsgDiv")) {
                document.getElementById("errorMsgDiv").innerHTML = "<UL id='errMessageUL'>";
                if ( fncValidateForm() ) {
                    blnListMode = false;
                }
            }
        }
    }

    var blnListMode = false;
    function fncFormatError(n_element, n_strError, n_blnNoFucus) {
        function fncAddLITtolist(n_strErrMsg) {
            var node = document.createElement("LI");
            var textnode = document.createTextNode(n_strErrMsg);
            node.appendChild(textnode);
            document.getElementById("errMessageUL").appendChild(node);
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
            fncAddLITtolist(m_strErrMsg);
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

function fncFormatPhone(n_intPhone) {
    let m_strFormattedPhone = "(" + n_intPhone.substring(0, 3) + ')';
    m_strFormattedPhone += " " + n_intPhone.substring(3, 6);
    m_strFormattedPhone += "-" + n_intPhone.substring(6, 10);
    return m_strFormattedPhone;
}

function fncValidatePhone(n_elementPhone) {
    let m_intPhone = n_elementPhone.value.replace(/\(|\)| |-|\./gi, "");
    if (m_intPhone.length) {
        if (isNaN(m_intPhone)) {
            fncFormatError(n_elementPhone, "must be numeric.");
            return false;
        }
        if (m_intPhone.length == 10) {
            n_elementPhone.value = fncFormatPhone(m_intPhone);
            return true;
        } else {
            fncFormatError(n_elementPhone, "must be 10 digits.");
            return false;
        }
    }
    return true;
}
function fncValidateZip(n_elementZip) {
    let m_intZip = n_elementZip.value.replace(/-/g,"");
    if (isNaN(m_intZip)) {
        fncFormatError(n_elementZip, "must be numeric.");
        return false;
    }
    if (m_intZip.length) {
        if (m_intZip.length == 5) {
            n_elementZip.value = m_intZip;
            return true;
        }
        if (m_intZip.length == 9) {
            n_elementZip.value = m_intZip.substring(0, 4) + '-' + m_intZip.substring(4, 9);
            return true;
        } else {
            fncFormatError(n_elementZip, "must be 5 or 9 digits");
            return false;
        }
    }
    return true;
}
function fncValidateState(n_eleState, n_datalistID) {
    let aryDatalistStates = document.getElementById(n_datalistID);
    let i;
    for (i = 0; i < aryDatalistStates.options.length; i++) {
        if (n_eleState.value.toUpperCase() == aryDatalistStates.options[i].value) {
            return true;
        }
    }
    fncFormatError(n_eleState, 'not found in state table');
    return false;
}
function fncValidateDate(n_elementDate) {
    let m_dtmEntered = new Date(n_elementDate.value);
    let m_dtmMin = new Date(n_elementDate.min);
    let m_dtmMax = new Date(n_elementDate.max);
    let m_blnValidDate = ((m_dtmEntered <= m_dtmMax) && (m_dtmEntered >= m_dtmMin));
    if (!m_blnValidDate) {
        fncFormatError(n_elementDate, 'error: date must be a valid date between ' + n_elementDate.min + ' and ' + n_elementDate.min, true);
        return false;
    }
    return true;
}