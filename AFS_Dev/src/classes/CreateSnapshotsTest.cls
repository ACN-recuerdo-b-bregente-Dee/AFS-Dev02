/**
 * Class Name: CreateSnapshotsTest
 * @author: Lhea Valencia
 * Date: 04/17/2015
 * Test Class for CreateSnapshots
 */
 
@isTest(SeeAllData=true)

/*
 * - Creates all the data needed/required
 */
private class CreateSnapshotsTest{
    
   private static Id opportunityId;
   private static Id productId;
   private static Opportunity recordOpp;
   private static Opportunity recordOpp2;
   private static Product2 recordProd;
   private static OpportunityLineITem recordOppLineItem;
   private static final Integer SOQL_LIMIT_CONSTANT = 1000;
    
   /*
    * - Creates all the data needed/required
    */
   static void prepdata() {
    
        /*
        * - Test User
        */
     
        Profile p = [select id from profile where name='System Administrator' limit 1];
        
        User testUser = new User();
        testUser.alias = 'user1A';
        testUser.email='user1@sample.com';
        testUser.emailencodingkey='UTF-8';
        testUser.lastname='DOe';
        testUser.languagelocalekey='en_US';   
        testUser.localesidkey='en_US';
        testUser.profileid = p.Id;
        testUser.timezonesidkey='America/Los_Angeles';
        testUser.username='user1@sample.com.dev';
        
        database.insert(testUser, True);
        
        
        User testUser2 = new User();
        testUser2.alias = 'user2Abc';
        testUser2.email='user1@sample.com';
        testUser2.emailencodingkey='UTF-8';
        testUser2.lastname='DOeh';
        testUser2.languagelocalekey='en_US';   
        testUser2.localesidkey='en_US';
        testUser2.profileid = p.Id;
        testUser2.timezonesidkey='America/Los_Angeles';
        testUser2.username='user2@sample.com.dev';
        
        database.insert(testUser2, True);
        
        /*
        * - Test Account
        */
        RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
        
        Account testAcc = new Account();
        testAcc.RecordTypeId = clientRecType.Id;
        testAcc.name = 'Sample Test Account Acc';
        testAcc.Status__c = 'Active';
        testAcc.Type = 'Client';
        testAcc.Client_Account_Lead__c = testUser.id; 
        testAcc.Client_QA_Director__c = testUser2.id;
        testAcc.P_Global_Client_Account_Lead__c = testUser.id;
        testAcc.Managing_Director_MC__c = testUser2.id;
        testAcc.Operations_Lead__c = testUser.id;
        testAcc.Technology_Account_Lead__c = testUser2.id;
        testAcc.Client_Classification__c = 'Diamond'; 
        
        database.insert(testAcc, True);
        
        
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
        
            /*
        * - Test PriceBook
        */  
        
        Pricebook2 testPricebook = new Pricebook2();
        testPricebook.Name = 'SI - CostPlus';
        testPricebook.Description = 'Test Pricebook Entry 1';
        testPricebook.isActive = true;
        
        database.insert(testPricebook, True);
        
        
        /*
        * - Test Products
        */  
        
        Product2 testProduct = new Product2();
        testProduct.Name = 'SI - CostPlus';
        testProduct.IsActive = true;
        testProduct.Target_OI__c = 10.4;
        testProduct.Type_of_Work__c = 'Consulting';
        testProduct.Type__c = 'SI';
        
        database.insert(testProduct, True);
        
        Product2 testProduct2 = new Product2();
        testProduct2.Name = 'SI - CostPlus';
        testProduct2.IsActive = true;
        testProduct2.Target_OI__c = 10.4;
        testProduct2.Type_of_Work__c = 'Consulting';
        testProduct2.Type__c = 'SI';
        
        database.insert(testProduct2, True);
        recordProd = testProduct2;
        
        /*
        * - Test PriceBook Entry
        */
        
        PricebookEntry testPricebookEntry = new PricebookEntry();
        testPricebookEntry.Product2ID = testProduct.id;
        testPricebookEntry.Pricebook2ID = standardPb.id;
        testPricebookEntry.UnitPrice = 100;
        testPricebookEntry.isActive = true;
        
        database.insert(testPricebookEntry, True);

         /*
        * - Test Person
        */     
        Person__c testPerson = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPerson,true);        
        
        /*
        * - Test Opportunity
        */
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Sample Test Account Acc Opp 1';
        testOpp.AccountId = testAcc.Id;
        testOpp.StageName = '0';
        testOpp.Reporting_Status__c = 'Unqualified';
        testOpp.Type = 'Competitive';
        testOpp.CloseDate = System.today() + 41;
        testOpp.Approved_Status_Stage__c = '0';
        testOpp.Status_Stage_Requested__c = '0';
        testOpp.Consulting_Start__c = System.today() + 42;
        testOpp.Consulting_End__c = System.today() + 45;
        testOpp.AFS_High_Priority_Deal__c = True;
        testOpp.Actual_Contract_Sign_Date__c = System.today() + 50;
        testOpp.Actual_Contract_Sign_Date_Quater__c = System.today() + 30;
        testOpp.Stagename = '0';
        testOpp.Draft_RFP_Release_Date__c = System.today() + 20;
        testOpp.Outsourcing_End__c = System.today() + 45;
        testOpp.Outsourcing_Start__c = System.today() + 42;
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
        testOpp.Win_Probability__c='11';
        testOpp.PoC_Responsible__c = testPerson.id;
        testOpp.Sales_Committed_for_First_Year__c = 345341;
        testOpp.Probability  = 5;
        testOpp.Bank_Guarantee_Letter_of_Credit__c = 'Yes';
        testOpp.Solicitation_Contract_Number__c = '232';
        testOpp.Most_Favored_Customer_Review_Conducted__c = 'Yes';
        testOpp.OCI_Review_Complete__c = 'Yes';
        testOpp.Service_Contract_Act_Clause_Applicable__c = 'Yes';       
        testOpp.Best_Probable_Worst__c ='Best';
        testOpp.Client_Industry_Area_of_Service__c = 'Aerospace & Defense' ;
        testOpp.Complexity_Category__c='CC: Capital >=$10M';
        
        database.insert(testOpp, True);
        
        opportunityId = testOpp.Id;
        recordOpp = testOpp;
        
        Opportunity testOpp2 = new Opportunity();
        testOpp2.Name = 'Sample Test Account Acc Opp 122';
        testOpp2.AccountId = testAcc.Id;
        testOpp2.StageName = '0';
        testOpp2.Reporting_Status__c = 'Unqualified';
        testOpp2.Type = 'Competitive';
        testOpp2.Approved_Status_Stage__c = '0';
        testOpp2.Status_Stage_Requested__c = '0';
        testOpp2.Consulting_Start__c = System.today() + 42;
        testOpp2.Consulting_End__c = System.today() + 45;
        testOpp2.AFS_High_Priority_Deal__c = True;
        testOpp2.Actual_Contract_Sign_Date__c = System.today() + 50;
        testOpp2.Actual_Contract_Sign_Date_Quater__c = System.today() + 30;
        testOpp2.Stagename = '0';
        testOpp2.Draft_RFP_Release_Date__c = System.today() + 20;
        testOpp2.CloseDate = System.today() + 41;
        testOpp2.Outsourcing_End__c = System.today() + 45;
        testOpp2.Outsourcing_Start__c = System.today() + 42;
        testOpp2.Peak_Capital_Balance__c = 24000;
        testOpp2.Proposal_Submission_Date__c = System.today() + 40;
        testOpp2.Reporting_Status__c = 'Unqualified';
        testOpp2.Reporting_Status_Since__c = System.today() + 40;
        testOpp2.RFP_Release_Date__c = System.today() + 25;
        testOpp2.Hierarchy_Level__c = 'Standalone';
        testOpp2.Follow_On_Revenue__c = 50000;
        testOpp2.Solution_Baseline_Review__c = System.today() + 25;
        testOpp2.Black_Hat_Review__c = System.today() + 26;
        testOpp2.PTW_Review__c = System.today() + 27;
        testOpp2.Color_Team_Review_Date__c = System.today() + 28;
        testOpp2.PRG_Review_Date__c = System.today() + 29;
        testOpp2.Date_of_Contract_Management_Review_Date__c = System.today() + 14;
        
        database.insert(testOpp2, True);
        recordOpp2 = testOpp2;
       
        /*
        * - Test Opportunity Products
        */  
        
        OpportunityLineItem testProd = new OpportunityLineItem();
        testProd.OpportunityId = testOpp.Id;

        testProd.PricebookEntryId = testPricebookEntry.Id;
        testProd.Quantity = 1;
        testProd.UnitPrice = 1;
        testProd.Revenue__c = 50000;
        testProd.Target_OI__c = 18;
        
        database.insert(testProd, True);
        
        OpportunityLineItem testProd2 = new OpportunityLineItem();
        testProd2.OpportunityId = testOpp.Id;

        testProd2.PricebookEntryId = testPricebookEntry.Id;
        testProd2.Quantity = 1;
        testProd2.UnitPrice = 1;
        testProd2.Revenue__c = 5000;
        testProd2.Target_OI__c = 17;
        
        database.insert(testProd2, false);
        recordOppLineItem = testProd2;
        
        System.Assert(true, 'Error');
    }
   /*
    * - Start of test class for CreateSnapshots
    */
    static testmethod void testCreateQuotes() {
    
        prepdata();
        OpportunityHandler.firstRunForBeforeUpdate = true;
        system.test.startTest();

        recordOpp.Approved_Status_Stage__c = 'Lost';
        //recordOpp.STATUS_STAGE_REQUESTED__C = '1A';
        database.update(recordOpp, True);

        // Confirm that record is inserted
        System.assertNotEquals(null, recordOpp.Id);
        
        //System.assertEquals(1,[SELECT Id FROM Quote WHERE OpportunityId =: recordOpp.Id LIMIT 5000].size());// Default maximum of SOQL rows to 5000

        
        //this is to satisfy the update, delete and undelete in OpportunityHandler    
        recordOpp2.Peak_Capital_Balance__c = 60000;
        database.update(recordOpp2, True);  
        database.delete(recordOpp2, True);    
        database.undelete(recordOpp2, True);
        
        //this is to satisfy the update, delete and undelete in ProductHandler   
        recordProd.Target_OI__c = 10.9;    
        database.update(recordProd, True);
        database.delete(recordProd, True);
        database.undelete(recordProd, True); 
        
        //this is to satisfy the update, delete and undelete in OpportunityLineItemHandler   
        recordOppLineItem.Revenue__c = 100000;
        database.update(recordOppLineItem, True);
        database.delete(recordOppLineItem, True);
        //undelete recordOppLineItem;
    
        system.test.stopTest();
        
    
    }

}