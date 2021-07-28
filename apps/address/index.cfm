<!DOCTYPE HTML PUBLIC ‘-//W3C//DTD HT\lL 4.0 Transitional//EN’>
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

<cfif len(form.submitButton) OR url.strTransaction EQ "getNameXX">
    <cfinclude template = "act_address.cfm">
</cfif>
<cfprocessingdirective suppressWhiteSpace = "yes">
<HTML>
    <head>
        <cfoutput>
        <link rel="stylesheet" href="#application.applicationBaseURLPath#/css/stylesheet.css">
        </cfoutput>
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
                                        onChange="fncValidateState(this, 'datalistStates');">
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
        
        <cfoutput>
            <script src="#application.applicationBaseURLPath#/js/beforeunload.js" defer></script>
            <script src="#application.applicationBaseURLPath#/js/validation.js" defer></script>
        </cfoutput>
    </body>
</cfprocessingdirective>
</HTML>