/******************************************************************************************************************************
* Name        - SI_ServiceGroup_Conversion_Backup 
* Description - This batch class splits all the SI Opporunity Lime Items into TC and SI Opportunity Line Items.
*               This will also split SI Offerings Attributes to TC Offerings and SI Offerings Attributes.
*        
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Recuerdo Bregente           03/16/2016             Initial creation.
* ******************************************************************************************************************************/
global class SIServiceGroupConversionBackup implements Database.Batchable<sObject>{
    
    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Retrieves the query from the UTIL_Constants class
        String query = UTIL_Constants.SI_SG_CONVERSION_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> oppLineItemList){
        //Retrieves the SI to TC and SI to SI % Split from the custom settings.
        ServiceGroupConversion__c siToTC = ServiceGroupConversion__c.getValues(UTIL_Constants.CUSTOM_SETTING_SI_TO_TC);
        ServiceGroupConversion__c siToSI = ServiceGroupConversion__c.getValues(UTIL_Constants.CUSTOM_SETTING_SI_TO_SI);
        
        //Sets the value of si and tc percentage split temporarily and update it with
        //values from custom settings when customg settings value is active.
        Decimal tcPercentage = UTIL_Constants.DEFAULT_FIFTY_PERCENTAGE;
        Decimal siPercentage = UTIL_Constants.DEFAULT_FIFTY_PERCENTAGE;
        if(siToTC.Active__c == true){
            tcPercentage = siToTC.Split_Percentage__c/UTIL_Constants.DEFAULT_HUNDRED;
        }
        
        if(siToSI.Active__c == true){
            siPercentage = siToSI.Split_Percentage__c/UTIL_Constants.DEFAULT_HUNDRED;
        }
        
        //Calls the method for Financial Details Split and Attribute Split
        Set<Id> oppIds = insertLineItemSplit(oppLineItemList, tcPercentage, siPercentage);
        insertAttributeSplit(oppIds);
     
    }
    
    /* Method for Financial Details Split which accepts Opportunity Line Items and % Splits for TC and SI */
    private Set<Id> insertLineItemSplit(List<OpportunityLineItem> oppLineItemList, Decimal tcPercentage, Decimal siPercentage){
        //Create an instance of List which holds the  OpportunityLineItem to insert and to update.
        List<OpportunityLineItem> toUpsert = new List<OpportunityLineItem>();
        //Create an instance of OpportunityLineItem which holds the values for TC Opportunity Line Item record.
        OpportunityLineItem tcOppLineItem = new OpportunityLineItem();
        
        //Retrieves all the Pricebook entries related to TC Opportunity Line Item.
        List<PricebookEntry> priceBooks = [SELECT Id, Product2.Name, Product2.Type__c FROM PricebookEntry Where Product2.Name like :UTIL_Constants.QUERY_WILDCARD_TC];
        
        //Creates a map instance of Pricebook Entry with Product Name as the key.
        Map<String, PricebookEntry> pbNameMap = new Map<String, PricebookEntry>();
        for(PricebookEntry pricebookEntry : priceBooks){
            pbNameMap.put(pricebookEntry.Product2.Name, pricebookEntry);
        }
        
        //Iterates through all the Opportunity Line Item records and create a new TC Opportunity Line Item.
        //Updates the current Opportunity Line Item record using the SI to SI % Split from Custom Settings.
        for(OpportunityLineItem oppLineItem: oppLineItemList){            
        
            tcOppLineItem = new OpportunityLineItem();
            
            tcOppLineItem.Revenue__c = oppLineItem.Revenue__c * tcPercentage;
            tcOppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * tcPercentage;
            tcOppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * tcPercentage;
            tcOppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * tcPercentage;
            tcOppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * tcPercentage;
            tcOppLineItem.OpportunityId = oppLineItem.OpportunityId;
            tcOppLineItem.Quantity = 1;
            tcOppLineItem.Cost_Components_N_A__c = oppLineItem.Cost_Components_N_A__c;
            tcOppLineItem.Target_OI__c = oppLineItem.Target_OI__c;
            tcOppLineItem.Target_OI_Temp_Calc__c = oppLineItem.Target_OI_Temp_Calc__c;
            tcOppLineItem.Type_of_Work__c = oppLineItem.Type_of_Work__c;
            
            if(oppLineItem.Product2.Name.equals(UTIL_Constants.SI_COSTPLUS)){
                tcOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.TC_COSTPLUS).Id;
                tcOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.TC_COSTPLUS).Product2.Type__c;
            }
            else if(oppLineItem.Product2.Name.equals(UTIL_Constants.SI_FIXEDPRICE)){
                tcOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.TC_FIXEDPRICE).Id;
                tcOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.TC_FIXEDPRICE).Product2.Type__c;
            }
            else{
                tcOppLineItem.PricebookEntryId = pbNameMap.get(UTIL_Constants.TC_MATERIALS).Id;
                tcOppLineItem.Type__c = pbNameMap.get(UTIL_Constants.TC_MATERIALS).Product2.Type__c;
            }
            
            oppLineItem.Revenue__c = oppLineItem.Revenue__c * siPercentage;
            oppLineItem.Total_Costs__c = oppLineItem.Total_Costs__c * siPercentage;
            oppLineItem.HW_SW_Costs__c = oppLineItem.HW_SW_Costs__c * siPercentage;
            oppLineItem.Other_Cost_Components__c = oppLineItem.Other_Cost_Components__c * siPercentage;
            oppLineItem.Subcontractor_Expenses__c = oppLineItem.Subcontractor_Expenses__c * siPercentage;            
            
            toUpsert.add(tcOppLineItem);
            toUpsert.add(oppLineItem);
            
        }
        
        //Stores all the Id of Opportunity Line Items which are successfully inserted or updated.
        Set<Id> successlineItemIds = new Set<Id>();
        for (Database.UpsertResult sr : Database.upsert(toUpsert, false)) {
            if (sr.isSuccess()) {
                successlineItemIds.add(sr.getId());
            }
        }
        
        //Stores the parent Opportunity Id of all the Opportunity Line Items which are successfully inserted or updated.
        Set<Id> oppIds = new Set<Id>();        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
        for(OpportunityLineItem lineItemRecord : [SELECT OpportunityId FROM OpportunityLineItem WHERE Id IN :successlineItemIds]){
            oppIds.add(lineItemRecord.OpportunityId);
        }
        
        return oppIds;
    }
    
    /* Method for Attribute split which accepts Set of Opportunity Ids and % Splits for TC and SI */
    private void insertAttributeSplit(Set<Id> oppIds){
        System.debug(LoggingLevel.ERROR,'---------insertAttributeSplit()-----------');
        
        // Calls the method for retrieving all the attribute split mapping for SI Service Group
        Map<String, Map<String, String>> attributeMap = retrieveAttributeMappings(UTIL_Constants.TGP_SI);
        
        // Initializes all the object instance needed for the Attribute Split
        List<Attribute__c> toUpdateAndInsert = new List<Attribute__c>();
        Attribute__c temp = new Attribute__c();
        boolean isChildLacking = false;
        
        // Retrieves  all Attribute records from all of the Opportunities specified in the parameter.
        // Loops through each of the Attribute records.
        for(Attribute__c attribute : [SELECT AttributePercent__c, Attribute_Type__c, Attribute_Value__c, Opportunity_Name__c FROM Attribute__c WHERE
                                        Attribute_Type__c = :UTIL_Constants.TGP_SI AND Opportunity_Name__c IN :oppIds]){
            
            isChildLacking = false;
            // Sets identifier for child count to true if the size of the Attribute Split Map for the current record is less than 2.
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).size() < 2){
                isChildLacking = true;
            }
            
            // Sets the child attribute for TC if key for TC Offeringss exists in the map for Attribute Split
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_TC)){
                System.debug(LoggingLevel.ERROR,'---------'+attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_TC)+'-----------');
                if(!isChildLacking){
                    temp = new Attribute__c();
                    temp.Opportunity_Name__c = attribute.Opportunity_Name__c;
                }
                else{
                    temp = attribute;
                }
                
                temp.Attribute_Type__c = UTIL_Constants.TGP_TC;
                temp.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_TC);
                temp.AttributePercent__c = attribute.AttributePercent__c;
                temp.AttributeTxt__c = temp.AttributePercent__c + '%';
                temp.Attribute_TypeName__c = UTIL_Constants.TGP_TC;
                
                toUpdateAndInsert.add(temp);
            }
            
            // Sets the child attribute for SI if key SI Offerings exists in the Map for Attribute Split.
            if(attributeMap.containsKey(attribute.Attribute_Value__c) && attributeMap.get(attribute.Attribute_Value__c).containsKey(UTIL_Constants.TGP_SI)){
                 attribute.Attribute_Type__c = UTIL_Constants.TGP_SI;
                 attribute.Attribute_Value__c = attributeMap.get(attribute.Attribute_Value__c).get(UTIL_Constants.TGP_SI);
                 attribute.AttributeTxt__c = attribute.AttributePercent__c + '%';
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
        System.debug(LoggingLevel.ERROR,'---------retrieveAttributeMappings()-----------');
        Map<String, Map<String, String>> attributeMap = new Map<String, Map<String, String>>();
        
        // Retrievs all the attribute split mappings from the Custom Settings.
        Map<String, SG_Split_Attribute_Mapping__c> nameMap = SG_Split_Attribute_Mapping__c.getAll();
        
        // Filters all the Attribute Split Mappings for the Specified SG Group and stores it to a Map
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
    
    /* Any post-processing will be run here */
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}