/**
   @Author      Honelee F. Padilla
   @name        AttributeBLTest
   @CreateDate                   
   @Description <insert description here>
*/
@isTest(SeeAllData=true)
private class AttributeBLTest{

    private static Id testPersonGlobalId;
    private static Id opportunityId;
    private static Id opportunityId2;
    private static Id accountId;
    private static list<Opportunity> opp = new list<Opportunity>();
    private static list<Opportunity> oppError = new list<Opportunity>();
    public static final String ACCOUNT_NAME = 'Sample Test Account';
    private static Set<String> priceBookEntryNames = new Set<String> {
        UTIL_Constants.AO_COSTPLUS,
        UTIL_Constants.TC_COSTPLUS, 
        UTIL_Constants.BPO_COSTPLUS, 
        UTIL_Constants.MC_COSTPLUS, 
        UTIL_Constants.IO_COSTPLUS,
        UTIL_Constants.SI_COSTPLUS
    };
    
    private static List<PriceBookEntry> priceBookEntries = new List<PriceBookEntry>{};
    private static Map<String, Id> priceBookEntryMap = new Map<String, Id>{};
   
   /**
   * This prepdata will test will create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    private static void prepdata() {   
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
        System.assertNotEquals(null, u.id);
        
        for (PriceBookEntry entry :[SELECT Id, Name FROM PriceBookEntry WHERE Name IN :priceBookEntryNames AND Pricebook2.IsStandard = true]) {
            priceBookEntryMap.put(entry.Name, entry.Id);
        }
        

        /*
        * - Test Account
        */
        RecordType clientRecType = [Select Id FROM RecordType WHERE Name = 'Client' LIMIT 1];
      
        Account testAcc  = new Account();
        testAcc.RecordTypeId = clientRecType.Id;
        testAcc.name = ACCOUNT_NAME;
        testAcc.Status__c = 'Active';
        testAcc.Type = 'Client';
        testAcc.Client_Account_Lead__c = u.id; 
        testAcc.Client_Classification__c = 'Diamond'; 
        database.insert(testAcc,true);
        accountid = testAcc.id;
        //System.assertEquals('TEST', String.valueOf([SELECT RecordType.Name, Status__c FROM Account where Id = :testAcc.Id]));
    
         /*
        * - Test Person
        */     
        Person__c testPersonGlobal = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPersonGlobal ,true); 
        testPersonGlobalId = testPersonGlobal.Id;
            
    
    }

    /*
    * - Test method to prepare data
    */
     static /*testmethod*/ void prepdata0() {
 

    /*
    * - Test Opportunity
    */
        //System.assertEquals('NULL', String.valueOf([SELECT Id from Account WHERE Name = :ACCOUNT_NAME]));

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
        testOpp.Hierarchy_Level__c = 'Contract Vehicle';
        testOpp.Probability = 0.1;
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 65464;
        //try {
        OpportunityHandler.firstRunForBeforeUpdate = true;
            database.insert(testOpp,true);
        //} catch (Exception e) {}
        opportunityId = testOpp.Id;
        opp.add(testOpp);
        System.debug('GEt value1: ' + testOpp.Id);
        
        System.debug('retrieve: ' + [Select id, name, STATUS_STAGE_REQUESTED__C, Source__c from opportunity where id =: testOpp.Id]);
        
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
    * - Test Opportunity Team Roles
    */
    
        
        Opportunity_Team_Roles__c testOppTR = new Opportunity_Team_Roles__c();
        testOppTR.Opportunity_Name__c = testOpp.Id;
        testOppTR.Name__c = testPerson.id;
        testOppTR.Role__c = 'Opportunity Director';
        testOppTR.Opportunity_Access__c = 'Read Only';
        testOppTR.Sales_Credit__c= 2;
        database.insert(testOppTR,True);
        
        Opportunity_Team_Roles__c testOppTR2 = new Opportunity_Team_Roles__c();
        testOppTR2.Opportunity_Name__c = testOpp.Id;
        testOppTR2.Name__c = testPerson.id;
        testOppTR2.Role__c = 'Opportunity QA Director';
        testOppTR2.Opportunity_Access__c = 'Read Only';
        testOppTR.Sales_Credit__c= 0;
        database.insert(testOppTR2,True);
        
        System.debug('teamOpp1: ' + testOppTR.id + ' - ' + 'teamOpp2: ' + testOppTR2.id);
        System.debug('teamroleQUery1: ' + [Select id, name, Role__c from Opportunity_Team_Roles__c where id =: testOppTR.id]);
        System.debug('teamroleQUery2: ' + [Select id, name, Role__c from Opportunity_Team_Roles__c where id =: testOppTR2.id]);
        
    /*
    * - Test Opportunity Line Item
    */

        Opportunity testOpp1 = new Opportunity();
        testOpp1.id = testOpp.Id;
        testOpp.Source__c = 'Salesforce';
        testOpp1.STATUS_STAGE_REQUESTED__C = '1A';
        testOpp1.Best_Probable_Worst__c = 'Probable Win';
        testOpp1.Client_Industry_Area_of_Service__c = 'None Apply';
        testOpp1.Complexity_Category__c = 'CB: Cross border client contract';
        testOpp1.Export_Transfer_of_Products_Software__c  = 'No';
        testOpp1.Hierarchy_Level__c = 'Contract Vehicle';
        testOpp1.Industry_Sub_Segment__c  = 'D&PS OTHER';
        testOpp1.ONCONUS_Work_Required__c  = 'Yes';
        testOpp1.Primary_Function__c  = 'Business Process Outsourcing';
        testOpp1.Is_AFS_Prime_or_Subcontractor__c = 'Prime';
        testOpp1.Proposal_Submission_Date__c = System.today() + 10;
        testOpp1.RFP_Release_Date__c = System.today() + 5;
        testOpp1.The_Opportunity_involves_activities_now__c = 'No';
        testOpp1.Subject_countries_client_operates__c = 'None Apply';
        testOpp1.Win_Probability__c = '50';
        OpportunityHandler.firstRunForBeforeUpdate = true;
        database.update(testOpp1,false);
        
        OpportunityLineItem testOppLI = new OpportunityLineItem();
        testOppLI.OpportunityId = testOpp.Id;
        testOppLI.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus'); //'01uq0000000WvKyAAK';
        testOppLI.Revenue__c = 1000000;
        testOppLI.Total_Costs__c = 100;
        testOppLI.Type__c ='01 - AO';
        database.insert(testOppLI,True);
        System.assertNotEquals(null, testOppLI.Id); 
        System.debug('GEt value2: ' + testOppLI.Id);
        //system.assertEquals(null,testOppLI.id);

        System.debug('lineItems: ' + [SELECT Id, OpportunityId , Type__c, Total_Costs__c, Revenue__c, Subcontractor_Expenses__c,
                   Service_Group_Text__c,Other_Cost_Components__c,HW_SW_Costs__c, Cost_Components_N_A__c 
                   FROM OpportunityLineItem WHERE OpportunityId =: testOpp.Id LIMIT 50000]);

        System.debug('retrieve2: ' + [Select id, name, STATUS_STAGE_REQUESTED__C, Source__c from opportunity where id =: testOpp.Id]);
        List<Opportunity> idOpp = [Select id, name,STATUS_STAGE_REQUESTED__C from opportunity where id =: testOpp1.id Limit 1];
        System.debug('OPPVAL: ' +testOpp1.id + ' OPPLINEVAl.oppid: ' + testOppLI.OpportunityId + 'OPPS: ' + idOpp);
        //System.assertNotEquals(null, testOpp.Id);

    }

    /*
    * - Test method to prepare data 1A
    */
   static /*testmethod*/ void prepdata1A() {
       
     /*
    * - Test Opportunity
    */

        Opportunity testOpp2 = new Opportunity();
        testOpp2.Name = 'Opportunity Test Class 1A';
        testOpp2.AccountId = accountid; //'001q0000006jVaf';
        testOpp2.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp2.CLOSEDATE = System.today() + 115; 
        testOpp2.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp2.TYPE = 'Competitive';
        testOpp2.STAGENAME = '0';
        testOpp2.STATUS_STAGE_REQUESTED__C = '0';
        testOpp2.APPROVED_STATUS_STAGE__C = '0';
        testOpp2.REPORTING_STATUS__C = 'Qualified';
        testOpp2.Consulting_Start__c  = System.today() + 120; 
        testOpp2.Consulting_End__c = System.today() + 210;   
        testOpp2.Outsourcing_Start__c = System.today() + 150; 
        testOpp2.Outsourcing_End__c  = System.today() + 240;
        testOpp2.Best_Probable_Worst__c= 'Best';
        testOpp2.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOpp2.Complexity_Category__c='CC: Capital >=$10M';
        testOpp2.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp2.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp2.Export_Transfer_of_Products_Software__c= 'No';
        testOpp2.Hierarchy_Level__c = 'Contract Vehicle';
        testOpp2.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOpp2.ONCONUS_Work_Required__c='No';
        testOpp2.Peak_Capital_Balance__c=1000;
        testOpp2.Primary_Function__c='Business Support';
        testOpp2.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOpp2.Proposal_Submission_Date__c=System.today() + 4;
        testOpp2.RFP_Release_Date__c=System.today() + 3;
        testOpp2.The_Opportunity_involves_activities_now__c='Yes';
        testOpp2.Subject_countries_client_operates__c='Iran';
        testOpp2.Win_Probability__c='11';
        testOpp2.PoC_Responsible__c = testPersonGlobalId;
        testOpp2.Sales_Committed_for_First_Year__c = 5655;
        testOpp2.Probability  = 5;
        database.insert(testOpp2,true);
        
        /*
    * - Test Person
    */     
        Person__c testPerson = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
            database.insert(testPerson,true);
        
        Opportunity_Team_Roles__c testOppTR2 = new Opportunity_Team_Roles__c();
        testOppTR2.Opportunity_Name__c = testOpp2.Id;
        testOppTR2.Name__c = testPerson.id;
        testOppTR2.Role__c = 'Opportunity QA Director';
        testOppTR2.Opportunity_Access__c = 'Read Only';
        testOppTR2.Sales_Credit__c= 0;
        database.insert(testOppTR2,True);
        //try {
        testOpp2.STAGENAME = '1A';
        testOpp2.STATUS_STAGE_REQUESTED__C = '1A';
        testOpp2.APPROVED_STATUS_STAGE__C = '1A';
            database.update(testOpp2,true);
        //} catch (Exception e) {}

        opp.add(testOpp2);
        
        opportunityId2 = testOpp2.Id;

        if (opportunityId2 <> null) {
    

    /*
    * - Test Opportunity Team Roles
    */  
        Opportunity_Team_Roles__c testOppTeamR = new Opportunity_Team_Roles__c();
        testOppTeamR.Opportunity_Name__c= opportunityId2;
        testOppTeamR.Role__c='Opportunity QA Director';
        testOppTeamR.Opportunity_Access__c='Read/Write';
        testOppTeamR.Sales_Credit__c=0;
        testOppTeamR.Name__c=testPerson.id;
        database.insert(testOppTeamR,true);

        Opportunity_Team_Roles__c testOppTeamR2 = new Opportunity_Team_Roles__c();
        testOppTeamR2.Opportunity_Name__c= opportunityId2;
        testOppTeamR2.Role__c='Opportunity Director';
        testOppTeamR2.Opportunity_Access__c='Read/Write';
        testOppTeamR2.Sales_Credit__c=0;
        testOppTeamR2.Name__c=testPerson.id;
        database.insert(testOppTeamR2,true);
 
    /*
    * - Test Opportunity Line Item
    */
    
        OpportunityLineItem testOppLI = new OpportunityLineItem();
        testOppLI.OpportunityId = opportunityId2;
        testOppLI.PriceBookEntryId = priceBookEntryMap.get('TC - CostPlus');//'01uq0000000Ww4hAAC';
        testOppLI.Revenue__c = 5000000;
        testOppLI.Total_Costs__c = 500;
        testOppLI.Type__c ='06 - TC';
        database.insert(testOppLI,true);
        System.assertNotEquals(null, testOppLI.Id); 
        }
   
    }
    
    /*
    * - Test method to prepare data 1B
    */
    static /*testmethod*/ void prepdata1B() {
    /*
    * - Test Opportunity
    */
        Opportunity testOppEx = new Opportunity();
        testOppEx.Name = 'Opportunity Test Class 0';
        testOppEx.AccountId = accountid; //'001q0000006jVaf';
        testOppEx.STATUS_STAGE_REQUESTED__C = '0';
        testOppEx.CLOSEDATE = System.today() + 115; 
        testOppEx.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOppEx.TYPE = 'Competitive';
        testOppEx.STAGENAME = '0';
        testOppEx.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOppEx.Draft_RFP_Release_Date__c=System.today() + 2;
        testOppEx.APPROVED_STATUS_STAGE__C = '0';
        testOppEx.REPORTING_STATUS__C = 'Qualified';
        testOppEx.Consulting_Start__c  = System.today() + 120; 
        testOppEx.Consulting_End__c = System.today() + 210;   
        testOppEx.Outsourcing_Start__c = System.today() + 150; 
        testOppEx.Outsourcing_End__c  = System.today() + 240;
        testOppEx.Proposal_Submission_Date__c=System.today() + 4;
        testOppEx.RFP_RELEASE_DATE__C = System.today() + 3;
        testOppEx.Draft_RFP_Release_Date__c=System.today() + 2;
        testOppEx.TEC_Opportunity_Name__c  = '80';     
        testOppEx.Probability  = 5;
        testOppEx.PoC_Responsible__c = testPersonGlobalId;
        testOppEx.Sales_Committed_for_First_Year__c = 9877;
        //try {
            database.insert(testOppEx,true);
        //} catch (Exception e) {}
        opp.add(testOppEx);
            
        
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class 1B';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.STATUS_STAGE_REQUESTED__C = '1B';
        testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp.CLOSEDATE = System.today() + 115; 
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Extension';
        testOpp.STAGENAME = '1B';
        testOpp.APPROVED_STATUS_STAGE__C = '1B';
        testOpp.REPORTING_STATUS__C = 'Qualified';
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240;
        testopp.Best_Probable_Worst__c= 'Best';
        testopp.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOpp.Complexity_Category__c='CC: Capital >=$10M';
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Export_Transfer_of_Products_Software__c= 'No';
        testOpp.Hierarchy_Level__c = 'Standalone';
        testOpp.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOpp.ONCONUS_Work_Required__c='No';
        testOpp.Peak_Capital_Balance__c=1000;
        testOpp.Primary_Function__c='Business Support';
        testOpp.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.RFP_Release_Date__c=System.today() + 3;
        testOpp.The_Opportunity_involves_activities_now__c='Yes';
        testOpp.Subject_countries_client_operates__c='Iran';
        testOpp.Win_Probability__c='11';
        testOpp.Probability  = 5;
        testOpp.Extended_From_Opp_ID__c=testOppEx.Id;
        //try {
            database.insert(testOpp,True);
        //} catch (Exception e) {}
        opp.add(testOpp);
        opportunityId = testOpp.Id;
            
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
    * - Test Opportunity Team Roles
    */  
        Opportunity_Team_Roles__c testOppTeamR = new Opportunity_Team_Roles__c();
        testOppTeamR.Opportunity_Name__c= opportunityId;
        testOppTeamR.Role__c='Opportunity QA Director';
        testOppTeamR.Opportunity_Access__c='Read/Write';
        testOppTeamR.Sales_Credit__c=0;
        testOppTeamR.Name__c=testPerson.id;
        database.insert(testOppTeamR,true);

        
        Opportunity_Team_Roles__c testOppTeamR2 = new Opportunity_Team_Roles__c();
        testOppTeamR2.Opportunity_Name__c= opportunityId;
        testOppTeamR2.Role__c='Opportunity Director';
        testOppTeamR2.Opportunity_Access__c='Read/Write';
        testOppTeamR2.Sales_Credit__c=0;
        testOppTeamR2.Name__c=testPerson.id;
        database.insert(testOppTeamR2,true);

    /*
    * - Test Opportunity Line Item
    */
    
        OpportunityLineItem testOppLI = new OpportunityLineItem();
        testOppLI.OpportunityId = opportunityId;
        testOppLI.PriceBookEntryId = priceBookEntryMap.get('BPO - CostPlus');//'01uU0000001fHJ9IAM';
        testOppLI.Revenue__c = 4000000;
        testOppLI.Total_Costs__c = 400;
        testOppLI.Type__c ='02 - BPO';
        database.insert(testOppLI,true);
        System.assertNotEquals(null, testOppLI.Id); 
  
  
    
    }
    
    
    /*
    * - Test method to prepare data 2A
    */
    static /*testmethod*/ void prepdata2A1() {
    /*
    * - Test Opportunity
    */

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class 2A';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp.CLOSEDATE = System.today() + 115;  
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STAGENAME = '0';
        testOpp.APPROVED_STATUS_STAGE__C = '0';
        testOpp.STATUS_STAGE_REQUESTED__C = '0';
        testOpp.REPORTING_STATUS__C = 'Qualified';
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240;
        testopp.Best_Probable_Worst__c= 'Best';
        testopp.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOpp.Complexity_Category__c='CC: Capital >=$10M';
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Export_Transfer_of_Products_Software__c= 'No';
        testOpp.Hierarchy_Level__c = 'Standalone';
        testOpp.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOpp.ONCONUS_Work_Required__c='No';
        testOpp.Peak_Capital_Balance__c=1000;
        testOpp.Primary_Function__c='Business Support';
        testOpp.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.RFP_Release_Date__c=System.today() + 3;
        testOpp.The_Opportunity_involves_activities_now__c='Yes';
        testOpp.Subject_countries_client_operates__c='Iran';
        testOpp.Win_Probability__c='11';
        testOpp.Bank_Guarantee_Letter_of_Credit__c='No';
        testOpp.Legal_Review_Complete__c = 'Yes';
        testOpp.Most_Favored_Customer_Review_Conducted__c='Yes';
        testOpp.OCI_Review_Complete__c='Yes';
        testOpp.Service_Contract_Act_Clause_Applicable__c='No';
        testOpp.Solicitation_Contract_Number__c='1234';
        testOpp.Probability  = 5;
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 6544;
        //try {
            database.insert(testOpp,true);  
        //} catch (Exception e) {}
        opportunityId = testOpp.Id;
        opp.add(testOpp); 
    
    /*
    * - Test Opportunity Line Item
    */
      System.Debug('Entering value of 1--------------------->');

        OpportunityLineItem testOppLI1 = new OpportunityLineItem();
        testOppLI1.OpportunityId = opportunityId;
        testOppLI1.PriceBookEntryId = priceBookEntryMap.get('MC - CostPlus');//'01uU0000001fFTa';
        testOppLI1.Revenue__c = 1000000;
        testOppLI1.Total_Costs__c = 100;
        testOppLI1.Type__c ='04 - MC';
        testOppLI1.Cost_Components_N_A__c=false;
        testOppLI1.HW_SW_Costs__c =10;
        testOppLI1.Subcontractor_Expenses__c=10;
        testOppLI1.Other_Cost_Components__c=10;
        database.insert(testOppLI1,false);
        System.assertNotEquals(null, testOppLI1.Id); 

        System.Debug('Entering value of 2--------------------->');

        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = opportunityId;
        testOppLI2.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus');//'01uU0000001fFTa';
        testOppLI2.Revenue__c = 1000000;
        testOppLI2.Total_Costs__c = 100;
        testOppLI2.Type__c ='01 - AO';
        testOppLI2.Cost_Components_N_A__c=false;
        testOppLI2.HW_SW_Costs__c =10;
        testOppLI2.Subcontractor_Expenses__c=0;
        testOppLI2.Other_Cost_Components__c=0;
        database.insert(testOppLI2,false);
        System.assertNotEquals(null, testOppLI2.Id); 
        
        OpportunityLineItem testOppLI3 = new OpportunityLineItem();
        testOppLI3.OpportunityId = opportunityId;
        testOppLI3.PriceBookEntryId = priceBookEntryMap.get('IO - CostPlus');//'01uU0000001fFTa';
        testOppLI3.Revenue__c = 1000000;
        testOppLI3.Total_Costs__c = 100;
        testOppLI3.Type__c ='03 - IO';
        testOppLI3.Cost_Components_N_A__c=false;
        testOppLI3.HW_SW_Costs__c =0;
        testOppLI3.Subcontractor_Expenses__c=0;
        testOppLI3.Other_Cost_Components__c=0;
        database.insert(testOppLI3,false);
        System.assertNotEquals(null, testOppLI3.Id); 
        
        OpportunityLineItem testOppLI4 = new OpportunityLineItem();
        testOppLI4.OpportunityId = opportunityId;
        testOppLI4.PriceBookEntryId = priceBookEntryMap.get('SI - CostPlus');//'01uU0000001fFTa';
        testOppLI4.Revenue__c = 1000000;
        testOppLI4.Total_Costs__c = 100;
        testOppLI4.Type__c ='05 - SI';
        testOppLI4.Cost_Components_N_A__c=false;
        testOppLI4.HW_SW_Costs__c =10;
        testOppLI4.Subcontractor_Expenses__c=2;
        testOppLI4.Other_Cost_Components__c=2;
        database.insert(testOppLI4,false);
        System.assertNotEquals(null, testOppLI4.Id); 
        
         OpportunityLineItem testOppLI5 = new OpportunityLineItem();
        testOppLI5.OpportunityId = opportunityId;
        testOppLI5.PriceBookEntryId = priceBookEntryMap.get('TC - CostPlus');//'01uU0000001fFTa';
        testOppLI5.Revenue__c = 1000000;
        testOppLI5.Total_Costs__c = 100;
        testOppLI5.Type__c ='06 - TC';
        testOppLI5.Cost_Components_N_A__c=false;
        testOppLI5.HW_SW_Costs__c =10;
        testOppLI5.Subcontractor_Expenses__c=2;
        testOppLI5.Other_Cost_Components__c=2;
        database.insert(testOppLI5,false);
        System.assertNotEquals(null, testOppLI5.Id); 
        
        System.Debug('Entering value of 3---------------------> Value :' + [SELECT Id, OpportunityId , Type__c, Total_Costs__c, Revenue__c, Subcontractor_Expenses__c,
                   Service_Group_Text__c,Other_Cost_Components__c,HW_SW_Costs__c, Cost_Components_N_A__c 
                   FROM OpportunityLineItem WHERE OpportunityId =: testOpp.Id LIMIT 50000]);
        testOpp.STAGENAME = '2A';
            testOpp.APPROVED_STATUS_STAGE__C = '2A';
            testOpp.STATUS_STAGE_REQUESTED__C = '2A';
            database.update(testOpp, false);
        
    }
    
    /*
    * - Test method to prepare data 2A
    */
    static /*testmethod*/ void prepdata2A2() {
    /*
    * - Test Opportunity
    */

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class 2A';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp.CLOSEDATE = System.today() + 115;  
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STAGENAME = '0';
        testOpp.APPROVED_STATUS_STAGE__C = '0';
        testOpp.STATUS_STAGE_REQUESTED__C = '0';
        testOpp.REPORTING_STATUS__C = 'Qualified';
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240;
        testopp.Best_Probable_Worst__c= 'Best';
        testopp.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOpp.Complexity_Category__c='CC: Capital >=$10M';
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Export_Transfer_of_Products_Software__c= 'No';
        testOpp.Hierarchy_Level__c = 'Standalone';
        testOpp.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOpp.ONCONUS_Work_Required__c='No';
        testOpp.Peak_Capital_Balance__c=1000;
        testOpp.Primary_Function__c='Business Support';
        testOpp.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.RFP_Release_Date__c=System.today() + 3;
        testOpp.The_Opportunity_involves_activities_now__c='Yes';
        testOpp.Subject_countries_client_operates__c='Iran';
        testOpp.Win_Probability__c='11';
        testOpp.Bank_Guarantee_Letter_of_Credit__c='No';
        testOpp.Legal_Review_Complete__c = 'Yes';
        testOpp.Most_Favored_Customer_Review_Conducted__c='Yes';
        testOpp.OCI_Review_Complete__c='Yes';
        testOpp.Service_Contract_Act_Clause_Applicable__c='No';
        testOpp.Solicitation_Contract_Number__c='1234';
        testOpp.Probability  = 5;
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 54221;
        //try {
            database.insert(testOpp,true);  
        //} catch (Exception e) {}
        opportunityId = testOpp.Id;
        opp.add(testOpp);

    /*
    * - Test Attribute
    */
        
        Attribute__c testAttrib = new Attribute__c(
            Attribute_Type__c='Accenture Digital',
            AttributePercent__c=5,
            Attribute_Value__c='Digital Sales - Customer',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib,true);
    
        Attribute__c testAttrib2 = new Attribute__c(
            Attribute_Type__c='Accenture Software',
            AttributePercent__c=5,
            Attribute_Value__c='Not Applicable',
            Opportunity_Name__c=opportunityId
        );
        database.insert(testAttrib2,true);
       
        Attribute__c testAttrib3 = new Attribute__c(
            Attribute_Type__c='AFS Horizontal',
            AttributePercent__c=5,
            Attribute_Value__c='Digital',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib3,true);
        
        Attribute__c testAttrib4 = new Attribute__c(
            Attribute_Type__c='Alliance',
            AttributePercent__c=5,
            Attribute_Value__c='CA',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib4,true);
        
        Attribute__c testAttrib5 = new Attribute__c(
            Attribute_Type__c='Cross Service Group Offering',
            AttributePercent__c=5,
            Attribute_Value__c='Cloud-Security',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib5,true);
        
        Attribute__c testAttrib7 = new Attribute__c(
            Attribute_Type__c='MC Offerings',
            AttributePercent__c=100,
            Attribute_Value__c='Analytics',
            Opportunity_Name__c=opportunityId
        );
        database.insert(testAttrib7,true);
    
        Attribute__c testAttrib8 = new Attribute__c(
            Attribute_Type__c='Industry Business Services',
            AttributePercent__c=5,
            Attribute_Value__c='HEALTH-CLINICAL SERVICES-MEDICAL IMAGING',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib8,true);
        
        Attribute__c testAttrib9 = new Attribute__c(
            Attribute_Type__c='AO Offerings',
            AttributePercent__c=12,
            Attribute_Value__c='AO-Application Management',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib9,true);
        
        Attribute__c testAttrib10 = new Attribute__c(
            Attribute_Type__c='IO Offerings',
            AttributePercent__c=12,
            Attribute_Value__c='IO-Infrastructure Capacity Services',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib10,true);
        
        Attribute__c testAttrib11 = new Attribute__c(
            Attribute_Type__c='SI Offerings',
            AttributePercent__c=12,
            Attribute_Value__c='SI-Application Svcs for Mainframe',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib11,true);
        
        Attribute__c testAttrib12 = new Attribute__c(
            Attribute_Type__c='TC Offerings',
            AttributePercent__c=12,
            Attribute_Value__c='TC-Infrastructure Transformation',
            Opportunity_Name__c=opportunityId
        );
        
        database.insert(testAttrib12,true);

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
    * - Test Opportunity Team Roles
    */  
        Opportunity_Team_Roles__c testOppTeamR = new Opportunity_Team_Roles__c();
        testOppTeamR.Opportunity_Name__c= opportunityId;
        testOppTeamR.Role__c='Opportunity QA Director';
        testOppTeamR.Opportunity_Access__c='Read/Write';
        testOppTeamR.Sales_Credit__c=0;
        testOppTeamR.Name__c=testPerson.id;
        database.insert(testOppTeamR,true);
            
        Opportunity_Team_Roles__c testOppTeamR2 = new Opportunity_Team_Roles__c();
        testOppTeamR2.Opportunity_Name__c= opportunityId;
        testOppTeamR2.Role__c='Opportunity Director';
        testOppTeamR2.Opportunity_Access__c='Read/Write';
        testOppTeamR2.Sales_Credit__c=0;
        testOppTeamR2.Name__c=testPerson.id;
        database.insert(testOppTeamR2,true);
 
    
    /*
    * - Test Opportunity Line Item
    */
      System.Debug('Entering value of 1--------------------->');

        OpportunityLineItem testOppLI1 = new OpportunityLineItem();
        testOppLI1.OpportunityId = opportunityId;
        testOppLI1.PriceBookEntryId = priceBookEntryMap.get('MC - CostPlus');//'01uU0000001fFTa';
        testOppLI1.Revenue__c = 1000000;
        testOppLI1.Total_Costs__c = 100;
        testOppLI1.Type__c ='04 - MC';
        testOppLI1.Cost_Components_N_A__c=false;
        testOppLI1.HW_SW_Costs__c =10;
        testOppLI1.Subcontractor_Expenses__c=10;
        testOppLI1.Other_Cost_Components__c=10;
        database.insert(testOppLI1,false);
        System.assertNotEquals(null, testOppLI1.Id); 

        System.Debug('Entering value of 2--------------------->');

        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = opportunityId;
        testOppLI2.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus');//'01uU0000001fFTa';
        testOppLI2.Revenue__c = 1000000;
        testOppLI2.Total_Costs__c = 100;
        testOppLI2.Type__c ='01 - AO';
        testOppLI2.Cost_Components_N_A__c=false;
        testOppLI2.HW_SW_Costs__c =10;
        testOppLI2.Subcontractor_Expenses__c=0;
        testOppLI2.Other_Cost_Components__c=0;
        database.insert(testOppLI2,false);
        System.assertNotEquals(null, testOppLI2.Id); 
        
        OpportunityLineItem testOppLI3 = new OpportunityLineItem();
        testOppLI3.OpportunityId = opportunityId;
        testOppLI3.PriceBookEntryId = priceBookEntryMap.get('IO - CostPlus');//'01uU0000001fFTa';
        testOppLI3.Revenue__c = 1000000;
        testOppLI3.Total_Costs__c = 100;
        testOppLI3.Type__c ='03 - IO';
        testOppLI3.Cost_Components_N_A__c=false;
        testOppLI3.HW_SW_Costs__c =0;
        testOppLI3.Subcontractor_Expenses__c=0;
        testOppLI3.Other_Cost_Components__c=0;
        database.insert(testOppLI3,false);
        System.assertNotEquals(null, testOppLI3.Id); 
        
        OpportunityLineItem testOppLI4 = new OpportunityLineItem();
        testOppLI4.OpportunityId = opportunityId;
        testOppLI4.PriceBookEntryId = priceBookEntryMap.get('SI - CostPlus');//'01uU0000001fFTa';
        testOppLI4.Revenue__c = 1000000;
        testOppLI4.Total_Costs__c = 100;
        testOppLI4.Type__c ='05 - SI';
        testOppLI4.Cost_Components_N_A__c=false;
        testOppLI4.HW_SW_Costs__c =10;
        testOppLI4.Subcontractor_Expenses__c=2;
        testOppLI4.Other_Cost_Components__c=2;
        database.insert(testOppLI4,false);
        System.assertNotEquals(null, testOppLI4.Id); 
        
         OpportunityLineItem testOppLI5 = new OpportunityLineItem();
        testOppLI5.OpportunityId = opportunityId;
        testOppLI5.PriceBookEntryId = priceBookEntryMap.get('TC - CostPlus');//'01uU0000001fFTa';
        testOppLI5.Revenue__c = 1000000;
        testOppLI5.Total_Costs__c = 100;
        testOppLI5.Type__c ='06 - TC';
        testOppLI5.Cost_Components_N_A__c=false;
        testOppLI5.HW_SW_Costs__c =10;
        testOppLI5.Subcontractor_Expenses__c=2;
        testOppLI5.Other_Cost_Components__c=2;
        database.insert(testOppLI5,false);
        System.assertNotEquals(null, testOppLI5.Id); 
        
        System.Debug('Entering value of 3---------------------> Value :' + [SELECT Id, OpportunityId , Type__c, Total_Costs__c, Revenue__c, Subcontractor_Expenses__c,
                   Service_Group_Text__c,Other_Cost_Components__c,HW_SW_Costs__c, Cost_Components_N_A__c 
                   FROM OpportunityLineItem WHERE OpportunityId =: testOpp.Id LIMIT 50000]);
        testOpp.STAGENAME = '2A';
            testOpp.APPROVED_STATUS_STAGE__C = '2A';
            testOpp.STATUS_STAGE_REQUESTED__C = '2A';
            database.update(testOpp, false);
        
    }
    
    
    /*
    * - Test method to prepare data error
    */
     static /*testmethod*/ void prepdata2ERR() {
    
    /*
    * - Test Opportunity
    */

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class 1AERR';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.STATUS_STAGE_REQUESTED__C = '1A';
        testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp.CLOSEDATE = System.today() + 115; 
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STAGENAME = '1A';
        testOpp.APPROVED_STATUS_STAGE__C = '1A';
        testOpp.REPORTING_STATUS__C = 'Qualified';
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240;
        testOpp.Best_Probable_Worst__c= 'Best';
        testOpp.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOpp.Complexity_Category__c='CC: Capital >=$10M';
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Export_Transfer_of_Products_Software__c= 'No';
        testOpp.Hierarchy_Level__c = 'Contract Vehicle';
        testOpp.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOpp.ONCONUS_Work_Required__c='No';
        testOpp.Peak_Capital_Balance__c=1000;
        testOpp.Primary_Function__c='Business Support';
        testOpp.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.RFP_Release_Date__c=System.today() + 3;
        testOpp.The_Opportunity_involves_activities_now__c='Yes';
        testOpp.Subject_countries_client_operates__c='Iran';
        testOpp.Win_Probability__c='11';
        testOpp.Probability  = 5.0;
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 54333;
        //try {
            database.insert(testOpp,true);
        //} catch (Exception e) {}
        opp.add(testOpp);  
        opportunityId = testOpp.Id;
       
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
    * - Test Opportunity Team Roles
    */  
        Opportunity_Team_Roles__c testOppTeamR = new Opportunity_Team_Roles__c();
        testOppTeamR.Opportunity_Name__c= opportunityId;
        testOppTeamR.Role__c='Opportunity QA Director';
        testOppTeamR.Opportunity_Access__c='Read/Write';
        testOppTeamR.Sales_Credit__c=0;
        testOppTeamR.Name__c=testPerson.id;
        
        database.insert(testOppTeamR,true);

       
       
        Opportunity_Team_Roles__c testOppTeamR2 = new Opportunity_Team_Roles__c();
        testOppTeamR2.Opportunity_Name__c= opportunityId;
        testOppTeamR2.Role__c='Opportunity Director';
        testOppTeamR2.Opportunity_Access__c='Read/Write';
        testOppTeamR2.Sales_Credit__c=0;
        testOppTeamR2.Name__c=testPerson.id;
        
        database.insert(testOppTeamR2,true);


    /*
    * - Test Opportunity Line Item
    */
    
        OpportunityLineItem testOppLI = new OpportunityLineItem();
        testOppLI.OpportunityId = opportunityId;
        testOppLI.PriceBookEntryId = priceBookEntryMap.get('TC - CostPlus');//'01uq0000000Ww4hAAC';
        testOppLI.Revenue__c = 5000000;
        testOppLI.Total_Costs__c = 500;
        testOppLI.Type__c ='06 - TC';
        testOppLI.Cost_Components_N_A__c=True;
        
        database.insert(testOppLI,true);
        System.assertNotEquals(null, testOppLI.Id);
    
    }
    
     
    /*
    * - Test method to prepare data for consulting record
    */
    static /*testmethod*/ void prepdataConsultingRec(){
    
    /*
    * - Test Opportunity
    */
       
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class 1A Consulting';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.STATUS_STAGE_REQUESTED__C = '1A';
        testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp.CLOSEDATE = System.today() + 115; 
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STAGENAME = '1A';
        testOpp.APPROVED_STATUS_STAGE__C = '1A';
        testOpp.REPORTING_STATUS__C = 'Qualified';
        
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240;
        
        testopp.Best_Probable_Worst__c= 'Best';
        testopp.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOpp.Complexity_Category__c='CC: Capital >=$10M';
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Export_Transfer_of_Products_Software__c= 'No';
        testOpp.Hierarchy_Level__c = 'Standalone';
        testOpp.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOpp.ONCONUS_Work_Required__c='No';
        testOpp.Peak_Capital_Balance__c=1000;
        testOpp.Primary_Function__c='Business Support';
        testOpp.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.RFP_Release_Date__c=System.today() + 3;
        testOpp.The_Opportunity_involves_activities_now__c='Yes';
        testOpp.Subject_countries_client_operates__c='Iran';
        testOpp.Win_Probability__c='11';
        testOpp.Probability  = 5;
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 4444;
        //try {
            database.insert(testOpp,True);  
        //} catch (Exception e) {}
        
        opportunityId = testOpp.Id;
        opp.add(testOpp);
    
    /*
    * - Test Opportunity Line Item
    */
        OpportunityLineItem testOppLI1 = new OpportunityLineItem();
        testOppLI1.OpportunityId = opportunityId;
        testOppLI1.PriceBookEntryId = priceBookEntryMap.get('MC - CostPlus');
        testOppLI1.Revenue__c = 5000000;
        testOppLI1.Total_Costs__c = 500;
        database.insert(testOppLI1,true);
        System.assertNotEquals(null, testOppLI1.Id); 
        
        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = opportunityId;
        testOppLI2.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus');
        testOppLI2.Revenue__c = 5000000;
        testOppLI2.Total_Costs__c = 500;
        database.insert(testOppLI2,true);
        System.assertNotEquals(null, testOppLI2.Id); 

    }
        
   /**
   * This testOpportunityBL01 will test will create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    static testmethod void testOpportunityBL01() {
    
        prepdata();
        prepdata0();
        //prepdataConsultingRec();

        Test.startTest();
        
        try {
            OpportunityHandler.firstRunForBeforeUpdate=True;
            database.update(opp,true);
            OpportunityHandler.firstRunForBeforeUpdate=True;
            database.update(oppError, true);
        } catch (Exception e) {

        }
        Test.stopTest();
        System.assertNotEquals(null, opp);
    }
    
   /**
   * This testOpportunityBL02 will test will create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
   static testmethod void testOpportunityBL02() {
    
        prepdata();
        //prepdata0();
        prepdata1A();

        Test.startTest();
        
        try {
            OpportunityHandler.firstRunForBeforeUpdate=True;
            database.update(opp,true);
        } catch (Exception e) {
        
        }
        Test.stopTest();
        System.assertNotEquals(null, opp);
    }
    
   /**
   * This testOpportunityBL03 will test will create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    static testmethod void testOpportunityBL03() {
    
        prepdata();
        //prepdata0();
        //prepdata1A();
        prepdata1B();      

        Test.startTest();
        
        try {
            OpportunityHandler.firstRunForBeforeUpdate=True;
            database.update(opp,true);
        } catch (Exception e) {
        
        }
        Test.stopTest();
        System.assertNotEquals(null, opp);
    }
   /**
   * This testOpportunityBL04 will test will create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    static testmethod void testOpportunityBL04() {
    
        prepdata();      
        prepdata2A1();

        Test.startTest();
        
        try {
            OpportunityHandler.firstRunForBeforeUpdate=True;
            database.update(opp,true);
        } catch (Exception e) {
        
        }
        Test.stopTest();
        System.assertNotEquals(null, opp);
    }
   /**
   * This testOpportunityBL05 will test will create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    static testmethod void testOpportunityBL05() {
    
        prepdata();      
        prepdata2A2();
        Test.startTest();
        try {
            prepdata2ERR();  
            database.update(opp,true);
        } catch (Exception e) {
        
        }
        Test.stopTest();
        System.assertNotEquals(null, opp);
    }
}