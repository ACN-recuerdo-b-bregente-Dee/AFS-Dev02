/**
 * Class Name: AccountTeamRoleHandlerTest
 * @author: Recuerdo Bregente
 * Date: 10/20/2015
 * Test Class for AccountTeamRoleHandler
 */
@isTest(SeeAllData=true)
private class AccountTeamRoleHandlerTest{

    static AccountTeamRoleHandler handler;
    static List<Account_Team_Role__c> accTeamRoles;

    /*  
    * @Method to prepare the data needed data for testing.
    */    
    static void prepdata() {
        handler = new AccountTeamRoleHandler();
 
        List<User> users = TestData.createUsers(2, 'System Administrator');
        database.insert(users);
        
        List<Account> accounts = TestData.createAccounts(1, 'Client');
        for(Account acc : accounts) {
            acc.Client_Account_Lead__c = users[0].id;
            acc.Client_Classification__c = 'Diamond';  
        }
        
        Database.insert(accounts);
        
        accTeamRoles = TestData.createAccountTeamRoles(1, accounts[0].Id);
        for(Account_Team_Role__c accTeamRole : accTeamRoles){
            accTeamRole.Team_Member__c = users[1].Id;
        }
        
        Database.insert(accTeamRoles);
  
    }
    
    /*  
    * @Method to test the onBeforeInsert() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnBeforeInsert(){
        prepdata();
        handler.onBeforeInsert(accTeamRoles);
        
        System.assertEquals(1, accTeamRoles.size());
    }
    
    /*  
    * @Method to test the onAfterInsert() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnAfterInsert(){
        prepdata();
        handler.onAfterInsert(accTeamRoles);
        
        System.assertEquals(1, accTeamRoles.size());
    }
    
    /*  
    * @Method to test the onBeforeUpdate() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnBeforeUpdate(){
        prepdata();
        Map<Id, Account_Team_Role__c> oldAccTeamRoleMap = new Map<Id, Account_Team_Role__c>{};
        Map<Id, Account_Team_Role__c> newAccTeamRoleMap = new Map<Id, Account_Team_Role__c>{};
        
        handler.onBeforeUpdate(oldAccTeamRoleMap, newAccTeamRoleMap);
        
        System.assertEquals(0, newAccTeamRoleMap.size());
    }
    
    /*  
    * @Method to test the onAfterUpdate() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnAfterUpdate(){
        prepdata();
        Map<Id, Account_Team_Role__c> oldAccTeamRoleMap = new Map<Id, Account_Team_Role__c>{};
        Map<Id, Account_Team_Role__c> newAccTeamRoleMap = new Map<Id, Account_Team_Role__c>{};
        
        handler.onAfterUpdate(oldAccTeamRoleMap, newAccTeamRoleMap);
        
        System.assertEquals(0, newAccTeamRoleMap.size());
    }
    
    /*  
    * @Method to test the onBeforeDelete() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnBeforeDelete(){
        prepdata();
        Map<Id, Account_Team_Role__c> accTeamRoleMap = new Map<Id, Account_Team_Role__c>{};
        
        handler.onBeforeDelete(accTeamRoles, accTeamRoleMap);
        
        System.assertEquals(0, accTeamRoleMap.size());
    }
    
    /*  
    * @Method to test the onAfterDelete() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnAfterDelete(){
        prepdata();
        Map<Id, Account_Team_Role__c> accTeamRoleMap = new Map<Id, Account_Team_Role__c>{};
        
        handler.onAfterDelete(accTeamRoles, accTeamRoleMap);
        
        System.assertEquals(0, accTeamRoleMap.size());
    }
    
    /*  
    * @Method to test the onUndelete() method of AccountTeamRoleHandler Class.
    */  
    static testMethod void testOnUndelete(){
        prepdata();
        
        handler.onUndelete(accTeamRoles);
        
        System.assertEquals(1, accTeamRoles.size());
    }
 }