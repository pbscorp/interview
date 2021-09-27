component {
  this.datasource="candidates";
	this.Name = "interview";
  function onApplicationStart() {
      m_jsonAppConfig = fileRead('resources/appconfig.json');
      m_stcAppConfig = deserializeJson(m_jsonAppConfig);
      application.applicationBaseURLPath = m_stcAppConfig.applicationBaseURLPath;
      application.applicationRestMapping = m_stcAppConfig.applicationRestMapping;
      application.dirPath =  m_stcAppConfig.dirPath;
      application.serviceMapping = m_stcAppConfig.serviceMapping;
      application.luceepassword = m_stcAppConfig.luceepassword;
      system=createObject("java", "java.lang.System");
      m_strJavaHome = system.getproperty("java.home");
      writeoutput(system.getproperty("java.home"));
      writeoutput(CompareNoCase(m_strJavaHome,"lucee"));

      if (CompareNoCase(m_strJavaHome,"lucee")) {
          restInitApplication(dirPath="#application.dirPath#", 
              serviceMapping="#application.serviceMapping#", 
              password="#application.luceepassword#");
      } else {
        restInitApplication( dirPath="C:\lucee\tomcat\webapps\ROOT\samplecode\interview\rest\");
      }
    }
}