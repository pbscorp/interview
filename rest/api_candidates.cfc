<cfcomponent restpath="/api_candidates" rest="true" httpMethod="GET">   
    <cffunction name="get_address" 
                httpmethod="GET"
                access="remote"
                restpath="{strTable}"
                returntype="string"
                produces="application/json">
        <cfargument name="strTable" default="" restArgSource="query"/>
        <cfargument Name="strKeyColumnName" default="" restArgSource="query"/>
        <cfargument Name="strKeyColumnValue" default="" restArgSource="query"/>
        <cfargument Name="lstColumns" default="*" restArgSource="query"/>
        <cfargument Name="strOrderByClause" default="ORDER BY ID DESC" restArgSource="query"/>
        <cfset local.lstColumns =  replace(arguments.lstColumns, "|", ",", "All")>
        <cftry>
            <cfoutput>
                <cfquery name="qryGetTable" datasource="candidates">
                    SELECT #local.lstColumns#
                        FROM candidates.#arguments.strTable#
                        <cfif len(arguments.strKeyColumnName)>
                            WHERE #arguments.strTable#.#arguments.strKeyColumnName# = "#urlDecode(arguments.strKeyColumnValue)#" 
                        </cfif>
                        #arguments.strOrderByClause#;
                </cfquery>
            </cfoutput>
            <cfscript>
                strQryColumnList = qryGetTable.columnlist();
                intColumnCount = 0;
                m_aryRtnColumns = "[";
                for ( j=1; j<=qryGetTable.recordCount; j++ ) {
                    m_aryRtnColumns &= "{";
                    for (i = 1; i <= listLen(strQryColumnList); i=i+1) {
                        intColumnCount = intColumnCount + 1;
                        m_strColumnName = listGetAt(strQryColumnList, i);
                        m_strColumnValue = qryGetTable[m_strColumnName][j];
                        m_aryRtnColumns &= '"' & m_strColumnName & '":"';
                        m_aryRtnColumns &= m_strColumnValue & '"';
                        if (i < listLen(strQryColumnList)) {
                            m_aryRtnColumns &= ',';
                        };
                    };
                    if (qryGetTable.currentRow < qryGetTable.recordCount) {
                        m_aryRtnColumns &= '},';
                    };
                    m_aryRtnColumns &= "}";
                };
                m_aryRtnColumns &= "]";
                if (intColumnCount == 0) {
                    r_result = "no data";
                } else {
                    r_result = m_aryRtnColumns;
                }
            </cfscript>
            <cfcatch>
                <cfinclude template="#application.applicationBaseURLPath#/resources/incl_cfcatchError.cfm">
            </cfcatch>
        </cftry> 
        <cfreturn r_result/>
    </cffunction>
</cfcomponent>