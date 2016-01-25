/**
   @Author: Honelee F. Padilla
   @name: OpportunityBL()
   @CreateDate: 04/14/2015
   @Description: Business logic that will require fields to related objects of Opportunity,
                 reschedule revenue of Opportunity Line items and populate Complexity Description of Opportunity
   @Version <1.0>
   @reference <Referenced program names>
*/
public class OpportunityBL {
    
    /*
    *  To require fields on the related objects of Opportunity. 
    *  @name   requireFields()
    *  @param  newOpportunity    mapped of current opportunity
    *  @return void
    *  @throws exception-NA
    */
    public static String requireFields(Map<Id, Opportunity> oldOpportunityMap,Opportunity[] newOpportunity) {
    
    List<Opportunitylineitem> oppLineItem = new List<Opportunitylineitem>();
    List<Opportunity_Team_Roles__c> oppTeamRole = new List<Opportunity_Team_Roles__c>();
    List<Opportunity> oppValue = new List<Opportunity>();
    String oppErrorMessage = UTIL_Constants.STRING_EMPTY;
    
    
    Set<Id> opplineSetId = new Set<Id>();
       
    //Profile p = [SELECT Id FROM Profile WHERE Name='AFS Standard User'];
    //if(p.Id != UserInfo.getProfileId()) {
        
    Opportunity opps = (Opportunity) Trigger.new[0];
    
               
    for(Opportunity OppId : newOpportunity){
        opplineSetId.add(OppId.id);     
    }
    oppValue.addAll(newOpportunity);
    System.debug('newOpportunity: ' + newOpportunity);
    oppLineItem = [SELECT Id, OpportunityId , Type__c, Total_Costs__c, Revenue__c, Subcontractor_Expenses__c,
                   Service_Group_Text__c,Other_Cost_Components__c,HW_SW_Costs__c, Cost_Components_N_A__c 
                   FROM OpportunityLineItem WHERE OpportunityId in : opplineSetId LIMIT 50000];
    
    oppTeamRole = [SELECT Id,Name__c,Opportunity_Name__c,Role__c 
                   FROM Opportunity_Team_Roles__c 
                   WHERE Opportunity_Name__c in : opplineSetId LIMIT 50000];
    
    Map<String, Custom_Error_Messages__c> cem = Custom_Error_Messages__c.getAll();
    
    for(Opportunity Opp : oppValue){
        
        if(oldOpportunityMap.containsKey(Opp.id) && oldOpportunityMap.get(Opp.id).Status_Stage_Requested__c != Opp.Status_Stage_Requested__c){
            System.debug('----Opp.Status_Stage_Requested__c'+Opp.Status_Stage_Requested__c);
            for(Opportunitylineitem oppline: oppLineItem){
                //Validating consulting Start/End date
                if(oppline.OpportunityId.equals(Opp.Id)){
                    if(oppline.Type__c != null){
                        //Validate if Consulting type of work
                        //if (oppline.Type_of_Work__c.equals('Consulting')){
                        if(oppline.Type__c.equals(UTIL_Constants.PRODUCT_TC) || oppline.Type__c.equals(UTIL_Constants.PRODUCT_MC) || oppline.Type__c.equals(UTIL_Constants.PRODUCT_SI)) {
                            //Consulting Start Date cannot be updated to null if type of work is Consulting  
                            if(Opp.Consulting_Start__c == null && Opp.Consulting_End__c != null){
                                oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_057).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                             }
                            //Consulting End Date cannot be updated to null if type of work is Consulting  
                            if(Opp.Consulting_End__c == null && Opp.Consulting_Start__c != null){
                                oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_058).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                            }
                        }
                        //Validate if type of work is Outsourcing
                        //if (oppline.Type_of_Work__c.equals('Outsourcing')){
                        if(oppline.Type__c.equals(UTIL_Constants.PRODUCT_BPO) || oppline.Type__c.equals(UTIL_Constants.PRODUCT_AO) || oppline.Type__c.equals(UTIL_Constants.PRODUCT_IO)) {
                            //Outsourcing Start Date cannot be updated to null if type of work is Outsourcing
                            if(Opp.Outsourcing_Start__c == null && Opp.Outsourcing_End__c != null ){
                              oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_059).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                            }
                            //Outsourcing End Date cannot be updated to null if type of work is Outsourcing
                            if(Opp.Outsourcing_End__c == null && Opp.Outsourcing_Start__c != null){
                              oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_060).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                            }
                          
                        }
                    }
                }
            }
        

        String [] stage_2A = UTIL_Constants.STAGEREQ_2A_3.split(UTIL_Constants.STRING_COMMA);
        for(String stageName : stage_2A){
            //Validate Status Stage requested 2A,2B,3
            if (Opp.Status_Stage_Requested__c.equals(stageName)){
                //Validate if Type and Hierarchy Level are not null
                if(Opp.type != null && Opp.Hierarchy_Level__c != null){
                    //Check for Opp type equals Extension and TDP greater or equal to 10M
                    // Samuel Morin Modified 10/15/2015 to include 'Option' Opportunity Types
                    if((Opp.type.equals(UTIL_Constants.OPP_TYPE_EXTENSION) || Opp.type.equals(UTIL_Constants.OPP_TYPE_OPTION)) && Opp.Total_deal_Potential__c >= 10000){
                        if(!oppTeamRole.isEmpty()){
                             Integer dirRoleExt = 0;
                             for(Opportunity_Team_Roles__c oppTeamRoles :oppTeamRole){
                                 if(oppTeamRoles.Opportunity_Name__c.equals(Opp.Id)){
                                     //Check if there is an existing Opportunity QA Director Role
                                     if(oppTeamRoles.Role__c.equals(UTIL_Constants.OPP_TEAM_ROLE_OPP_QA_DIRECTOR)){
                                         ++dirRoleExt;
                                     }
                                 }
                             }
                             //Required Opportunity QA Director role if counter is 0. 
                             if(dirRoleExt == 0){
                                 oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_061).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                             }

                        }else{
                            oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_061).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                        }                        
                    }
                     //Validate Status Stage Requested not equals 0 or Client Withdrew or AFS Withdrew or Closed Won or Closed Lost and Hierarchy Level equals Contract Vehicle
                     if((!Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_0) || !Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_CLIENT_WITHDREW) || !Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_AFS_WITHDREW) || !Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_WON) || !Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_LOST))) { //&& !Opp.Hierarchy_Level__c.equals('Contract Vehicle')){
                        //Check for Opp type not equals Extension and TDP greater or equal to 1M
                        // Samuel Morin Modified 10/15/2015 to include 'Option Opportunity Types
                        if(!Opp.type.equals(UTIL_Constants.OPP_TYPE_EXTENSION) && Opp.Total_deal_Potential__c >= 1000 && !Opp.type.equals(UTIL_Constants.OPP_TYPE_OPTION)){
                            if(!oppTeamRole.isEmpty()){
                                Integer dirRoleNoExt = 0;
                                for(Opportunity_Team_Roles__c oppTeamRoles :oppTeamRole){  
                                    //Check if there is an existing Opportunity QA Director Role   
                                    if(oppTeamRoles.Role__c.equals(UTIL_Constants.OPP_TEAM_ROLE_OPP_QA_DIRECTOR)){
                                        ++dirRoleNoExt ;
                                    }
                                }
                                
                                //Required Opportunity QA Director role if counter is 0.   
                                if(dirRoleNoExt== 0){
                                    oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_062).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                                }

                            }else{
                                oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_062).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                            }                        
                        }
                    } 
                }
            }     
        }   
        String [] typeNamez = UTIL_Constants.STAGEREQ_1A_3.split(UTIL_Constants.STRING_COMMA);
        for(String typeName : typeNamez){
            //Validate Status Stage requested 1A,1B,2A,2B,3                          

        //Validate for Opportunity Director Role in Opportunity Team Roles
        if (Opp.Status_Stage_Requested__c.equals(typeName)){
            if(!oppTeamRole.isEmpty()){
                Integer dirRoleOD = 0;
                for(Opportunity_Team_Roles__c oppTeamRoles :oppTeamRole){
                    if(oppTeamRoles.Opportunity_Name__c.equals(Opp.Id)){
                    //Check if there is an existing Opportunity Director Role
                        if(oppTeamRoles.Role__c.equals(UTIL_Constants.OPP_TEAM_ROLE_OPP_DIRECTOR)){
                            ++dirRoleOD;
                        }
                    }
                }
                //Required Opportunity Director role if counter is 0. 
                if(dirRoleOD == 0){
                    oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_054).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                System.debug('---1.1');
                }
            }else{
                System.debug('---1.2');
                oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_054).Error_Message__c+ UTIL_Constants.STRING_BREAK;
            }
            System.debug('---oppErrorMessage2'+oppErrorMessage);
        }
        
        } 
        
        //Code Fix apply here for stages 2A, 2B and 3 for Opportunity Financials related list

        String [] typeNames = UTIL_Constants.STAGEREQ_2A_3.split(UTIL_Constants.STRING_COMMA);
        if(Opp.Hierarchy_Level__c != null){
            if((Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_0)) || (Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_CLIENT_WITHDREW)) || (Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_AFS_WITHDREW)) || (Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_WON)) || (Opp.Status_Stage_Requested__c.equals(UTIL_Constants.STAGENAME_LOST))){

           }else{
                //TCR is required if Hierarchy Level equals Contract Vehicle for stages 1A and beyond
                if (!Opp.Hierarchy_Level__c.equals(UTIL_Constants.OPP_HIERARCHY_LEVEL_CONTRACT_VEHICLE)){
                    if(Opp.Total_Current_Revenue__c == 0 || Opp.Total_Current_Revenue__c == null){
                        oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_067).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                    }
                }
            }            
            for(String typeName : typeNames){
                
                if (Opp.Status_Stage_Requested__c.equals(typeName)){
                    for(OpportunityLineItem oppline : oppLineItem){ 
                        //When Cost Components N/A Checkbox is unchecked Cost Components are required
                        if(oppLine.Cost_Components_N_A__c==false){                                              
                            if(oppLine.HW_SW_Costs__c != null && oppLine.Subcontractor_Expenses__c != null && oppLine.Other_Cost_Components__c != null){
                                Integer total = Integer.valueOf(oppLine.HW_SW_Costs__c)+Integer.valueOf(oppLine.Subcontractor_Expenses__c)+Integer.valueOf(oppLine.Other_Cost_Components__c);
                                //Check Total cost component greater that total cost and Check if Total cost components equals zero
                                if(total == 0||total > oppLine.Total_Costs__c){
                                    if(!oppErrorMessage.contains(cem.get(UTIL_Constants.ERROR_MSG_OPP_065).Error_Message__c)){
                                        oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_065).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                                    }
                                    
                                }
                            } 
                            // Check for blank or zero value of HW/SW Costs, Subcontractor Expenses or Other Cost Components
                            else{
                                if(oppLine.HW_SW_Costs__c == null && oppLine.Subcontractor_Expenses__c == null &&    oppLine.Other_Cost_Components__c == null){
                                    if(!oppErrorMessage.contains(cem.get(UTIL_Constants.ERROR_MSG_OPP_065).Error_Message__c)){
                                        oppErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + cem.get(UTIL_Constants.ERROR_MSG_OPP_065).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                                    }
                                }
                            }
                                        
                        }  
                    }
                }
            }
                }
            }
            
        }
       
        System.debug('---oppErrorMessage'+oppErrorMessage);
        return oppErrorMessage;

    }
    
    /**
    *  To populate Complexity Description field from the custom settings value.
    *  @name   populateComplexityCategory()
    *  @param  newOpportunities   map of current opportunities
    *  @return void
    *  @throws exception-NA
    */
    public static void populateComplexityCategory(Opportunity[] newOpportunities) {
        // Fetch all the Complexity Categories in the custom setting
        Map<String, Complexity_Description__c> categories = Complexity_Description__c.getAll();

        for (Opportunity opp : newOpportunities) {
                String value = UTIL_Constants.STRING_EMPTY;
                //Check if Complexity Category is not null
                if (opp.Complexity_Category__c != null) {
                    for(String key : categories.keyset()) {
                        if (categories.get(key).Abbreviated__c != null) {
                            //If Complexity Category contains the Abbreviated description assign the corresponding Complete value
                            if (opp.Complexity_Category__c.contains(categories.get(key).Abbreviated__c)) {
                                value += categories.get(key).Complete__c + UTIL_Constants.STRING_SEMI_COLON + UTIL_Constants.STRING_NEW_LINE;
                            }
                        }

                    }
                    //Assign Complexity Description from collected Complete value description
                    if (value != UTIL_Constants.STRING_EMPTY) {
                        opp.Complexity_Description__c = value.substring(0, value.length()-2);
                        
                    }
                    //Assign Complexity Description to blank if value is blank
                    else {
                        opp.Complexity_Description__c = UTIL_Constants.STRING_EMPTY;
                    }
                }
                //Assign value to blank if Complex Category is blank
                else {
                    opp.Complexity_Description__c = UTIL_Constants.STRING_EMPTY;
                }
        }
    }

    
    /**
    *  To populate Stage Entry Dates in Opportunity
    *  @name   populateStageEntryDates()
    *  @param  oldOpportunities,newOpportunities
    *  @return void
    *  @throws exception-NA
    */
    public static void populateStageEntryDates(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities)  {
    
        for (Integer i = 0; i < newOpportunities.size(); i++) {
            
            for(Opportunity opp : newOpportunities ) {
    
                if (oldOpportunities[i].Approved_Status_Stage__c != newOpportunities[i].Approved_Status_Stage__c) {
            System.debug('newOpportunities[i].Approved_Status_Stage__c'+newOpportunities[i].Approved_Status_Stage__c);
            
                
                //this is to populate the Stage Entry Date
                    if(opp.Approved_Status_Stage__c.equals(UTIL_Constants.STAGENAME_1A)) {
                        opp.Stage_1A_Entry_Date__c = System.Today();
                    } 
                    if (opp.Approved_Status_Stage__c.equals(UTIL_Constants.STAGENAME_1B)) {
                        opp.Stage_1B_Entry_Date__c = System.Today();
                    }
                    if (opp.Approved_Status_Stage__c.equals(UTIL_Constants.STAGENAME_2A)) {
                        opp.Stage_2A_Entry_Date__c = System.Today();
                    } 
                    if (opp.Approved_Status_Stage__c.equals(UTIL_Constants.STAGENAME_2B)) {
                        opp.Stage_2B_Entry_Date__c = System.Today();  
                    } 
                    if (opp.Approved_Status_Stage__c.equals(UTIL_Constants.STAGENAME_3)) {
                        opp.Stage_3_Entry_Date__c = System.Today();
                    }
                }
            }
        }
    }
    
    
    /**
    *  Trade Compliance Team Guidance Email to be Routed to the Opp Director
    *  @name   sendEmailToLegal()
    *  @param  oldOpportunityMap,newOpportunity
    *  @return void
    *  @throws exception-NA
    */
    public static void sendEmailToLegal(Opportunity[] oldOpportunityVal,Opportunity[] newOpportunity) {
        Set<Id> opplineSetId = new Set<Id>();
        Set<Id> personId = new Set<Id>();
        List<Opportunity> oppArr = new List<Opportunity>();
        
        List<Opportunity_Team_Roles__c> oppTeamRole = new List<Opportunity_Team_Roles__c>();
        List<Person__c> per = new List<Person__c>();
        List<Opportunity> oppValue = new List<Opportunity>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        List<String> ccTo = new List<String>();
        List<String> PersonName = new List<String>();
        Map<String, LegalEmail__c> legalEmail = LegalEmail__c.getAll();

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        
        for(Opportunity OppId : newOpportunity){
            opplineSetId.add(OppId.id);     
        }
        
        oppArr = [Select id, name, account.id from opportunity where id =:opplineSetId ];
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Id IN (SELECT AccountId from opportunity where id =:opplineSetId)];
        
        oppValue.addAll(newOpportunity);
        oppTeamRole = [SELECT Id,Name__c,Opportunity_Name__c,Role__c FROM Opportunity_Team_Roles__c WHERE Opportunity_Name__c in : opplineSetId and role__c =: UTIL_Constants.OPPDIRECTOR LIMIT 50000];
        
        for(Opportunity_Team_Roles__c oppTR : oppTeamRole){
            personId.add(oppTR.Name__c);
        }
        
        per = [SELECT Id,Email__c FROM Person__c where id =: personId];
        
        for (Integer i = 0; i < newOpportunity.size(); i++) {
            
                Integer compCount = 0;
               
                if(newOpportunity[i].Subject_countries_client_operates__c != null && newOpportunity[i].Client_Industry_Area_of_Service__c != null && newOpportunity[i].Export_Transfer_of_Products_Software__c != null 
                && newOpportunity[i].The_Opportunity_involves_activities_now__c != null){
                    if(newOpportunity[i].Subject_countries_client_operates__c != oldOpportunityVal[i].Subject_countries_client_operates__c || newOpportunity[i].Client_Industry_Area_of_Service__c != oldOpportunityVal[i].Client_Industry_Area_of_Service__c 
                    || newOpportunity[i].Export_Transfer_of_Products_Software__c != oldOpportunityVal[i].Export_Transfer_of_Products_Software__c || newOpportunity[i].The_Opportunity_involves_activities_now__c != oldOpportunityVal[i].The_Opportunity_involves_activities_now__c ){
                        if(newOpportunity[i].Subject_countries_client_operates__c.equals(UTIL_Constants.NONEAPPLY) && newOpportunity[i].Client_Industry_Area_of_Service__c.equals(UTIL_Constants.NONEAPPLY)
                         && newOpportunity[i].Export_Transfer_of_Products_Software__c.trim().equals(UTIL_Constants.STRING_NO) && newOpportunity[i].The_Opportunity_involves_activities_now__c.equals(UTIL_Constants.STRING_NO)){
                            ++compCount;
                        }
                    }
                }
                
                
                
                if(compCount != 0){
                        
                        if(oppTeamRole != null){
                            For(Opportunity_Team_Roles__c oppTM : oppTeamRole){
                                if(oppTM.Opportunity_Name__c.equals(newOpportunity[i].id)){
                                        PersonName.add(oppTM.Name__c);
                                }
                            }
                        }
                        
                        if(per != null){
                            for(Person__c pers : per){
                                for(String perName : PersonName){   
                                    if(pers.id.equals(perName)){
                                        sendTo.add(pers.Email__c);
                                    }                   
                                }
                            }
                        }
                        
                        /*if(legalEmail.get(UTIL_Constants.BARBARA_OVERALL).Email__c != null){
                            ccTo.add(legalEmail.get(UTIL_Constants.BARBARA_OVERALL).Email__c);
                            mail.setCcAddresses(ccTo);
                        }*/
                        
                        mail.setSubject(UTIL_Constants.TRADECOMP);
                        mail.setHtmlBody(UTIL_Constants.tradeComplianceHTML(newOpportunity[i], accounts));
                            
                        mail.setToAddresses(sendTo);
                        mails.add(mail);
                }
            }
        if(sendTo != null){
            Messaging.sendEmail(mails);         
        }
    }  
}