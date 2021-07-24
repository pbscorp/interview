<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="form.ID" default="">
<cfparam name="form.strNameFirst" default="">
<cfparam name="form.strNameMiddle" default="">
<cfparam name="form.strNameLast" default="">
<cfparam name="form.strAddressLine1" default="">
<cfparam name="form.strAddressLine2" default="">
<cfparam name="form.strCity" default="">
<cfparam name="form.strState" default="">
<cfparam name="form.strZip" default="">
<cfparam name="form.strEmail" default="">
<cfparam name="form.intPhone" default="">
<cfparam name="form.intMobile" default="">
<cfparam name="form.strName" default="">
<cfparam name="form.submitButton" default="">
<cfparam name="form.blnHasError" default="0">
<cfparam name="form.strErorMessage" default="">
<cfparam name="strSuccessMessage" default="">

<cfset aryErrorMessage = ArrayNew(1)>

<cfif len(form.submitButton)>
    <cfinclude template = "act_address.cfm">
    <cfabort>
</cfif>
<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfprocessingdirective suppressWhiteSpace = "yes">
<HTML>
    <head>
        <link rel="stylesheet" href="css/stylesheet.css">
        <cfscript>
            objCandidates = createObject('component', 'interview-cfc.candidates');
            stcStates = objCandidates.getstates();
            function CFfncFormatPhone(n_intPhone)   {
                var m_intPhone = trim(n_intPhone);
                var r_intPhone = n_intPhone;
                if(len(n_intPhone) && len(m_intPhone) == 10) {
                    r_intPhone = "(" & mid(m_intPhone, 1, 3) & ") ";
                    r_intPhone &= mid(m_intPhone, 4, 3) & "-";
                    r_intPhone &= mid(m_intPhone, 7, 4);
                }
                return r_intPhone;
            }
            function CFfncFromatZip(n_strZip) {
                var m_strZip = trim(n_strZip);
                var r_strZip = n_strZip;
                if(len(m_strZip) > 1) {
                }
                if(len(m_strZip) == 9) {
                    r_strZip = mid(m_strZip, 1, 5);
                    r_strZip &= "-" & mid(m_strZip, 6, 4);
                }
                return r_strZip;
            }
        </cfscript>
    </head>
    <body id="bodyID">
        <div>
            <cfoutput>
                <form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#" onSubmit="fncRemoveBeforeUnloadEvent()"
                    onsubmit="return fncValidateForm()" target="_self">
                    <div id="errorMsgDiv">
                        <cfif arrayLen(aryErrorMessage)>
                            <ul>
                            <cfloop from = "1" to = "#arrayLen(aryErrorMessage)#" index = "i">
                                <li>#aryErrorMessage[#i#]#</li>
                            </cfloop>
                            </ul>
                        </cfif> 
                    </div>
                    <cfif len(strSuccessMessage)>
                        <div id="successMsgDiv">#strSuccessMessage#</div>
                    </cfif> 
                    <div id="addressSectionID">
                        <fieldset>
                            <Legend>Address</legend>
                            <cfoutput>
                                <div id="addressTableDiv">
                                    <span  title="#form.strNameFirst# #form.strNameMiddle# #form.strNameLast#">
                                        Full Name: </span>
                                    <input type="text" id="strNameFirst"  name="strNameFirst" 
                                            placeholder="First"
                                            size="9" maxLength="255" 
                                            value="#form.strNameFirst#"
                                            title="#form.strNameFirst#">
                                    <input type="text" id="strNameMiddle" name="strNameMiddle"
                                            placeholder="M"
                                            size="1" maxLength="45" 
                                            value="#form.strNameMiddle#"
                                            title="#form.strNameMiddle#">
                                    <input type="text" id="strNameFirst" name="strNameLast" 
                                            placeholder="Last"
                                            size="12" maxLength="255" 
                                            value="#form.strNameLast#"
                                            title="#form.strNameLast#"></br>

                                    <span  title="#form.strAddressLine1# #form.strAddressLine2#" >
                                        Street: </span>
                                    <input type="text" 
                                            id="strAddressLine1" name="strAddressLine1" 
                                            size="34" maxLength="255" 
                                            value="#form.strAddressLine1#"
                                            title="#form.strAddressLine1#"></br>
                                            
                                    <span  title="#form.strAddressLine1# #form.strAddressLine2#" >
                                        :</span>
                                    <input type="text"
                                            id="strAddressLine2" name="strAddressLine2" 
                                            size="34" maxLength="255"
                                            value="#form.strAddressLine2#"
                                            title="#form.strAddressLine2#"></br>

                                    <span  title="#form.strCity# #form.strState# #form.strZip#">
                                        City/State/Zip: </span>
                                    <input type="text" title="#form.strCity#" id="strCity" name="strCity"
                                            size="13" maxLength="45" value="#form.strCity#">
                                    <cfset m_intStrctSize = stcStates.size()>
                                    <cfset  i = 1>
                                    <input list="datalistStates" id="inputStates" name="inputStates" 
                                        value="#form.strState#"
                                        size="2" 
                                        style="text-transform:uppercase;"
                                        onFocus="this.select()"
                                        onChange="fncValidateState(this.value);">
                                    <datalist id="datalistStates">
                                        <option value="">State</option>
                                        <cfloop index="i" from="1" to="#m_intStrctSize#">
                                            <option value="#stcStates[i].code#">#stcStates[i].code#|#stcStates[i].state#</option>
                                        </cfloop>
                                    </datalist>
                                        <input type="text" title="#form.strZip#" id="strZip" name="strZip" 
                                                        size="7" maxLength="10" 
                                                        value="#CFfncFromatZip(form.strZip)#"
                                                        onchange="fncValidateZip(this)"></br>
                                    
                                    <span  title=" Landline and/or mobile">
                                        Landline/mobile: </span>
                                    <input type="text" id="intPhone" name="intPhone" size="14" maxLength="16"
                                                        placeholder="Home"
                                                        title="#form.intPhone#"
                                                        value="#CFfncFormatPhone(form.intPhone)#"
                                                        onchange="fncValidatePhone(this)">
                                    <input type="text" id="intMobile" name="intMobile" size="14" maxLength="16"
                                                        placeholder="Mobile"
                                                        title="#form.intMobile#"
                                                        value="#CFfncFormatPhone(form.intMobile)#"
                                                        onchange="fncValidatePhone(this)"></br>

                                    <span  title="#form.strEmail#" >
                                        eMail: </span>
                                    <input type="text" id="strEmail" name="strEmail" 
                                                        size="34" maxLength="255"
                                                        value="#form.strEmail#"
                                                        title="#form.strEmail#"
                                                        onchange="fncValidateEmail(this)"></br>
                                                        
                                    <span>
                                        <input type="submit" name="submitButton" id="submitButton"
                                            value="update" disabled>
                                    </span>
                                </div>
                            </cfoutput>
                        </fieldset>
                    </div> 
                </form>
            </cfoutput>
        </div>
        
        <script>
                
            function fncValidateEmail(n_elementEmail)   {
                var m_strMailformat = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/;
                if(n_elementEmail.value.match(m_strMailformat)) {
                    return true;
                } else {
                    alert("You have entered an invalid email address!");
                    n_elementEmail.select();
                    n_elementEmail.focus();
                    return false;
                }
            }
            
            function fncFormatPhone(n_intPhone) {
                var m_strFormattedPhone = "(" + n_intPhone.substring(0,3) + ')';
                m_strFormattedPhone += " " + n_intPhone.substring(3,6);
                m_strFormattedPhone += "-" + n_intPhone.substring(6,10);
                return m_strFormattedPhone;
            }

            function fncValidatePhone(n_elementPhone)   {
                var m_intPhone =  n_elementPhone.value.replace(/\D/g,'');
                if(m_intPhone.length) {
                    if(m_intPhone.length == 10) {
                //alert("Valid phone !" + m_intPhone);
                        n_elementPhone.value = fncFormatPhone(m_intPhone);
                        return true;
                    } else {
                        alert("Invalid phone number must be 10 digits!");
                        n_elementPhone.select();
                        n_elementPhone.focus();
                        return false;
                    }
                }
            }
            function fncValidateZip(n_elementZip)   {
                var m_intZip =  n_elementZip.value.replace(/\D/g,'');
                if (m_intZip.length) {
                    if (m_intZip.length == 5) {
                        n_elementZip.value =  m_intZip;
                        return true;
                    }
                    if (m_intZip.length == 9) {
                        n_elementZip.value =  m_intZip.substring(0,4) + '-' + m_intZip.substring(4,9);
                        return true;
                    } else {
                        alert("Invalid zipcode must be 5 or 9 digits");
                        n_elementZip.select();
                        n_elementZip.focus();
                        return false;
                    }
                }
            }
            function fncValidateState(n_stateCode) {
                var aryDatalistStates = document.getElementById("datalistStates");
                var i;
                for (i = 0; i < aryDatalistStates.options.length; i++) {
                    if (n_stateCode.toUpperCase() == aryDatalistStates.options[i].value) {
                        return true;
                    }
                }
                alert('error: ' + n_stateCode.toUpperCase() + ' not in found in state table');
                document.getElementById("inputStates").select();
                document.getElementById("inputStates").focus();
                return false;
            }
            function fncFormatError(n_strError) {
                document.getElementById("errorDiv").innerHTML += "<li>" + n_strError + "</li>";
            }
        </script>
        <script src="/pbscorp/js/beforeunload.js" defer></script>
    </body>
</cfprocessingdirective>
</HTML>