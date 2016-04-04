/******************************************************************************************************************************
* Name        - TC_Attribute_Placeholder_Batch 
* Description - This batch class creates a placeholder holder for TC attribute type to store the lacking percentage value.
*        
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Recuerdo Bregente           04/04/2016             Initial creation.
* ******************************************************************************************************************************/
global class TCAttributePlaceholderBatch implements Database.Batchable<sObject>{
    
    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC){
        //Retrieves the query from the UTIL_Constants class
        String query = UTIL_Constants.OPEN_OPPORTUNITIES_BATCHQUERY;
        return Database.getQueryLocator(query);
    }
      
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<Opportunity> opps){
        //Iterates all through all Open Opportunities and store Ids to a Set Object.
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity oppRec : opps){
            oppIdSet.add(oppRec.Id);
        }
        
        Map<Id, Decimal> oppAttributeMap = retrieveOppAttibuteMappings(oppIdSet, Util_Constants.TGP_TC);
        
        List<Attribute__c> toInsert = new List<Attribute__c>();
        
        // Iterates through all Map of Decimal Data and create an Attribute Placeholder record if Map data is less than 100
        for(Id oppId : oppAttributeMap.keySet()){
            if(oppAttributeMap.get(oppId) < Util_Constants.DEFAULT_HUNDRED){
                toInsert.add(new Attribute__c(
                    AttributePercent__c = Util_Constants.DEFAULT_HUNDRED - oppAttributeMap.get(oppId),
                    AttributeTxt__c = (Util_Constants.DEFAULT_HUNDRED - oppAttributeMap.get(oppId)) + UTIL_Constants.DEFAULT_PERCENT_STRING,
                    Attribute_TypeName__c = Util_Constants.TGP_TC,
                    Attribute_Type__c = Util_Constants.TGP_TC,
                    Attribute_Value__c = Util_Constants.TC_PLACEHOLDER,
                    Opportunity_Name__c = oppId
                ));
            }
        }
        
        Database.insert(toInsert);
     
    }
    
    /* Method for retrieving Attribute records of specific Attribute Type and Store it to a Map if Decimal object with OpportunityId as key */
    private Map<Id, Decimal> retrieveOppAttibuteMappings(Set<Id> oppIdSet, String attType){
        // Instantiate a Map of Decimal object.
        Map<Id, Decimal> oppAttributeMap = new Map<Id, Decimal>();
        
        // Retrives all Attribute records of specific Attribute Type, process the data and store it to a Map of Decimal object.
        for(Attribute__c attRec : [SELECT Id, Attribute_Value__c, Attribute_Type__c, AttributePercent__c, Opportunity_Name__c FROM Attribute__c WHERE 
                                Opportunity_Name__c IN :oppIdSet AND Attribute_Type__c = :attType]){
            if(!oppAttributeMap.containsKey(attRec.opportunity_name__c)){
                oppAttributeMap.put(attRec.opportunity_name__c, Util_Constants.DEFAULT_ZERO_DECIMAL);
            }
            
            oppAttributeMap.put(attRec.opportunity_name__c, oppAttributeMap.get(attRec.opportunity_name__c) + attRec.AttributePercent__c);
        }
        
        return oppAttributeMap;
    }
    
    /* Any post-processing will be run here */
    global void finish(Database.BatchableContext BC){
        // Logic to be Executed at finish
    }
}