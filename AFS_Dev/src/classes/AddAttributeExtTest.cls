/**
   @Author                       Honelee F. Padilla
   @name                         AddAttributeExtTest
   @CreateDate                   
   @Description                  <insert description here>
*/
@isTest(SeeAllData=true)
private class AddAttributeExtTest{

    private static id testPersonGlobalId;
    
    
   /**
   * This testAddAttributeExt1 will test create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    private static testmethod void testAddAttributeExt1(){    
            
    Id opportunityId = null;
    Id accountId = null;
    list<Opportunity> opp = new list<Opportunity>();
    list<Opportunity> oppError = new list<Opportunity>();
    final String accountName = 'Sample Test Account';
    Set<String> priceBookEntryNames = new Set<String> {
        'AO - CostPlus',
        'IO - CostPlus',
        'BPO - CostPlus',
        'SI - CostPlus',
        'TC - CostPlus',
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

        /*
        * - Test Person
        */     
        Person__c testPersonGlobal = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPersonGlobal,true);  
        testPersonGlobalId = testPersonGlobal.Id;

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
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 1234;
        database.insert(testOpp,true);
        
        test.startTest();
        List<Attribute__c> testAtts = new List<Attribute__c>();
        Attribute__c testAtt1 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Accenture Digital',
        Attribute_Value__c = 'Analytics',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt1);
        
        Attribute__c testAtt2 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
         Attribute_Type__c = 'TGP Offerings', 
        Attribute_Value__c ='Not Applicable', 
        AttributePercent__c = 1);
        testAtts.add(testAtt2);
        
        Attribute__c testAtt3 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Alliance',
        Attribute_Value__c = 'ADOBE',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt3);

         Attribute__c testAtt4 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Alliance',
        Attribute_Value__c = 'CALLIDUS',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt4);

         Attribute__c testAtt5 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Horizontals/Initiatives',
        Attribute_Value__c = 'Accenture Cloud Platform-Cloud Managed Services',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt5);
        
        Database.insert(testAtts, false);
        
        Attribute__c testAtt6 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Horizontals/Initiatives',
        Attribute_Value__c = 'Cloud-Apps and Platform Services (PaaS)',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt6);
        
        Attribute__c testAtt7 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Industry Business Services',
        Attribute_Value__c = 'D&PS-ENTERPRISE SERVICES FOR DEFENSE-DIGITAL DEFENSE TRANSFORMATION',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt7);

        Attribute__c testAtt8 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Industry Business Services',
        Attribute_Value__c = 'D&PS-ENTERPRISE SERVICES FOR DEFENSE-MILITARY HEALTH',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt8);

        Attribute__c testAtt9 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Ventures & Acquisitions',
        Attribute_Value__c = 'Agilex - Synergy',
        AttributePercent__c = 100);
                
        testAtts.add(testAtt9);

        Attribute__c testAtt10 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Ventures & Acquisitions',
        Attribute_Value__c = 'Agilex - Standalone',
        AttributePercent__c = 100);
                
        testAtts.add(testAtt10);

        Attribute__c testAtt11 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Ventures & Acquisitions',
        Attribute_Value__c = 'Agilex - Standalone',
        AttributePercent__c = 1);
                
        testAtts.add(testAtt11);

        Attribute__c testAtt12 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Ventures & Acquisitions',
        Attribute_Value__c = 'Agilex - Standalone',
        AttributePercent__c = 1);

        testAtts.add(testAtt12);

        Attribute__c testAtt13 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Accenture Digital',
        Attribute_Value__c = 'Analytics',
        AttributePercent__c = 0);
                
        testAtts.add(testAtt13);

        Attribute__c testAtt14 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Alliance',
        Attribute_Value__c = 'ADOBE',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt14);

        Attribute__c testAtt15 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Industry Business Services',
        Attribute_Value__c = 'D&PS-ENTERPRISE SERVICES FOR DEFENSE-DIGITAL DEFENSE TRANSFORMATION',
        AttributePercent__c = 0);
                
        testAtts.add(testAtt15);

        database.insert(testAtts,false);
        
        ApexPages.currentPage().getParameters().put('id',testOpp.id);
          
        List <Attribute__c> attrib = [SELECT Name, id,Attribute_Check__c ,Attribute_TypeName__c, Attribute_Type__c, AttributeTxt__c, Attribute_Value__c, AttributePercent__c,Opportunity_Name__c FROM Attribute__c WHERE Opportunity_Name__c = :testOpp.id  ORDER BY Attribute_Type__c, Attribute_Value__c ASC LIMIT 50000];
        
        System.debug('AttributeVal: ' + attrib);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(attrib);      
        AddAttributeExt objController  = new AddAttributeExt(ssc);
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'ASM - Synergy', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.attributes.clear();
        
        objController.ATT = new Attribute__c (        
        Opportunity_Name__c = testOpp.id, 
        Attribute_Check__c = true, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'ASM - Synergy', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c ='Agilex - Standalone', 
        AttributePercent__c = 100);
        objController.updateAttributes(); 
        
        objController.attributes.clear();
        
        objController.ATT = new Attribute__c (        
        Opportunity_Name__c = testOpp.id, 
        Attribute_Check__c = true, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'ASM - Synergy', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c ='Agilex - Standalone', 
        AttributePercent__c = 10);
        objController.updateAttributes(); 
          

        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Alliance', 
        Attribute_Value__c = 'MICROSOFT', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Horizontals/Initiatives', 
        Attribute_Value__c ='UC & Network', 
        AttributePercent__c = 10);
        objController.addAttribute();
        
        objController.attributes.add(new Attribute__c (
        Attribute_Check__c = true, 
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Alliance', 
        Attribute_Value__c ='INFORMATICA', 
        AttributePercent__c = 16));
            
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Alliance', 
        Attribute_Value__c ='INFORMATICA', 
        AttributePercent__c = 18);
        objController.updateAttributes();
        
        objController.attributes.add(new Attribute__c (
        Attribute_Check__c = true, 
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Accenture Digital', 
        Attribute_Value__c ='Interactive', 
        AttributePercent__c = 16));
            
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Accenture Digital', 
        Attribute_Value__c ='Interactive', 
        AttributePercent__c = 10);
        objController.updateAttributes();
        
        objController.attributes.add(new Attribute__c (
        Attribute_Check__c = true, 
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Horizontals/Initiatives', 
        Attribute_Value__c ='Cloud-Strategy', 
        AttributePercent__c = 16));
        
        objController.ATT = new Attribute__c ( 
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Horizontals/Initiatives', 
        Attribute_Value__c ='Cloud-Strategy', 
        AttributePercent__c = 16);
        objController.deleteAttributes();
        
        objController.attributes.add(new Attribute__c (
        Attribute_Check__c = true, 
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Alliance', 
        Attribute_Value__c ='SI-Application Svcs for Mainframe', 
        AttributePercent__c = 16));
        
        objController.attributes = attrib;
        
        objController.ATT = new Attribute__c (
            Opportunity_Name__c = testOpp.id, 
            Attribute_Type__c = 'Alliance', 
            Attribute_Value__c ='CALLIDUS', 
            AttributePercent__c = 16);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
            Opportunity_Name__c = testOpp.id, 
            Attribute_Type__c = 'Industry Business Services', 
            Attribute_Value__c = 'D&PS-ENTERPRISE SERVICES FOR DEFENSE-DIGITAL DEFENSE TRANSFORMATION', 
            AttributePercent__c = 15);
        objController.updateAttributes();
       
        objController.ATT = new Attribute__c ( 
            Opportunity_Name__c = testOpp.id, 
            Attribute_Type__c = 'TGP Offerings', 
            Attribute_Value__c ='Not Applicable', 
            AttributePercent__c = 1);
        objController.addAttribute();
                
        objController.ATT = new Attribute__c (
            Opportunity_Name__c = testOpp.id, 
            Attribute_Type__c = null, 
            Attribute_Value__c = null, 
            AttributePercent__c = 10);
        objController.deleteAttributes();
        
        objController.ATT = new Attribute__c (
            Opportunity_Name__c = testOpp.id, 
            Attribute_Type__c = null, 
            Attribute_Value__c = null, 
            AttributePercent__c = null);
        objController.insertAttributes();
        
       objController.attributes.clear();
       
       objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Accenture Digital', 
          Attribute_Value__c ='Interactive', 
          AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Alliance', 
          Attribute_Value__c ='AMAZON WEB SERVICES (AWS)', 
          AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Horizontals/Initiatives', 
          Attribute_Value__c ='Accenture Cloud Platform-Cloud Managed Services', 
          AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Industry Business Services', 
          Attribute_Value__c ='D&PS-ENTERPRISE SERVICES FOR DEFENSE-DIGITAL DEFENSE TRANSFORMATION', 
          AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Accenture Digital', 
          Attribute_Value__c ='Analytics', 
          AttributePercent__c = 0);
        objController.addAttribute();
        
        objController.attributes.clear();
        objController.offerings.clear();
        objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Accenture Digital', 
          Attribute_Value__c ='Analytics', 
          AttributePercent__c = 150);
        objController.addAttribute();
        objController.offerings.clear();
        objController.collectTotal.clear();
        objController.attributes.clear();
        
        objController.ATT = new Attribute__c (
            Attribute_Type__c = 'Industry Business Services', 
          Attribute_Value__c =null, 
          AttributePercent__c = 10);
        objController.addAttribute();
        
        objController.attributes.add(new Attribute__c(
          Attribute_Check__c = true,
          Attribute_Type__c = 'Accenture Digital', 
          Attribute_Value__c ='Analytics', 
          AttributePercent__c = 10));
          
        objController.attributes.add(new Attribute__c(
          Attribute_Check__c = true,
          Attribute_Type__c = 'Accenture Digital', 
          Attribute_Value__c ='Interactive', 
          AttributePercent__c = 100));
                    
        objController.deleteAttributes();
       test.stopTest();
    }   
    
   /**
   * This testAddAttributeExt2 will test create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
     private static testmethod void testAddAttributeExt2(){    
            
    Id opportunityId = null;
    Id accountId = null;
    list<Opportunity> opp = new list<Opportunity>();
    list<Opportunity> oppError = new list<Opportunity>();
    final String accountName = 'Sample Test Account';
    Set<String> priceBookEntryNames = new Set<String> {
        'AO - CostPlus',
        'IO - CostPlus',
        'BPO - CostPlus',
        'SI - CostPlus',
        'TC - CostPlus',
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
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 2344;
        database.insert(testOpp,true);
        
        Person__c testPerson = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPerson,true);
        
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
        
        database.update(testOpp1,false);
        
        List<OpportunityLineItem> listOppItem = new List<OpportunityLineItem>();
        
        OpportunityLineItem testOppLI1 = new OpportunityLineItem();
        testOppLI1.OpportunityId = testOpp.id;
        testOppLI1.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus');
        testOppLI1.Revenue__c = 1000000;
        testOppLI1.Total_Costs__c = 100;
        testOppLI1.Type__c ='01 - AO';
        database.insert(testOppLI1,True);
        
        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = testOpp.id;
        testOppLI2.PriceBookEntryId = priceBookEntryMap.get('MC - CostPlus');
        testOppLI2.Revenue__c = 1000000;
        testOppLI2.Total_Costs__c = 100;
        testOppLI2.HW_SW_Costs__c = 0;
        testOppLI2.Type__c ='04 - MC';
        database.insert(testOppLI2,True);
        
        OpportunityLineItem testOppLI3 = new OpportunityLineItem();
        testOppLI3.OpportunityId = testOpp.id;
        testOppLI3.PriceBookEntryId = priceBookEntryMap.get('SI - CostPlus');
        testOppLI3.Revenue__c = 1000000;
        testOppLI3.Total_Costs__c = 100;
        testOppLI3.HW_SW_Costs__c = 0;
        testOppLI3.Type__c ='05 - SI';
        database.insert(testOppLI3,True);
        
        OpportunityLineItem testOppLI4 = new OpportunityLineItem();
        testOppLI4.OpportunityId = testOpp.id;
        testOppLI4.PriceBookEntryId = priceBookEntryMap.get('TC - CostPlus');
        testOppLI4.Revenue__c = 1000000;
        testOppLI4.Total_Costs__c = 100;
        testOppLI4.HW_SW_Costs__c = 0;
        testOppLI4.Type__c ='06 - TC';
        database.insert(testOppLI4,True);
        
        OpportunityLineItem testOppLI5 = new OpportunityLineItem();
        testOppLI5.OpportunityId = testOpp.id;
        testOppLI5.PriceBookEntryId = priceBookEntryMap.get('IO - CostPlus');
        testOppLI5.Revenue__c = 1000000;
        testOppLI5.Total_Costs__c = 100;
        testOppLI5.HW_SW_Costs__c = 0;
        testOppLI5.Type__c ='IO';
        database.insert(testOppLI5,True);
        
        test.startTest();
        List<Attribute__c> testAtts = new List<Attribute__c>();
        Attribute__c testAtt1 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Accenture Digital',
        Attribute_Value__c = 'Analytics',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt1);
        
        database.insert(testAtts,true);
        
        ApexPages.currentPage().getParameters().put('id',testOpp.id);
          
        List <Attribute__c> attrib = [SELECT Name, id,Attribute_Check__c ,Attribute_TypeName__c, Attribute_Type__c, AttributeTxt__c, Attribute_Value__c, AttributePercent__c,Opportunity_Name__c FROM Attribute__c WHERE Opportunity_Name__c = :testOpp.id  ORDER BY Attribute_Type__c, Attribute_Value__c ASC LIMIT 50000];
        
        System.debug('AttributeVal: ' + attrib);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(attrib);      
        AddAttributeExt objController  = new AddAttributeExt(ssc);

        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 10);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 150);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 0);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 150);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'ASM - Synergy', 
        AttributePercent__c = 150);
        objController.addAttribute();
        
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'ASM - Synergy', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'ASM - Synergy', 
        AttributePercent__c = 150);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'AO Offerings', 
        Attribute_Value__c = 'AO-Application Management', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'IO Offerings', 
        Attribute_Value__c = 'IO-Data Center & Cloud Operations', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'MC Offerings', 
        Attribute_Value__c = 'Analytics', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'TC Offerings', 
        Attribute_Value__c = 'TC-Data Center Transformation', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'SI Offerings', 
        Attribute_Value__c = 'SI-Application Svcs for Java', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'SI Offerings', 
        Attribute_Value__c = 'SI-Application Svcs for Java', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Accenture Digital', 
        Attribute_Value__c = 'Analytics', 
        AttributePercent__c = 20);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Accenture Digital', 
        Attribute_Value__c = 'Interactive', 
        AttributePercent__c = 20);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Horizontals/Initiatives', 
        Attribute_Value__c = 'Accenture Cloud Platform-Cloud Managed Services', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Alliance', 
        Attribute_Value__c = 'MICROSOFT', 
        AttributePercent__c = 100);
        objController.addAttribute(); 
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Alliance', 
        Attribute_Value__c = 'ADOBE', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        System.debug('attributesVal: ' + objController.attributes);

        test.stopTest();
    }   
   /**
   * This testAddAttributeExt3 will test create of opportunity product and insert, update and deletion of attributes.
   * @param N/A
   * @return void
   */
    private static testmethod void testAddAttributeExt3(){    
            
    Id opportunityId = null;
    Id accountId = null ;
    list<Opportunity> opp = new list<Opportunity>();
    list<Opportunity> oppError = new list<Opportunity>();
    final String accountName = 'Sample Test Account';
    Set<String> priceBookEntryNames = new Set<String> {
        'AO - CostPlus',
        'IO - CostPlus',
        'BPO - CostPlus',
        'SI - CostPlus',
        'TC - CostPlus',
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
        System.assertNotEquals(null, u.id);
        
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
        testOpp.PoC_Responsible__c = testPersonGlobalId;
        testOpp.Sales_Committed_for_First_Year__c = 433;
        database.insert(testOpp,true);
        
        Person__c testPerson = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
        ); 
        database.insert(testPerson,true);
        
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
        
        database.update(testOpp1,false);
        
        List<OpportunityLineItem> listOppItem = new List<OpportunityLineItem>();
        
        OpportunityLineItem testOppLI1 = new OpportunityLineItem();
        testOppLI1.OpportunityId = testOpp.id;
        testOppLI1.PriceBookEntryId = priceBookEntryMap.get('AO - CostPlus');
        testOppLI1.Revenue__c = 1000000;
        testOppLI1.Total_Costs__c = 100;
        testOppLI1.Type__c ='01 - AO';
        database.insert(testOppLI1,True);
        
        OpportunityLineItem testOppLI2 = new OpportunityLineItem();
        testOppLI2.OpportunityId = testOpp.id;
        testOppLI2.PriceBookEntryId = priceBookEntryMap.get('MC - CostPlus');
        testOppLI2.Revenue__c = 1000000;
        testOppLI2.Total_Costs__c = 100;
        testOppLI2.HW_SW_Costs__c = 0;
        testOppLI2.Type__c ='04 - MC';
        database.insert(testOppLI2,True);
        
        OpportunityLineItem testOppLI3 = new OpportunityLineItem();
        testOppLI3.OpportunityId = testOpp.id;
        testOppLI3.PriceBookEntryId = priceBookEntryMap.get('SI - CostPlus');
        testOppLI3.Revenue__c = 1000000;
        testOppLI3.Total_Costs__c = 100;
        testOppLI3.HW_SW_Costs__c = 0;
        testOppLI3.Type__c ='05 - SI';
        database.insert(testOppLI3,True);
        
        OpportunityLineItem testOppLI4 = new OpportunityLineItem();
        testOppLI4.OpportunityId = testOpp.id;
        testOppLI4.PriceBookEntryId = priceBookEntryMap.get('TC - CostPlus');
        testOppLI4.Revenue__c = 1000000;
        testOppLI4.Total_Costs__c = 100;
        testOppLI4.HW_SW_Costs__c = 0;
        testOppLI4.Type__c ='06 - TC';
        database.insert(testOppLI4,True);
        
        OpportunityLineItem testOppLI5 = new OpportunityLineItem();
        testOppLI5.OpportunityId = testOpp.id;
        testOppLI5.PriceBookEntryId = priceBookEntryMap.get('IO - CostPlus');
        testOppLI5.Revenue__c = 1000000;
        testOppLI5.Total_Costs__c = 100;
        testOppLI5.HW_SW_Costs__c = 0;
        testOppLI5.Type__c ='IO';
        database.insert(testOppLI5,True);
        
        test.startTest();
        List<Attribute__c> testAtts = new List<Attribute__c>();
        Attribute__c testAtt1 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Accenture Digital',
        Attribute_Value__c = 'Analytics',
        AttributePercent__c = 20);
                
        testAtts.add(testAtt1);
        
        Attribute__c testAtt2 = new Attribute__c (Opportunity_Name__c = testOpp.Id,    
        Attribute_Type__c = 'Accenture Digital',
        Attribute_Value__c = 'Mobility',
        AttributePercent__c = 0);
                
        testAtts.add(testAtt2);
        
        database.insert(testAtts,true);
        
        ApexPages.currentPage().getParameters().put('id',testOpp.id);
          
        List <Attribute__c> attrib = [SELECT Name, id,Attribute_Check__c ,Attribute_TypeName__c, Attribute_Type__c, AttributeTxt__c, Attribute_Value__c, AttributePercent__c,Opportunity_Name__c FROM Attribute__c WHERE Opportunity_Name__c = :testOpp.id  ORDER BY Attribute_Type__c, Attribute_Value__c ASC LIMIT 50000];
        
        System.debug('AttributeVal: ' + attrib);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(attrib);      
        AddAttributeExt objController  = new AddAttributeExt(ssc);

        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Ventures & Acquisitions', 
        Attribute_Value__c = 'Agilex - Standalone', 
        AttributePercent__c = 100);
        objController.addAttribute();
        
        objController.ATT = new Attribute__c (
        Opportunity_Name__c = testOpp.id, 
        Attribute_Type__c = 'Accenture Digital', 
        Attribute_Value__c = 'Analytics', 
        AttributePercent__c = 10);
        objController.addAttribute();

        test.stopTest();
    }  
}