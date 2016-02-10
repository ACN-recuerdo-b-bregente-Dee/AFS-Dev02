global class SIServiceGroupConversionBatch {
    
    global Database.QueryLocator start(Database.BatchableContext context){
        String query = Util_Constants.SI_SG_CONVERSION_BATCHQUERY;
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext context, List<OpportunityLineItem> lineItems){
        //get service group split percentages from custom settigs
        ServiceGroupConversion__c siToSi = ServiceGroupConversion__c.getValues('SI to SI');
        ServiceGroupConversion__c siToIc = ServiceGroupConversion__c.getValues('SI to TC');
        
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
        
        Map<String, PricebookEntry> pbMap = new Map<String, PricebookEntry>();
        for(PricebookEntry entry: [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry WHERE Product2.Name LIKE '%SI%' OR Product2.Name LIKE '%TC%']){
            pbMap.put(entry.Product2.Name, entry);
        }
        
        Set<id> opps = new Set<id>();
        for(OpportunityLineItem oppLineItem: lineItems){
            opps.add(oppLineItem.Opportunity.Id);
            
            
        }
        return new Set<id>();  
    }
    
    private void insertAttributeSplit(Set<id> opps, Decimal siPercentage, Decimal icPercentaege){
        
    }
    
    global void finish(Database.BatchableContext context){
        
    }

}