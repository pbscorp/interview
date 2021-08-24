function fncGetTableValues (n_strDBTable, n_strKeyColumnName, n_strKeyColumnValue, n_lstColumns, n_strOrderByClause, n_fncCallback) {
    let m_xhttp = new XMLHttpRequest();
    m_xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            window[n_fncCallback](this.responseText);
        }
    };
    let m_strURL = "../../resources/get_table.cfm?strTable=" + n_strDBTable;
    m_strURL += "&strKeyColumnName=" + encodeURIComponent(n_strKeyColumnName);
    m_strURL += "&strKeyColumnValue=" + encodeURIComponent(n_strKeyColumnValue);
    m_strURL += "&lstColumns=" + encodeURIComponent(n_lstColumns);
    m_strURL += "&strOrderByClause=" + encodeURIComponent(n_strOrderByClause);
    m_xhttp.open("GET", m_strURL, true);
    m_xhttp.send();
}
                