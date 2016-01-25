/**
   @Author Honelee F. Padilla
   @name AccountHandler
   @CreateDate 04/14/2015
   @Description Class handler that will implement Account trigger.
   @Version <1.0>
   @reference <Referenced program names>
  */
public with sharing class AccountHandler {

    public static boolean firstRunForUpdate = true;
    
    /**Start of AccountHandler*/
    public AccountHandler(){
    
    }
    
    /**OnBeforeInsert of newAccounts*/
    public void onBeforeInsert(Account[] newAccounts){
        //if (firstRunForUpdate) {
            //firstRunForUpdate = false;   
            AccountBL.updateClientAccount(null, newAccounts);
        //}
    }
    
    
    /**OnAferInsert of newAccounts*/
    public void onAfterInsert(Account[] newAccounts){
        AccountBL.updateClientAccount(null, newAccounts);
    }
    
    /**OnBeforeUpdate of newAccounts*/
    public void onBeforeUpdate(Map<Id, Account> oldAccountMap,  Map<Id, Account> newAccountMap){
        //if (firstRunForUpdate) {
            //firstRunForUpdate = false;      
        //AccountBL.updateClientAccount(oldAccountMap.values(), newAccountMap.values());
        //AccountBL.updateOpp(newAccountMap, oldAccountMap);
        //}
    }
    
    /**OnAfterInsert of newAccounts*/
    public void onAfterUpdate(Map<Id, Account> oldAccountMap,  Map<Id, Account> newAccountMap){
        //Call your helper class
        if (firstRunForUpdate) {
            firstRunForUpdate = false;        
        AccountBL.updateClientAccount(oldAccountMap.values(), newAccountMap.values());
        AccountBL.updateOpp(newAccountMap, oldAccountMap);
        }
    }
    
    /**OnBeforeDelete of newAccounts*/
    public void onBeforeDelete(Account[] accountsToDelete, Map<ID, Account> accountMap){
        //Call your helper class
    }
    
    /**OnBeforeInsert of Account[] deletedAccount*/
    public void onAfterDelete(Account[] deletedAccounts, Map<ID, Account> accountMap){
        //Call your helper class
    }
    
    /**OnBeforeInsert of Account[] restoredAccounts*/
    public void onUndelete(Account[] restoredAccounts){
        
    }
}