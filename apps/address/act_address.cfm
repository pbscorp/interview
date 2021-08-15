<!--- <cfdump var = "#form#"><cfabort> --->
<cftransaction>
    <cfset strErrorMessage =  "">
    <cftry>
        <cfif form.strTransaction EQ "add">
            <cfquery name="qryAddAddress">
                INSERT INTO address
                    (strNameFirst,
                    strNameMiddle,
                    strNameLast,
                    strAddressLine1,
                    strAddressLine2,
                    strCity,
                    strState,
                    strZip,
                    strEmail,
                    intPhone,
                    intMobile
                ) VALUES (
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strNameFirst, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strNameMiddle, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strNameLast, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strAddressLine1, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strAddressLine2, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strCity, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCase(form.strState)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#reReplace(form.strZip, "[^0-9]", "", "all")#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strEmail#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#reReplace(form.intPhone, "[^0-9]", "", "all")#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#reReplace(form.intMobile, "[^0-9]", "", "all")#">
                )
            </cfquery>
            <cfquery name="qryNewAddress">
                SELECT address.ID as addressID
                    FROM candidates.address
                    WHERE address.strEmail = "#form.strEmail#" ORDER BY address.dtmAdded DESC; 
            </cfquery>
        <cfelseif form.strTransaction EQ "update">
            <cfquery name="qryUpdateAddress">
                UPDATE candidates.address
                    SET
                        strNameFirst = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strNameFirst, true)#">,
                        strNameMiddle = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strNameMiddle, true)#">,
                        strNameLast = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strNameLast, true)#">,
                        strAddressLine1 = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strAddressLine1, true)#">,
                        strAddressLine2 = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strAddressLine2, true)#">,
                        strCity = <cfqueryparam cfsqltype="CF_sql_varchar" value="#ucFirst(form.strCity, true)#">,
                        strState = <cfqueryparam cfsqltype="CF_sql_varchar"value="#uCase(form.strState)#">,
                        strZip = <cfqueryparam cfsqltype="CF_sql_varchar"  value="#replace(form.strZip, "-", "", "all")#">,
                        strEmail = <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strEmail#">,
                        intPhone = <cfqueryparam cfsqltype="cf_sql_integer" value="#reReplace(form.intPhone, "[^0-9]", "", "all")#">,
                        intMobile = <cfqueryparam cfsqltype="cf_sql_integer"value="#reReplace(form.intMobile, "[^0-9]", "", "all")#">
                    WHERE ID =  <cfqueryparam CFSQLTYPE="cf_sql_integer" VALUE="#FORM.addressID#">;
            </cfquery>
            <cfset strSuccessMessage = "record updated">
        <cfelseif form.strTransaction EQ "delete">
            <cfquery name="qryDeleteAddress">
                DELETE FROM address
                WHERE ID =  <cfqueryparam CFSQLTYPE="cf_sql_integer" VALUE="#FORM.addressID#">;
            </cfquery>
        </cfif>
        <cfcatch>
            <cfsavecontent variable = "stcCatchDump"> 
                <cfdump var="#cfcatch#">
            </cfsavecontent>
                <cffile action = "write" 
                    file = "C:\lucee\tomcat\logs\CFerror\Catch_error#dateFormat(now(), 'yyyy-mm-dd')##timeFormat(now(), 'HHmmss')#.html" 
                    output = "Created By: #cgi.SCRIPT_NAME# 
                    Date: #dateFormat(#now()#, 'mm/dd/yy')# time: #timeFormat(#now()#)#
                    #cfcatch#">
                    <cfset strErrorMessage= "See error log:#cfcatch.message#">
                    <cftransaction action = "rollback"/>
        </cfcatch>
        <cfif NOT len(strErrorMessage)>
            <cfif lCase(form.strTransaction) EQ "delete">
                <cfset form.strTransaction = "Add">
                <cfset strSuccessMessage = "record #form.addressID# deleted">    
                <cfset form.addressID = ''>
            <cfelseif lCase(form.strTransaction) EQ "add">
                <cfset strSuccessMessage = "record #form.addressID# added">
                <cfset form.strTransaction = "update">
                <cfset form.addressID = qryNewAddress.addressID>
            <cfelse>
                <cfset strSuccessMessage = "record #form.addressID# updated">
            </cfif>
        </cfif>
    </cftry>
    
</cftransaction>