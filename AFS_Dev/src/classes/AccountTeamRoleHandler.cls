/**
   @Author Lhea Valencia
   @name AccountHandler
   @CreateDate 04/14/2015
   @Description Class handler that will implement Account trigger.
   @Version <1.0>
   @reference <Referenced program names>
  */
public with sharing class AccountTeamRoleHandler {

    public static boolean firstRunForUpdate = true;
    
    /**Start of AccountTeamRoleHandler*/
    public AccountTeamRoleHandler(){
    
    }
    
    /**OnBeforeInsert of newAccounts*/
    public void onBeforeInsert(Account_Team_Role__c[] newAccountTeamRoles){

    }
    
    
    /**OnAferInsert of newAccounts*/
    public void onAfterInsert(Account_Team_Role__c[] newAccountTeamRoles){
        AccountTeamRoleBL.insertAccountOwner (newAccountTeamRoles);
    }
    
    /**OnBeforeUpdate of newAccountTeamRoles*/
    public void onBeforeUpdate(Map<Id, Account_Team_Role__c> oldAccountTeamRoleMap,  Map<Id, Account_Team_Role__c> newAccountTeamRoleMap){

    }
    
    /**OnAfterInsert of newAccountTeamRoles*/
    public void onAfterUpdate(Map<Id, Account_Team_Role__c> oldAccountTeamRoleMap,  Map<Id, Account_Team_Role__c> newAccountTeamRoleMap){
        AccountTeamRoleBL.insertAccountTeam(oldAccountTeamRoleMap, newAccountTeamRoleMap);
    }
    
    /**OnBeforeDelete of newAccountTeamRoles*/
    public void onBeforeDelete(Account_Team_Role__c[] accountTeamRolesToDelete, Map<ID, Account_Team_Role__c> AccountTeamRoleMap){
        //Call your helper class
    }
    
    /**OnBeforeInsert of Account_Team_Role__c[] deletedAccount*/
    public void onAfterDelete(Account_Team_Role__c[] deletedAccountTeamRoles, Map<ID, Account_Team_Role__c> accountTeamRoleMap){
        //Call your helper class
    }
    
    /**OnBeforeInsert of Account_Team_Role__c[] restoredAccounts*/
    public void onUndelete(Account_Team_Role__c[] restoredAccountTeamRoles){
        
    }
}