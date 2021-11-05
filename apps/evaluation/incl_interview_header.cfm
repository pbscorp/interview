<div>
    <fieldset>
        <Legend>Interview</legend>
        <span class="interviewSpan">
            <cfif reFindNoCase("add|view|delete", eForm.strTransaction) >
                <cfoutput>
                    <label class="interviewInputlabel required">Email:</label>
                    <input type="email" name="strEmail" id="strEmail"
                            title="eMail Address|#eForm.strEmail#"
                            placeholder="example@mail.com"
                            <cfif lCase(eForm.strTransaction) EQ "add">
                                <cfif application.blnLucee>
                                    onChange="fncGetAddress(this);"
                                <cfelse>
                                    onChange="fncEditAddress();"
                                </cfif>
                            </cfif>
                            value="#eForm.strEmail#">
                    <input type="hidden" name="interviewsID" id="interviewsID" value="#eForm.interviewsID#">
                </cfoutput>
            <cfelse>
                <cfoutput>
                    <label class="interviewInputlabel required">Interview:</label>
                    <select size="1" name="interviewsID" id="interviewsID"
                        onChange="fncChangeInterviews(this.options[this.selectedIndex]);"
                        title="Interview|#eForm.interviewsID#"
                        value="#eForm.interviewsID#">
                        <option value="">Select an Interview</option>
                </cfoutput>
                <cfoutput query = "qryAllInterviews">
                    <option value="#qryAllInterviews.interviewsID#"
                        title="#qryAllInterviews.strName# (#qryAllInterviews.strEmail#)
                            interviewed on #dateFormat(qryAllInterviews.dtmInterviewDate, 'mm/dd/yyyy')#
                            by #qryAllInterviews.strInterviewer#
                            for #qryAllInterviews.strPosition#"
                        <cfif qryAllInterviews.interviewsID  EQ eForm.interviewsID >
                            selected
                        </cfif>
                        >
                        #qryAllInterviews.strEmail#
                    </option>
                </cfoutput>
                    <option value="add">New Interview</option>
                </select>
                <input type="hidden" name="strEmail" id="strEmail" value="<cfoutput>#eForm.strEmail#</cfoutput>">
            </cfif> 
        </span>
        <cfoutput>
            <span class="interviewSpan">
                <label class="interviewInputlabel required">Date:</label>
                <input type="date" name="dtmInterviewDate" id="dtmInterviewDate"
                    min="#dateFormat(dateAdd('yyyy', -2, now()), "yyyy-mm-dd")#" max="#dateFormat(now(), "yyyy-mm-dd")#" 
                    value="#dateFormat(eForm.dtmInterviewDate, 'yyyy-mm-dd')#"
                    onfocusout="fncValidateInterview();fncValidateDate(this);"/>
            </span>
            <br/>
            <label class="interviewInputlabel"></label>
            <span id="candidatesNameSpan" 
                        style="font-size: smaller;
                        vertical-align: top;
                        <cfif len(eForm.interviewsID) GT 0 || len(eForm.strEmail) GT 0>
                            visibility: visible;
                        <cfelse> 
                            visibility: hidden;
                        </cfif> 
                        font-style: italic;">

                <span  style.display="inline" id="candidatesNameTextSpan">
                    #eForm.strName#
                </span>
                <cfif lCase(eForm.strTransaction) NEQ "view">
                    <span class="button" id = "addressButton" onClick="fncEditAddress();">Edit Address</span>
                </cfif>
            </span>
            <br/>

            <span class="interviewSpan">
                <label class="interviewInputlabel required">Interviewer:</label>
                <input type="text" class="caps"
                        name="strInterviewer" 
                        title="Interviewer|#eForm.strInterviewer#"
                        id="strInterviewer"
                        placeholder="Name"
                        onChange="fncValidateInterview();"
                        value="#eForm.strInterviewer#"/>
            </span>

        </cfoutput>
        
        <span class="interviewSpan">
            <label class="interviewInputlabel required">Position:</label>
            <cfoutput>
                <input list="datalistPositions" 
                name="strPosition"
                title="Position|#eForm.strPosition#"
                id="strPosition"
                placeholder="Position"
                value="#eForm.strPosition#"
            </cfoutput>
                <cfif reFindNoCase("add|update", eForm.strTransaction) >
                    onChange="fncValidateInterview();fncNewPosition(this, 'datalistPositions');"
                </cfif>
                onFocus="this.select()">
            <datalist id="datalistPositions">
                <option value="">Position</option>
                <cfoutput Query=qryPositions>
                    <option value="#qryPositions.strPosition#">#qryPositions.strPosition#</option>
                </cfoutput>
            </datalist>
        </span>
        <br/>
        <br/>
    </fieldset>
</div>
<script>
    function fncNewPosition( ) {
        g_blnFormHasUnsubmittedData = false;
        mainForm.removeEventListener('change', fncEnableSubmit);
        mainForm.submit();
    }
</script>