trigger OpportunityTeamRoleTrigger on Opportunity_Team_Roles__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
   
ManageTriggers__c TM = ManageTriggers__c.getValues('OpportunityTeamRoleTrigger');
If(tm!= null && tm.Active__c == TRUE)
{
    OpportunityTeamRoleHandler handler = new OpportunityTeamRoleHandler(/*Trigger.isExecuting, Trigger.size*/);
  
  
    if(Trigger.isInsert && Trigger.isBefore){
        OpportunityTeamRoleHandler.OnBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        OpportunityTeamRoleHandler.OnAfterInsert(Trigger.newMap);
    }
    
    else if(Trigger.isUpdate && Trigger.isBefore){
        OpportunityTeamRoleHandler.OnBeforeUpdate(Trigger.oldMap, Trigger.newMap);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        OpportunityTeamRoleHandler.OnAfterUpdate(Trigger.oldMap, Trigger.newMap);
    }

    else if(Trigger.isDelete && Trigger.isBefore){
        OpportunityTeamRoleHandler.OnBeforeDelete(Trigger.old, Trigger.newMap);
    }
    else if(Trigger.isDelete && Trigger.isAfter){
        OpportunityTeamRoleHandler.OnAfterDelete(Trigger.old, Trigger.newMap);
    }
    
    else if(Trigger.isUnDelete){
        OpportunityTeamRoleHandler.OnUndelete(Trigger.new);    
    }
}
}