<cfscript>
    function fncLuceeMapping() {
        restInitApplication(dirPath="#application.dirPath#", 
            serviceMapping="#application.serviceMapping#", 
            password="#application.luceepassword#");
    }
 </cfscript>
