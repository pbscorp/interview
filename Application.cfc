component {
  this.datasource="candidates"
	this.Name = "interview";
  function onApplicationStart() {
      application.applicationBaseURLPath = "/samplecode/interview";
      application.applicationRestMapping = "http://localhost:8888/rest/interview/";
      restInitApplication( 
              dirPath="C:\lucee\tomcat\webapps\ROOT\samplecode\interview\rest\", 
              serviceMapping="interview", 
              password="Lpatrick##1"
      );
    }
}