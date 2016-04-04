public with sharing class UTIL_Constants {    
    
    public static final String FINANCIAL_SUMMARY_TYPE_TOTAL = 'Total'; 
    public static final String OBJAGGREGATERESULT_EXPR0 = 'expr0';
    public static final String OBJAGGREGATERESULT_EXPR1 = 'expr1';
    public static final String OBJAGGREGATERESULT_EXPR2 = 'expr2';
    public static final String OBJAGGREGATERESULT_EXPR3 = 'expr3';
    public static final String OBJAGGREGATERESULT_EXPR4 = 'expr4';
    public static final String OBJAGGREGATERESULT_EXPR5 = 'expr5';
    public static final String TYPE_OF_WORK_FIELD = 'Type_Of_Work__c';
    public static final String TYPE_FIELD = 'Type__c';
    public static final String OBJAGGREGATERESULT_OpportunityID = 'opportunityId';
    public static final Integer DEFAULT_SOQL_LIMIT = 10000;
    public static final Decimal DEFAULT_ZERO_DECIMAL = 0.00;
    public static final Decimal DEFAULT_FIFTY_PERCENTAGE = 0.50;
    public static final Decimal DEFAULT_HUNDRED = 100;
    public static final Decimal DEFAULT_TWO_DECIMAL = 2;
    public static final Decimal DEFAULT_ONE_DECIMAL = 1;
    
    public static final String DEFAULT_PERCENT_STRING = '%';
    
    //for opportunityTeamRoleBL
    public static final String OPPORTUNITY_ACCESS_READONLY = 'Read Only';
    public static final String OPPORTUNITY_ACCESS_READWRITE = 'Read/Write';
    public static final String OPPORTUNITY_ACCESS_EDIT = 'Edit';
    public static final String OPPORTUNITY_ACCESS_READ = 'Read';
    public static final String PIPE = '|';
    
    public static final String TF_LAST_NAME = 'Roger Louie Cabatic';
    public static final String TF_LAST_NAME2 = 'Gin Lapad';
    public static final String TF_EMAIL = 'ooo@yahoo.com';
    
    public static final String TF_ACCOUNT_NAME = 'Batch Apex';
    public static final String TF_BILLING_CITY = 'yyyy';
    public static final String TF_BILLING_COUNTRY = 'qqqq';
    public static final String TF_BILLING_POSTAL_CODE = '222';
    public static final String TF_BILLING_STREET = 'jbdkj';
    public static final String TF_BILLING_STATE = 'jsvbdj';
    public static final String TF_SHIPPING_CITY = 'dadad';
    public static final String TF_SHIPPING_STATE = 'asasas';
    public static final String TF_SHIPPING_COUNTRY = 'ksjndkajn';
    public static final String TF_SHIPPING_POSTAL_CODE = 'jhdbjsab';
    public static final String SHIPPING_STREET = 'sbhad';
    
    public static final String TF_ACCOUNT_NAME2 = 'Blanco Inc';
    
    public static final String EXCEP_MSG = ' ';

    
    //Created by Michael
    public static final String OPPLINEITEMHANDLER_LINE_MAP_INSERT = 'OPPORTUNITY_LINE_ITEM_INSERT';
    public static final String OPPLINEITEMHANDLER_LINE_MAP_UPDATE = 'OPPORTUNITY_LINE_ITEM_UPDATE';
    
    public static final Date DATE_AFTER_TWO_WEEKS = System.today() + 14;
    
    //Created by Lhea 
    public static final String PERSON_STATUS = 'Active';
    public static final String QUOTE_NAME = 'Snapshot for Approved Stage ';
    public static final String OPP_REC_TYPE_MAIN = 'Main Record Type';
    public static final String OPP_REC_TYPE_SVIEW = 'Switch View'; 
    public static final String ERROR_RECORD = ' [ERROR RECORD : ';   
    public static final String PARENTHESIS = ']';
    //public static final String ERROR_ACCOUNT_1 = ' Unable to update Account due to errors on the following Opportunities:  ';
    //public static final String ERROR_ACCOUNT_2 = '. Please correct these errors before updating this Account.';  
    public static final String COLON = ': ';      
    //Created by Pabs 05/12/15
    
    public static final String PRODUCT_AO = '01 - AO';
    public static final String PRODUCT_BPO = '02 - BPO';
    public static final String PRODUCT_IO = '03 - IO';
    public static final String PRODUCT_MC = '04 - MC';
    public static final String PRODUCT_SI = '05 - SI';
    public static final String PRODUCT_TC = '06 - TC';
    
    public static final String AO_COSTPLUS = 'AO - CostPlus';
    public static final String TC_COSTPLUS = 'TC - CostPlus';
    public static final String BPO_COSTPLUS = 'BPO - CostPlus';
    public static final String MC_COSTPLUS = 'MC - CostPlus';
    public static final String IO_COSTPLUS = 'IO - CostPlus';
    public static final String SI_COSTPLUS = 'SI - CostPlus';
    public static final String IC_COSTPLUS = 'IC - CostPlus';
    public static final String STRATEGY_COSTPLUS = 'Strategy - CostPlus';
    public static final String SI_FIXEDPRICE = 'SI - Fixed Price';
    public static final String TC_FIXEDPRICE = 'TC - Fixed Price';
    public static final String IC_FIXEDPRICE = 'IC - Fixed Price';
    public static final String STRATEGY_FIXEDPRICE = 'Strategy - Fixed Price';
    public static final String SI_MATERIALS = 'SI - Time & Materials';
    public static final String TC_MATERIALS = 'TC - Time & Materials';
    public static final String IC_MATERIALS = 'IC - Time & Materials';
    public static final String STRATEGY_MATERIALS = 'Strategy - Time & Materials';
    public static final String MC_FIXEDPRICE = 'MC - Fixed Price';
    
    //Create by Pabs 6/23/15
    public static final String AO = 'AO';
    public static final String BPO = 'BPO';
    public static final String IO = 'IO';
    public static final String MC = 'MC';
    public static final String SI = 'SI';
    public static final String TC = 'TC';
    
    public static final String HORIZONTALS_INITIATIVES = 'Horizontals/Initiatives';
    public static final String ACCENTURE_DIGITAL = 'Accenture Digital';
    public static final String ACCENTURE_SOFTWARE = 'Accenture Software';
    public static final String AFS_HORIZONTAL = 'AFS Horizontal';
    public static final String ALLIANCE = 'Alliance';
    public static final String CROSS_SERVICE_GROUP_OFFERING = 'Cross Service Group Offering';
    public static final String INDUSTRY_BUSINESS_SERVICES = 'Industry Business Services';
    public static final String MICROSOFT_PLATFORM = 'Microsoft Platform';
    
    public static final String MC_OFERRING = 'MC Offerings';
    public static final String TGP_SI = 'SI Offerings';
    public static final String TGP_AO = 'AO Offerings';
    public static final String TGP_IO = 'IO Offerings';
    public static final String TGP_TC = 'TC Offerings';
    public static final String TGP_IC = 'IC Offerings';
    public static final String TGP_Strategy = 'S Offerings';
    public static final String STRATEGY = 'Strategy';
    
    //Created by Pabs 05/29/15
    public static final String TGP_OFFERINGS = 'TGP Offerings';
    public static final String AGILEX_STANDALONE = 'Agilex - Standalone';
    public static final String OFFERINGS =  'Offerings';
    public static final String PERCENT = '%';
    
    public static final String ID = 'id';
    public static final String DASH = '-';
    public static final String SPACEDASH = ' - '; 
    public static final String NOTLABEL = 'not';  
    
    //Created by Pabs 06/03/15
    public static final String VENTURES_ACQUISITIONS = 'Ventures & Acquisitions';    
    
    //created by Honee 5/29/2015
    
    public static final String STAGENAME_0 = '0';
    public static final String STAGENAME_1A = '1A';
    public static final String STAGENAME_1B = '1B';
    public static final String STAGENAME_2A = '2A';
    public static final String STAGENAME_2B = '2B';
    public static final String STAGENAME_3 = '3';
    
    public static final String STAGEREQ_2A_3 = '2A,2B,3';
    public static final String STAGEREQ_1A_3 = '1A,1B,2A,2B,3';
    
    //created by Boni 5/29/2015
    
    public static final String STAGENAME_CLIENT_WITHDREW = 'Client Withdrew';
    public static final String STAGENAME_AFS_WITHDREW = 'AFS Withdrew';
    public static final String STAGENAME_WON = 'Won';
    public static final String STAGENAME_LOST = 'Lost';
    public static final String STAGENAME_CLOSED = 'Closed';
    public static final String STAGENAME_CLOSED_WON = 'Closed Won';
    public static final String STAGENAME_CLOSED_LOST = 'Closed Lost';
    
    public static final String ACCOUNT_TYPE_CLIENT = 'Client';
    public static final String ACCOUNT_TYPE_CUSTOMER = 'Customer';
    public static final String ACCOUNT_TYPE_SUB_PORTFOLIO = 'Sub Portfolio';
    public static final String ACCOUNT_TYPE_PORTFOLIO = 'Portfolio';
    
    public static final String PRODUCT_TYPE_OF_WORK_CONSULTING = 'Consulting';
    public static final String PRODUCT_TYPE_OF_WORK_OUTSOURCING = 'Outsourcing';
    public static final String REVENUE_BL_ORIGIN = 'OPPORTUNITY_UPDATE';
    public static final String SCHEDULE_TYPE_REVENUE = 'Revenue';
    
    //created by Honee 5/29/2015
    public static final String OPP_TYPE_EXTENSION = 'Extension';
    public static final String OPP_TYPE_OPTION = 'Option';  //added by Samuel Morin 10/02/2015
    public static final String OPP_HIERARCHY_LEVEL_CONTRACT_VEHICLE= 'Contract Vehicle';

    public static final String OPP_TEAM_ROLE_OPP_QA_DIRECTOR = 'Opportunity QA Director';
    public static final String OPP_TEAM_ROLE_OPP_DIRECTOR = 'Opportunity Director';
    public static final String FIN_BATCHQUERY = 'SELECT Id from OpportunityLineItem where Opportunity.Source__c = \'STaR\'';
    public static final String TC_SG_CONVERSION_BATCHQUERY = 'SELECT Id, Product2Id, Product2.Name, Opportunity.Id, Opportunity.Name, Cost_Components_N_A__c, HW_SW_Costs__c, ' + 
                                                             'Other_Cost_Components__c, Type__c, Subcontractor_Expenses__c, Target_OI__c, Target_OI_Temp_Calc__c, ' +
                                                             'Revenue__c, Total_Costs__c, Type_of_Work__c from OpportunityLineItem where Type__c like \'%TC%\' AND '+
                                                             '(Opportunity.Reporting_Status__c= \'Qualified\' OR Opportunity.Reporting_Status__c= \'Unqualified\')';
                                                             
                                                             
    public static final String SI_SG_CONVERSION_BATCHQUERY = 'SELECT Id, Product2Id, Product2.Name, Opportunity.Id, Cost_Components_N_A__c, HW_SW_Costs__c, ' + 
                                                             'Other_Cost_Components__c, Type__c, Subcontractor_Expenses__c, Target_OI__c, Target_OI_Temp_Calc__c, ' +
                                                             'Revenue__c, Total_Costs__c, Type_of_Work__c from OpportunityLineItem where Type__c like \'%SI%\' AND '+
                                                             '(Opportunity.Reporting_Status__c= \'Qualified\' OR Opportunity.Reporting_Status__c= \'Unqualified\')'; 
                                                             
    public static final String MC_SG_CONVERSION_BATCHQUERY = 'SELECT Id, Product2Id, Product2.Name, Opportunity.Id, Cost_Components_N_A__c, HW_SW_Costs__c, ' + 
                                                             'Other_Cost_Components__c, Type__c, Subcontractor_Expenses__c, Target_OI__c, Target_OI_Temp_Calc__c, ' +
                                                             'Revenue__c, Total_Costs__c, Type_of_Work__c from OpportunityLineItem where Type__c = \'04 - MC\' AND '+
                                                             '(Opportunity.Reporting_Status__c= \'Qualified\' OR Opportunity.Reporting_Status__c= \'Unqualified\')';
    //Added by Raymond 3/30/2016                                                                                         
    public static final String ATTRIBUTE_VALIDATION_BATCHQUERY1 = 'SELECT Opportunity.id  FROM OpportunityLineItem WHERE (Opportunity.Reporting_Status__c = \'Qualified\' OR Opportunity.Reporting_Status__c = \'Unqualified\')' +
                                                                  'AND type__c LIKE \'%TC%\' AND (Opportunity.Opportunity_ID__c = \'555300\' OR Opportunity.Opportunity_ID__c = \'555301\' OR Opportunity.Opportunity_ID__c = \'555302\' OR Opportunity.Opportunity_ID__c = \'555303\'';
    public static final String ATTRIBUTE_VALIDATION_BATCHQUERY2 = ' OR Opportunity.Opportunity_ID__c = ';
    
    //Added by Dee 4/4/2016
    public static final String OPEN_OPPORTUNITIES_BATCHQUERY = 'SELECT Id FROM Opportunity WHERE Reporting_Status__c = \'Qualified\' OR Reporting_Status__c = \'Unqualified\'';
    
    //created by Dee 3/17/2015 for Split Conversion    public static String CUSTOM_SETTING_SI_TO_TC = 'SI to TC';
    public static String CUSTOM_SETTING_SI_TO_SI = 'SI to SI';
    public static String CUSTOM_SETTING_TC_TO_TC = 'TC to TC';
    public static String CUSTOM_SETTING_TC_TO_IC = 'TC to IC';
    
    public static String QUERY_WILDCARD_TC = '%TC%';
    public static String QUERY_WILDCARD_IC = '%IC%';
    public static String QUERY_WILDCARD_STRATEGY = '%Strategy%';
    
    
    public static String QUERY_WILDCARD_TC_ITS = '%TC-ITS%';
    
    //Added by Dee 4/4/2016
    public static String TC_PLACEHOLDER = 'TC-PlaceHolder';
    
    public static final String ERROR_MSG_ATT_002 =  'ATT-002';
    public static final String ERROR_MSG_ATT_003 =  'ATT-003';
    public static final String ERROR_MSG_ATT_004 =  'ATT-004';
    public static final String ERROR_MSG_ATT_005 =  'ATT-005';
    public static final String ERROR_MSG_ATT_006 =  'ATT-006';
    public static final String ERROR_MSG_ATT_007 =  'ATT-007';
    public static final String ERROR_MSG_ATT_008 =  'ATT-008';
    public static final String ERROR_MSG_ATT_009 =  'ATT-009';
    public static final String ERROR_MSG_ATT_010 =  'ATT-010';
    public static final String ERROR_MSG_ATT_011 =  'ATT-011';
    public static final String ERROR_MSG_ATT_012 =  'ATT-012';
    public static final String ERROR_MSG_ATT_013 =  'ATT-013';
    public static final String ERROR_MSG_ATT_014 =  'ATT-014';
    public static final String ERROR_MSG_ATT_015 =  'ATT-015';
    public static final String ERROR_MSG_ATT_016 =  'ATT-016';
    public static final String ERROR_MSG_ATT_017 =  'ATT-017';
    public static final String ERROR_MSG_ATT_018 =  'ATT-018';
    public static final String ERROR_MSG_ATT_019 =  'ATT-019';
    public static final String ERROR_MSG_ATT_020 =  'ATT-020';
    public static final String ERROR_MSG_ATT_021 =  'ATT-021';
    public static final String ERROR_MSG_ATT_022 =  'ATT-022';
    public static final String ERROR_MSG_ATT_023 =  'ATT-023';
    public static final String ERROR_MSG_ATT_024 =  'ATT-024';
    public static final String ERROR_MSG_ATT_025 =  'ATT-025';
    public static final String ERROR_MSG_ATT_026 =  'ATT-026';
    public static final String ERROR_MSG_ATT_027 =  'ATT-027';
    public static final String ERROR_MSG_ATT_028 =  'ATT-028';
    
    public static final String ERROR_MSG_FIN_004 =  'FIN-004';
    public static final String ERROR_MSG_FIN_005 =  'FIN-005';
    public static final String ERROR_MSG_FIN_006 =  'FIN-006';
    public static final String ERROR_MSG_OPP_054 =  'OPP-054';
    public static final String ERROR_MSG_OPP_057 =  'OPP-057';
    public static final String ERROR_MSG_OPP_058 =  'OPP-058';
    public static final String ERROR_MSG_OPP_059 =  'OPP-059';
    public static final String ERROR_MSG_OPP_060 =  'OPP-060';
    public static final String ERROR_MSG_OPP_061 =  'OPP-061';
    public static final String ERROR_MSG_OPP_062 =  'OPP-062';
    public static final String ERROR_MSG_OPP_065 =  'OPP-065';
    public static final String ERROR_MSG_OPP_067 =  'OPP-067';
    public static final String ERROR_MSG_TEA_016 =  'TEA-016';
    public static final String ERROR_MSG_TEA_013 =  'TEA-013';
    public static final String ERROR_MSG_ACC_003_1 =  'ACC-003_1';
    public static final String ERROR_MSG_ACC_003_2 =  'ACC-003_2';
    
    public static final String STRING_EMPTY =  '';
    public static final String STRING_COMMA =  ',';
    public static final String STRING_SEMI_COLON =  ';';
    public static final String STRING_NEW_LINE=  '\r\n';
    public static final String STRING_SPAN_SPACE =  '<div style="text-align: left !important;"><b>';
    public static final String STRING_SPACE =  ' ';
    public static final String STRING_BREAK='</b></br><b>';
    
    //created by Pabs 8/21/2015
    public static final String TRADECOMP =  'Trade Compliance Team Guidance Letter Official';
    public static final String IAMNOTSURE = 'I am not sure, please contact me';
    public static final String AEROSPACE = 'Aerospace & Defense';
    public static final String OPPDIRECTOR = 'Opportunity Director';
    public static final String NONEAPPLY = 'None Apply';
    public static final String STRING_NO = 'No';
    public static final String LegalEmailCCAddresss = 'barbara.j.overall@accenturefederal.com';
    public static final String BARBARA_OVERALL = 'Barbara Overall';
    
    public static String tradeComplianceHTML(Opportunity opp, List<Account> acc){
    
    String name = opp.AccountId;
    
    for(Account accountName : acc){
        if(accountName.Id.equals(opp.accountId)){
           name = accountName.name;
        }
    }
    
    String HTMLBODY = '<div style="font-size: 12pt;"><font face="arial"><b>Global Trade Compliance Team Guidance&nbsp;</b></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial"><b><br></b></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial"><b>Accenture Federal Services (AFS)</b></font></div>'
    + '<div style="font-size: 12pt;"><br></div><div style="font-size: 12pt;">'
    + '<font face="arial" style="font-size: 12pt;">You&nbsp;</font>'
    + '<span style="font-family: Arial, sans-serif;">have been identified as the Opportunity Director in Salesforce for the opportunity noted below. &nbsp;This note provides instructions about actions you</span><span style="font-family: Arial, sans-serif;"> are required to take to keep your team compliant with Accenture Trade Controls</span><span style="font-family: Arial, sans-serif;">, and where to go for assistance if needed.</span></div>'
    + '<p class="MsoNormal" style="font-size: 12pt;">'
    + '<span style="font-size: 10pt; font-family: Arial, sans-serif;"><o:p></o:p></span></p>'
    + '<div style="font-size: 12pt;"><font face="arial"><br></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial">Opportunity ID: '+opp.Opportunity_Id__c+'</font></div>'
    + '<div style="font-size: 12pt;"><font face="arial">Opportunity Name: '+opp.Name+'</font></div>'
    + '<div style="font-size: 12pt;"><font face="arial">Client Name: '+name+'</font></div>'
    + '<div style="font-size: 12pt;"><font face="arial">Opportunity Stage: '+opp.Status_Stage_Requested__c+ '&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</font></div>'
    + '<div style="font-size: 12pt;"><font face="arial"><b><br></b></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial"><b>What Do I Need to Do?</b></font></div><div style="font-size: 12pt;"><font face="arial"><b><br></b></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial" style="font-size: 12pt;"><b>Select the&nbsp;</b></font><b><span style="font-family: Arial, sans-serif;">best option from below that fits your opportunity pursuit at this point in time.&nbsp; Select only one (1):</span></b></div>'
    + '<div style="font-size: 12pt;"><font face="arial"><br></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial" style="font-size: 12pt;">1.&nbsp;</font><b><span style="font-family: Arial, sans-serif;">Implement the Engagement</span></b><b><span style="font-family: Arial, sans-serif;">-Specific Plan</span></b><span style="font-family: Arial, sans-serif;"> <b>found in the links below</b>&nbsp;</span><font style="font-size: 12pt;" face="arial">&nbsp;– </font><font face="arial">Review&nbsp;</font><span style="font-family: Arial, sans-serif;">engagement plan guidance with existing team members. New team members rolling on to the engagement should receive this information prior to performing any work for the engagement</span></div>'
    + '<div style="font-size: 12pt;"><font style="font-size: 12pt;" face="arial"><br></font></div>'
    + '<div><font face="arial" style="font-size: 12pt;">2. <b>Implement the&nbsp;</b></font><b><span style="font-family: Arial, sans-serif;">basic</span></b><span style="font-family: Arial, sans-serif; color: rgb(48, 48, 48); background-image: initial; background-attachment: initial; background-color: white; background-size: initial; background-origin: initial; background-clip: initial; background-position: initial; background-repeat: initial;">&nbsp;</span><span style="font-family: ' + 'Times New Roman, serif;"><a href="https://ts.accenturefederal.com/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/TCP%20Final%20(3).pdf"><span style="font-family: Arial, sans-serif;">AFS Technology Control Plan</span></a></span><span style="font-family: Arial, sans-serif;">&nbsp;(TCP)</span><font face="arial" style="font-size: 12pt;">&nbsp;</font><span style="font-size: 16px;">–</span><font face="arial" style="font-size: 12pt;">&nbsp;</font><span style="font-family: Arial, sans-serif;">Review trade compliance guidance addressed in the TCP with your team prior to opportunity escalation. Note: Upon hire, all AFS employees are required to review the TCP and take annual TCP training. Employees are required to review and sign off on the TCP</span><font face="arial" style="font-size: 12pt;">.</font></div><div style="font-size: 12pt;"><font face="arial"><br></font></div>'
    + '<div><font face="arial"><span style="font-size: 12pt;">3. </span><b style="font-size: 12pt;">Obtain&nbsp;AFS Global Team Guidance</b><span style="font-size: 12pt;"> – </span>If&nbsp;</font><span style="font-family: Arial, sans-serif;">your opportunity doesn’t fit options 1 and 2, contact </span><span style="font-family: Arial, sans-serif;">Barbara Overall: </span><span style="font-family: '+ 'Times New Roman, serif;"><a href="mailto:barbara.j.overall@accenturefederal.com"><span style="font-family: Arial, sans-serif;">barbara.j.overall@accenturefederal.com</span></a></span><span style="font-family: Arial, sans-serif;">.</span></div></div><div style="font-size: 12pt;"><font face="arial"><br></font></div>'
    + '<div style="font-size: 12pt;"><font face="arial"><b>Engagement-Specific Plans</b>:</font></div>'
    + '<div style="font-size: 12pt;"><font face="arial">1. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/AFMSTT%20Engagement%20Export%20Compliance%20Plan%200408.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Air Force Modeling and Simulation Training Toolkit (AFMSTT) </span><span style="font-family: Arial, sans-serif;">Engagement Trade Compliance Plan</span></a></div>'
    + '<div style="font-size: 12pt;"><font face="arial">2. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/AFMSTT%20Engagement%20Export%20Compliance%20Plan%200408.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Guidelines for Lean Six Sigma Engagements</span></a></div>'
    + '<div style="font-size: 12pt;"><font face="arial">3. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/US%20State%20Dept%20Integrated%20Logistics%20Management%20System%20Compliance%20Plan.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Integrated Logistics Management System (ILMS) Compliance Plan&nbsp;</span></a></div>'
    + '<p class="MsoNormal" style="font-size: 12pt;"><span style="font-family: Arial, sans-serif;"><o:p></o:p></span></p>'
    + '<div style="font-size: 12pt;"><font face="arial">4. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/JCDX%20Foreign%20Military%20Sales%20Compliance%20Plan%200408.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Joint Cross Domain eXchange (</span><span style="font-family: Arial, sans-serif;">JCDX) Foreign Military Sales Program Trade Compliance Plan</span></a></div>'
    + '<div style="font-size: 12pt;"><font face="arial">5. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/JCDX%20RoK%20On-Site%20Reps%20TAA%20Export%20Compliance%20Plan.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Joint Cross Domain eXchange/Republic of Korea (JCDX/ROK) Site Reps Trade Compliance Plan</span></a></div>'
    + '<div style="font-size: 12pt;"><font face="arial">6. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/MUOS%20Compliance%20Plan%200408.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Mobile User Objective System Satellite (MUOS) Program Trade Compliance Plan</span></a></div>'
    + '<div style="font-size: 12pt;"><font face="arial">7. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/NetCDS%20Export%20Compliance%20Plan%20%20073108.doc&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Net Centric Commanders’ Decision Services (</span><span style="font-family: Arial, sans-serif;">NetCDS) Engagement Trade Compliance Plan</span></a></div>'
    + '<div style="font-size: 12pt;"><font face="arial">8. &nbsp; &nbsp;</font><a href="https://ts.accenturefederal.com/sites/TradeCompliance/_layouts/WordViewer.aspx?id=/sites/TradeCompliance/Screening%20Guidance%20And%20Questions/Trade%20Compliance%20Plan%20for%20Services%20Involving%20U.S.%20Military%20Installations%20Abroad.docx&Source=https%3A%2F%2Fts%2Eaccenturefederal%2Ecom%2Fsites%2FTradeCompliance%2FScreening%2520Guidance%2520And%2520Questions%2FForms%2FAllItems%2Easpx&DefaultItemOpen=1&DefaultItemOpen=1"><span style="font-family: Arial, sans-serif;">Trade Compliance Plan for Services Involving Military Installations Abroad</span></a></div>'
    + '<div style="font-size: 12pt;"><br></div><div style="font-size: 12pt;"><font face="arial"><br></font></div>'
    + '<div style="font-size: 12pt;"><span style="font-size: 12pt;">If you need questions please contact Barbara Overall: </span><span style="font-size: 12pt;">&nbsp;&lt;barbara.j.overall@accenturefederal.com&gt;</span></div></div>'
    + '</td> '
    + '</tr> '
    + '</table>';
    
    return HTMLBODY;
   }
}