
<cfsetting enablecfoutputonly="true"></cfsetting>
<cfparam name="url.strTransaction" default="">
<cfparam name="form.strTransaction" default="#url.strTransaction#">
<cfparam name="url.addressID" default="">
<cfparam name="form.addressID" default="#url.addressID#">
<cfoutput>
    <cfquery name="qryNewAddress">
        SELECT address.ID as addressID
            FROM candidates.address
            WHERE address.strEmail = "#url.strEmail#" ORDER BY address.dtmAdded DESC; 
    </cfquery>
</cfoutput>
<cfsetting enablecfoutputonly="false"></cfsetting>
<outputXML>
    <resultCode>Tove</resultCode>
    <resultMessage>Reminder</resultMessage>
    <strName>charley brown </strName>
    <strAddressID>3</strAddressID>
</outputXML>