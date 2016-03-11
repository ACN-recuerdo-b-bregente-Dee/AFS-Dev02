global class SIServiceGroupConversionBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext context){
        String query = Util_Constants.SI_SG_CONVERSION_BATCHQUERY;
        System.debug('in start');
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext context, List<OpportunityLineItem> lineItems){
        //get service group split percentages from custom settigs
        ServiceGroupConversion__c siToSi = ServiceGroupConversion__c.getValues('SI to SI');
        ServiceGroupConversion__c siToIc = ServiceGroupConversion__c.getValues('SI to TC');
        System.debug('in exec');
        //convert from custom settings to percentage
        Decimal siPercentage, icPercentage = 0.0;
        if(siToSi.Active__c == true){
            siPercentage = siToSi.Split_Percentage__c/100;
        }else{
            System.debug('siToSi not active');
        }
        
        if(siToIc.Active__c == true){
            icPercentage = siToIc.Split_Percentage__c/100;
        }else{
            System.debug('siToIc not active');
        }
        
        //do splits and insert
        Set<id> oppIds = insertLineItemSplit(lineItems, siPercentage, icPercentage);
        insertAttributeSplit(oppIds, siPercentage, icPercentage);
    }        
    
    private Set<id> insertLineItemSplit(List<OpportunityLineItem> lineItems, Decimal siPercentage, Decimal icPercentage){
        List<OpportunityLineItem> toInsert = new List<OpportunityLineItem>();
        OpportunityLineItem icItem = new OpportunityLineItem();
        OpportunityLineItem siItem = new OpportunityLineItem();
        System.debug('in insert');
        Map<String, PricebookEntry> pbMap = new Map<String, PricebookEntry>();
        for(PricebookEntry entry: [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry WHERE Product2.Name LIKE '%SI%' OR Product2.Name LIKE '%TC%']){
            pbMap.put(entry.Product2.Name, entry);
        }
        
        Set<id> opps = new Set<id>();
        for(OpportunityLineItem oppLineItem: lineItems){
            opps.add(oppLineItem.Opportunity.Id);
            
            icItem = new OpportunityLineItem();
            icItem.Revenue__c = oppLineItem.Revenue__c * icPercentage;
            icItem.Total_Costs__c = oppLineItem.Total_Costs__c * icPercentage;
            icItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * icPercentage;
            icItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * icPercentage;
            icItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * icPercentage;
            icItem.OpportunityId = oppLineItem.OpportunityId;
            icItem.Quantity = 1;
            icItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            icItem.Target_OI__c = oppLineItem.Target_OI__c;
            icItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            icItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
            siItem = new OpportunityLineItem();
            siItem.Revenue__c = oppLineItem.Revenue__c * siPercentage;
            siItem.Total_Costs__c = oppLineItem.Total_Costs__c * siPercentage;
            siItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * siPercentage;
            siItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * siPercentage;
            siItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * siPercentage;
            siItem.OpportunityId = oppLineItem.OpportunityId;
            siItem.Quantity = 1;
            siItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            siItem.Target_OI__c = oppLineItem.Target_OI__c;
            siItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            siItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
            //switch(oppLineItem.Product2.Name)
            
            toInsert.add(icItem);
            toInsert.add(siItem);
            System.debug('added '+icItem.Name +' '+ siItem.name);
        }
        
        System.debug('exit for loop');
        Database.insert(toInsert);
        Database.delete(lineItems);
        return opps;  
    }
    
    private void insertAttributeSplit(Set<id> opps, Decimal siPercentage, Decimal icPercentaege){
        
    }
    
    global void finish(Database.BatchableContext context){
        System.debug('in finish');
    }

}