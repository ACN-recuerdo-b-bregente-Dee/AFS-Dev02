/**
 * Class Name: ViewSummaryOnclickTest
 * @author: Lhea Valencia
 * Date: 04/22/2015
 * Test Class for Summary_View_Onclick
 */

@isTest(SeeAllData=true) 
/*
 * @Class This class Summary_View_OnclickTest is used to test this class
 */
private class ViewSummaryOnclickTest{
/*    
    private static Id opportunityId; 
    private static final ID MAIN = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Main Record Type').getRecordTypeId();
    
     
    static void prepdata() {
        
       
        
        Profile p = [select id from profile where name='System Administrator' limit 1];
        
        User u = new User();
        u.alias = 'user1A';
        u.email='user1@sample.com';
        u.emailencodingkey='UTF-8';
        u.lastname='DOe';
        u.languagelocalekey='en_US';   
        u.localesidkey='en_US';
        u.profileid = p.Id;
        u.timezonesidkey='America/Los_Angeles';
        u.username='user1@sample.com.dev';
        
        //insert u;
        Database.insert(u, True);
        
        User usr2 = new User();
        usr2.alias = 'user2Abc';
        usr2.email='user1@sample.com';
        usr2.emailencodingkey='UTF-8';
        usr2.lastname='DOeh';
        usr2.languagelocalekey='en_US';   
        usr2.localesidkey='en_US';
        usr2.profileid = p.Id;
        usr2.timezonesidkey='America/Los_Angeles';
        usr2.username='user2@sample.com.dev';
        
        //insert usr2;
        Database.insert(usr2, false);
       
        RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
        
        Account testAcc = new Account();
        testAcc.RecordTypeId = ClientRecType.Id;
        testAcc.name = 'Sample Test Account Acc';
        testAcc.Status__c = 'Active';
        testAcc.Type = 'Client';
        testAcc.Client_Account_Lead__c = u.id; 
        testAcc.Client_QA_Director__c = usr2.id;
        testAcc.P_Global_Client_Account_Lead__c = u.id;
        testAcc.Managing_Director_MC__c = usr2.id;
        testAcc.Operations_Lead__c = u.id;
        testAcc.Technology_Account_Lead__c = usr2.id;
        testAcc.Client_Classification__c = 'Diamond'; 
        
        //insert testAcc;
        Database.insert(testAcc, false);
        
        
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Sample Test Account Acc Opp 1';
        testOpp.AccountId = testAcc.Id;
        testOpp.StageName = '0';
        testOpp.Reporting_Status__c = 'Unqualified';
        testOpp.Type = 'Competitive';
        testOpp.CloseDate = System.today() + 30;
        testOpp.Approved_Status_Stage__c = '0';
        testOpp.Status_Stage_Requested__c = '0';
        testOpp.Consulting_Start__c = System.today() + 51;
        testOpp.Consulting_End__c = System.today() + 52;
        testOpp.AFS_High_Priority_Deal__c = True;
        testOpp.Actual_Contract_Sign_Date__c = System.today() + 50;
        testOpp.Actual_Contract_Sign_Date_Quater__c = System.today() + 30;
        testOpp.Stagename = '0';
        testOpp.Draft_RFP_Release_Date__c = System.today() + 20;
        testOpp.CloseDate = System.today() + 50;
        testOpp.Outsourcing_End__c = System.today() + 52;
        testOpp.Outsourcing_Start__c = System.today() + 51;
        testOpp.Peak_Capital_Balance__c = 24000;
        testOpp.Proposal_Submission_Date__c = System.today() + 40;
        testOpp.Reporting_Status__c = 'Unqualified';
        testOpp.Reporting_Status_Since__c = System.today() + 40;
        testOpp.RFP_Release_Date__c = System.today() + 25;
        testOpp.Hierarchy_Level__c = 'Standalone';
        testOpp.Follow_On_Revenue__c = 50000;
        testOpp.Solution_Baseline_Review__c = System.today() + 25;
        testOpp.Black_Hat_Review__c = System.today() + 26;
        testOpp.PTW_Review__c = System.today() + 27;
        testOpp.Color_Team_Review_Date__c = System.today() + 28;
        testOpp.PRG_Review_Date__c = System.today() + 29;
        testOpp.Date_of_Contract_Management_Review_Date__c = System.today() + 14;
        
        //insert testOpp;
        Database.insert(testOpp, True);
        OpportunityId = testOpp.id;
        system.assertNotEquals(testOpp.id, null);
    
    }
   
    static testmethod void testStageView() {
    
        prepdata();
        
        system.test.startTest();
        
        String opp = OpportunityId;
        String rectype = Main;
        
        ViewSummaryOnclick.recordtypecahng(opp , rectype.substring(0,15));
        
        System.assertEquals(Summary, [SELECT Id, recordTypeId FROM Opportunity WHERE Id =: OpportunityId LIMIT 5000][0].recordtypeId); // Default maximum of SOQL rows to 5000
        
        String errorReceived = ViewSummaryOnclick.recordtypecahng(opp , rectype.substring(0,15));
        System.assertEquals('',errorReceived);
        
       
        
        String opp2 = OpportunityId;
        String rectype2 = Summary;
        
        ViewSummaryOnclick.recordtypecahng(opp2 , rectype2.substring(0,15));
        
        System.assertEquals(Main, [SELECT Id, recordTypeId FROM Opportunity WHERE Id =: OpportunityId LIMIT 5000][0].recordtypeId); // Default maximum of SOQL rows to 5000
        
        String errorReceived2 = ViewSummaryOnclick.recordtypecahng(Null, rectype2.substring(0,15));
        String errorReceived3 = ViewSummaryOnclick.recordtypecahng(Main, rectype2.substring(0,15));
        System.assertNotEquals(null, errorReceived2);
        System.assertNotEquals(null, errorReceived3);
        
    } 
    */
}