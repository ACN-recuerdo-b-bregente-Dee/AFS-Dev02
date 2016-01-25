/**
 * Class Name: RevenueBLTest
 * @author: Honelee Padilla
 * Date: 03/10/2015
 * Test Class for RevenueBL
 */
@isTest(SeeAllData=true)
    /*
    * - Testclass for RevenueBLTest
    */
private class RevenueBLTest{
    
   private static id opportunityId;
   private static final String SOME_VALUE = 'Some Value';
   private static Map<String, Id> priceBookEntryMap = new Map<String, Id>{};
   
   /*
    * - Test method that creates the needed data
    */
   static testmethod void prepdata() {
 
       /*
        * - Get profile to assign to testUser
        */
    Set<String> priceBookEntryNames = new Set<String> {
        'AO - CostPlus',
        'TC - Time & Materials',
        'BPO - CostPlus',
        'IO - CostPlus'
    };
    
    for (PriceBookEntry entry :[SELECT Id, Name FROM PriceBookEntry WHERE Name IN :priceBookEntryNames AND Pricebook2.IsStandard = true]) {
            priceBookEntryMap.put(entry.Name, entry.Id);
        }
  Profile testProfile = [select id from profile where name='System Administrator' limit 1];
  
    User u = new User();
    u.alias = 'userTest';
    u.email='user1@sample.com';
    u.emailencodingkey='UTF-8';
    u.lastname='Test';
    u.languagelocalekey='en_US';   
    u.localesidkey='en_US';
    u.profileid = testProfile.Id;
    u.timezonesidkey='America/Los_Angeles';
    u.username='user1@sample.com.dev';
    
    Database.insert(u, true);
    
    //insert u;
  
     /*
    * - Test Account
    */
  RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
  
  Account testAcc  = new Account();
  testAcc.RecordTypeId = clientRecType.Id;
  testAcc.name = 'Sample Test Account';
  testAcc.Status__c = 'Active';
  testAcc.Type = 'Client';
  testAcc.Client_Account_Lead__c = u.id; 
  testAcc.Client_Classification__c = 'Diamond'; 
  
  Database.insert(testAcc, true);
  
  //insert testAcc;

    /*
    * - Test Opportunity
    */
    Opportunity testOpp = new Opportunity();
    testOpp.Name = 'Opportunity Test Class';
    testOpp.AccountId = testAcc.id;
    testOpp.STATUS_STAGE_REQUESTED__C = '0';
    testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
    testOpp.CLOSEDATE = System.today() + 115; 
    testOpp.Actual_Contract_Sign_Date__c = System.today() + 120;
    testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
    testOpp.TYPE = 'Competitive';
    testOpp.STAGENAME = '0';
    testOpp.APPROVED_STATUS_STAGE__C = '0';
    testOpp.REPORTING_STATUS__C = 'Qualified';
    testOpp.Consulting_Start__c  = System.today() + 120; 
    testOpp.Consulting_End__c = System.today() + 210;   
    testOpp.Outsourcing_Start__c = System.today() + 150; 
    testOpp.Outsourcing_End__c  = System.today() + 240; 
    testOpp.ATS_Notes__c = 'Write text here';
    testOpp.Best_Probable_Worst__c = 'Probable Win';
    testOpp.Source__c = 'StaR';
    testOpp.Complexity_Category__c = 'ATSLP: SW license chg/SW assets provided';
    testOpp.Draft_RFP_Release_Date__c = System.today();
    testOpp.RFP_Release_Date__c = System.today() + 1;
    testOpp.Estimator_Confirm_Compliance__c = 'Yes';
    testOpp.Client_Data_Protection_Risk_Assessment__c = SOME_VALUE;
    testOpp.Client_Industry_Area_of_Service__c = SOME_VALUE;
    testOpp.Hierarchy_Level__c = SOME_VALUE;
    
    Database.insert(testOpp, true);
    
    //insert testOpp;
    
    opportunityId = testOpp.Id;
    
    /*
    * - Test Opportunity Line Item
    */
    
    OpportunityLineItem testOppLI = new OpportunityLineItem();
    testOppLI.OpportunityId = opportunityId;
    testOppLI.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus');//'01uq0000000WvKyAAK';
    testOppLI.Revenue__c = 1000000;
    testOppLI.Total_Costs__c = 100;
    testOppLI.Type__c ='01 - AO';
    
    Database.insert(testOppLI, true);
    
    System.assertNotEquals(null, testOppLi.Id);
    
    }
    
     /*
      * - Method to test testRevenueBL and used the data in prepdata method
      */   
    static testmethod void testRevenueBL() {
    
        prepdata();
        RevenueBL.isRevenueScheduled = false;
        Test.startTest();
        
        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = opportunityId;
        testOppLI2.PriceBookEntryId = priceBookEntryMap.get('TC - Time & Materials');
        testOppLI2.Revenue__c = 5000000;
        testOppLI2.Total_Costs__c = 500;
        testOppLI2.Type__c ='06 - TC';
        testOppLi2.Type_of_Work__c = 'Consulting';
        
        OpportunityLineItem testOppLI3 = new OpportunityLineItem();
        testOppLI3.OpportunityId = opportunityId;
        testOppLI3.PriceBookEntryId = priceBookEntryMap.get('BPO - CostPlus');//'01uU0000001fHJ9IAM';
        testOppLI3.Revenue__c = 4000000;
        testOppLI3.Total_Costs__c = 400;
        testOppLI3.Type__c ='02 - BPO';
        testOppLI3.Type_of_Work__c = 'Outsourcing';
        
        OpportunityLineItem testOppLI4 = new OpportunityLineItem();
        testOppLI4.OpportunityId = opportunityId;
        testOppLI4.PriceBookEntryId = priceBookEntryMap.get('IO - CostPlus');//'01uq0000000WvL3AAK';
        testOppLI4.Revenue__c = 3000000;
        testOppLI4.Total_Costs__c = 300;
        testOppLI4.Type__c ='03 - IO';
		testOppLI4.Type_of_Work__c = 'Outsourcing';
        
        Database.insert(new OpportunityLineItem[]{testOppLI2, testOppLI3, testOppLI4}, true);
        System.assertNotEquals(null, testOppLI4.Id);
        
        System.debug('?????????????<<< id of opp line item 2 ' + testOppLI2.id);
        System.debug('?????????????<<< id of opp line item 3' + testOppLI3.id);
        System.debug('?????????????<<< id of opp line item 4' + testOppLI4.id);
        System.debug('?????????????<<< outsourcing/consulting value ' + testOppLI2.Type_of_Work__c);
        System.debug('?????????????<<< outsourcing/consulting value ' + testOppLI3.Type_of_Work__c);
        System.debug('?????????????<<< outsourcing/consulting value ' + testOppLI4.Type_of_Work__c);
        
        
        Test.stopTest();
    
    }  
}