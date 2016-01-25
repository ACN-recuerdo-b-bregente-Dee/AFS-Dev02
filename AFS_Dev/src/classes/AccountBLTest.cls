/**
 * Class Name: AccountBLTest
 * @author: Lhea Valencia
 * Date: 04/21/2015
 * Test Class for Account BL
 Test for jenkins
 */
@isTest(SeeAllData=true)
private class AccountBLTest {

    private static Account clientAcc;
    private static Account recordAcc;
    private static Account recordAcc2;
    private static Account recordAcc3;
    private static Account recordAcc4;
    private static Account recordAcc5;
    private static Account recordAcct;
    private static Opportunity OppAccountPlanOIValid;
    private static Opportunity OppAccountPlanOIInvalid; 
    private static Id accountID;
    private static Id userID;
    private static final Id PORTFOLIO_REC_TYPE  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Portfolio').getRecordTypeId();
    private static final Id CUSTOMER_REC_TYPE  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Summary Customer').getRecordTypeId();
    private static final Id CLIENT_REC_TYPE  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Client').getRecordTypeId();
    
    
    /*    
    * @Method Define scope of testmethod.    
    */
    private static void prepdata() {
        
        /*
        * - Test User
        */
        
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
        Database.insert(u, true);
        userID = u.Id;
        
        User usr2 = new User(
        alias = 'user2Abc',
        email='user1@sample.com',
        emailencodingkey='UTF-8',
        lastname='DOeh',
        languagelocalekey='en_US', 
        localesidkey='en_US',
        profileid = p.Id,
        timezonesidkey='America/Los_Angeles',
        username='user2@sample.com.dev'
        );
        Database.insert(usr2, true);
        


        /*
        * - Test Account
        */
        
        Account testAcc = new Account(
        RecordTypeId = PORTFOLIO_REC_TYPE,
        name = 'Sample Test Account Acc',
        Status__c = 'Active',
        Type = 'AFS'
        );
        Database.insert(testAcc, true);
        
        Account testAcc2 = new Account(
        RecordTypeId = PORTFOLIO_REC_TYPE,
        name = 'Sample Test Account Acc22',
        Status__c = 'Active',
        Type = 'Portfolio',
        ParentId = testAcc.Id,
        Account_Plan_OI__c = 80
        );
        Database.insert(testAcc2, true);
                
        Account testAcc20 = new Account(
        RecordTypeId = CLIENT_REC_TYPE,
        name = 'Sample Test Account Acc220',
        Status__c = 'Active',
        Type = 'Client',
        Client_Account_Lead__c = u.id,
        Client_Classification__c = 'Diamond',    
        Account_Plan_OI__c = 80
        );
        Database.insert(testAcc20, true);
        testAcc20.Account_Plan_OI__c = 90;
        Database.update(testAcc20, true);
        accountID = testAcc20.Id;
        
        Account testAcc3 = new Account(
        RecordTypeId = PORTFOLIO_REC_TYPE,
        name = 'Sample Test Account Acc223',
        Status__c = 'Active',
        Type = 'Sub Portfolio',
        ParentId = testAcc2.Id
        );
        Database.insert(testAcc3, true);
            
        Account testAcc7 = new Account(
        RecordTypeId = PORTFOLIO_REC_TYPE,
        name = 'Sample Test Account Acc22377',
        Status__c = 'Active',
        Type = 'Sub Portfolio',
        ParentId = testAcc2.Id
        );
        Database.insert(testAcc7, true);
        recordAcc2 = testAcc7;
        
        Account testAcc6 = new Account(
        RecordTypeId = CUSTOMER_REC_TYPE,
        name = 'Sample Test Account Acc2266',
        Status__c = 'Active',
        Type = 'Customer',
        ParentId = testAcc7.Id
        );
        Database.insert(testAcc6, true);
        recordAcc = testAcc6;
        
        Account testAcc4 = new Account(
        RecordTypeId = CUSTOMER_REC_TYPE,
        name = 'Sample Test Account Acc2234',
        Status__c = 'Active',
        Type = 'Customer',
        ParentId = testAcc3.Id
        );
        Database.insert(testAcc4, true);
        recordAcct = testAcc4;
            
        Account testAcc8 = new Account(
        RecordTypeId = CLIENT_REC_TYPE,
        name = 'Sample Test Account Acc22384',
        Status__c = 'Active',
        ParentId = testAcc6.Id,
        Type = 'Client'
        );
        Database.insert(testAcc8, true);
        recordAcc3 = testAcc8;
        
        Account testAcc9 = new Account(
        RecordTypeId = CUSTOMER_REC_TYPE,
        name = 'Sample Test Account Acc2238445',
        Status__c = 'Active',
        Type = 'Customer',
        ParentId = testAcc3.Id
        );
        Database.insert(testAcc9, true);
        recordAcc5 = testAcc9;
        
        Account testAcc5 = new Account(
        RecordTypeId = CLIENT_REC_TYPE,
        ParentId = testAcc4.Id,
        name = 'Sample Test Account Acc3336',
        Status__c = 'Active',
        Type = 'Client',
        Client_Account_Lead__c = u.id,
        Client_QA_Director__c = usr2.id,
        P_Global_Client_Account_Lead__c = u.id,
        Managing_Director_MC__c = usr2.id,
        Operations_Lead__c = u.id,
        Technology_Account_Lead__c = usr2.id,
        Client_Classification__c = 'Diamond'
        );
        Database.insert(testAcc5, true);
        recordAcc4 = testAcc5;
        
    /*
    * - Test Opportunity
    */
        
        Opportunity testOpp = new Opportunity(
        Name = 'Opportunity Test Class 033341',
        AccountId = accountID,
        STATUS_STAGE_REQUESTED__C = '0',
        Draft_RFP_Release_Date__c = System.today() + 80,
        RFP_RELEASE_DATE__C = System.today() + 90,
        Proposal_Submission_Date__c = System.today() + 95,
        Actual_Contract_Sign_Date__c = System.today() + 110,
        CLOSEDATE = System.today() + 115,
        REPORTING_STATUS_SINCE__C = System.today() - 30, 
        TYPE = 'Competitive',
        STAGENAME = '0',
        APPROVED_STATUS_STAGE__C = '0',
        REPORTING_STATUS__C = 'Qualified',
        Consulting_Start__c  = System.today() + 120,
        Consulting_End__c = System.today() + 210,   
        Outsourcing_Start__c = System.today() + 150, 
        Outsourcing_End__c  = System.today() + 240 
        );
        Database.insert(testOpp,true);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, testOpp.Id);


        


        
        Account afs = new Account ();
        afs.RecordTypeId = PORTFOLIO_REC_TYPE;
        afs.Name = 'AFS Sample Account';
        afs.Status__c = 'Active';
        afs.Type = 'AFS';
        Database.insert (afs, true);
        
        Account port = new Account ();
        port.RecordTypeId = PORTFOLIO_REC_TYPE;
        port.Name = 'Portfolio Sample Account';
        port.Status__c = 'Active';
        port.Type = 'Portfolio';
        port.ParentId = AFS.Id;
        Database.insert (port, true);
        
        Account subPort = new Account ();
        subPort.RecordTypeId = PORTFOLIO_REC_TYPE;
        subPort.Name = 'SubPortfolio Sample Account';
        subPort.Status__c = 'Active';
        subPort.Type = 'Sub Portfolio';
        subPort.ParentId = Port.Id;
        Database.insert (subPort, true);    

        Account customer = new Account();
        customer.RecordTypeId = CUSTOMER_REC_TYPE;
        customer.Name = 'Customer Sample Account';
        customer.Status__c = 'Active';
        customer.Type = 'Customer';
        customer.ParentId = SubPort.Id;
        Database.insert (customer, true);       

        Account client = new Account();
        client.RecordTypeId = CLIENT_REC_TYPE;
        client.Name = 'Client Sample Account';
        client.Status__c = 'Active';
        client.Type = 'Client';
        client.Account_Plan_OI__c = 75;
        client.ParentId = Customer.Id;
        Database.insert (client, true);
        clientAcc = client;

    /*
    * - Test Opportunity for Account Plan OI Valid
    */
        
        Opportunity testOppAccPlanOIValid = new Opportunity(
        Name = 'Opportunity For Account OI Valid',
        AccountId = clientAcc.Id,
        Approved_Status_Stage__c = '0',
        STATUS_STAGE_REQUESTED__C = '0',
        Draft_RFP_Release_Date__c = System.today() + 80,
        RFP_RELEASE_DATE__C = System.today() + 90,
        Proposal_Submission_Date__c = System.today() + 95,
        Actual_Contract_Sign_Date__c = System.today() + 110,
        CLOSEDATE = System.today() + 115,
        REPORTING_STATUS_SINCE__C = System.today() - 30, 
        TYPE = 'Competitive', 
        STAGENAME = '0',
        REPORTING_STATUS__C = 'Unqualified',
        Consulting_Start__c  = System.today() + 120,
        Consulting_End__c = System.today() + 210,   
        Outsourcing_Start__c = System.today() + 150, 
        Outsourcing_End__c  = System.today() + 240 
        );
        Database.insert(testOppAccPlanOIValid,true);
        OppAccountPlanOIValid = testOppAccPlanOIValid;      

    /*
    * - Test Opportunity for Account Plan OI Invalid
    */
        
        Opportunity testOppAccPlanOIInvalid = new Opportunity(
        Name = 'Opportunity For Account OI Invalid',
        AccountId = clientAcc.Id,
        Approved_Status_Stage__c = '0',
        STATUS_STAGE_REQUESTED__C = '0',
        Draft_RFP_Release_Date__c = System.today() + 80,
        RFP_RELEASE_DATE__C = System.today() + 90,
        Proposal_Submission_Date__c = System.today() + 95,
        Actual_Contract_Sign_Date__c = System.today() + 110,
        CLOSEDATE = System.today() + 115,
        REPORTING_STATUS_SINCE__C = System.today() - 30, 
        TYPE = 'Competitive', 
        STAGENAME = '0',
        REPORTING_STATUS__C = 'Unqualified',
        Consulting_Start__c  = System.today() + 120,
        Consulting_End__c = System.today() + 210,   
        Outsourcing_Start__c = System.today() + 150, 
        Outsourcing_End__c  = System.today() + 240 
        );
        Database.insert(testOppAccPlanOIInvalid,true);
        OppAccountPlanOIInvalid = testOppAccPlanOIInvalid;  
        
        
    }
    

    
    /* 
    * @Method Define scope of testmethod.
    */
    static testmethod void testIfAccount(){
        //Line 31
        Profile p = [select id from profile where name='System Administrator' limit 1];
        
        /*
        * - Test User
        */
        
        User u = new User(
        alias = 'user16',
        email='user1@sample.com',
        emailencodingkey='UTF-8',
        lastname='DOee',
        languagelocalekey='en_US',  
        localesidkey='en_US',
        profileid = p.Id,
        timezonesidkey='America/Los_Angeles',
        username='user111@sample.com.dev'
        );
        Database.insert(u, true);
        
        /*
        * - Test Account
        */
    
        RecordType clientRecordType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
        
        Account testAcc = new Account(
        RecordTypeId = clientRecordType.Id,
        name = 'Sample Test Account Acc',
        Status__c = 'Active',
        Type = 'Client',
        Client_Account_Lead__c = u.id,
        Client_Classification__c = 'Diamond'
        );
        Database.insert(testAcc, true);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, testAcc.Id);
    }
    
    //Line 33
    /* 
    * @Method Define scope of testmethod.
    */
    static testmethod void testElseAccount(){
        
        /*
        * - Test User
        */
        
        Profile p = [select id from profile where name='System Administrator' limit 1];
        
        User u = new User(
        alias = 'user16',
        email='user1@sample.com',
        emailencodingkey='UTF-8',
        lastname='DOee',
        languagelocalekey='en_US',   
        localesidkey='en_US',
        profileid = p.Id,
        timezonesidkey='America/Los_Angeles',
        username='user11@sample.com.dev'
        );
        Database.insert(u, true);
        
        User usr2 = new User(
        alias = 'user2Ab0',
        email='user1@sample.com',
        emailencodingkey='UTF-8',
        lastname='DOehh',
        languagelocalekey='en_US',  
        localesidkey='en_US',
        profileid = p.Id,
        timezonesidkey='America/Los_Angeles',
        username='user22@sample.com.dev'
        );
        Database.insert(usr2, true);
        
        /*
        * - Test Account
        */
        
        Account testAcc6 = new Account(
        RecordTypeId = CUSTOMER_REC_TYPE,
        name = 'Sample Test Account Acc22666',
        Status__c = 'Active',
        Type = 'Customer'
        );
        Database.insert(testAcc6, false);
        recordAcc = testAcc6;
        
        Account testAcc10 = new Account(
        RecordTypeId = CLIENT_REC_TYPE,
        name = 'Sample Test Account Acc2238466',
        Status__c = 'Active',
        ParentId = testAcc6.Id,
        Type = 'Client'
        );
        Database.insert(testAcc10);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, testAcc10.Id);
    }
    
    //Line 143
    /* 
    * @Method Define scope of testmethod.
    */
    static testmethod void testValidAccount(){
        
        /*
        * - Test Account
        */
 
        Account testAcc001 = new Account(
        RecordTypeId = PORTFOLIO_REC_TYPE,
        name = 'Sample Test Account Account',
        Status__c = 'Active',
        Type = 'AFS',
        Account_Plan_OI__c = 0
        );
        Database.insert(testAcc001, true);
        testAcc001.Account_Plan_OI__c = 100;
        Database.update(testAcc001, true);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, testAcc001.Id);
    }
    
    
    /* 
    * @Method Define scope of testmethod.
    */
    static testmethod void queryValidAccount(){
        
        /*
        * - Test Account
        */
 
        Account testAcc002 = new Account(
        RecordTypeId = CLIENT_REC_TYPE,
        name = 'Sample Test Account Acc220',
        Status__c = 'Active',
        Type = 'Client',
        Client_Account_Lead__c = userID,
        Client_Classification__c = 'Diamond',    
        Account_Plan_OI__c = 80
        );
        Database.insert(testAcc002, true);
        testAcc002.Account_Plan_OI__c = 100;
                
        
        /*
        * - Test Opportunity
        */

        Opportunity testOpp23 = new Opportunity(
        Name = 'Opportunity Test Class 100',
        AccountId = testAcc002.Id,
        Win_Probability__c = '50',
        Best_Probable_Worst__c = 'Best',
        Hierarchy_Level__c = 'Standalone',
        STATUS_STAGE_REQUESTED__C = '0',
        Draft_RFP_Release_Date__c = System.today() + 80,
        RFP_RELEASE_DATE__C = System.today() + 90,
        Proposal_Submission_Date__c = System.today() + 95,
        Actual_Contract_Sign_Date__c = System.today() + 110,
        CLOSEDATE = System.today() + 115,
        REPORTING_STATUS_SINCE__C = System.today() - 30, 
        TYPE = 'Competitive',
        STAGENAME = '0',
        APPROVED_STATUS_STAGE__C = '0',
        Reporting_Status__c = 'Qualified',
        Consulting_Start__c  = System.today() + 120,
        Consulting_End__c = System.today() + 210,   
        Outsourcing_Start__c = System.today() + 150, 
        Outsourcing_End__c  = System.today() + 240 
        );
        Database.insert(testOpp23,true);
        Database.update(testAcc002, true); 
        Database.update(testOpp23,true);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, testOpp23.Id);
    }
    
    /* 
    * @Method Define scope of testmethod.
    */    
    static testmethod void testUpdateClientAccount(){
        //Test Type Client
        
        //Insert Client Account - No Parent Acc
        Account clientAccParent = new Account(
        RecordTypeId = CLIENT_REC_TYPE,
        name = 'Sample Test Account Acc220',
        Status__c = 'Active',
        Type = 'Client',
        Client_Account_Lead__c = userID,
        Client_Classification__c = 'Diamond',    
        Account_Plan_OI__c = 80
        );
        Database.insert(clientAccParent, true);
        
        System.assertNotEquals(null, clientAccParent.Id);        
        
    }
    
    /* 
    * @Method Define scope of testmethod.
    */
    static testmethod void testAccount() {

        prepdata();
        //testIfAccount();
        //testElseAccount();
        //testValidAccount();
        //queryValidAccount();
        Test.startTest();
        
        //AccountHandler.firstRunForUpdate=True;

        System.debug('Approve Status Stage>>>> ' + OppAccountPlanOIValid.Approved_Status_Stage__c );
        System.debug('Reporting Status>>> ' + OppAccountPlanOIValid.REPORTING_STATUS__C);       
        System.debug('Before Value of Account Plan OI>>' + clientAcc.Account_Plan_OI__c);       
        System.debug('Before Value of Opp Plan OI>>' + OppAccountPlanOIValid.Account_Plan_OI__c);
        System.debug('Before Id of Opp Plan OI>>' + OppAccountPlanOIValid.Id);
        AccountHandler.firstRunForUpdate = True;
        
        clientAcc.Account_Plan_OI__c = 27;
        //AccountHandler.firstRunForUpdate = True;
        Database.update(clientAcc, true);

        System.debug('Approve Status Stage>>>> ' + OppAccountPlanOIInvalid.Approved_Status_Stage__c );
        System.debug('Reporting Status>>> ' + OppAccountPlanOIInvalid.REPORTING_STATUS__C);         
        System.debug('After Value of Account Plan OI>>' + clientAcc.Account_Plan_OI__c);
        System.debug('After Value of Opp Plan OI>>' + OppAccountPlanOIInvalid.Account_Plan_OI__c);
        System.debug('After Id of Opp Plan OI>>' + OppAccountPlanOIInvalid.Id);
        

        
        recordAcc.Type = 'Sub Portfolio';
        Database.update(recordAcc);
        
        Database.update(recordAcct);
        
        //recordAcc2.Type = 'Customer';
        Database.update(recordAcc2);
        
        //this is to satisfy the update, delete and undelete in AccountHandler  
        recordAcc3.Type = 'Client';
        Database.update(recordAcc3);       
        Database.delete(recordAcc5);        
        Database.undelete(recordAcc5);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, recordAcc5.Id);
        
        Test.stopTest();
        
        
    }
    /*static testmethod void testHandler() {
    
        prepdata();
        Test.startTest();
        
        //this is to satisfy the update, delete and undelete in AccountHandler  
        recordAcc3.Type = 'Client';
        Database.update(recordAcc3);       
        Database.delete(recordAcc5);        
        Database.undelete(recordAcc5);
        
        // Confirm that record is inserted
        System.assertNotEquals(null, recordAcc5.Id);
        Test.stopTest();
    
    
    
    }*/
    
    
}