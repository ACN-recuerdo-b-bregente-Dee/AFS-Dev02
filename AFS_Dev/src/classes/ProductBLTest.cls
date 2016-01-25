/**
 * Class Name: ProductBLTest
 * @author: Honelee Padilla
 * Date: 04/28/2015
 * Test Class for ProductBL
 */
@isTest(SeeAllData=true)
private class ProductBLTest{
    
    private static id opportunityId;
    private static final String SOME_VALUE = 'Some Value';
    private static OpportunityLineItem  oppLI;

    /*  
    * @Method to test prepared data for User, Account, Opportunity and Opportunity Product
    */    
    static testmethod void prepdata() {
 
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
        
        database.insert(u);
      
        RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
        Account testAcc  = new Account(
            RecordTypeId = clientRecType.Id,
            Name = 'Sample Test Account',
            Status__c = 'Active',
            Type = 'Client',
            Client_Account_Lead__c = u.id,
            Client_Classification__c = 'Diamond'
        );
        database.insert(testAcc);
        
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
        testOpp.Proposal_Submission_Date__c = System.today() + 5;
        testOpp.Estimator_Confirm_Compliance__c = 'Yes';
        testOpp.Client_Data_Protection_Risk_Assessment__c = SOME_VALUE;
        testOpp.Client_Industry_Area_of_Service__c = SOME_VALUE;
        testOpp.Hierarchy_Level__c = SOME_VALUE;
        database.insert(testOpp);
        
        opportunityId = testOpp.Id;
        
        PriceBookEntry testPricebookEntry = [Select Product2Id, Pricebook2Id, Name, Id From PricebookEntry p where name = 'AO - Time & Materials' limit 1];
        
        OpportunityLineItem testOppLI = new OpportunityLineItem();
        testOppLI.OpportunityId = opportunityId;
        testOppLI.PriceBookEntryId = testPricebookEntry.id;
        testOppLI.Revenue__c = 1000000;
        testOppLI.Total_Costs__c = 100;
        testOppLI.Type__c ='AO';
        database.upsert(testOppLI);  
        
        System.assertEquals(1 , [SELECT COUNT() FROM OpportunityLineItem WHERE Id =: testOppLI.Id] );
    }
    
    /*  
    * @Method to test prepared data for Opportunity Product
    */ 
    static testmethod void testProductBL() {
        Pricebook2  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];       
        
        /*
        * - Test PriceBook
        */  
        PriceBookEntry testPricebookEntry = [Select Product2Id, Pricebook2Id, Name, Id From PricebookEntry p where name = 'AO - Time & Materials' limit 1];
    
        prepdata();
        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = opportunityId;
        testOppLI2.PriceBookEntryId = testPricebookEntry.id;
        testOppLI2.Revenue__c = 5000000;
        testOppLI2.Total_Costs__c = 500;
        testOppLI2.Type__c ='TC';
        testOppLI2.Target_OI__c =3;
        database.insert(testOppLI2); 
           
        OpportunityLineItem testOppLI3 = new OpportunityLineItem();
        testOppLI3.OpportunityId = opportunityId;
        testOppLI3.PriceBookEntryId = testPricebookEntry.id;
        testOppLI3.Revenue__c = 4000000;
        testOppLI3.Total_Costs__c = 400;
        testOppLI3.Type__c ='BPO';
        testOppLI3.Target_OI__c =1;
        database.insert(testOppLI3); 
        
        System.assertNotEquals(null, testOppLI3.id);
        
        Test.startTest();
        
        Id productId =    [
                SELECT Product2Id 
                FROM PriceBookEntry 
                WHERE Id =: testPricebookEntry.id
            ].Product2Id ;
        Product2[] productsToUpdate = [SELECT Id, Type_of_Work__c 
            FROM Product2 
            WHERE Id = :productId
            LIMIT 1
        ];
    
        productsToUpdate[0].Type_of_Work__c = 'SOME TEXT';
        Database.update(productsToUpdate, false);

        
        try {
            OpportunityLineItem testOppLI_ERR = new OpportunityLineItem(
                //OpportunityId = opportunityId,
                PriceBookEntryId = testPricebookEntry.id,
                Revenue__c = 4000000,
                Total_Costs__c = 400,
                Type__c ='BPO',
                Target_OI__c =1
            );
            database.insert(testOppLI3); 
            Database.update(productsToUpdate, false);
            //Database.update(new Product2(), true);
        }
        catch (Exception e) {
        }
        
        Test.stopTest();
    
    }
    
    
    
    
}