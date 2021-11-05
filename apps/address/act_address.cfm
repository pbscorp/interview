<cftransaction>
    <cfset strErrorMessage =  "">
    <cftry>
        <cfif eForm.strTransaction EQ "add">
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
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strNameFirst, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strNameMiddle, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strNameLast, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strAddressLine1, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strAddressLine2, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strCity, true)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCase(eForm.strState)#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#reReplace(eForm.strZip, "[^0-9]", "", "all")#">,
                    <cfqueryparam cfsqltype="CF_sql_varchar" value="#eForm.strEmail#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=#reReplace(eForm.intPhone, "[^0-9]", "", "all")#>,
                    <cfqueryparam cfsqltype="cf_sql_integer" value=#reReplace(eForm.intMobile, "[^0-9]", "", "all")#>
                )
            </cfquery>
            <cfquery name="qryNewAddress">
                SELECT address.ID as addressID
                    FROM candidates.address
                    WHERE address.strEmail = "#eForm.strEmail#" ORDER BY address.dtmAdded DESC; 
            </cfquery>
        <cfelseif eForm.strTransaction EQ "update">
            <cfquery name="qryUpdateAddress">
                UPDATE candidates.address
                    SET
                        strNameFirst = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strNameFirst, true)#">,
                        strNameMiddle = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strNameMiddle, true)#">,
                        strNameLast = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strNameLast, true)#">,
                        strAddressLine1 = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strAddressLine1, true)#">,
                        strAddressLine2 = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strAddressLine2, true)#">,
                        strCity = <cfqueryparam cfsqltype="CF_sql_varchar" value="#uCaseFirst(eForm.strCity, true)#">,
                        strState = <cfqueryparam cfsqltype="CF_sql_varchar"value="#uCase(eForm.strState)#">,
                        strZip = <cfqueryparam cfsqltype="CF_sql_varchar"  value="#replace(eForm.strZip, "-", "", "all")#">,
                        <cfif len(eForm.intPhone)>
                            intPhone = <cfqueryparam cfsqltype="cf_sql_integer" value=#reReplace(eForm.intPhone, "[^0-9]", "", "all")#>,
                        </cfif>
                        <cfif len(eForm.intMobile)>
                            intMobile = <cfqueryparam cfsqltype="cf_sql_integer"value=#reReplace(eForm.intMobile, "[^0-9]", "", "all")#>,
                        </cfif>
                        strEmail = <cfqueryparam cfsqltype="CF_sql_varchar" value="#eForm.strEmail#">
                    WHERE ID =  <cfqueryparam cfsqltype="cf_sql_integer" value=#eForm.addressID#>;
            </cfquery>
            <cfset strSuccessMessage = "record updated">
        <cfelseif eForm.strTransaction EQ "delete">
            <cfquery name="qryDeleteAddress">
                DELETE FROM address
                WHERE ID =  <cfqueryparam cfsqltype="cf_sql_integer" value=#eForm.addressID#>;
            </cfquery>
        </cfif>
        <cfcatch>
            <cfinclude template="#application.applicationBaseURLPath#/resources/incl_cfcatchError.cfm">
            <cfset strErrorMessage= "See error log:#cfcatch.message#">
            <cftransaction action = "rollback"/>
        </cfcatch>
    </cftry>
    <cfif len(strErrorMessage) EQ  0>
        <cfif lCase(eForm.strTransaction) EQ "delete">
            <cfset eForm.strTransaction = "Add">
            <cfset strSuccessMessage = "record #eForm.addressID# deleted">    
            <cfset eForm.addressID = ''>
        <cfelseif lCase(eForm.strTransaction) EQ "add">
            <cfset strSuccessMessage = "record #eForm.addressID# added">
            <cfset eForm.strTransaction = "update">
            <cfset eForm.addressID = qryNewAddress.addressID>
        <cfelse>
            <cfset strSuccessMessage = "record #eForm.addressID# updated">
        </cfif>
    </cfif>
</cftransaction>
<cffunction name="uCaseFirst" access="private" output="false" returntype="String">
    <cfargument name="n_strText" required="false" type="String" default="" />
    <cfreturn reReplace(lCase(arguments.n_strText), "(\b\w)", "\u\1", "all") />
</cffunction>