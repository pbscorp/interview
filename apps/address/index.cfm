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
<!--- 

    <cfif len(form.strEmail)>
        <cfset form.strTransaction = "update">
    <cfelse>
        <cfset form.strTransaction = "add">
    </cfif> 
--->

<cfif len(form.submitButton)>
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
            if ( (!form.blnHasError) && (qryAddress.recordCount)) {
                form.strTransaction = "update";
                form.addressID  = qryAddress.addressID;
                form.strNameFirst = qryaddress.strNameFirst;
                form.strNameMiddle = qryaddress.strNameMiddle;
                form.strNameLast = qryaddress.strNameLast;
                form.strName = qryaddress.strName;
                form.strAddressLine1 = qryaddress.strAddressLine1;
                form.strAddressLine2 = qryaddress.strAddressLine2;
                form.strCity = qryaddress.strCity;
                form.strState = qryaddress.strState;
                form.strZip = qryaddress.strZip;
                form.strEmail = qryaddress.strEmail;
                form.intPhone = qryaddress.intPhone;
                form.intMobile = qryaddress.intMobile;
            } else {
                form.strTransaction = "add";
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
                    <Legend>#form.strTransaction# Address</legend>
                    <div id="addressTableDiv">
                        <span  title="Full name|#form.strNameFirst# #form.strNameMiddle# #form.strNameLast#">
                            Full Name: </span>
                        <input type="text" id="strNameFirst"  name="strNameFirst" 
                                placeholder="First"
                                size="9" maxLength="255" 
                                value="#form.strNameFirst#"
                                title="First name|#form.strNameFirst#">
                        <input type="text" id="strNameMiddle" name="strNameMiddle"
                                placeholder="M"
                                size="1" maxLength="45" 
                                value="#form.strNameMiddle#"
                                title="Middle name|#form.strNameMiddle#">
                        <input type="text" id="strNameFirst" name="strNameLast" 
                                placeholder="Last"
                                size="12" maxLength="255" 
                                value="#form.strNameLast#"
                                title="Last name|#form.strNameLast#"></br>

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
                        <input type="text" title="City|#form.strCity#" id="strCity" name="strCity"
                                size="13" maxLength="45" value="#form.strCity#">
                        <cfset m_intStrctSize = stcStates.size()>
                        <cfset  i = 1>
                        <input list="datalistStates" id="strState" name="strState" 
                            title="State"
                            value="#form.strState#"
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
                            <input type="text" title="Zip code|#form.strZip#" id="strZip" name="strZip" 
                                            size="7" maxLength="10" 
                                            value="#CFfncFromatZip(form.strZip)#"
                                            onchange="fncValidateZip(this)"></br>
                        
                        <span  title=" Landline and/or mobile">
                            Landline/mobile: </span>
                        <input type="tel" id="intPhone" name="intPhone" size="14" maxLength="16"
                                            placeholder="Home"
                                            title="Phone (landline)|#form.intPhone#"
                                            value="#CFfncFormatPhone(form.intPhone)#"
                                            onchange="fncValidatePhone(this)">
                        <input type="text" id="intMobile" name="intMobile" size="14" maxLength="16"
                                            placeholder="Mobile"
                                            title="Mobile number|#form.intMobile#"
                                            value="#CFfncFormatPhone(form.intMobile)#"
                                            onchange="fncValidatePhone(this)"></br>

                        <span  title="#form.strEmail#" >
                            eMail: </span>
                        <input type="email" id="strEmail" name="strEmail" 
                                            size="34" maxLength="255"
                                            style="text-transform: none;"
                                            value="#form.strEmail#"
                                            title="eMail address|#form.strEmail#"
                                    <cfif len(url.strEmail)>
                                        disabled
                                    </cfif> 
                                            onchange="fncValidateEmail(this)"></br>
                                            
                        <span>
                            <input type="hidden" name="strTransaction" id="strTransaction" value="#form.strTransaction#">
                            <input type="hidden" name="strErrorMessage" id="strErrorMessage" value="#strErrorMessage#">
                            <input type="hidden" name="strSuccessMessage" id="strSuccessMessage" value="#strSuccessMessage#">
                            <input type="hidden" name="addressID" id="addressID" value="#form.addressID#">
                            <input type="submit" name="submitButton" id="submitButton" value="update" disabled>
                            <input type="button" name="closeButton" id="closeButton" value="close" onClick="window.close();">
                        </span>
                    </div>
                </fieldset>
            </div> 
        </form>
    </div>

    <script>
        if (opener) {alert(22)
            opener.document.getElementById("candidatesNameTextSpan").innerHTML = "#form.strName#";
            opener.document.getElementById("addressID").value = "#form.addressID#";
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
                    //alert (m_intErrors + ' m_intErrors found ');
                    return false;
                }
            </script>
</cfoutput>
    </body>
</cfprocessingdirective>
</HTML>