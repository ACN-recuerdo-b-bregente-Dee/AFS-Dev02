global class UpdateMCFinancialDetailsBatch implements Database.Batchable<sObject>{
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
         String query = UTIL_Constants.MC_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        ServiceGroupConversion__c mcToMC = ServiceGroupConversion__c.getValues('MC to MC');
        ServiceGroupConversion__c mcToStrategy = ServiceGroupConversion__c.getValues('MC to Strategy');
        
        Decimal mcPercentage = 0.50;
        Decimal stratPercentage = 0.50;
        if(mcToMC.Active__c == true){
            mcPercentage = mcToMC.Split_Percentage__c/100;
        }
        
        if(mcToStrategy.Active__c == true){
            stratPercentage = mcToStrategy.Split_Percentage__c/100;
        }
        
        List<OpportunityLineItem> toInsert = new List<OpportunityLineItem>();
        OpportunityLineItem strategyOppLineItem = new OpportunityLineItem();
        
        List<PricebookEntry> priceBooks = [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where Product2.Name like '%Strategy%'];
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : priceBooks){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        for(OpportunityLineItem oppLineItem: oppLineItemList){            
        
            strategyOppLineItem = new OpportunityLineItem();
            
            strategyOppLineItem.Revenue__c = oppLineItem.Revenue__c * stratPercentage;
            strategyOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * stratPercentage;
            strategyOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * stratPercentage;
            strategyOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * stratPercentage;
            strategyOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * stratPercentage;
            strategyOppLineItem.OpportunityId = oppLineItem.OpportunityId;
            strategyOppLineItem.Quantity = 1;
            strategyOppLineItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            strategyOppLineItem.Target_OI__c = oppLineItem.Target_OI__c;
            strategyOppLineItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            strategyOppLineItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
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
            
            oppLineItem.Revenue__c = oppLineItem.Revenue__c * mcPercentage;
            oppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * mcPercentage;
            oppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * mcPercentage;
            oppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * mcPercentage;
            oppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * mcPercentage;            
            
            toInsert.add(strategyOppLineItem);
            toInsert.add(oppLineItem);
            
        }
        
        Database.upsert(toInsert);
     
    }
     
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}