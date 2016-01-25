public class ctrl_codeCoverage {
    
    /**
     * CloudAlley CodeCoverage+
     *
     * Show all classes code coverage on a single page.
     *
     * Version: 1.2
     * Date: 3/6/2014
     */
 
    public List<apexWrapper> apexPages2 {get;set;}
    private String sessionId;
    public Decimal uncoveredLines {get; set;}
    public Decimal coveredLines {get; set;}
    public Decimal totalLines {get; set;}
    public Decimal codeCoverage {get; set;}
    public String codeCoverageMsg {get; set;}
    public String codeCoverageStatus {get; set;}
    public String codeCoverageColor {get; set;}
    public DateTime dateNow {get; set;}
    public Date dateToday {get; set;}
    public String timeNow {get; set;}
    public String firstName {get; set;}
    public ctrl_codeCoverage(){
        this.sessionId = UserInfo.getSessionId();
        apexPages2 = codeCoverage();
        dateNow = DateTime.now();
        dateToday = Date.today();
        timeNow = DateTime.now().Format();
        firstName = UserInfo.getFirstName();
    }
    public class ApexClassTriggerWrapper{
        public string Name {get; set;}
        public Id Id {get; set;}
        public Decimal ApiVersion {get; set;}
        public Integer LengthWithoutComments {get; set;}
    }
    public List<apexWrapper> codeCoverage(){
        //Map<Id, ApexClass> apexClassMap = new Map<Id, ApexClass>( [SELECT Id, Name, ApiVersion, LengthWithoutComments FROM ApexClass /* WHERE NamespacePrefix = NULL AND Status = 'Active' */ ORDER BY LastModifiedDate DESC]);
        Map<Id, ApexClassTriggerWrapper> apexClassMap = new Map<Id, ApexClassTriggerWrapper>();
        for(ApexTrigger at: [Select Id, Name, ApiVersion, LengthWithoutComments FROM ApexTrigger]){
            ApexClassTriggerWrapper actw = new ApexClassTriggerWrapper();
            actw.Name = at.Name;
            actw.id = at.id;
            actw.ApiVersion = at.ApiVersion;
            actw.lengthWithoutComments = at.lengthWithoutComments;
            apexClassMap.put(at.Id, actw);
        }
        Set<String> excludedClasses = new Set<String>();
        excludedClasses.add('ctrl_codeCoverage');
        excludedClasses.add('J2A_ApexCodeCoverageAggregate');
        for(ApexClass ac: [Select Id, Name, ApiVersion, LengthWithoutComments FROM ApexClass WHERE Name NOT IN :excludedClasses]){
            ApexClassTriggerWrapper actw = new ApexClassTriggerWrapper();
            actw.Name = ac.Name;
            actw.id = ac.id;
            actw.ApiVersion = ac.ApiVersion;
            actw.lengthWithoutComments = ac.lengthWithoutComments;
            apexClassMap.put(ac.Id, actw);
        }
        String soql = 'SELECT Id, ApexClassorTriggerId,  NumLinesCovered, NumLinesUncovered FROM ApexCodeCoverageAggregate';/* WHERE ';
 
        for(ApexClass ap : apexClassMap.values()){
            if(ap.LengthWithoutComments >= 1 ){
                soql += 'ApexClassOrTriggerId=\'' + ap.Id + '\' OR ';
            }
        }
 
        soql = soql.substring(0, soql.length() - 3);*/
 
        System.debug('SOQL Query: ' + soql);
 
        Http h = new Http();
        HttpRequest queryReq = new HttpRequest();
        queryReq.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v29.0/tooling/query/?q=' + EncodingUtil.urlEncode(soql, 'UTF-8'));
        queryReq.setHeader('Authorization', 'OAuth ' + sessionId);
        queryReq.setHeader('Content-Type', 'application/json');
        queryReq.setTimeout(110000);
        queryReq.setMethod('GET');
         
        String response;
        if(!Test.isRunningTest()){
            HttpResponse queryRes = h.send(queryReq);
            response = queryRes.getBody();
        } else {
            response = '{\"size\":17,\"totalSize\":17,\"done\":true,\"queryLocator\":null,\"records\":[{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA1IAO\"},\"Id\":\"715L0000000ANA1IAO\",\"ApexClassOrTriggerId\":\"01pa0000001pXO2AAM\",\"NumLinesCovered\":7,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA2IAO\"},\"Id\":\"715L0000000ANA2IAO\",\"ApexClassOrTriggerId\":\"01pa0000001pXO1AAM\",\"NumLinesCovered\":9,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA3IAO\"},\"Id\":\"715L0000000ANA3IAO\",\"ApexClassOrTriggerId\":\"01pL00000005aILIAY\",\"NumLinesCovered\":22,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA4IAO\"},\"Id\":\"715L0000000ANA4IAO\",\"ApexClassOrTriggerId\":\"01pL00000005ZCqIAM\",\"NumLinesCovered\":15,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA5IAO\"},\"Id\":\"715L0000000ANA5IAO\",\"ApexClassOrTriggerId\":\"01p30000000YjJDAA0\",\"NumLinesCovered\":87,\"NumLinesUncovered\":6},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA6IAO\"},\"Id\":\"715L0000000ANA6IAO\",\"ApexClassOrTriggerId\":\"01p30000000YWsEAAW\",\"NumLinesCovered\":101,\"NumLinesUncovered\":13},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA7IAO\"},\"Id\":\"715L0000000ANA7IAO\",\"ApexClassOrTriggerId\":\"01p30000000aoWAAAY\",\"NumLinesCovered\":174,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA8IAO\"},\"Id\":\"715L0000000ANA8IAO\",\"ApexClassOrTriggerId\":\"01p30000000ZurzAAC\",\"NumLinesCovered\":169,\"NumLinesUncovered\":11},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANA9IAO\"},\"Id\":\"715L0000000ANA9IAO\",\"ApexClassOrTriggerId\":\"01pL00000005ZDAIA2\",\"NumLinesCovered\":67,\"NumLinesUncovered\":74},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAAIA4\"},\"Id\":\"715L0000000ANAAIA4\",\"ApexClassOrTriggerId\":\"01pL00000005YKAIA2\",\"NumLinesCovered\":191,\"NumLinesUncovered\":16},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANABIA4\"},\"Id\":\"715L0000000ANABIA4\",\"ApexClassOrTriggerId\":\"01pL00000005YJlIAM\",\"NumLinesCovered\":86,\"NumLinesUncovered\":3},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANACIA4\"},\"Id\":\"715L0000000ANACIA4\",\"ApexClassOrTriggerId\":\"01pL00000005aGoIAI\",\"NumLinesCovered\":51,\"NumLinesUncovered\":0},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANADIA4\"},\"Id\":\"715L0000000ANADIA4\",\"ApexClassOrTriggerId\":\"01pL00000005YLwIAM\",\"NumLinesCovered\":147,\"NumLinesUncovered\":10},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAEIA4\"},\"Id\":\"715L0000000ANAEIA4\",\"ApexClassOrTriggerId\":\"01pa0000001pKuPAAU\",\"NumLinesCovered\":98,\"NumLinesUncovered\":1},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAFIA4\"},\"Id\":\"715L0000000ANAFIA4\",\"ApexClassOrTriggerId\":\"01p30000000ZGdkAAG\",\"NumLinesCovered\":36,\"NumLinesUncovered\":2},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAGIA4\"},\"Id\":\"715L0000000ANAGIA4\",\"ApexClassOrTriggerId\":\"01pL00000005ZClIAM\",\"NumLinesCovered\":31,\"NumLinesUncovered\":27},{\"attributes\":{\"type\":\"ApexCodeCoverageAggregate\",\"url\":\"/services/data/v29.0/tooling/sobjects/ApexCodeCoverageAggregate/715L0000000ANAHIA4\"},\"Id\":\"715L0000000ANAHIA4\",\"ApexClassOrTriggerId\":\"01pa0000001pXO3AAM\",\"NumLinesCovered\":44,\"NumLinesUncovered\":2}],\"entityTypeName\":\"ApexCodeCoverageAggregate\"}';
        }
        
        J2A_ApexCodeCoverageAggregate acc = J2A_ApexCodeCoverageAggregate.parse(response);
 
        system.debug('RESPONSE: ' + response);
        system.debug('Wrapper: ' + acc);
        List<apexWrapper> apexPages2 = new List<apexWrapper>();
        uncoveredLines = 0;
        coveredLines = 0;
        totalLines =0;
        for(J2A_ApexCodeCoverageAggregate.Records r : acc.records){
            decimal covered     = r.NumLinesCovered;
            decimal uncovered   = r.NumLinesUncovered;
            //System.assertNotEquals(null, covered);
            if (uncovered == null) uncovered = 0;
            decimal percent;
            if (covered != null) {
                if ((covered + uncovered) > 0) percent     = (covered / (covered + uncovered) * 100);
                else percent = 0;
            }
            else percent = 0;
            if (apexClassMap.containsKey(r.ApexClassorTriggerId)) {
                if(r.NumLinesUncovered != null){
                    uncoveredLines += r.NumLinesUncovered;
                }
                if(r.NumLinesCovered != null){
                coveredLines += r.NumLinesCovered;
                }
                apexPages2.add(new apexWrapper(apexClassMap.get(r.ApexClassorTriggerId).Name, r.ApexClassorTriggerId, apexClassMap.get(r.ApexClassorTriggerId).ApiVersion, apexClassMap.get(r.ApexClassorTriggerId).LengthWithoutComments, r.NumLinesUncovered, r.NumLinesCovered, percent.SetScale(2)));
            }
        }
        totalLines = coveredLines + uncoveredLines;
        codeCoverage = (coveredLines.divide(totalLines, 4)*100).setScale(2);
        
        codeCoverageMsg = 'Current Overall Code Coverage: '+coveredLines+' / '+totalLines+' ('+codeCoverage+'%)';
        if(codeCoverage >= 80){
            codeCoverageStatus = 'Good';
            codeCoverageColor = 'Green';

        } else if(codeCoverage >= 75&& codeCoverage<80){
            codeCoverageStatus = 'Warning';
            codeCoverageColor = 'Orange';
        } else{
            codeCoverageStatus = 'Critical';
            codeCoverageColor = 'Red';
        }
        
        //System.assertEquals(null, acc.records.size());
 
        // Sort using the custom compareTo() method
        apexPages2.sort();
 
        return apexPages2;
    }
 
    public class apexWrapper implements Comparable {
        public string apexName {get;set;}
        public string Id {get;set;}
        public decimal ApiVersion {get;set;}
        public integer LengthWithoutComments {get;set;}
        public decimal linesUncovered {get;set;}
        public decimal linesCovered {get;set;}
        public decimal percentCovered {get;set;}
 
        // Code Coverage Wrapper
        public apexWrapper(string apexNameIn, string idIn, decimal ApiVersionIn, integer LengthWithoutCommentsIn, decimal linesUncoveredIn, decimal linesCoveredIn, decimal percentCoveredIn) {
            apexName                = apexNameIn;
            id                      = idIn;
            ApiVersion              = ApiVersionIn;
            LengthWithoutComments   = LengthWithoutCommentsIn;
            linesUncovered          = linesUncoveredIn;
            linesCovered            = linesCoveredIn;
            percentCovered          = percentCoveredIn;
        }
 
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            apexWrapper compareToClass = (apexWrapper)compareTo;
            if (percentCovered == compareToClass.percentCovered){
                if(LengthWithoutComments == compareToClass.LengthWithoutComments){
                    return 0;
                }else if(LengthWithoutComments < compareToClass.LengthWithoutComments){
                    return 1;
                }
            }
            if (percentCovered < compareToClass.percentCovered) return 1;
            return -1;
        }
    }
    public PageReference exportToExcel(){
        PageReference pRef = Page.vf_codeCoverage_Excel;
        pRef.setRedirect(false);
        return pRef;
    }
    
    public PageReference sendEmail() {
        PageReference excel = Page.vf_codeCoverage_Excel;
        PageReference emailBody = Page.vf_codeCoverage_Email;
        // add parent id to the parameters for standardcontroller
        // the contents of the attachment from the pdf
        Blob body;
        Blob emBody;
        try {
    
          // returns the output of the page as a PDF
          body = excel.getContent();
          emBody = emailBody.getContent();
    
        // need to pass unit test -- current bug  
        } catch (VisualforceException e) {
          body = Blob.valueOf('Some Text');
        }
        Id userId = UserInfo.getUserId();
        String emailRecipient = [Select Email From User Where Id =: userId Limit 1].Email;
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/vnd.ms-excel');
        attach.setFileName('Test Execution Code Coverage Report_'+timeNow+'.xls');
        attach.setInline(false);
        attach.Body = body;
        List<String> toStr = new List<string>();
        toStr.add(emailRecipient);
        //toStr.add('eden.g.capuyan@accenture.com');
        //toStr.add('marvin.t.bonifacio@accenture.com');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(false);
        mail.setToAddresses(toStr);
        mail.setSubject('[SPH] Test Execution Coverage Report '+timeNow);
        mail.setHtmlBody(emBody.toString());
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
    
        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Email has been successfully sent.');
        ApexPages.addMessage(myMsg);
        return null;
    }
}