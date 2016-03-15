global class SIServiceGroupConversionBatch implements Database.Batchable<sObject> {
    //Purpose: to begin the lifecycle of the batch operation, startup activities
    //Parameters: 
    //				context (Database.BatchableContext) = 
    //Output: none
    global Database.QueryLocator start(Database.BatchableContext context){
        String query = Util_Constants.SI_SG_CONVERSION_BATCHQUERY;
        System.debug('in start');
        return Database.getQueryLocator(query);
    }
    
    //Purpose: to start the logic behind the batch operation
    //Parameters: 
    //				context (Database.BatchableContext) = 
    //				lineItems (List<OpportunityLineItem) = list of the line items to be updated
    //Output: none
    global void execute(Database.BatchableContext context, List<OpportunityLineItem> lineItems){
        //get service group split percentages from custom settigs
        ServiceGroupConversion__c siToSi = ServiceGroupConversion__c.getValues('SI to SI');
        ServiceGroupConversion__c siToTc = ServiceGroupConversion__c.getValues('SI to TC');
        System.debug('in exec');
        //convert from custom settings to percentage
        Decimal siPercentage, tcPercentage = 0.0;
        if(siToSi.Active__c == true){
            siPercentage = siToSi.Split_Percentage__c/100;
        }else{
            System.debug('siToSi not active');
        }
        
        if(siTotc.Active__c == true){
            tcPercentage = siToTc.Split_Percentage__c/100;
        }else{
            System.debug('siToTc not active');
        }
        
        //do splits and inserts
        Set<id> oppIds = insertLineItemSplit(lineItems, siPercentage, tcPercentage);
        insertAttributeSplit(oppIds, siPercentage, tcPercentage);
    }        
    
    //Purpose: To split the line items into the new categories with the new split percentages
    //Parameters:
    //				lineItems (List<OpportunityLineItems) = list of line items to split
    //				siPercentage (Decimal) = percentage to split the si line items
    //				tcPercentage (Decimal) = percentage to split the tc line items
    //Output:
    //				Set<id> = Set of the ids that were added to the database
    private Set<id> insertLineItemSplit(List<OpportunityLineItem> lineItems, Decimal siPercentage, Decimal tcPercentage){
        List<OpportunityLineItem> toInsert = new List<OpportunityLineItem>();
        OpportunityLineItem tcItem = new OpportunityLineItem();
        OpportunityLineItem siItem = new OpportunityLineItem();
        System.debug('in insert');
        Map<String, PricebookEntry> pbMap = new Map<String, PricebookEntry>();
        for(PricebookEntry entry: [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry WHERE Product2.Name LIKE '%SI%' OR Product2.Name LIKE '%TC%']){
            pbMap.put(entry.Product2.Name, entry);
        }
        
        //edit each line item
        Set<id> opps = new Set<id>();
        for(OpportunityLineItem oppLineItem: lineItems){
            System.debug('Enter For loop');
            opps.add(oppLineItem.Opportunity.Id);
            
            //edit the details of the line item
            tcItem = new OpportunityLineItem();
            tcItem.Revenue__c = oppLineItem.Revenue__c * tcPercentage;
            tcItem.Total_Costs__c = oppLineItem.Total_Costs__c * tcPercentage;
            tcItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * tcPercentage;
            tcItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * tcPercentage;
            tcItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * tcPercentage;
            tcItem.OpportunityId = oppLineItem.OpportunityId;
            tcItem.Quantity = 1;
            tcItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            tcItem.Target_OI__c = oppLineItem.Target_OI__c;
            tcItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            tcItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
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
            
            //edit the name & id of the line items
            if(oppLineItem.Product2.Name.equals('SI - CostPlus')){
                tcItem.PricebookEntryId = pbMap.get('TC - CostPlus').Id;
                tcItem.Type__c = pbMap.get('TC - CostPlus').Product2.Type__c;
                siItem.PricebookEntryId = pbMap.get('SI - CostPlus').Id;
                siItem.Type__c = pbMap.get('SI - CostPlus').Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals('SI - Fixed Price')){
                tcItem.PricebookEntryId = pbMap.get('TC - Fixed Price').Id;
                tcItem.Type__c = pbMap.get('TC - Fixed Price').Product2.Type__c;
                siItem.PricebookEntryId = pbMap.get('SI - Fixed Price').Id;
                siItem.Type__c = pbMap.get('SI - Fixed Price').Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals('SI - Time & Materials')){
                tcItem.PricebookEntryId = pbMap.get('TC - Time & Materials').Id;
                tcItem.Type__c = pbMap.get('TC - Time & Materials').Product2.Type__c;
                siItem.PricebookEntryId = pbMap.get('SI - Time & Materials').Id;
                siItem.Type__c = pbMap.get('SI - Time & Materials').Product2.Type__c;
            }
            
            //add the items to the lists to add to the database all at once for database efficiency
            toInsert.add(tcItem);
            toInsert.add(siItem);
            System.debug('added '+tcItem.Name +' '+ siItem.name);
        }
        
        //replace the old line items with the new split items
        System.debug('exit for loop');
        insert toInsert;
        delete lineItems;
        return opps;  
    }

    //Purpose: To split the attributes into the new categories with the new split percentages
    //Parameters:
    //				opps (Set<id>) = list of attributes to split
    //				siPercentage (Decimal) = percentage to split the si line items
    //				tcPercentage (Decimal) = percentage to split the tc line items
    //Output:
    //				none
    private void insertAttributeSplit(Set<id> opps, Decimal siPercentage, Decimal tcPercentage){
        List<Attribute__c> toUpsert = new List<Attribute__c>();
        Attribute__c siAttribute, tcAttribute;
        
        //update all attributes that have the type of SI Offerings and are found in opps
        for(Attribute__c current: [SELECT AttributePercent__c, Attribute_Type__c, Attribute_Value__c, Opportunity_Name__c FROM Attribute__c WHERE
                                        Attribute_Type__c = 'SI Offerings' AND Opportunity_Name__c IN :opps]){
            //edit and add to upsert list TC attributes
            tcAttribute = new Attribute__c();
            tcAttribute.Attribute_Type__c = 'TC Offerings';
            tcAttribute.Attribute_Value__c = current.Attribute_Value__c.replace('SI-','TC-');
            tcAttribute.AttributePercent__c = current.AttributePercent__c * tcPercentage;
            tcAttribute.AttributeTxt__c = current.AttributePercent__c * tcPercentage + '%';
            tcAttribute.Attribute_TypeName__c = 'TC Offerings';
            tcAttribute.Opportunity_Name__c = current.Opportunity_Name__c;
            toUpsert.add(tcAttribute);
            
            //edit and add to upsert list SI attributes
            siAttribute = new Attribute__c();
            siAttribute.Attribute_Type__c = 'SI Offerings';
            siAttribute.Attribute_Value__c = current.Attribute_Value__c;
            siAttribute.AttributePercent__c = current.AttributePercent__c * siPercentage;
            siAttribute.AttributeTxt__c = current.AttributePercent__c * siPercentage + '%';
            siAttribute.Attribute_TypeName__c = 'SI Offerings';
            siAttribute.Opportunity_Name__c = current.Opportunity_Name__c;
            toUpsert.add(siAttribute);
        }
        //upsert all updated attributes
        upsert toUpsert;
    }
    
    //Purpose: to end the lifecycle of the batch operation, cleanup activities
    //Parameters: 
    //				context (Database.BatchableContext) = 
    //Output: none
    global void finish(Database.BatchableContext context){
        System.debug('in finish');
    }

}