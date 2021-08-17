<div>
    <fieldset>
        <cfoutput>
            <Legend>Interview</legend>
            <span class="interviewSpan">
                <cfif lCase(form.strTransaction) EQ "add">
                    <label class="interviewInputlabel">Email:</label>
                    <input type="email" name="strEmail" id="strEmail"
                            title="eMail Address|#form.strEmail#"
                            placeholder="example@mail.com"
                            onChange="fncGetAddress(this);"
                            value="#form.strEmail#">
                    <input type="hidden" name="interviewsID" id="interviewsID" value="#form.interviewsID#">
                <cfelse>
                    <label class="interviewInputlabel">Interview:</label>
                    <select size="1" name="interviewsID" id="interviewsID"
                        onChange="fncChangeInterviews(this.options[this.selectedIndex]);"
                        title="Interview|#form.interviewsID#"
                        value="#form.interviewsID#">
                        <option value="">Select an Interview</option>
                    <cfoutput query = "qryAllInterviews">
                        <option value="#qryAllInterviews.interviewsID #"
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
                    <input type="hidden" name="strEmail" id="strEmail" value="#form.strEmail#">
                </cfif> 
            </span>

            <span class="interviewSpan">
                <label class="interviewInputlabel">Date:</label>
                <input type="date" name="dtmInterviewDate" id="dtmInterviewDate"
                    min="#dateFormat(#dateAdd('yyyy', -2, #now()#)#, "yyyy-mm-dd")#" max="#dateFormat(#now()#, "yyyy-mm-dd")#" 
                    value="#dateFormat(form.dtmInterviewDate, 'yyyy-mm-dd')#"
                    onBlur="fncValidateDate(this);"/>
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
                <span class="button" id = "addressButton" onClick="fncEditAddress();">Edit Address</span>
            </span>
            <br/>

            <span class="interviewSpan">
                <label class="interviewInputlabel">Interviewer:</label>
                <input type="text" class="caps" name="strInterviewer" title="Interviewer|#form.strInterviewer#" id="strInterviewer" placeholder="Name"  value="#form.strInterviewer#"/>
            </span>

            
            <span class="interviewSpan">
                <label class="interviewInputlabel">Position:</label>
                <input type="text" name="strPosition" title="Position|#form.strPosition#" id="strPosition" placeholder="Position"   value="#form.strPosition#"/>
            </span>
            <br/>
            <br/>

        </cfoutput>
    </fieldset>
</div>