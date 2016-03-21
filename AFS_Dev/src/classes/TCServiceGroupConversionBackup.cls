/******************************************************************************************************************************
* Name        - TC_ServiceGroup_Conversion_Backup 
* Description - This batch class splits all the TC Opporunity Lime Items into Strategy, IC and TC Opportunity Line Items.
*               This will also split TC Offerings Attributes to S Offerings, IC Offerings and TC Offerings Attributes.
*        
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Recuerdo Bregente           03/21/2016             Initial creation.
* ******************************************************************************************************************************/
global class TCServiceGroupConversionBackup implements Database.Batchable<sObject>{
    
    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Retrieves the query from the UTIL_Constants class
        String query = UTIL_Constants.TC_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        //Retrieves the TC to TC and TC to IC % Split from the custom settings.
        ServiceGroupConversion__c tcTC = ServiceGroupConversion__c.getValues(UTIL_Constants.CUSTOM_SETTING_TC_TO_TC);
        ServiceGroupConversion__c tcIC = ServiceGroupConversion__c.getValues(UTIL_Constants.CUSTOM_SETTING_TC_TO_IC);
        
        //Sets the value of TC and IC percentage split temporarily and update it with
        //values from custom settings when customg settings value is active.
        Decimal tcPercentage = UTIL_Constants.DEFAULT_FIFTY_PERCENTAGE;
        Decimal icPercentage = UTIL_Constants.DEFAULT_FIFTY_PERCENTAGE;
        if(tcTC.Active__c == true){
            tcPercentage = tcTC.Split_Percentage__c/UTIL_Constants.DEFAULT_HUNDRED;
        }
        
        if(tcIC.Active__c == true){
            icPercentage = tcIC.Split_Percentage__c/UTIL_Constants.DEFAULT_HUNDRED;
        }
        
        //Calls the method for Financial Details Split and Attribute Split
        Set<Id> oppIds = insertLineItemSplit(oppLineItemList, tcPercentage, icPercentage);
        insertAttributeSplit(oppIds);
     
    }
    
    /* Method for Financial Details Split which accepts Opportunity Line Items and % Splits for TC and IC */
    private Set<Id> insertLineItemSplit(List<OpportunityLineItem> oppLineItemList, Decimal tcPercentage, Decimal icPercentage){
        //Create an instance of List which holds the  OpportunityLineItem to insert and to update.
        List<OpportunityLineItem> toUpsert = new List<OpportunityLineItem>();
        
        //Create an instance of OpportunityLineItem which holds the values for IC Opportunity Line Item record.
        OpportunityLineItem icOppLineItem = new OpportunityLineItem();
        
        //Create an instance of OpportunityLineItem which holds the values for Strategy Opportunity Line Item record.
        OpportunityLineItem strategyOppLineItem = new OpportunityLineItem();
        
        //Retrieves all the Pricebook entries related to IC and IC Opportunity Line Items.
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where 
                                            Product2.Name like :UTIL_Constants.QUERY_WILDCARD_IC OR Product2.Name like :UTIL_Constants.QUERY_WILDCARD_STRATEGY]){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        //Retrieves the aggregated sum of Attribute % of all attributes by Opportunity ID
        Map<Id, AggregateResult> aggResult = new Map<Id, AggregateResult>([SELECT Opportunity_Name__c Id, SUM(AttributePercent__c) attributeSum FROM 
                                                                Attribute__c WHERE Attribute_Value__c like :UTIL_Constants.QUERY_WILDCARD_TC_ITS GROUP BY Opportunity_Name__c]);
        
        //Iterates through all the Opportunity Line Item records and create a new Strategy and IC Opportunity Line Items.
        //Updates the current Opportunity Line Item record using the TC to TC % Split from Custom Settings.
        for(OpportunityLineItem oppLineItem: oppLineItemList){
            Decimal strategyPercentage = UTIL_Constants.DEFAULT_ZERO_DECIMAL;
            if(aggResult.containsKey(oppLineItem.OpportunityId)){
                strategyPercentage = ((Decimal)aggResult.get(oppLineItem.OpportunityId).get('attributeSum'))/UTIL_Constants.DEFAULT_HUNDRED;
                
                strategyOppLineItem = new OpportunityLineItem();
            
                strategyOppLineItem.Revenue__c = oppLineItem.Revenue__c * strategyPercentage;
                strategyOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * strategyPercentage;
                strategyOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * strategyPercentage;
                strategyOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * strategyPercentage;
                strategyOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * strategyPercentage;
                strategyOppLineItem.OpportunityId = oppLineItem.OpportunityId;
                strategyOppLineItem.Quantity = UTIL_Constants.DEFAULT_ONE_DECIMAL;
                strategyOppLineItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
                strategyOppLineItem.Target_OI__c = oppLineItem.Target_OI__c;
                strategyOppLineItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
                strategyOppLineItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            }
            
        
            Decimal tempIC = (UTIL_Constants.DEFAULT_ONE_DECIMAL - strategyPercentage)*icPercentage;
            icOppLineItem = new OpportunityLineItem();
            
            icOppLineItem.Revenue__c = oppLineItem.Revenue__c * tempIC;
            icOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * tempIC;
            icOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * tempIC;
            icOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * tempIC;
            icOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * tempIC;
            icOppLineItem.OpportunityId = oppLineItem.OpportunityId;
            icOppLineItem.Quantity = UTIL_Constants.DEFAULT_ONE_DECIMAL;
            icOppLineItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            icOppLineItem.Target_OI__c = oppLineItem.Target_OI__c;
            icOppLineItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            icOppLineItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
            if(oppLineItem.Product2.Name.equals(UTIL_Constants.TC_COSTPLUS)){
                if(strategyPercentage != 0){
                    strategyOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.STRATEGY_COSTPLUS).Id;
                    strategyOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.STRATEGY_COSTPLUS).Product2.Type__c;
                }
                
                icOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.IC_COSTPLUS).Id;
                icOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.IC_COSTPLUS).Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals(UTIL_Constants.TC_FIXEDPRICE)){
                if(strategyPercentage != 0){
                    strategyOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.STRATEGY_FIXEDPRICE).Id;
                    strategyOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.STRATEGY_FIXEDPRICE).Product2.Type__c;
                }
                
                icOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.IC_FIXEDPRICE).Id;
                icOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.IC_FIXEDPRICE).Product2.Type__c;
            }
            else{
                if(strategyPercentage != 0){
                    strategyOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.STRATEGY_MATERIALS).Id;
                    strategyOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.STRATEGY_MATERIALS).Product2.Type__c;
                }
                
                icOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.IC_MATERIALS).Id;
                icOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.IC_MATERIALS).Product2.Type__c;
            }
            
            Decimal tempTC = (1 - strategyPercentage)*tcPercentage;
            
            oppLineItem.Revenue__c = oppLineItem.Revenue__c * tempTC;
            oppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * tempTC;
            oppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * tempTC;
            oppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * tempTC;
            oppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * tempTC;
            
            if(strategyPercentage != 0){
                toUpsert.add(strategyOppLineItem);
            }
            toUpsert.add(icOppLineItem);
            toUpsert.add(oppLineItem);
        }
        
        //Stores all the Id of Opportunity Line Items which are successfully inserted or updated.
        Set<Id> successlineItemIds = new Set<Id>();
        for (Database.UpsertResult sr : Database.upsert(toUpsert, false)) {
            if (sr.isSuccess()) {
                successlineItemIds.add(sr.getId());
            }
        }
        
        Set<Id> oppIds = new Set<Id>();
        
        //Stores the parent Opportunity Id of all the Opportunity Line Items which are successfully inserted or updated.
        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
        for(OpportunityLineItem lineItemRecord : [SELECT OpportunityId FROM OpportunityLineItem WHERE Id IN :successlineItemIds]){
            oppIds.add(lineItemRecord.OpportunityId);
        }
        
        return oppIds;
    }
    
    /* Method for Attribute split which accepts Set of Opportunity Ids and % Splits for Strategy and IC */
    private void insertAttributeSplit(Set<Id> oppIds){
        System.debug(LoggingLevel.ERROR,'---------insertAttributeSplit()-----------');
        
        // Calls the method for retrieving all the attribute split mapping for TC Service Group
        Map<String, Map<String, String>> attributeMap = retrieveAttributeMappings(UTIL_Constants.TGP_TC);
        
        // Initializes all the object instances needed for the Attribute Split
        List<Attribute__c> toUpdateAndInsert = new List<Attribute__c>();
        Attribute__c temp = new Attribute__c();
        boolean isChildLacking = false;
        
        // Retrieves  all Attribute records from all of the Opportunities specified in the parameter.
        // Loops through each of the Attribute records.
        for(Attribute__c attribute : [SELECT AttributePercent__c, Attribute_Type__c, Attribute_Value__c, Opportunity_Name__c FROM Attribute__c WHERE
                                        Attribute_Type__c = :UTIL_Constants.TGP_TC AND Opportunity_Name__c IN :oppIds]){
            
            isChildLacking = false;
            // Sets identifier for child count to true if the size of the Attribute Split Map for the current record is less than 2.
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).size() < UTIL_Constants.DEFAULT_TWO_DECIMAL){
                isChildLacking = true;
            }
            
            // Sets the child attribute for TC if key for S Offerings exists in the map for Attribute Split
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_Strategy)){
                System.debug(LoggingLevel.ERROR,'---------'+attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_Strategy)+'-----------');
                if(!isChildLacking){
                    temp = new Attribute__c();
                    temp.Opportunity_Name__c = attribute.Opportunity_Name__c;
                }
                else{
                    temp = attribute;
                }
                
                temp.Attribute_Type__c = UTIL_Constants.TGP_Strategy;
                temp.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_Strategy);
                temp.AttributePercent__c = attribute.AttributePercent__c;
                temp.AttributeTxt__c = temp.AttributePercent__c + UTIL_Constants.DEFAULT_PERCENT_STRING;
                temp.Attribute_TypeName__c = UTIL_Constants.TGP_Strategy;
                
                toUpdateAndInsert.add(temp);
            }
            
            // Sets the child attribute for TC if key IC Offerings exists in the Map for Attribute Split.
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_IC)){
                 attribute.Attribute_Type__c = UTIL_Constants.TGP_IC;
                 attribute.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_IC);
                 attribute.AttributeTxt__c = attribute.AttributePercent__c + UTIL_Constants.DEFAULT_PERCENT_STRING;
                 attribute.Attribute_TypeName__c = attribute.Attribute_Type__c;
                 
                 toUpdateAndInsert.add(attribute);
            }
            
        }                                
             
             
        Database.upsert(toUpdateAndInsert);                            
    }
    
    /* 
    *  Method for retrieving all the Attribute mappings of the TC Group specified in the parameter.
    *  Attribute mappings are retrieved from the custom settings. */
    private Map<String, Map<String, String>> retrieveAttributeMappings(String serviceGroup){
        Map<String, Map<String, String>> attributeMap = new Map<String, Map<String, String>>();
        
        // Retrievs all the attribute split mappings from the Custom Settings.
        Map<String, SG_Split_Attribute_Mapping__c> nameMap = SG_Split_Attribute_Mapping__c.getAll();
        
        // Filters all the Attribute Split Mappings for the Specified TC Service Group and stores it to a Map
        for(SG_Split_Attribute_Mapping__c attributeCS: nameMap.values()){
            if(attributeCS.SG_Origin__c.equals(serviceGroup)){
                if(!attributeMap.containsKey(attributeCS.Attribute_Value_Origin__c)){
                    attributeMap.put(attributeCS.Attribute_Value_Origin__c, new Map<String, String>());
                }
                if(!String.isEmpty(attributeCS.Child_Attribute_Offering_1__c) && !String.isEmpty(attributeCS.Child_Attribute_Value_1__c)){
                        attributeMap.get(attributeCS.Attribute_Value_Origin__c).put(attributeCS.Child_Attribute_Offering_1__c,attributeCS.Child_Attribute_Value_1__c);
                }
                if(!String.isEmpty(attributeCS.Child_Attribute_Offering_2__c) && !String.isEmpty(attributeCS.Child_Attribute_Value_2__c)){
                        attributeMap.get(attributeCS.Attribute_Value_Origin__c).put(attributeCS.Child_Attribute_Offering_2__c,attributeCS.Child_Attribute_Value_2__c);
                }
            }
        }
        
        return attributeMap;
    }
    
    /* Any post-processing will be run here */
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}