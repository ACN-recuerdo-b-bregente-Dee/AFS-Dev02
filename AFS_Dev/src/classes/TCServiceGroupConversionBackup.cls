global class TCServiceGroupConversionBackup implements Database.Batchable<sObject>{
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
         String query = UTIL_Constants.TC_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        ServiceGroupConversion__c tcTC = ServiceGroupConversion__c.getValues('TC to TC');
        ServiceGroupConversion__c tcIC = ServiceGroupConversion__c.getValues('TC to IC');
        
        Decimal tcPercentage = 0.50;
        Decimal icPercentage = 0.50;
        if(tcTC.Active__c == true){
            tcPercentage = tcTC.Split_Percentage__c/100;
        }
        
        if(tcIC.Active__c == true){
            icPercentage = tcIC.Split_Percentage__c/100;
        }
        
        Set<Id> oppIds = insertLineItemSplit(oppLineItemList, tcPercentage, icPercentage);
        //insertAttributeSplit(oppIds, strategyPercentage, icPercentage);
     
    }
    
    private Set<Id> insertLineItemSplit(List<OpportunityLineItem> oppLineItemList, Decimal tcPercentage, Decimal icPercentage){
        List<OpportunityLineItem> toUpsert = new List<OpportunityLineItem>();
        OpportunityLineItem icOppLineItem = new OpportunityLineItem();
        OpportunityLineItem strategyOppLineItem = new OpportunityLineItem();
        
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where Product2.Name like '%IC%' OR Product2.Name like '%Strategy%']){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        Map<Id, AggregateResult> aggResult = new Map<Id, AggregateResult>([SELECT Opportunity_Name__c Id, SUM(AttributePercent__c) attributeSum FROM Attribute__c WHERE Attribute_Value__c like '%TC-ITS%' GROUP BY Opportunity_Name__c]);
        
        for(OpportunityLineItem oppLineItem: oppLineItemList){
            Decimal strategyPercentage = 0;
            if(aggResult.containsKey(oppLineItem.OpportunityId)){
                strategyPercentage = ((Decimal)aggResult.get(oppLineItem.OpportunityId).get('attributeSum'))/100;
            }
            
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
            
        
            Decimal tempIC = (1 - strategyPercentage)*icPercentage;
            icOppLineItem = new OpportunityLineItem();
            
            icOppLineItem.Revenue__c = oppLineItem.Revenue__c * tempIC;
            icOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * tempIC;
            icOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * tempIC;
            icOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * tempIC;
            icOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * tempIC;
            icOppLineItem.OpportunityId = oppLineItem.OpportunityId;
            icOppLineItem.Quantity = 1;
            icOppLineItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            icOppLineItem.Target_OI__c = oppLineItem.Target_OI__c;
            icOppLineItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            icOppLineItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
            if(oppLineItem.Product2.Name.equals('TC - CostPlus')){
                strategyOppLineItem.PricebookEntryId = pbNameMap.get('Strategy - CostPlus').Id;
                strategyOppLineItem.Type__c = pbNameMap.get('Strategy - CostPlus').Product2.Type__c;
                
                icOppLineItem.PricebookEntryId = pbNameMap.get('IC - CostPlus').Id;
                icOppLineItem.Type__c = pbNameMap.get('IC - CostPlus').Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals('TC - Fixed Price')){
                strategyOppLineItem.PricebookEntryId = pbNameMap.get('Strategy - Fixed Price').Id;
                strategyOppLineItem.Type__c = pbNameMap.get('Strategy - Fixed Price').Product2.Type__c;
                
                icOppLineItem.PricebookEntryId = pbNameMap.get('IC - Fixed Price').Id;
                icOppLineItem.Type__c = pbNameMap.get('IC - Fixed Price').Product2.Type__c;
            }
            else{
                strategyOppLineItem.PricebookEntryId = pbNameMap.get('Strategy - Time & Materials').Id;
                strategyOppLineItem.Type__c = pbNameMap.get('Strategy - Time & Materials').Product2.Type__c;
                
                icOppLineItem.PricebookEntryId = pbNameMap.get('IC - Time & Materials').Id;
                icOppLineItem.Type__c = pbNameMap.get('IC - Time & Materials').Product2.Type__c;
            }
            
            Decimal tempTC = (1 - strategyPercentage)*tcPercentage;
            
            oppLineItem.Revenue__c = oppLineItem.Revenue__c * tempTC;
            oppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * tempTC;
            oppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * tempTC;
            oppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * tempTC;
            oppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * tempTC;
            
            
            toUpsert.add(strategyOppLineItem);
            toUpsert.add(icOppLineItem);
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
    
    private void insertAttributeSplit(Set<Id> oppIds, Decimal strategyPercentage, Decimal icPercentage){
        System.debug(LoggingLevel.ERROR,'---------insertAttributeSplit()-----------');
        
        Map<String, Map<String, String>> attributeMap = retrieveAttributeMappings(UTIL_Constants.TGP_TC);
        List<Attribute__c> toUpdateAndInsert = new List<Attribute__c>();
        Attribute__c temp = new Attribute__c();
        boolean isChildLacking = false;
        for(Attribute__c attribute : [SELECT AttributePercent__c, Attribute_Type__c, Attribute_Value__c, Opportunity_Name__c FROM Attribute__c WHERE
                                        Attribute_Type__c = :UTIL_Constants.TGP_TC AND Opportunity_Name__c IN :oppIds]){
            
            isChildLacking = false;
            if(attributeMap.get(attribute.Attribute_Value__c).size() < 2){
                isChildLacking = true;
            }
            
            if(attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_Strategy)){
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
                temp.AttributeTxt__c = temp.AttributePercent__c + '%';
                temp.Attribute_TypeName__c = UTIL_Constants.TGP_Strategy;
                
                toUpdateAndInsert.add(temp);
            }
            
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_IC)){
                 attribute.Attribute_Type__c = UTIL_Constants.TGP_IC;
                 attribute.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_IC);
                 attribute.AttributeTxt__c = attribute.AttributePercent__c + '%';
                 attribute.Attribute_TypeName__c = attribute.Attribute_Type__c;
                 
                 toUpdateAndInsert.add(attribute);
            }
            
        }                                
             
             
        Database.upsert(toUpdateAndInsert);                            
    }
    
    private Map<String, Map<String, String>> retrieveAttributeMappings(String serviceGroup){
        System.debug(LoggingLevel.ERROR,'---------retrieveAttributeMappings()-----------');
        Map<String, Map<String, String>> attributeMap = new Map<String, Map<String, String>>();
        
        Map<String, SG_Split_Attribute_Mapping__c> nameMap = SG_Split_Attribute_Mapping__c.getAll();
        for(SG_Split_Attribute_Mapping__c attributeCS: nameMap.values()){
            if(attributeCS.SG_Origin__c.equals(serviceGroup)){
                if(!attributeMap.containsKey(attributeCS.Attribute_Value_Origin__c)){
                    attributeMap.put(attributeCS.Attribute_Value_Origin__c, new Map<String, String>());
                }
                if(!String.isEmpty(attributeCS.Child_Attribute_Offering_1__c) && !String.isEmpty(attributeCS.Child_Attribute_Value_1__c)){
                        System.debug(LoggingLevel.ERROR,'Child1---------'+attributeCS.Child_Attribute_Value_1__c+'-----------');
                        attributeMap.get(attributeCS.Attribute_Value_Origin__c).put(attributeCS.Child_Attribute_Offering_1__c,attributeCS.Child_Attribute_Value_1__c);
                }
                if(!String.isEmpty(attributeCS.Child_Attribute_Offering_2__c) && !String.isEmpty(attributeCS.Child_Attribute_Value_2__c)){
                        System.debug(LoggingLevel.ERROR,'Child2---------'+attributeCS.Child_Attribute_Value_2__c+'-----------');
                        attributeMap.get(attributeCS.Attribute_Value_Origin__c).put(attributeCS.Child_Attribute_Offering_2__c,attributeCS.Child_Attribute_Value_2__c);
                }
            }
        }
        
        return attributeMap;
    }
     
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}