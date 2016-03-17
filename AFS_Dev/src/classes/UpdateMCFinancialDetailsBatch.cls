/******************************************************************************************************************************
* Name        - UpdateMCFinancialDetailsBatch 
* Description - This batch class splits all the MC Opporunity Lime Items into Strategy and MC Opportunity Line Items.
*        
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Lhea Valencia           01/08/2016             Initial creation.
* Lhea Valencia           03/17/2016             Update the code based on the new requirement.
* ******************************************************************************************************************************/
global class UpdateMCFinancialDetailsBatch implements Database.Batchable<sObject>{
     
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
    
        //Retrieves the query from the UTIL_Constants class
        String query = UTIL_Constants.MC_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        
        Set<Id> oppIds = insertLineItemSplit(oppLineItemList);
        //insertAttributeSplit(oppIds, strategyPercentage, icPercentage);
     
    }
    
    private Set<Id> insertLineItemSplit(List<OpportunityLineItem> oppLineItemList){
        List<OpportunityLineItem> toUpsert = new List<OpportunityLineItem>();
        OpportunityLineItem icOppLineItem = new OpportunityLineItem();
        OpportunityLineItem strategyOppLineItem = new OpportunityLineItem();
        
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where Product2.Name like '%Strategy%']){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        Map<Id, AggregateResult> aggResult = new Map<Id, AggregateResult>([SELECT Opportunity_Name__c Id, SUM(AttributePercent__c) attributeSum FROM Attribute__c WHERE Attribute_Type__c ='MC Offerings' AND Attribute_Value__c = 'Strategy' GROUP BY Opportunity_Name__c]);
        
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
                       
            if(oppLineItem.Product2.Name.equals('MC - CostPlus')){
                strategyOppLineItem.PricebookEntryId = pbNameMap.get('Strategy - CostPlus').Id;
                strategyOppLineItem.Type__c = pbNameMap.get('Strategy - CostPlus').Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals('MC - Fixed Price')){
                strategyOppLineItem.PricebookEntryId = pbNameMap.get('Strategy - Fixed Price').Id;
                strategyOppLineItem.Type__c = pbNameMap.get('Strategy - Fixed Price').Product2.Type__c;
            }
            else{
                strategyOppLineItem.PricebookEntryId = pbNameMap.get('Strategy - Time & Materials').Id;
                strategyOppLineItem.Type__c = pbNameMap.get('Strategy - Time & Materials').Product2.Type__c;
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
        
        Set<Id> successlineItemIds = new Set<Id>();
        for (Database.UpsertResult sr : Database.upsert(toUpsert, false)) {
            if (sr.isSuccess()) {
                successlineItemIds.add(sr.getId());
            }
        }
        
        Set<Id> oppIds = new Set<Id>();
        
        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
        for(OpportunityLineItem lineItemRecord : [SELECT OpportunityId FROM OpportunityLineItem WHERE Id IN :successlineItemIds]){
            oppIds.add(lineItemRecord.OpportunityId);
        }
        
        return oppIds;
    }
    
 
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}