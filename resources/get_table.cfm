<cfsetting enablecfoutputonly="true"/>
<cfparam name="url.strTable" default="">
<cfparam name="url.lstColumns" default="*">
<cfparam name="url.strKeyColumnName" default="">
<cfparam name="url.strKeyColumnValue" default="">
<cfparam name="url.strOrderByClause" default="ORDER BY ID DESC">
<cfset local.lstColumns =  replace(url.lstColumns, "|", ",", "All")>
<cfoutput>
    <cfquery name="qryGetTable">
        SELECT #local.lstColumns#
            FROM candidates.#url.strTable#
            <cfif len(url.strKeyColumnName)>
                WHERE #url.strTable#.#url.strKeyColumnName# = "#urlDecode(url.strKeyColumnValue)#" 
            </cfif>
            #url.strOrderByClause#;
    </cfquery>
</cfoutput>
<cfscript>
    strQryColumnList = qryGetTable.columnlist();
    intColumnCount = 0;
    m_XHTTPRtnColumns = "[";
    cfloop (query="qryGetTable") {
        m_XHTTPRtnColumns &= "{";
        for (i = 1; i <= listLen(strQryColumnList); i=i+1) {
            intColumnCount = intColumnCount + 1;
            m_strColumnName = listGetAt(strQryColumnList, i);
            m_strColumnValue = qryGetTable[m_strColumnName];
            m_XHTTPRtnColumns &= '"' & m_strColumnName & '":"';
            m_XHTTPRtnColumns &= m_strColumnValue & '"';
            if (i < listLen(strQryColumnList)) {
                m_XHTTPRtnColumns &= ',';
            }
        }
        if (qryGetTable.currentRow < qryGetTable.recordCount) {
            m_XHTTPRtnColumns &= '},';
        }
    }
    m_XHTTPRtnColumns &= "}]";
    if (intColumnCount = 0) {
        r_result = "no data";
    } else {
        r_result = m_XHTTPRtnColumns;
    }
</cfscript>
<cfsetting enablecfoutputonly="false"/>
<cfoutput>#r_result#</cfoutput>