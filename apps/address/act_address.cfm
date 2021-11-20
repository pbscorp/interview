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
                    intPhone,
                    intMobile,
                    strEmail
                ) VALUES (
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strNameFirst, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strNameMiddle, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strNameLast, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strAddressLine1, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strAddressLine2, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strCity, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCase(form.strState)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#reReplace(form.strZip, "[^0-9]", "", "all")#">,
                    <cfif len(form.intPhone)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value=#reReplace(form.intPhone, "[^0-9]", "", "all")#>,
                    <cfelse>
                        NULL,
                    </cfif>
                    <cfif len(form.intMobile)>
                        <cfqueryparam cfsqltype="cf_sql_integer" value=#reReplace(form.intMobile, "[^0-9]", "", "all")#>
                    <cfelse>
                        NULL,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strEmail#">
                    </cfif>
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
                        strNameFirst = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strNameFirst, true)#">,
                        strNameMiddle = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strNameMiddle, true)#">,
                        strNameLast = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strNameLast, true)#">,
                        strAddressLine1 = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strAddressLine1, true)#">,
                        strAddressLine2 = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strAddressLine2, true)#">,
                        strCity = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(form.strCity, true)#">,
                        strState = <cfqueryparam cfsqltype="CF_sql_varchar"value="#uCase(form.strState)#">,
                        strZip = <cfqueryparam cfsqltype="CF_sql_varchar"  value="#replace(form.strZip, "-", "", "all")#">,
                        <cfif len(form.intPhone)>
                            intPhone = <cfqueryparam cfsqltype="cf_sql_integer" value=#reReplace(form.intPhone, "[^0-9]", "", "all")#>,
                        <cfelse>
                            intPhone = NULL,
                        </cfif>
                        <cfif len(form.intMobile)>
                            intMobile = <cfqueryparam cfsqltype="cf_sql_integer"value=#reReplace(form.intMobile, "[^0-9]", "", "all")#>,
                        <cfelse>
                            intMobile = NULL,
                        </cfif>
                        strEmail = <cfqueryparam cfsqltype="CF_sql_varchar" value="#form.strEmail#">
                    WHERE ID =  <cfqueryparam cfsqltype="cf_sql_integer" value=#form.addressID#>;
            </cfquery>
            <cfset strSuccessMessage = "record updated">
        <cfelseif form.strTransaction EQ "delete">
            <cfquery name="qryDeleteAddress">
                DELETE FROM address
                WHERE ID =  <cfqueryparam cfsqltype="cf_sql_integer" value=#form.addressID#>;
            </cfquery>
        </cfif>
        <cfcatch>
            <cfinclude template="#application.applicationBaseURLPath#/resources/incl_cfcatchError.cfm">
            <cfset strErrorMessage= "See error log:#cfcatch.message#">
            <cftransaction action = "rollback"/>
        </cfcatch>
    </cftry>
    <cfif len(strErrorMessage) EQ  0>
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
</cftransaction>
<cffunction name="uCaseFirst" access="private" output="false" returntype="String">
    <cfargument name="n_strText" required="false" type="String" default="" />
    <cfreturn reReplace(lCase(arguments.n_strText), "(\b\w)", "\u\1", "all") />
</cffunction>