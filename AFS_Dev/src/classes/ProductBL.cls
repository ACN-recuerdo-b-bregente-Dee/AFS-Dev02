/**
   @Author Pablito M. Abalos Jr.
   @name ProductBL
   @CreateDate 3/4/2015
   @Description Update All Service Groups, Type of Work and Targer OI% in product level
   @Version <1.0>
   @reference
  */
public class ProductBL{

    /**
    *  Retrived opportunity product fields Service Group, Type of work and Target OI % on all open Opportunity record. 
    *  @name updateTargetOI
    *  @param Product2[] , Product2[]
    *  @return <parameter> - <Description about the return parameter>
    *  @throws exception-<exception description>
    */
    public static void updateTargetOI(Product2[] oldProducts, Product2[] newProducts){
      //OpportunityLineItem[] oppItemNew = new OpportunityLineItem[]{};
       // Set<ID> prods = new Set<ID>();
        Map<Id, Product2> updatedProductMap = new Map<Id, Product2>{};
        
        for (Integer i = 0; i < newProducts.size(); i++) {
            if (oldProducts[i].Target_OI__c != newProducts[i].Target_OI__c || oldProducts[i].Type__c != newProducts[i].Type__c || oldProducts[i].Type_of_Work__c != newProducts[i].Type_of_Work__c) {
                updatedProductMap.put(newProducts[i].Id, newProducts[i]);
            }
        }
        
      OpportunityLineItem[] opportunityLineItemsToUpdate = [SELECT Id, Target_OI__c, Product2Id, PricebookEntryId
                                                                FROM OpportunityLineItem 
                                                                WHERE Opportunity.IsClosed = false and OpportunityId in : [SELECT Id FROM Opportunity WHERE Reporting_Status__c not in (:UTIL_Constants.STAGENAME_CLIENT_WITHDREW, :UTIL_Constants.STAGENAME_AFS_WITHDREW, :UTIL_Constants.STAGENAME_WON, :UTIL_Constants.STAGENAME_LOST, :UTIL_Constants.STAGENAME_CLOSED) LIMIT 5000] 
                                                                AND Product2Id In :updatedProductMap.keyset() ORDER BY Product2Id LIMIT 5000];
      
      for (OpportunityLineItem opportunityLineItemToUpdate : opportunityLineItemsToUpdate) {
        opportunityLineItemToUpdate.Target_OI__c = updatedProductMap.get(opportunityLineItemToUpdate.Product2Id).Target_OI__c;
        opportunityLineItemToUpdate.Type__c = updatedProductMap.get(opportunityLineItemToUpdate.Product2Id).Type__c;
        opportunityLineItemToUpdate.Type_of_Work__c = updatedProductMap.get(opportunityLineItemToUpdate.Product2Id).Type_of_Work__c;
      }
      
      Integer counter = 0;
        for (Database.SaveResult sr : Database.update(opportunityLineItemsToUpdate, false)) {
            if (!sr.isSuccess()) {
                //Database.Error err = ;
                //newProducts[counter].addError(err.getStatusCode() + ': ' + err.getMessage());
                updatedProductMap.get(opportunityLineItemsToUpdate[counter].Product2Id).addError(sr.getErrors()[0].getStatusCode() + ': ' + sr.getErrors()[0].getMessage() + '[ERROR RECORD : ' + opportunityLineItemsToUpdate[counter].Id + ']');
            }
            counter++;
        }
    }
}