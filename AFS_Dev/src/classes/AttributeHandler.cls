/**
   @Author  Recuerdo Bregente
   @name    AttributeHandler
   @CreateDate 12/14/2015
   @Description Attribute Handler to call helper class
   @Version <1.0>
   @reference <Referenced program names>
  */
public with sharing class AttributeHandler {

    static boolean firstRunForUpdate = true;
    
    /**Attribute Handler Constructor*/
    public AttributeHandler(){
        //Add constructor routine
    }
    
    /**Call your helper class for Before Insert*/    
    public void onBeforeInsert(OpportunityLineItem[] newOpportunityLineItems){
        //Call your helper class
    }
    
    
    //public void OnAfterInsert(OpportunityLineItem[] newOpportunityLineItems){
    /**Call your helper class for After Insert*/
    public void onAfterInsert(Map<Id, Attribute__c> newAttributeMap){
        //Call your helper class
        AttributeSummary.calculateAttributeSummary(getLineItems(newAttributeMap.keySet()));
        
    }
    
    /**Call your helper class for Before Update*/                
    public void onBeforeUpdate(Map<Id, Attribute__c> oldAttributeMap,  Map<Id, Attribute__c> newAttributeMap){
        //Call your helper class      
        
    }
    
    /**Call your helper class for After Update*/
    public void onAfterUpdate(Map<Id, Attribute__c> oldAttributeMap,  Map<Id, Attribute__c> newAttributeMap){
        //Call your helper class
        AttributeSummary.calculateAttributeSummary(getLineItems(newAttributeMap.keySet()));
    }
    
    /**Call your helper class for Before Delete*/
    public void onBeforeDelete(Attribute__c[] attributesToDelete, Map<Id, Attribute__c> newAttributeMap){
        //Call your helper class
    }
    
    /**Call your helper class for After Delete*/
    public void onAfterDelete(Map<Id, Attribute__c> deletedAttributeMap, Map<Id, Attribute__c> attributeMap){
        //Call your helper class
        Set<Id> oppIds = new Set<Id>();
        for(Attribute__c attr : deletedAttributeMap.values()){
            oppIds.add(attr.Opportunity_Name__c);
        }
        AttributeSummary.calculateAttributeSummary(getLineItemsByOppIds(oppIds));
    }
    
    /**Call your helper class for UnDelete*/
    public void onUndelete(Map<Id, Attribute__c> unDeletedAttributeMap){
        //Call your helper class
        AttributeSummary.calculateAttributeSummary(getLineItems(unDeletedAttributeMap.keySet()));
    }
    
    public Map<Id, OpportunityLineItem> getLineItems(Set<Id> attributeIds){
        Set<Id> oppIds = new Set<Id>();
        for(Attribute__c attr : [SELECT Id, Opportunity_Name__c FROM Attribute__c WHERE ID IN :attributeIds]){
            oppIds.add(attr.Opportunity_Name__c);
        }
        
        return getLineItemsByOppIds(oppIds);
    }
    
    public Map<Id, OpportunityLineItem> getLineItemsByOppIds(Set<Id> oppIds){
        Map<Id, OpportunityLineItem> oppLineItemMap = new Map<Id, OpportunityLineItem>();
        
        for(Opportunity oppRecord :[SELECT Id, Name, (SELECT Id, Opportunity.Id, Revenue__c FROM OpportunityLineItems) FROM Opportunity WHERE ID IN: oppIds]){
            System.debug(LoggingLevel.ERROR,'----------------Opportunity'+oppRecord.Name);
            for(OpportunityLineItem productItem : oppRecord.OpportunityLineItems){
                oppLineItemMap.put(oppRecord.Id, productItem);
            }
        }     
        
        Map<Id, OpportunityLineItem> lineItemMap = new Map<Id, OpportunityLineItem>();
        
        for(OpportunityLineItem productItem : oppLineItemMap.values()){
                lineItemMap.put(productItem.Id, productItem);
        }
        
        return lineItemMap;
    }
        
}