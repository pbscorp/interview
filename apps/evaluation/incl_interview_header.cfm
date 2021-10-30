<div>
    <fieldset>
        <Legend>Interview</legend>
        <span class="interviewSpan">
            <cfif reFindNoCase("add|view|delete", form.strTransaction) >
                <cfoutput>
                    <label class="interviewInputlabel required">Email:</label>
                    <input type="email" name="strEmail" id="strEmail"
                            title="eMail Address|#form.strEmail#"
                            placeholder="example@mail.com"
                            <cfif lCase(form.strTransaction) EQ "add">
                                <cfif application.blnLucee>
                                    onChange="fncGetAddress(this);"
                                <cfelse>
                                    onChange="fncEditAddress();"
                                </cfif>
                            </cfif>
                            value="#form.strEmail#">
                    <input type="hidden" name="interviewsID" id="interviewsID" value="#form.interviewsID#">
                </cfoutput>
            <cfelse>
                <cfoutput>
                    <label class="interviewInputlabel required">Interview:</label>
                    <select size="1" name="interviewsID" id="interviewsID"
                        onChange="fncChangeInterviews(this.options[this.selectedIndex]);"
                        title="Interview|#form.interviewsID#"
                        value="#form.interviewsID#">
                        <option value="">Select an Interview</option>
                </cfoutput>
                <cfoutput query = "qryAllInterviews">
                    <option value="#qryAllInterviews.interviewsID#"
                        title="#qryAllInterviews.strName# (#qryAllInterviews.strEmail#)
                            interviewed on #dateFormat(qryAllInterviews.dtmInterviewDate, 'mm/dd/yyyy')#
                            by #qryAllInterviews.strInterviewer#
                            for #qryAllInterviews.strPosition#"
                        <cfif qryAllInterviews.interviewsID  EQ form.interviewsID >
                            selected
                        </cfif>
                        >
                        #qryAllInterviews.strEmail#
                    </option>
                </cfoutput>
                    <option value="add">New Interview</option>
                </select>
                <input type="hidden" name="strEmail" id="strEmail" value="<cfoutput>#form.strEmail#</cfoutput>">
            </cfif> 
        </span>
        <cfoutput>
            <span class="interviewSpan">
                <label class="interviewInputlabel required">Date:</label>
                <input type="date" name="dtmInterviewDate" id="dtmInterviewDate"
                    min="#dateFormat(dateAdd('yyyy', -2, now()), "yyyy-mm-dd")#" max="#dateFormat(now(), "yyyy-mm-dd")#" 
                    value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#"
                    onfocusout="fncValidateInterview();fncValidateDate(this);"/>
            </span>
            <br/>
            <label class="interviewInputlabel"></label>
            <span id="candidatesNameSpan" 
                        style="font-size: smaller;
                        vertical-align: top;
                        <cfif len(form.interviewsID) GT 0 || len(form.strEmail) GT 0>
                            visibility: visible;
                        <cfelse> 
                            visibility: hidden;
                        </cfif> 
                        font-style: italic;">

                <span  style.display="inline" id="candidatesNameTextSpan">
                    #form.strName#
                </span>
                <cfif lCase(form.strTransaction) NEQ "view">
                    <span class="button" id = "addressButton" onClick="fncEditAddress();">Edit Address</span>
                </cfif>
            </span>
            <br/>

            <span class="interviewSpan">
                <label class="interviewInputlabel required">Interviewer:</label>
                <input type="text" class="caps"
                        name="strInterviewer" 
                        title="Interviewer|#form.strInterviewer#"
                        id="strInterviewer"
                        placeholder="Name"
                        onChange="fncValidateInterview();"
                        value="#form.strInterviewer#"/>
            </span>

        </cfoutput>
        
        <span class="interviewSpan">
            <label class="interviewInputlabel required">Position:</label>
            <cfoutput>
                <input list="datalistPositions" 
                name="strPosition"
                title="Position|#form.strPosition#"
                id="strPosition"
                placeholder="Position"
                value="#form.strPosition#"
            </cfoutput>
                <cfif reFindNoCase("add|update", form.strTransaction) >
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