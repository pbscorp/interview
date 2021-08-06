window.addEventListener('load', fncClearMessage);
    function fncClearMessage () {
        setTimeout(function(){  
            if (document.getElementById("successMsgDiv")) {
                document.getElementById("successMsgDiv").innerHTML = "";
            };
        }, 5000);
    }

function fncFormatError(n_element, n_strError, n_blnNoFucus) {
    let m_blnNoFucus = false;
    if (n_blnNoFucus) {
        m_blnNoFucus = true;
    }
    let m_blnListMode = false;
    if (document.getElementById("errorMsgDiv") && document.getElementById("errorMsgDiv").innerHTML == "<ul>") {
        // initialize above when submitting the form
        m_blnListMode = true;
    }
    if (m_blnListMode) {
        document.getElementById("errorMsgDiv").innerHTML += "<li>" + n_element.title + ' ' + n_strError + "</li>";
    } else {
        alert(n_strError);
        if (!m_blnNoFucus) {
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
        fncFormatError(n_elementEmail, "You have entered an invalid email address!");
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
    let m_intPhone = n_elementPhone.value.replace(/\D/g, '');
    if (m_intPhone.length) {
        if (m_intPhone.length == 10) {
            n_elementPhone.value = fncFormatPhone(m_intPhone);
            return true;
        } else {
            fncFormatError(n_elementPhone, "Invalid phone number must be 10 digits!");
            return false;
        }
    }
}
function fncValidateZip(n_elementZip) {
    let m_intZip = n_elementZip.value.replace(/\D/g, '');
    if (m_intZip.length) {
        if (m_intZip.length == 5) {
            n_elementZip.value = m_intZip;
            return true;
        }
        if (m_intZip.length == 9) {
            n_elementZip.value = m_intZip.substring(0, 4) + '-' + m_intZip.substring(4, 9);
            return true;
        } else {
            fncFormatError(n_elementZip, "Invalid zipcode must be 5 or 9 digits");
            return false;
        }
    }
}
function fncValidateState(n_eleState, n_datalistID) {
    let aryDatalistStates = document.getElementById(n_datalistID);
    let i;
    for (i = 0; i < aryDatalistStates.options.length; i++) {
        if (n_eleState.value.toUpperCase() == aryDatalistStates.options[i].value) {
            return true;
        }
    }
    fncFormatError(n_eleState, 'error: ' + n_eleState.value.toUpperCase() + ' not in found in state table');
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
}