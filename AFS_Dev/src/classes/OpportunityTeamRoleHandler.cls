/**
   @Author <Author Name>
   @name <Class name>
   @CreateDate <Date>
   @Description <purpose of the class>
   @Version <1.0>
   @reference <Referenced program names>
  */
public with sharing class OpportunityTeamRoleHandler{
    
    /**OpportunityTeamRoleHandler Handler Constructor*/
    public OpportunityTeamRoleHandler(){
        //Call your helper class/routine
    }
    
    /**Call your helper class for Before Insert*/    
    public static void onBeforeInsert(Opportunity_Team_Roles__c [] teamRolesToInsert){
        //Call your helper class
    }
    
    /**Call your helper class for After Insert*/
    public static void onAfterInsert(Map<Id, Opportunity_Team_Roles__c> newTeamRoleMap){
        //Call your helper class
        OpportunityTeamRoleBL.ValidateSalesCredit(newTeamRoleMap);
        OpportunityTeamRoleBL.upsertOpportunityTeam(newTeamRoleMap.values(), false);
    }
    
    /**Call your helper class for Before Update*/
    public static void onBeforeUpdate(Map<Id, Opportunity_Team_Roles__c> oldTeamRoleMap,  Map<Id, Opportunity_Team_Roles__c> newTeamRoleMap){
        //Call your helper class        
        //OpportunityTeamRoleBL.ValidateSalesCredit(newTeamRoleMap);
    }
    
    /**Call your helper class for After Update*/
    public static void onAfterUpdate(Map<Id, Opportunity_Team_Roles__c> oldTeamRoleMap,  Map<Id, Opportunity_Team_Roles__c> newTeamRoleMap){
        //Call your helper class
        OpportunityTeamRoleBL.ValidateSalesCredit(newTeamRoleMap);
        OpportunityTeamRoleBL.upsertOpportunityTeam(newTeamRoleMap.values(), true);
    }
    
    /**Call your helper class for Before Delete*/
    public static void onBeforeDelete(Opportunity_Team_Roles__c[] teamRolesToDelete, Map<ID, Opportunity_Team_Roles__c> oldTeamRoleMap){
        //Call your helper class
        OpportunityTeamRoleBL.deleteOpportunityTeam(teamRolesToDelete);
    }
    
    /**Call your helper class for After Delete*/
    public static void onAfterDelete(Opportunity_Team_Roles__c[] deletedOpportunity_Team_Roles, Map<ID, Opportunity_Team_Roles__c> oldTeamRoleMap){
        //Call your helper class
    }
    
    /**Call your helper class for Undelete*/
    public static void onUndelete(Opportunity_Team_Roles__c[] restoredOpportunity_Team_Roles){
        //Call your helper class
    }
}