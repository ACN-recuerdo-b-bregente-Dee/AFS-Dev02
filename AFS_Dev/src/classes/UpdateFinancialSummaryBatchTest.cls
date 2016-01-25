/**
 * Class Name: UpdateFinancialSummayBatchTest
 * @author:
 * Date: 05/05/2015
 * Test Class for UpdateFinancialSummayBatch
 */
@isTest
private class UpdateFinancialSummaryBatchTest {

	private static id opportunityId;
    private static final String SOME_VALUE = 'Some Value';

    /* 
	* @Method The query used by the batch job
	*/
    public Database.QueryLocator start(Database.BatchableContext BC) {
         String query = 'SELECT Id from OpportunityLineItem where Opportunity.Source__c = \'STaR\' and (Opportunity.StageName != \'Won\'' 
                       + 'and Opportunity.StageName != \'Withdrew\'and Opportunity.StageName != \'Lost\')';
         System.assertNotEquals(null, query); 
         return Database.getQueryLocator(query);
    }
    
    /*
    * - Get profile to assign to testUser
    */
    static testmethod void test() {
    // Create some test Opportunities items to be updated by the batch job
     
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
	    
	    //Database.insert(u, false);
	    
	    Database.insert(u, false);
	    System.assertNotEquals(null, u); 
  
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
	
	  Database.insert(testAcc, false);

    /*
    * - Insert Test Opportunity
    */
    Opportunity testOpp = new Opportunity();
    testOpp.Name = 'Opportunity Test Class';
    testOpp.AccountId = testAcc.id;
    testOpp.STATUS_STAGE_REQUESTED__C = '';
    testOpp.Draft_RFP_Release_Date__c = System.today() + 80;
    testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
    testOpp.Proposal_Submission_Date__c = System.today() + 95;
    testOpp.Actual_Contract_Sign_Date__c = System.today() + 110;
    testOpp.CLOSEDATE = System.today() + 115; 
    testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
    testOpp.TYPE = 'Competitive';
    testOpp.StageName = '0';
    testOpp.APPROVED_STATUS_STAGE__C = '0';
    testOpp.REPORTING_STATUS__C = 'Qualified';
    testOpp.Consulting_Start__c  = System.today() + 120; 
    testOpp.Consulting_End__c = System.today() + 210;   
    testOpp.Outsourcing_Start__c = System.today() + 150; 
    testOpp.Outsourcing_End__c  = System.today() + 240; 
    testOpp.ATS_Notes__c = 'Write text here';
    testOpp.Source__c = 'STaR';
    testOpp.Best_Probable_Worst__c = 'Probable Win';
    testOpp.Complexity_Category__c = 'ATSLP: SW license chg/SW assets provided';
    testOpp.Draft_RFP_Release_Date__c = System.today();
    testOpp.RFP_Release_Date__c = System.today() + 1;
    testOpp.Estimator_Confirm_Compliance__c = 'Yes';
    testOpp.Client_Data_Protection_Risk_Assessment__c = SOME_VALUE;
    testOpp.Client_Industry_Area_of_Service__c = SOME_VALUE;
    testOpp.Hierarchy_Level__c = SOME_VALUE;
    
    //Database.insert(testOpp, false);
    
    Database.insert(testOpp, false);
    
    testOpp.Source__c = 'STaR';
    Database.update(testOpp, false);     
    
    opportunityId = testOpp.Id;    
    
    /*
    * - Test Opportunity Line Item
    */
    
    OpportunityLineItem testOppLI = new OpportunityLineItem();
    testOppLI.OpportunityId = opportunityId;
    testOppLI.PriceBookEntryId = '01uq0000000WvKyAAK';
    testOppLI.Revenue__c = 1000000;
    testOppLI.Total_Costs__c = 100;
    testOppLI.Type__c ='AO';
    
    //Database.insert(testOppLI, false);
    
    Database.insert(testOppLI, false);
   
    list <Opportunity> opp1 = [SELECT Id FROM Opportunity Limit 50000];
    list <OpportunityLineItem> opp2 = [SELECT Id FROM OpportunityLineItem Limit 50000];
    system.debug('Opp1 check' + opp1);
    system.debug('Opp2 check' + opp2);
     
    List<OpportunityLineItem> oppLIQuery = [SELECT Id,Opportunity.Source__c from OpportunityLineItem where Opportunity.StageName != 'Won' and Opportunity.StageName != 'Withdrew' and Opportunity.StageName != 'Lost' Limit 50000];
    //Database.Query(query);
    system.debug('query check' + oppLIQuery);
        
    system.test.startTest();
    UpdateFinancialSummayBatch batch = new UpdateFinancialSummayBatch();
    database.executeBatch(batch); 
    system.test.stopTest();
    }
}