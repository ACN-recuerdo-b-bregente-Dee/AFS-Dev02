/**
 * Class Name: RedirectAttributeExtTest
 * @author: Michael Arradaza
 * Date: 04/28/2015
 * Test Class for RedirectAttributeExt
 */

@isTest(SeeAllData=true)
/** Test Class for RedirectAttributeExt */
private class RedirectAttributeExtTest {

   /**
   * This testRedirectAttributeExt will test create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    private static testmethod void testRedirectAttributeExt(){         
    Id opportunityId = null;
    Id accountId = null;
    list<Opportunity> opp = new list<Opportunity>();
    list<Opportunity> oppError = new list<Opportunity>();
    final String accountName = 'Sample Test Account';
    Set<String> priceBookEntryNames = new Set<String> {
        'AO - CostPlus',
        'TC - Time & Materials',
        'BPO - CostPlus',
        'MC - CostPlus',
        'TC - Time & Materials',
        'MC - CostPlus'
    };
    List<PriceBookEntry> priceBookEntries = new List<PriceBookEntry>{};
    Map<String, Id> priceBookEntryMap = new Map<String, Id>{};
  
        Profile p = [select id from profile where name='System Administrator' limit 1];
        User u = new User();
        u.alias = 'userTest';
        u.email='user1@sample.com';
        u.emailencodingkey='UTF-8';
        u.lastname='Test';
        u.languagelocalekey='en_US';   
        u.localesidkey='en_US';
        u.profileid = p.Id;
        u.timezonesidkey='America/Los_Angeles';
        u.username='user1@sample.com.dev';
        database.insert(u,true);
        System.assertNotEquals(null, u.Id);
        
        for (PriceBookEntry entry :[SELECT Id, Name FROM PriceBookEntry WHERE Name IN :priceBookEntryNames AND Pricebook2.IsStandard = true]) {
            priceBookEntryMap.put(entry.Name, entry.Id);
        }
        
        RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
      
        Account testAcc  = new Account();
        testAcc.RecordTypeId = clientRecType.Id;
        testAcc.name = accountName;
        testAcc.Status__c = 'Active';
        testAcc.Type = 'Client';
        testAcc.Client_Account_Lead__c = u.id; 
        testAcc.Client_Classification__c = 'Diamond'; 
        database.insert(testAcc,true);
        accountid = testAcc.id;
        
        Person__c testPerson = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPerson,true);        

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class Zero';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.Source__c = 'Salesforce';
        testOpp.STATUS_STAGE_REQUESTED__C = '0';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.RFP_RELEASE_DATE__C = System.today() + 3;
        testOpp.CLOSEDATE = System.today() + 115; 
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STAGENAME = '0';
        testOpp.APPROVED_STATUS_STAGE__C = '0';
        testOpp.REPORTING_STATUS__C = 'Unqualified';
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240; 
        testOpp.Hierarchy_Level__c = 'Standalone';
        testOpp.Probability = 0.1;
        testOpp.PoC_Responsible__c = testPerson.Id;
        testOpp.Sales_Committed_for_First_Year__c = 123;
        database.insert(testOpp,true);
        
        Attribute__c testAtt = new Attribute__c ();
        testAtt.Opportunity_Name__c = testOpp.Id;    
        testAtt.Attribute_Type__c = 'Alliance';
        testAtt.Attribute_Value__c = 'ADOBE';
        testAtt.AttributePercent__c = 100;    
        database.insert(testAtt,true);
        
        Test.StartTest(); //This creates a new Heap block Dedicated to your test Run of actual lines in Base Class.
        PageReference pageRef = Page.RedirectAttribute;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',testOpp.id); //add this statement if Base Class contains  "ApexPages.currentPage().getParameters().put"
        RedirectAttributeExt controller = new RedirectAttributeExt(new ApexPages.StandardController(testAtt));//FOR EXTENSION CONTROLLERS ; co is the SOBJECT Record.
    
        controller.redirect();
    }
    
}