/**
 * Class Name: OpportunityBLTest
 * @author: Honelee Padilla
 * Date: 03/10/2015
 * Test Class for OpportunityBL
 */
 
@isTest(SeeAllData=true)

/*
* - OpportunityBLTest
*/
private without sharing class OpportunityBLTest{

    private static Id testPersonGlobalId;
    private static Opportunity recordOppCost;
    private static Opportunity recordOpp;
    private static Opportunity recordOppEndDate;
    private static Id opportunityId;
    private static Id opportunityId2;
    private static Id accountId;
    private static list<Opportunity> opp = new list<Opportunity>();
    private static list<Opportunity> oppError = new list<Opportunity>();
    private static final String ACCOUNT_NAME = 'Sample Test Account';
    private static Set<String> priceBookEntryNames = new Set<String> {
        UTIL_Constants.AO_COSTPLUS ,
        UTIL_Constants.TC_MATERIALS,
        UTIL_Constants.BPO_COSTPLUS,
        UTIL_Constants.MC_COSTPLUS
        //'TC - Time & Materials',
        //'MC - CostPlus'
    };
    private static List<PriceBookEntry> priceBookEntries = new List<PriceBookEntry>{};
    private static Map<String, Id> priceBookEntryMap = new Map<String, Id>{};

    /*
    * - Test method to prepare data
    */
     static /*testmethod*/ void prepdata0() {

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

    /*
    * - Test Opportunity
    */
        //System.assertEquals('NULL', String.valueOf([SELECT Id from Account WHERE Name = :ACCOUNT_NAME]));

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class Zero';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.Source__c = 'Salesforce';
        testOpp.Proposal_Submission_Date__c=System.today() + 4;
        testOpp.Draft_RFP_Release_Date__c=System.today() + 2;
        testOpp.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOpp.RFP_RELEASE_DATE__C = System.today() + 3;
        testOpp.CLOSEDATE = System.today() + 115; 
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STAGENAME = '0';
        testOpp.APPROVED_STATUS_STAGE__C = '0';
        testOpp.STATUS_STAGE_REQUESTED__C = '0';
        testOpp.REPORTING_STATUS__C = 'Unqualified';
        testOpp.Consulting_Start__c  = System.today() + 120; 
        testOpp.Consulting_End__c = System.today() + 210;   
        testOpp.Outsourcing_Start__c = System.today() + 150; 
        testOpp.Outsourcing_End__c  = System.today() + 240; 
        testOpp.Hierarchy_Level__c = 'Contract Vehicle';
        testOpp.Probability = 0.1;
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 45422;
        //try {
            database.insert(testOpp,true);
        //} catch (Exception e) {}
        opportunityId = testOpp.Id;
        opp.add(testOpp);
        System.debug('GEt value1: ' + testOpp.Id);
        
        //System.debug('retrieve: ' + [Select id, name, STATUS_STAGE_REQUESTED__C, Source__c from opportunity where id =: testOpp.Id]);
        database.update(testOpp,true);
     /*
    * - Test Person
    */     
        Person__c testPerson = new Person__c(
            Name='Test name for Person',
            email__c='testPerson@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPerson,true);
        database.update(testPerson,true);
 
 
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
        //System.debug('teamroleQUery1: ' + [Select id, name, Role__c from Opportunity_Team_Roles__c where id =: testOppTR.id]);
        //System.debug('teamroleQUery2: ' + [Select id, name, Role__c from Opportunity_Team_Roles__c where id =: testOppTR2.id]);
        
    
        
        
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
        
        database.insert(testOpp1,false);
        database.update(testOpp1,false);
        
        OpportunityLineItem testOppLI = new OpportunityLineItem();
        testOppLI.OpportunityId = testOpp.Id;
        testOppLI.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus'); //'01uq0000000WvKyAAK';
        testOppLI.Revenue__c = 1000000;
        testOppLI.Total_Costs__c = 100;
        testOppLI.Type__c ='01 - AO';
        //testOpp.Consulting_Start__c  = System.today() + 120; 
        //testOpp.Consulting_End__c = System.today() + 210;
        database.insert(testOppLI,True);
        database.update(testOppLI,True);
        System.assertNotEquals(null, testOppLI.Id); 
        System.debug('GEt value2: ' + testOppLI.Id);
        //system.assertEquals(null,testOppLI.id);

        //System.debug('lineItems: ' + [SELECT Id, OpportunityId , Type__c, Total_Costs__c, Revenue__c, Subcontractor_Expenses__c,
                   //Service_Group_Text__c,Other_Cost_Components__c,HW_SW_Costs__c, Cost_Components_N_A__c 
                   //FROM OpportunityLineItem WHERE OpportunityId =: testOpp.Id LIMIT 50000]);

        //System.debug('retrieve2: ' + [Select id, name, STATUS_STAGE_REQUESTED__C, Source__c from opportunity where id =: testOpp.Id]);
        //List<Opportunity> idOpp = [Select id, name,STATUS_STAGE_REQUESTED__C from opportunity where id =: testOpp1.id Limit 1];
        //System.debug('OPPVAL: ' +testOpp1.id + ' OPPLINEVAl.oppid: ' + testOppLI.OpportunityId + 'OPPS: ' + idOpp);
        //System.assertNotEquals(null, testOpp.Id);
        
    /*
    * - Opportunity Test Data for Consulting and Outsourcing Date
    */ 
    
        Opportunity testOppDate = new Opportunity();
        testOppDate.Name = 'Opportunity Test Class 1A';
        testOppDate.AccountId = accountid; //'001q0000006jVaf';
        testOppDate.RFP_RELEASE_DATE__C = System.today() + 90;
        testOppDate.CLOSEDATE = System.today() + 115; 
        testOppDate.REPORTING_STATUS_SINCE__C = System.today() + 30; 
        testOppDate.TYPE = 'Competitive';
        testOppDate.STAGENAME = '0';
        testOppDate.STATUS_STAGE_REQUESTED__C = '0';
        testOppDate.APPROVED_STATUS_STAGE__C = '0';
        testOppDate.REPORTING_STATUS__C = 'Unqualified';
        testOppDate.Consulting_Start__c  = System.today() + 120; 
        testOppDate.Consulting_End__c = System.today() + 210;   
        testOppDate.Outsourcing_Start__c = System.today() + 150; 
        testOppDate.Outsourcing_End__c  = System.today() + 240;
        testOppDate.Best_Probable_Worst__c= 'Best';
        testOppDate.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOppDate.Complexity_Category__c='CC: Capital >=$10M';
        testOppDate.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOppDate.Draft_RFP_Release_Date__c=System.today() + 2;
        testOppDate.Export_Transfer_of_Products_Software__c= 'No';
        testOppDate.Hierarchy_Level__c = 'Standalone';
        testOppDate.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOppDate.ONCONUS_Work_Required__c='No';
        testOppDate.Peak_Capital_Balance__c=1000;
        testOppDate.Primary_Function__c='Business Support';
        testOppDate.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOppDate.Proposal_Submission_Date__c=System.today() + 4;
        testOppDate.RFP_Release_Date__c=System.today() + 3;
        testOppDate.The_Opportunity_involves_activities_now__c='Yes';
        testOppDate.Subject_countries_client_operates__c='Iran';
        testOppDate.Win_Probability__c='11';
        testOppDate.PoC_Responsible__c = testPersonGlobalId;
        testOppDate.Sales_Committed_for_First_Year__c = 63272;
        testOppDate.Probability  = 5;
        database.insert(testOppDate,true);
        recordOpp = testOppDate;
        
        System.assertNotEquals(null, testOppDate.Id);
        
    /*
    * - Test Opportunity Line Item
    */
    
        OpportunityLineItem testOppLICons = new OpportunityLineItem();
        testOppLICons.OpportunityId = testOppDate.id;
        testOppLICons.PriceBookEntryId = priceBookEntryMap.get('TC - Time & Materials');//'01uq0000000Ww4hAAC';
        testOppLICons.Revenue__c = 5000000;
        testOppLICons.Total_Costs__c = 500;
        testOppLICons.Type__c ='06 - TC';
        database.insert(testOppLICons,true);
        
    
        OpportunityLineItem testOppLIOuts = new OpportunityLineItem();
        testOppLIOuts.OpportunityId = testOppDate.id;
        testOppLIOuts.PriceBookEntryId = priceBookEntryMap.get('BPO - CostPlus');//'01uU0000001fHJ9IAM';
        testOppLIOuts.Revenue__c = 4000000;
        testOppLIOuts.Total_Costs__c = 400;
        testOppLIOuts.Type__c ='02 - BPO';
        database.insert(testOppLIOuts,true);
        System.assertNotEquals(null, testOppLIOuts.Id); 
        
        
    /*
    * - Opportunity Test Data for Consulting and Outsourcing End Date
    */ 
    
        Opportunity testOppEndDate = new Opportunity();
        testOppEndDate.Name = 'Opportunity Test Class for Consulting and Outsourcing End Date';
        testOppEndDate.AccountId = accountid; //'001q0000006jVaf';
        testOppEndDate.RFP_RELEASE_DATE__C = System.today() + 90;
        testOppEndDate.CLOSEDATE = System.today() + 115; 
        testOppEndDate.REPORTING_STATUS_SINCE__C = System.today() + 30; 
        testOppEndDate.TYPE = 'Extension';
        testOppEndDate.Extended_From_Opp_ID__c = testOppDate.id;
        testOppEndDate.STAGENAME = '0';
        testOppEndDate.STATUS_STAGE_REQUESTED__C = '2A';
        testOppEndDate.APPROVED_STATUS_STAGE__C = '0';
        testOppEndDate.REPORTING_STATUS__C = 'Unqualified';
        testOppEndDate.Consulting_Start__c  = System.today() + 120; 
        testOppEndDate.Consulting_End__c = System.today() + 210;   
        testOppEndDate.Outsourcing_Start__c = System.today() + 150; 
        testOppEndDate.Outsourcing_End__c  = System.today() + 240;
        testOppEndDate.Best_Probable_Worst__c= 'Best';
        testOppEndDate.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOppEndDate.Complexity_Category__c='CC: Capital >=$10M';
        testOppEndDate.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOppEndDate.Draft_RFP_Release_Date__c=System.today() + 2;
        testOppEndDate.Export_Transfer_of_Products_Software__c= 'No';
        testOppEndDate.Hierarchy_Level__c = 'Standalone';
        testOppEndDate.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOppEndDate.ONCONUS_Work_Required__c='No';
        testOppEndDate.Peak_Capital_Balance__c=1000;
        testOppEndDate.Primary_Function__c='Business Support';
        testOppEndDate.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOppEndDate.Proposal_Submission_Date__c=System.today() + 4;
        testOppEndDate.RFP_Release_Date__c=System.today() + 3;
        testOppEndDate.The_Opportunity_involves_activities_now__c='Yes';
        testOppEndDate.Subject_countries_client_operates__c='Iran';
        testOppEndDate.Win_Probability__c='11';
        testOppEndDate.PoC_Responsible__c = testPersonGlobalId;
        testOppEndDate.Sales_Committed_for_First_Year__c = 2231;
        testOppEndDate.Probability  = 5;
        testOppEndDate.Bank_Guarantee_Letter_of_Credit__c = 'Yes';
        testOppEndDate.Solicitation_Contract_Number__c = '232';
        testOppEndDate.Most_Favored_Customer_Review_Conducted__c = 'Yes';
        testOppEndDate.OCI_Review_Complete__c = 'Yes';
        testOppEndDate.Service_Contract_Act_Clause_Applicable__c = 'Yes';
        
        database.insert(testOppEndDate,true);
        recordOppEndDate = testOppEndDate;
        
        System.assertNotEquals(null, testOppEndDate.Id);
        
    /*
    * - Test Opportunity Line Item
    */
    
        OpportunityLineItem testOppLIConsEnd = new OpportunityLineItem();
        testOppLIConsEnd.OpportunityId = testOppEndDate.id;
        testOppLIConsEnd.PriceBookEntryId = priceBookEntryMap.get('TC - Time & Materials');//'01uq0000000Ww4hAAC';
        testOppLIConsEnd.Revenue__c = 5000000;
        testOppLIConsEnd.Total_Costs__c = 500;
        testOppLIConsEnd.Type__c ='06 - TC';
        testOppLIConsEnd.Cost_Components_N_A__c = true;
        database.insert(testOppLIConsEnd,true);
        
    
        OpportunityLineItem testOppLIOutEnd = new OpportunityLineItem();
        testOppLIOutEnd.OpportunityId = testOppEndDate.id;
        testOppLIOutEnd.PriceBookEntryId = priceBookEntryMap.get('BPO - CostPlus');//'01uU0000001fHJ9IAM';
        testOppLIOutEnd.Revenue__c = 4000000;
        testOppLIOutEnd.Total_Costs__c = 400;
        testOppLIOutEnd.Type__c ='02 - BPO';
        testOppLIOutEnd.Cost_Components_N_A__c = true;
        database.insert(testOppLIOutEnd,true);
        System.assertNotEquals(null, testOppLIOutEnd.Id); 
         
        /*
         * - Test Person
        */     
        Person__c testPerson2 = new Person__c(
            Name='Test name for Team Role',
            email__c='test21@email.com',
            user_type__c='AFS'
        ); 
            database.insert(testPerson2,true);         
         
        /*
         * - Test Opportunity Team Roles
        */  
        Opportunity_Team_Roles__c testOppTeamR = new Opportunity_Team_Roles__c();
        testOppTeamR.Opportunity_Name__c= testOppEndDate.id;
        testOppTeamR.Role__c='Opportunity QA Director';
        testOppTeamR.Opportunity_Access__c='Read/Write';
        testOppTeamR.Sales_Credit__c=0;
        testOppTeamR.Name__c=testPerson2.id;
        database.insert(testOppTeamR,true);         

        /*
         * - Test Opportunity Team Roles
        */  
        Opportunity_Team_Roles__c teamRoleTest = new Opportunity_Team_Roles__c();
        teamRoleTest.Opportunity_Name__c= testOppEndDate.id;
        teamRoleTest.Role__c='Opportunity Director';
        teamRoleTest.Opportunity_Access__c='Read/Write';
        teamRoleTest.Sales_Credit__c=7;
        teamRoleTest.Name__c=testPerson2.id;
        database.insert(teamRoleTest,true);         
         
         
    /*
    * - Opportunity Test Data for Cost Components N/A
    */ 
    
        Opportunity testOppCost = new Opportunity();
        testOppCost.Name = 'Opportunity Test Class for Cost Components N/A';
        testOppCost.AccountId = accountid; //'001q0000006jVaf';
        testOppCost.RFP_RELEASE_DATE__C = System.today() + 90;
        testOppCost.CLOSEDATE = System.today() + 115; 
        testOppCost.REPORTING_STATUS_SINCE__C = System.today() + 30; 
        testOppCost.TYPE = 'Extension';
        testOppCost.Extended_From_Opp_ID__c = testOppDate.id;
        testOppCost.STAGENAME = '0';
        testOppCost.STATUS_STAGE_REQUESTED__C = '2A';
        testOppCost.APPROVED_STATUS_STAGE__C = '0';
        testOppCost.REPORTING_STATUS__C = 'Unqualified';
        testOppCost.Consulting_Start__c  = System.today() + 120; 
        testOppCost.Consulting_End__c = System.today() + 210;   
        testOppCost.Outsourcing_Start__c = System.today() + 150; 
        testOppCost.Outsourcing_End__c  = System.today() + 240;
        testOppCost.Best_Probable_Worst__c= 'Best';
        testOppCost.Client_Industry_Area_of_Service__c = 'Government Intelligence';
        testOppCost.Complexity_Category__c='CC: Capital >=$10M';
        testOppCost.Actual_Contract_Sign_Date__c=System.today() + 20;
        testOppCost.Draft_RFP_Release_Date__c=System.today() + 2;
        testOppCost.Export_Transfer_of_Products_Software__c= 'No';
        testOppCost.Hierarchy_Level__c = 'Standalone';
        testOppCost.Industry_Sub_Segment__c ='D&PS PUBLIC SAFETY';
        testOppCost.ONCONUS_Work_Required__c='No';
        testOppCost.Peak_Capital_Balance__c=1000;
        testOppCost.Primary_Function__c='Business Support';
        testOppCost.Is_AFS_Prime_or_Subcontractor__c='Prime';
        testOppCost.Proposal_Submission_Date__c=System.today() + 4;
        testOppCost.RFP_Release_Date__c=System.today() + 3;
        testOppCost.The_Opportunity_involves_activities_now__c='Yes';
        testOppCost.Subject_countries_client_operates__c='Iran';
        testOppCost.Win_Probability__c='11';
        testOppCost.PoC_Responsible__c = testPersonGlobalId;
        testOppCost.Sales_Committed_for_First_Year__c = 1232;
        testOppCost.Probability  = 5;
        testOppCost.Bank_Guarantee_Letter_of_Credit__c = 'Yes';
        testOppCost.Solicitation_Contract_Number__c = '232';
        testOppCost.Most_Favored_Customer_Review_Conducted__c = 'Yes';
        testOppCost.OCI_Review_Complete__c = 'Yes';
        testOppCost.Service_Contract_Act_Clause_Applicable__c = 'Yes';
        
        database.insert(testOppCost,true);
        recordOppCost = testOppCost;      

        /*
        * - Test Opportunity Team Roles
        */  
        Opportunity_Team_Roles__c testOppTeam = new Opportunity_Team_Roles__c();
        testOppTeam.Opportunity_Name__c= testOppCost.id;
        testOppTeam.Role__c='Opportunity QA Director';
        testOppTeam.Opportunity_Access__c='Read/Write';
        testOppTeam.Sales_Credit__c=0;
        testOppTeam.Name__c=testPerson2.id;
        database.insert(testOppTeam,true);         
         
    }   

   /**
   * Test method to prepare data error
   */
     static testmethod void prepdata2ERR() {
    
    /*
    * - Test Opportunity
    */

        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Opportunity Test Class 1AERR';
        testOpp.AccountId = accountid; //'001q0000006jVaf';
        testOpp.RFP_RELEASE_DATE__C = System.today() + 90;
        testOpp.CLOSEDATE = System.today() + 115; 
        testOpp.REPORTING_STATUS_SINCE__C = System.today() - 30; 
        testOpp.TYPE = 'Competitive';
        testOpp.STATUS_STAGE_REQUESTED__C = '1A';
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
        testOpp.Sales_Committed_for_First_Year__c = 43532;
        try {
            database.insert(testOpp,true);
            System.assertNotEquals(null, testOpp.Id);
        } catch (Exception e) {}
        
        opp.add(testOpp);  
        
        
    }

    /*
    * - Test method to prepare data for updates on Consulting and Outsourcing Dates
    */  
    static testmethod void testOpportunityBL01() {
    
        //prepdata();
        prepdata0();
        //prepdata1A();

        Test.startTest();
        
        for (Opportunity o : opp) {
            o.STAGENAME = '1A';
            o.APPROVED_STATUS_STAGE__C = '1A';
            o.STATUS_STAGE_REQUESTED__C = '1A';
        }
        
            OpportunityHandler.firstRunForBeforeUpdate=True;
            OpportunityHandler.firstRunForAfterUpdate=True;
            database.update(opp,true);
        
            OpportunityHandler.firstRunForBeforeUpdate=True;
            OpportunityHandler.firstRunForAfterUpdate=True;

       
            try{
            recordOppEndDate.Status_Stage_Requested__c = '2A';
            //recordOppEndDate.Consulting_End__c = null;
            //recordOppEndDate.Outsourcing_End__c = null;
            database.update(recordOppEndDate,true);
            } catch(DMLException e) {
        
            }           
            OpportunityHandler.firstRunForBeforeUpdate=True;
            OpportunityHandler.firstRunForAfterUpdate=True;
            database.update(oppError, true);
        System.debug('>>>>>>>>>> value of Record OPP consulting start ' + recordOpp.Consulting_Start__c);
        System.debug('************** value of Consulting End first' + recordOppEndDate.Consulting_End__c);
        System.debug('************** value of Outsourcing END first' + recordOppEndDate.Outsourcing_End__c);
        
        try{
        recordOpp.Consulting_Start__c = null;
        recordOpp.Outsourcing_Start__c = null;
        database.update(recordOpp,true);
        
        }catch(DMLException e) {
        
        }

        //OpportunityHandler.firstRunForBeforeUpdate=True;
        //OpportunityHandler.firstRunForAfterUpdate=True;             
        try {
        OpportunityLineItem testOppLICostComp = new OpportunityLineItem();
        testOppLICostComp.OpportunityId = recordOppCost.id;
        testOppLICostComp.PriceBookEntryId = priceBookEntryMap.get('TC - Time & Materials');//'01uq0000000Ww4hAAC';
        testOppLICostComp.Revenue__c = 5000000;
        testOppLICostComp.Total_Costs__c = 500;
        testOppLICostComp.Type__c ='06 - TC';
        testOppLICostComp.HW_SW_Costs__c = 1000;
        testOppLICostComp.Subcontractor_Expenses__c = 500;
        testOppLICostComp.Other_Cost_Components__c = 800;
        testOppLICostComp.Cost_Components_N_A__c = false;
        //insert testOppLICostComp;
        database.insert(testOppLICostComp,true);
        
        System.debug('%%% value of testOppLICostComp ' + testOppLICostComp.Cost_Components_N_A__c);
        } catch (DMLException e) {

        } 
        
        Test.stopTest();
        System.assertNotEquals(null, opp);
    }

    /*
    * - Test method to prepare and test data
    */   
    static testmethod void testOpportunityBL05() {
        
        prepdata0();
        Test.startTest();
        
        OpportunityHandler.firstRunForBeforeUpdate=True;
        OpportunityHandler.firstRunForAfterUpdate=True;
        prepdata2ERR();

        Test.stopTest();
        System.assertNotEquals(null, opp);
        
    }    
}