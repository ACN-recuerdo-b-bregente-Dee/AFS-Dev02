/******************************************************************************************************************************
* Name        - UpdateMCFinancialDetailsBatch 
* Description - This batch class splits all the MC Opporunity Lime Items into Strategy and MC Opportunity Line Items.
*        
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Lhea Valencia           01/08/2016             Initial creation.
* Lhea Valencia           03/17/2016             Modify code based on new requirement
* Lhea Valencia           03/23/2016             Address best practices
* ******************************************************************************************************************************/
global class UpdateMCFinancialDetailsBatch implements Database.Batchable<sObject>{
     
    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        //Retrieves the query from the UTIL_Constants class
        String query = UTIL_Constants.MC_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        
        //Calls the method for Financial Details Split and Attribute Split
        Set<Id> oppIds = insertLineItemSplit(oppLineItemList);
        insertAttributeSplit(oppIds);
     
    }
    
    /* Method for Financial Details Split which accepts Opportunity Line Items and % Splits for Strategy and MC */
    private Set<Id> insertLineItemSplit(List<OpportunityLineItem> oppLineItemList){
        //Create an instance of List which holds the  OpportunityLineItem to insert and to update.
        List<OpportunityLineItem> toUpsert = new List<OpportunityLineItem>();
        
        //Create an instance of OpportunityLineItem which holds the values for Strategy Opportunity Line Item record.
        OpportunityLineItem strategyOppLineItem = new OpportunityLineItem();
        
        //Retrieves all the Pricebook entries related to Strategy Opportunity Line Item.
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where Product2.Name like :UTIL_Constants.QUERY_WILDCARD_STRATEGY]){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        //Retrieves the aggregated sum of Attribute % of Strategy Attribute Value by Opportunity ID
        Map<Id, AggregateResult> aggResult = new Map<Id, AggregateResult>([SELECT Opportunity_Name__c Id, SUM(AttributePercent__c) attributeSum FROM Attribute__c WHERE Attribute_Type__c =:UTIL_Constants.MC_OFERRING AND Attribute_Value__c = :UTIL_Constants.Strategy GROUP BY Opportunity_Name__c]);
        
        //Iterates through all the Opportunity Line Item records and create a new Strategy Opportunity Line Item.
        //Updates the current MC Opportunity Line Item record
        for(OpportunityLineItem oppLineItem: oppLineItemList){
            Decimal strategyPercentage = 0;
            if(aggResult.containsKey(oppLineItem.OpportunityId)){
                strategyPercentage = ((Decimal)aggResult.get(oppLineItem.OpportunityId).get('attributeSum'))/100;
                
                strategyOppLineItem = new OpportunityLineItem();
            
                strategyOppLineItem.Revenue__c = oppLineItem.Revenue__c * strategyPercentage;
                strategyOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * strategyPercentage;
                strategyOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * strategyPercentage;
                strategyOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * strategyPercentage;
                strategyOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * strategyPercentage;
                strategyOppLineItem.OpportunityId = oppLineItem.OpportunityId;
                strategyOppLineItem.Quantity = 1;
                strategyOppLineItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
                strategyOppLineItem.Target_OI__c = oppLineItem.Target_OI__c;
                strategyOppLineItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
                strategyOppLineItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            }
                       
            if(oppLineItem.Product2.Name.equals(UTIL_Constants.MC_COSTPLUS)){
                strategyOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.STRATEGY_COSTPLUS).Id;
                strategyOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.STRATEGY_COSTPLUS).Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals(UTIL_Constants.MC_FIXEDPRICE )){
                strategyOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.STRATEGY_FIXEDPRICE).Id;
                strategyOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.STRATEGY_FIXEDPRICE).Product2.Type__c;
            }
            else{
                strategyOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.STRATEGY_MATERIALS).Id;
                strategyOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.STRATEGY_MATERIALS).Product2.Type__c;
            }
            
            
            Decimal mcPercentage = (1 - strategyPercentage);
                    
            oppLineItem.Revenue__c = oppLineItem.Revenue__c * mcPercentage;
            oppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * mcPercentage;
            oppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * mcPercentage;
            oppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * mcPercentage;
            oppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * mcPercentage;               
            
            if(strategyPercentage != 0){
                toUpsert.add(strategyOppLineItem);
            }
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
    
    /* Method for Attribute split which accepts Set of Opportunity Ids and % Splits for Strategy and MC */
    private void insertAttributeSplit(Set<Id> oppIds){
        System.debug(LoggingLevel.ERROR,'---------insertAttributeSplit()-----------');
        
        // Calls the method for retrieving all the attribute split mapping for MC Service Group
        Map<String, Map<String, String>> attributeMap = retrieveAttributeMappings(UTIL_Constants.MC_OFERRING);
        
        // Initializes all the object instance needed for the Attribute Split
        List<Attribute__c> toUpdateAndInsert = new List<Attribute__c>();
        Attribute__c temp = new Attribute__c();
        boolean isChildLacking = false;
        
        // Retrieves  all Attribute records from all of the Opportunities specified in the parameter.
        // Loops through each of the Attribute records.
        for(Attribute__c attribute : [SELECT AttributePercent__c, Attribute_Type__c, Attribute_Value__c, Opportunity_Name__c FROM Attribute__c WHERE
                                        Attribute_Type__c = :UTIL_Constants.MC_OFERRING AND Opportunity_Name__c IN :oppIds]){
            
            isChildLacking = false;
            // Sets identifier for child count to true if the size of the Attribute Split Map for the current record is less than 2.
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).size() < 2){
                isChildLacking = true;
            }
            
            // Sets the child attribute for Strategy if key for S Offerings exists in the map for Attribute Split
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
            
            // Sets the child attribute for MC if key MC Offerings exists in the Map for Attribute Split.
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.MC_OFERRING)){
                 attribute.Attribute_Type__c = UTIL_Constants.MC_OFERRING;
                 attribute.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.MC_OFERRING);
                 attribute.AttributeTxt__c = attribute.AttributePercent__c + UTIL_Constants.DEFAULT_PERCENT_STRING;
                 attribute.Attribute_TypeName__c = attribute.Attribute_Type__c;
                 
                 toUpdateAndInsert.add(attribute);
            }
            
        }                                
             
             
        Database.upsert(toUpdateAndInsert);                            
    }
    
    /* 
    *  Method for retrieving all the Attribute mappings of the SG Group specified in the parameter.
    *  Attribute mappings are retrieved from the custom settings. */
    private Map<String, Map<String, String>> retrieveAttributeMappings(String serviceGroup){
        
        Map<String, Map<String, String>> attributeMap = new Map<String, Map<String, String>>();
        
        // Retrieves all the attribute split mappings from the Custom Settings.
        Map<String, SG_Split_Attribute_Mapping__c> nameMap = SG_Split_Attribute_Mapping__c.getAll();
        
        // Filters all the Attribute Split Mappings for the Specified SG Group and stores it to a Map
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