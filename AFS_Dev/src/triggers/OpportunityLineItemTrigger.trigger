trigger OpportunityLineItemTrigger on OpportunityLineItem (after delete, after insert, after undelete, after update, 
                                                           before delete, before insert, before update) {
ManageTriggers__c TM = ManageTriggers__c.getValues('OpportunityLineItemTrigger');
If(tm!= null && tm.Active__c == TRUE)
{
    OpportunityLineItemHandler handler = new OpportunityLineItemHandler();
    
    if(Trigger.isInsert && Trigger.isBefore){
        handler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //handler.OnAfterInsert(Trigger.new);
        handler.OnAfterInsert(Trigger.newMap);
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
        handler.OnBeforeUpdate(Trigger.oldMap, Trigger.newMap);
    }
    
    else if(Trigger.isUpdate && Trigger.isAfter){
        handler.OnAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }
    
    else if(Trigger.isDelete && Trigger.isBefore){
        handler.OnBeforeDelete(Trigger.old, Trigger.newMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        handler.OnAfterDelete(Trigger.oldMap, Trigger.newMap);
    }
    
    //else if(Trigger.isUnDelete){
    //    handler.OnUndelete(Trigger.new);
    //}
}
}