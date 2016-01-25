/**
 * Class Name: OpportunityTeamRoleBLTest
 * @author: Lhea Valencia
 * Date: 02/19/2015
 * Test Class for OpportunityTeamRoleBL
 */
@isTest(SeeAllData=true)
private class OpportunityTeamRoleBLTest{
    
    private static id opportunityId;
    private static id personId;
    private static id personId2;
    private static Opportunity_Team_Roles__c oppTR;
    
    /** Preparation Data for test */ 
    static testmethod void prepdata() {
        // Create Test User
        Profile p = [select id from profile where name='System Administrator' limit 1];
        User u = new User(
        alias = 'user1A',
        email='user1@sample.com',
        emailencodingkey='UTF-8',
        lastname='DOe',
        languagelocalekey='en_US',
        localesidkey='en_US',
        profileid = p.Id,
        timezonesidkey='America/Los_Angeles',
        username='user1@sample.com.dev'
        );
        database.insert(u,false);
        system.assertEquals(u,u);
    
        // Create Test Account
        RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
        Account testAcc  = new Account();
        testAcc.RecordTypeId = ClientRecType.Id;
        testAcc.name = 'Sample Test Account Acc';
        testAcc.Status__c = 'Active';
        testAcc.Type = 'Client';
        testAcc.Client_Account_Lead__c = u.id; 
        testAcc.Client_Classification__c = 'Diamond'; 
        database.insert(testAcc,false);
  
        /*
        * - Test Opportunity
        */
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Sample Test Account Acc Opp 1';
        testOpp.AccountId = testAcc.Id;
        testOpp.StageName = '0';
        testOpp.Reporting_Status__c = 'Unqualified';
        testOpp.Type = 'Competitive';
        testOpp.CloseDate = System.today() + 30;
        testOpp.Approved_Status_Stage__c = '0';
        testOpp.Probability = 10;
        testOpp.STATUS_STAGE_REQUESTED__C = '0';
        database.insert(testOpp,false);
        //insert testOpp;
        opportunityId = testOpp.Id;
        
        /*
        * - Test Person
        */
        
        Person__c testPerson = new Person__c();
        testPerson.Name = 'Dana Smith';
        testPerson.Email__c = 'user1@sample.com';
        testPerson.User_Type__c = 'AFS';
        database.insert(testPerson,false);
        
        personId = testPerson.Id;
        
        /*
        * - Test Person2
        */
        
        Person__c testPerson2 = new Person__c();
        testPerson2.Name = 'Dana Smith2';
        testPerson2.Email__c = 'user1@sample.com';
        testPerson2.User_Type__c = 'AFS';
        database.insert(testPerson2,false);
        
        personId2 = testPerson2.Id;
        
        /*
        * - Test Opportunity Team Role
        */
        
        Opportunity_Team_Roles__c testOTRole = new Opportunity_Team_Roles__c();
        testOTRole.Opportunity_Name__c = testOpp.Id;
        testOTRole.Name__c = testPerson.Id;
        testOTRole.Role__c = 'Capture Lead';
        testOTRole.Opportunity_Access__c = 'Read Only';
        testOTRole.Sales_Credit__c = 37;
        testOTRole.Service_Group__c = 'AO';
        database.insert(testOTRole,false);
        
        /*
        * - Test Opportunity Team Role 2
        */
        
        Opportunity_Team_Roles__c testOTRole4 = new Opportunity_Team_Roles__c();
        testOTRole4.Opportunity_Name__c = testOpp.Id;
        testOTRole4.Name__c = testPerson.Id;
        testOTRole4.Role__c = 'Capture Lead';
        testOTRole4.Opportunity_Access__c = 'Read/Write';
        testOTRole4.Sales_Credit__c = 3;
        testOTRole4.Service_Group__c = 'AO';
        database.insert(testOTRole4,false);        
        
        Opportunity_Team_Roles__c testOTRole5 = new Opportunity_Team_Roles__c();
        testOTRole5.Opportunity_Name__c = testOpp.Id;
        testOTRole5.Name__c = testPerson.Id;
        testOTRole5.Role__c = 'Delivery Lead';
        testOTRole5.Opportunity_Access__c = 'Read Only';
        testOTRole5.Sales_Credit__c = 3;
        testOTRole5.Service_Group__c = 'AO';
        database.insert(testOTRole5,false);
        //insert testOTRole5;
        oppTR = testOTRole5;
    }
    /**Validates Sales Credit */ 
    static testmethod void testValidateSalesCredit() {
  
        prepdata();
        system.test.startTest();
  
        Opportunity_Team_Roles__c testOTRole4 = new Opportunity_Team_Roles__c();
        testOTRole4.Opportunity_Name__c = opportunityId;
        testOTRole4.Name__c = personId;
        testOTRole4.Role__c = 'Capture Lead';
        testOTRole4.Opportunity_Access__c = 'Read Only';
        testOTRole4.Sales_Credit__c = 45;
        testOTRole4.Service_Group__c = 'AO';    
        database.insert(testOTRole4,false);     
        
        try{
  
        Opportunity_Team_Roles__c testOTRole3 = new Opportunity_Team_Roles__c();
        testOTRole3.Opportunity_Name__c = opportunityId;
        testOTRole3.Name__c = personId;
        testOTRole3.Role__c = 'Capture Lead';
        testOTRole3.Opportunity_Access__c = 'Read Only';
        testOTRole3.Sales_Credit__c = 45;
            testOTRole3.Service_Group__c = 'AO';    
        database.insert(testOTRole3,false);  
        
        } catch (DMLException e) {
        //Assert Error Message
            System.assert( e.getMessage().contains('limit exceeded on user'), 
                e.getMessage() );             
        }
  
        try {
        Opportunity_Team_Roles__c testOTRole2 = new Opportunity_Team_Roles__c();
        testOTRole2.Opportunity_Name__c = opportunityId;
        testOTRole2.Name__c = personId2;
        testOTRole2.Role__c = 'Capture Lead';
        testOTRole2.Opportunity_Access__c = 'Read Only';
        testOTRole2.Sales_Credit__c = 73;
            testOTRole2.Service_Group__c = 'AO';
        database.insert(testOTRole2,false);  
        
        } catch (DMLException e) {
        //Assert Error Message
            System.assert( e.getMessage().contains('limit exceeded on role'), 
                e.getMessage() );   
        }
        
        //this is to satisfy the update, delete and undelete in OpportunityTeamRoleHandler
        oppTR.Sales_Credit__c = 1;
        database.update(oppTR,false);
        database.delete(oppTR,false);
        database.undelete(oppTR,false);
        system.test.stopTest();
  
    }
  
  
  
  
}