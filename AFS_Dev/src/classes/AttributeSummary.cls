/**
   @Author Recuerdo B. Bregente
   @name CalculateFinancialSummaryBL
   @CreateDate 12/14/2015
   @Description Implementation Class for AttributeSummary
   @Version <1.0>
   @reference
  */
public class AttributeSummary{
   
   /**
    *  Aggregate value of Attribute TCR for digital and Non-Digital. 
    *  @name calculateAttributeSummary
    *  @param OpportunityLineItem[]
    *  @return void
    *  @throws exception
    */    
    public static void calculateAttributeSummary(Map<Id, OpportunityLineItem> newOpportunityLineItemMap){
        Set<Id> oppIds = new Set<ID>();
        
        for(OpportunityLineItem product : newOpportunityLineItemMap.values()){
            oppIds.add(product.OpportunityId);
        }
        
        Map<Id, Opportunity> oppAttrSummaryMap = new Map<Id, Opportunity>(
            [SELECT Id, (SELECT Id, Attribute_TCR__c, Name, Attribute_Percent__c FROM Attribute_Summary__r),
            (SELECT Id, Revenue__c FROM OpportunityLineItems),
            Digital_TCR__c, Total_Current_Revenue__c 
            FROM Opportunity WHERE Id IN :oppIds LIMIT 50000]);
    
        Map<Id, AttributeSummaryWrapper> oppWrapperMapUpdate = new Map<Id, AttributeSummaryWrapper>();
        Map<Id, AttributeSummaryWrapper> oppWrapperMapInsert = new Map<Id, AttributeSummaryWrapper>();
        List<Attribute_Summary__c> oppAttSum = new List<Attribute_Summary__c>();
        
        for(Id oppId : oppAttrSummaryMap.keySet()){
            oppAttSum = oppAttrSummaryMap.get(oppId).Attribute_Summary__r;
            
            if(oppAttSum.isEmpty()){
                oppWrapperMapInsert.put(oppId, initializeAttributeWrapper(oppId, getProductTCRSum(oppAttrSummaryMap.get(oppId).OpportunityLineItems)));
            }
            else{
                oppWrapperMapUpdate.put(oppId, createWrapper(oppAttSum, getProductTCRSum(oppAttrSummaryMap.get(oppId).OpportunityLineItems), oppId));
            }
        }
        
        Schema.DescribeFieldResult fieldResult = Attribute__c.Attribute_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Set<String> notAllowedAttrType = new Set<String>{'IO Offerings','MC Offerings','SI Offerings','TC Offerings','AO Offerings'};
        Set<String> allowedAttrType = new Set<String>();
        for( Schema.PicklistEntry f : ple)
        {
            if(!notAllowedAttrType.contains(f.getValue())){
                allowedAttrType.add(f.getValue());
            }
        }
        
        AttributeSummaryWrapper wrapper = null;
        for (AggregateResult aggRes : [
              SELECT SUM(AttributePercent__c) attrTCRSum,
              Opportunity_Name__c
              FROM Attribute__c
              WHERE Attribute_Type_Digital_or_Not__c = 'Digital' AND Attribute_Type__c IN :allowedAttrType
              GROUP BY Opportunity_Name__c
        ]) {
            Decimal tcrPercent = (Decimal) aggRes.get('attrTCRSum');
            Id oppId = (Id) aggRes.get('Opportunity_Name__c');
            
            if(oppWrapperMapInsert.containsKey(oppId)){
                wrapper = oppWrapperMapInsert.get(oppId);
                wrapper.digital.Attribute_TCR__c = wrapper.total.Attribute_TCR__c*(tcrPercent/100);
                wrapper.nonDigital.Attribute_TCR__c = wrapper.total.Attribute_TCR__c - wrapper.digital.Attribute_TCR__c;
                wrapper.digital.Attribute_Percent__c = tcrPercent;
                wrapper.nonDigital.Attribute_Percent__c = 100 - tcrPercent;
                oppWrapperMapInsert.put(oppId, wrapper);
            }
            
            if(oppWrapperMapUpdate.containsKey(oppId)){
                wrapper = oppWrapperMapUpdate.get(oppId);
                wrapper.digital.Attribute_TCR__c = wrapper.total.Attribute_TCR__c*(tcrPercent/100);
                wrapper.nonDigital.Attribute_TCR__c = wrapper.total.Attribute_TCR__c - wrapper.digital.Attribute_TCR__c;
                wrapper.digital.Attribute_Percent__c = tcrPercent;
                wrapper.nonDigital.Attribute_Percent__c = 100 - tcrPercent;
                oppWrapperMapUpdate.put(oppId, wrapper);
            }
        }
        
        List<Attribute_Summary__c> attSumInsert = new List<Attribute_Summary__c>();
        
        for(AttributeSummaryWrapper wrapperObj : oppWrapperMapInsert.values()){
            attSumInsert.add(wrapperObj.digital);
            attSumInsert.add(wrapperObj.nonDigital);
            attSumInsert.add(wrapperObj.total);
        }
        
        List<Attribute_Summary__c> attSumUpdate = new List<Attribute_Summary__c>();
        
        
        for(AttributeSummaryWrapper wrapperObj : oppWrapperMapUpdate.values()){
            if(wrapperObj.digital.Id <> null){
                attSumUpdate.add(wrapperObj.digital);
            }
            else{
                attSumInsert.add(wrapperObj.digital);
            }
            
            if(wrapperObj.nonDigital.Id <> null){
                attSumUpdate.add(wrapperObj.nonDigital);
            }
            else{
                attSumInsert.add(wrapperObj.nonDigital);
            }
            
            if(wrapperObj.total.Id <> null){
                attSumUpdate.add(wrapperObj.total);
            }
            else{
                attSumInsert.add(wrapperObj.total);
            }
        }
        
        Database.insert(attSumInsert);
        Database.update(attSumUpdate);
        
    }
    
    public Class AttributeSummaryWrapper{
        Attribute_Summary__c digital {get; set;}
        Attribute_Summary__c nonDigital {get; set;}
        Attribute_Summary__c total {get; set;}
        
        public AttributeSummaryWrapper(Attribute_Summary__c digital, Attribute_Summary__c nonDigital, Attribute_Summary__c total){
            this.digital = digital;
            this.nonDigital = nonDigital;
            this.total = total;
        }
    }
    
    public static AttributeSummaryWrapper initializeAttributeWrapper(Id oppId, Decimal TCR){
        Attribute_Summary__c digital = new Attribute_Summary__c(
                                        Name = 'Digital',
                                        Attribute_TCR__c = 0.00,
                                        Attribute_Type_Digital_or_Non_digital__c = 'Digital',
                                        Summary_Level__c = '2',
                                        Attribute_Percent__c = 0.00,
                                        Opportunity__c = oppId);
        Attribute_Summary__c nonDigital = new Attribute_Summary__c(
                                        Name = 'Non Digital',
                                        Attribute_TCR__c = TCR,
                                        Attribute_Type_Digital_or_Non_digital__c = 'Non-digital',
                                        Summary_Level__c = '2',
                                        Attribute_Percent__c = 100.00,
                                        Opportunity__c = oppId);
        Attribute_Summary__c total = new Attribute_Summary__c(
                                        Name = 'Total',
                                        Attribute_TCR__c = TCR,
                                        Summary_Level__c = '1',
                                        Attribute_Percent__c = 100.00,
                                        Opportunity__c = oppId);
                                        
        return new AttributeSummaryWrapper(digital, nonDigital, total);
    }
    
    public static AttributeSummaryWrapper createWrapper(List<Attribute_Summary__c> attributeSummaries, Decimal TCR, Id oppId){
        Attribute_Summary__c digital;
        Attribute_Summary__c nonDigital;
        Attribute_Summary__c total;
        
        for(Attribute_Summary__c attrSum : attributeSummaries){
            if(attrSum.Name == 'Non Digital'){
                nonDigital = attrSum;
                nonDigital.Attribute_TCR__c = TCR;
                nonDigital.Attribute_Percent__c = 100.00;
            }
            else if(attrSum.Name == 'Digital'){
                digital = attrSum;
                digital.Attribute_TCR__c = 0.00;
                digital.Attribute_Percent__c = 0.00;
            }
            else{
                total = attrSum;
                total.Attribute_TCR__c = TCR;
                total.Attribute_Percent__c = 100.00;
            }
        }
        
        if(digital == null){
            digital = new Attribute_Summary__c(
                                        Name = 'Digital',
                                        Attribute_TCR__c = 0.00,
                                        Attribute_Type_Digital_or_Non_digital__c = 'Digital',
                                        Summary_Level__c = '2',
                                        Attribute_Percent__c = 0.00,
                                        Opportunity__c = oppId);
        }
        
        
        if(nonDigital == null){
            nonDigital = new Attribute_Summary__c(
                                        Name = 'Non Digital',
                                        Attribute_TCR__c = TCR,
                                        Attribute_Type_Digital_or_Non_digital__c = 'Non-digital',
                                        Summary_Level__c = '2',
                                        Attribute_Percent__c = 100.00,
                                        Opportunity__c = oppId);
        }
        
        if(total == null){
            total = new Attribute_Summary__c(
                                        Name = 'Total',
                                        Attribute_TCR__c = TCR,
                                        Summary_Level__c = '1',
                                        Attribute_Percent__c = 100.00,
                                        Opportunity__c = oppId);
        }
        
        
        return new AttributeSummaryWrapper(digital, nonDigital, total);
        
    }
    
    public static Decimal getProductTCRSum(List<OpportunityLineItem> productItems){
        Decimal productSum = 0;
        for(OpportunityLineItem productItem : productItems){
            productSum = productSum + productItem.Revenue__c;
        }
        
        return productSum;
    } 
}