global class TCServiceGroupConversionBackup implements Database.Batchable<sObject>{
    
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
         String query = UTIL_Constants.TC_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        ServiceGroupConversion__c tcStrategy = ServiceGroupConversion__c.getValues('TC to Strategy');
        ServiceGroupConversion__c tcIC = ServiceGroupConversion__c.getValues('TC to IC');
        
        Decimal strategyPercentage = 0.50;
        Decimal icPercentage = 0.50;
        if(tcStrategy.Active__c == true){
            strategyPercentage = tcStrategy.Split_Percentage__c/100;
        }
        
        if(tcIC.Active__c == true){
            icPercentage = tcIC.Split_Percentage__c/100;
        }
        
        Set<Id> oppIds = insertLineItemSplit(oppLineItemList, strategyPercentage, icPercentage);
        insertAttributeSplit(oppIds, strategyPercentage, icPercentage);
     
    }
    
    private Set<Id> insertLineItemSplit(List<OpportunityLineItem> oppLineItemList, Decimal strategyPercentage, Decimal icPercentage){
        List<OpportunityLineItem> toInsert = new List<OpportunityLineItem>();
        OpportunityLineItem icOppLineItem = new OpportunityLineItem();
        OpportunityLineItem strategyOppLineItem = new OpportunityLineItem();
        
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where Product2.Name like '%IC%' OR Product2.Name like '%Strategy%']){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        Map<Id,Id> lineItemAndOppIds = new Map<Id,Id>();
        for(OpportunityLineItem oppLineItem: oppLineItemList){
            lineItemAndOppIds.put(oppLineItem.Id, oppLineItem.Opportunity.Id);
            
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
            
        
            icOppLineItem = new OpportunityLineItem();
            
            icOppLineItem.Revenue__c = oppLineItem.Revenue__c * icPercentage;
            icOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * icPercentage;
            icOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * icPercentage;
            icOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * icPercentage;
            icOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * icPercentage;
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
            
            toInsert.add(strategyOppLineItem);
            toInsert.add(icOppLineItem);
            
        }
        
        Set<Id> oppIds = new Set<Id>();
        for (Database.SaveResult sr : Database.insert(toInsert, false)) {
            if (sr.isSuccess()) {
                oppIds.add(lineItemAndOppIds.get(sr.getId()));
            }
        }
        Database.delete(oppLineItemList);
        
        return oppIds;
    }
    
    private void insertAttributeSplit(Set<Id> oppIds, Decimal strategyPercentage, Decimal icPercentage){
        
        Map<String, Map<String, String>> attributeMap = retrieveAttributeMappings(UTIL_Constants.TGP_TC);
        List<Attribute__c> toUpdateAndInsert = new List<Attribute__c>();
        for(Attribute__c attribute : [SELECT AttributePercent__c, Attribute_Type__c, Attribute_Value__c, Opportunity_Name__c FROM Attribute__c WHERE
                                        Attribute_Type__c = :UTIL_Constants.TGP_TC AND Opportunity_Name__c IN :oppIds]){
            
            if(attributeMap.get(attribute.Attribute_Value__c).size() < 2){
                strategyPercentage = 1;
                icPercentage = 1;
            }
            
            if(attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_Strategy)){
                toUpdateAndInsert.add(new Attribute__c(
                    Attribute_Type__c = UTIL_Constants.TGP_Strategy,
                    Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_Strategy),
                    AttributePercent__c = attribute.AttributePercent__c * strategyPercentage,
                    AttributeTxt__c = attribute.AttributePercent__c * strategyPercentage + '%',
                    Attribute_TypeName__c = UTIL_Constants.TGP_Strategy,
                    Opportunity_Name__c = attribute.Opportunity_Name__c));
            }
            
            if(attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_IC)){
                 attribute.Attribute_Type__c = UTIL_Constants.TGP_IC;
                 attribute.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_IC);
                 attribute.AttributePercent__c = attribute.AttributePercent__c * icPercentage;
                 attribute.AttributeTxt__c = attribute.AttributePercent__c + '%';
                 attribute.Attribute_TypeName__c = attribute.Attribute_Type__c;
                 
                 toUpdateAndInsert.add(attribute);
            }
            
        }                                
             
             
        Database.upsert(toUpdateAndInsert);                            
    }
    
    private Map<String, Map<String, String>> retrieveAttributeMappings(String serviceGroup){
        Map<String, Map<String, String>> attributeMap = new Map<String, Map<String, String>>();
        
        Map<String, SG_Split_Attribute_Mapping__c> nameMap = SG_Split_Attribute_Mapping__c.getAll();
        for(SG_Split_Attribute_Mapping__c attributeCS: nameMap.values()){
            if(attributeCS.SG_Origin__c.equals(serviceGroup)){
                if(!attributeMap.containsKey(attributeCS.Attribute_Value_Origin__c)){
                    attributeMap.put(attributeCS.Attribute_Value_Origin__c, new Map<String, String>());
                }
                else{
                    if(!String.isEmpty(attributeCS.Child_Attribute_Offering_1__c) && !String.isEmpty(attributeCS.Child_Attribute_Value_1__c)){
                        attributeMap.get(attributeCS.Attribute_Value_Origin__c).put(attributeCS.Child_Attribute_Offering_1__c,attributeCS.Child_Attribute_Value_1__c);
                    }
                    if(!String.isEmpty(attributeCS.Child_Attribute_Offering_2__c) && !String.isEmpty(attributeCS.Child_Attribute_Value_2__c)){
                        attributeMap.get(attributeCS.Attribute_Value_Origin__c).put(attributeCS.Child_Attribute_Offering_2__c,attributeCS.Child_Attribute_Value_2__c);
                    }
                }
            }
        }
        
        return attributeMap;
    }
     
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}