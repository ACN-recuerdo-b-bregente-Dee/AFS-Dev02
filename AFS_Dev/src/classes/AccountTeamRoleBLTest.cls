/**
 * Class Name: AccountTeamRoleBLTest
 * @author: Recuerdo Bregente
 * Date: 10/20/2015
 * Test Class for AccountTeamRoleBL
 */
@isTest(SeeAllData=true)
private class AccountTeamRoleBLTest{

    static List<Account_Team_Role__c> accTeamRoles;

    /*  
    * @Method to prepare the data needed data for testing.
    */    
    static void prepdata() {
 
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
    * @Method to test insertAccountOwner() method of AccountTeamRoleTrigger Class if list parameter is null.
    */  
    static testMethod void testInsertAccountOwnerIfListIsEmpty(){
        accTeamRoles = new List<Account_Team_Role__c>();
        boolean errorExists = false;
        try{
            AccountTeamRoleBL.insertAccountOwner(accTeamRoles);
        }
        catch(Exception e){
            errorExists = true;
        }
        
        System.assertEquals(false, errorExists);
        
    }
    
    /*  
    * @Method to test insertAccountOwner() method of AccountTeamRoleTrigger Class if the List Values are valid.
    */  
    static testMethod void testInsertAccountOwnerIfListValuesValid(){
        
        prepData();
        
        AccountTeamRoleBL.insertAccountOwner(accTeamRoles);
        
        Account_Team_Role__c role = [SELECT Id, status__c, account_owner__c, Account__c FROM Account_Team_Role__c WHERE Id =:accTeamRoles[0].Id];
        Account acc = [SELECT ownerId FROM Account WHERE Id =:role.Account__c];
        
        System.assertEquals('New', role.status__c);
        System.assertEquals(acc.ownerId, role.account_owner__c);
        
    }
    
    /*  
    * @Method to test insertAccountTeam() method of AccountTeamRoleTrigger Class if Map parameter is null.
    */  
    static testMethod void testInsertAccountTeamIfListIsEmpty(){
        Map<Id, Account_Team_Role__c> newMap = new Map<Id, Account_Team_Role__c>{};
        Map<Id, Account_Team_Role__c> oldMap = new Map<Id, Account_Team_Role__c>{};
        boolean errorExists = false;
        try{
            AccountTeamRoleBL.insertAccountTeam(oldMap, newMap);
        }
        catch(Exception e){
            errorExists = true;
        }
        
        System.assertEquals(false, errorExists);
        
    }
    
    /*  
    * @Method to test insertAccountTeam() method of AccountTeamRoleTrigger Class if the Map Values are valid.
    */  
    static testMethod void testInsertAccountTeamIfListValuesValid(){
        Map<Id, Account_Team_Role__c> newMap = new Map<Id, Account_Team_Role__c>{};
        Map<Id, Account_Team_Role__c> oldMap = new Map<Id, Account_Team_Role__c>{};
        prepData();
        
        for(Account_Team_Role__c accTeamRole : accTeamRoles){
            accTeamRole.status__c = 'Approved';
            newMap.put(accTeamRole.Id, accTeamRole);
        }
        
        AccountTeamRoleBL.insertAccountTeam(oldMap, newMap);
        
        List<AccountTeamMember> members = [SELECT Id, TeamMemberRole FROM AccountTeamMember WHERE AccountId =: accTeamRoles[0].Account__c AND
                                            userId =:accTeamRoles[0].Team_Member__c];
        
        System.assertEquals(1, members.size());
        System.assertEquals(accTeamRoles[0].Team_Role__c, members[0].TeamMemberRole);
        
        List<AccountShare> shares = [SELECT Id FROM AccountShare WHERE AccountId =:accTeamRoles[0].Account__c AND UserOrGroupId =:accTeamRoles[0].Team_Member__c];
        System.assertEquals(1, shares.size());
        
    }
}