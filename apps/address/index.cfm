<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="url.addressID" default="">
<cfparam name="form.addressID" default="#url.addressID#">
<cfparam name="url.strEmail" default="">
<cfparam name="form.strEmail" default="#url.strEmail#">
<cfparam name="form.strNameFirst" default="">
<cfparam name="form.strNameMiddle" default="">
<cfparam name="form.strNameLast" default="">
<cfparam name="form.strAddressLine1" default="">
<cfparam name="form.strAddressLine2" default="">
<cfparam name="form.strCity" default="">
<cfparam name="form.strState" default="">
<cfparam name="form.strZip" default="">
<cfparam name="form.intPhone" default="0">
<cfparam name="form.intMobile" default="0">
<cfparam name="form.strName" default="">
<cfparam name="form.submitButton" default="">
<cfparam name="form.blnHasError" default="0">
<cfparam name="strErrorMessage" default="">
<cfparam name="strSuccessMessage" default="">
<cfset objUtilities = createObject('component', 'interview-cfc.utilities')>
<cfset eForm = objUtilities.encodeFormForHTML(form)>
<cfif len(eForm.submitButton)>
    <cfinclude template = "act_address.cfm">
</cfif>
<cfprocessingdirective suppressWhiteSpace = "yes">
<HTML>
    <head>
        <cfoutput>
        <link rel="stylesheet" href="#application.applicationBaseURLPath#/css/stylesheet.css">
        </cfoutput>
        <cfscript>
            objAddress = createObject('component', 'interview-cfc.address');
            stcStates = objAddress.getstates();
            qryAddress = objAddress.getAddress(form.strEmail);
            if ( (!eForm.blnHasError) && (qryAddress.recordCount)) {
                eForm.strTransaction = "update";
                eForm.addressID  = qryAddress.addressID;
                eForm.strNameFirst = qryaddress.strNameFirst;
                eForm.strNameMiddle = qryaddress.strNameMiddle;
                eForm.strNameLast = qryaddress.strNameLast;
                eForm.strName = qryaddress.strName;
                eForm.strAddressLine1 = qryaddress.strAddressLine1;
                eForm.strAddressLine2 = qryaddress.strAddressLine2;
                eForm.strCity = qryaddress.strCity;
                eForm.strState = qryaddress.strState;
                eForm.strZip = qryaddress.strZip;
                eForm.strEmail = qryaddress.strEmail;
                eForm.intPhone = qryaddress.intPhone;
                eForm.intMobile = qryaddress.intMobile;
            } else {
                eForm.strTransaction = "add";
            }
            function CFfncFormatPhone(n_intPhone)   {
                var m_intPhone = trim(n_intPhone);
                var r_intPhone = "";
                if (n_intPhone != 0) {
                    r_intPhone = n_intPhone;
                }
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
        <cfoutput><form name="mainForm" id="mainForm" method="post" action="#cgi.script_name#?strEmail=#url.strEmail#"></cfoutput>
        <cfoutput>
            <div id="addressSectionID">
                <fieldset>
                    <Legend>#eForm.strTransaction# Address</legend>
                    <div id="addressTableDiv">
                        <span  title="Full name|#eForm.strNameFirst# #eForm.strNameMiddle# #eForm.strNameLast#">
                            Full Name: </span>
                        <input type="text" id="strNameFirst"  name="strNameFirst" 
                                placeholder="First"
                                size="9" maxLength="255" 
                                value="#eForm.strNameFirst#"
                                title="First name|#eForm.strNameFirst#">
                        <input type="text" id="strNameMiddle" name="strNameMiddle"
                                placeholder="M"
                                size="1" maxLength="45" 
                                value="#eForm.strNameMiddle#"
                                title="Middle name|#eForm.strNameMiddle#">
                        <input type="text" id="strNameFirst" name="strNameLast" 
                                placeholder="Last"
                                size="12" maxLength="255" 
                                value="#eForm.strNameLast#"
                                title="Last name|#eForm.strNameLast#"></br>

                        <span  title="#eForm.strAddressLine1# #eForm.strAddressLine2#" >
                            Street: </span>
                        <input type="text" 
                                id="strAddressLine1" name="strAddressLine1" 
                                size="34" maxLength="255" 
                                value="#eForm.strAddressLine1#"
                                title="#eForm.strAddressLine1#"></br>
                                
                        <span  title="#eForm.strAddressLine1# #eForm.strAddressLine2#" >
                            :</span>
                        <input type="text"
                                id="strAddressLine2" name="strAddressLine2" 
                                size="34" maxLength="255"
                                value="#eForm.strAddressLine2#"
                                title="#eForm.strAddressLine2#"></br>

                        <span  title="#eForm.strCity# #eForm.strState# #eForm.strZip#">
                            City/State/Zip: </span>
                        <input type="text" title="City|#eForm.strCity#" id="strCity" name="strCity"
                                size="13" maxLength="45" value="#eForm.strCity#">
                        <cfset m_intStrctSize = stcStates.size()>
                        <cfset  i = 1>
                        <input list="datalistStates" id="strState" name="strState" 
                            title="State"
                            value="#eForm.strState#"
                            size="2" 
                            style="text-transform: uppercase;"
                            onFocus="this.select()"
                            onChange="fncValidateState(this, 'datalistStates');">
                        <datalist id="datalistStates">
                            <option value="">State</option>
                            <cfloop index="i" from="1" to="#m_intStrctSize#">
                                <option value="#stcStates[i].code#">#stcStates[i].code#|#stcStates[i].state#</option>
                            </cfloop>
                        </datalist>
                            <input type="text" title="Zip code|#eForm.strZip#" id="strZip" name="strZip" 
                                            size="7" maxLength="10" 
                                            value="#CFfncFromatZip(eForm.strZip)#"
                                            onchange="fncValidateZip(this)"></br>
                        
                        <span  title=" Landline and/or mobile">
                            Landline/mobile: </span>
                        <input type="tel" id="intPhone" name="intPhone" size="14" maxLength="16"
                                            placeholder="Home"
                                            title="Phone (landline)|#eForm.intPhone#"
                                            value="#CFfncFormatPhone(eForm.intPhone)#"
                                            onchange="fncValidatePhone(this)">
                        <input type="text" id="intMobile" name="intMobile" size="14" maxLength="16"
                                            placeholder="Mobile"
                                            title="Mobile number|#eForm.intMobile#"
                                            value="#CFfncFormatPhone(eForm.intMobile)#"
                                            onchange="fncValidatePhone(this)"></br>

                        <span  title="#eForm.strEmail#" >
                            eMail: </span>
                        <input type="email" id="strEmail" name="strEmail" 
                                            size="34" maxLength="255"
                                            style="text-transform: none;"
                                            value="#eForm.strEmail#"
                                            title="eMail address|#eForm.strEmail#"
                                    <cfif len(url.strEmail)>
                                        disabled
                                    </cfif> 
                                            onchange="fncValidateEmail(this)"></br>
                                            
                        <span>
                            <input type="hidden" name="strTransaction" id="strTransaction" value="#eForm.strTransaction#">
                            <input type="hidden" name="strErrorMessage" id="strErrorMessage" value="#strErrorMessage#">
                            <input type="hidden" name="strSuccessMessage" id="strSuccessMessage" value="#strSuccessMessage#">
                            <input type="hidden" name="addressID" id="addressID" value="#eForm.addressID#">
                            <input type="submit" name="submitButton" id="submitButton" value="update" disabled>
                            <input type="button" name="closeButton" id="closeButton" value="close" onClick="window.close();">
                        </span>
                    </div>
                </fieldset>
            </div> 
        </form>
    </div>

    <script>
        if (opener) {
            opener.document.getElementById("candidatesNameTextSpan").innerHTML = "#eForm.strName#";
            opener.document.getElementById("addressID").value = "#eForm.addressID#";
        }
        document.getElementById("strNameFirst").focus();
        document.getElementById("strNameFirst").select();
        </script>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" defer></script>
            <script>
                function fncValidateForm() {
                    let m_intErrors = 0;
                    if ( !fncValidateZip(mainForm.strZip)  ) {
                        m_intErrors++;
                    }
                    if ( !fncValidateState(mainForm.strState,  'datalistStates') ) {
                        m_intErrors++;
                    }
                    if ( !fncValidatePhone(mainForm.intPhone) ) {
                        m_intErrors++;
                    }
                    if ( !fncValidatePhone(mainForm.intMobile) ) {
                        m_intErrors++;
                    }
                    if ( !fncValidateEmail(mainForm.strEmail) ) {
                        m_intErrors++;
                    }
                    if (!m_intErrors) {
                        return true; 
                    }
                    return false;
                }
            </script>
</cfoutput>
    </body>
</cfprocessingdirective>
</HTML>