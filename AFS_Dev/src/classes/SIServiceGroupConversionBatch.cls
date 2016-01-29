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
    }        
        

}