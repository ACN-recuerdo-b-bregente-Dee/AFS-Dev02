/**
 * Class Name: AccountTeamRoleTriggerTest
 * @author: Recuerdo Bregente
 * Date: 10/20/2015
 * Test Class for AccountTeamRoleTrigger
 */
@isTest(SeeAllData=true)
private class AccountTeamRoleTriggerTest{

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
    * @Method to test all the methods of AccountTeamRoleTrigger Class.
    */  
    static testMethod void testTrigger(){
        List<Account_Team_Role__c> roles = null;
    
        //Inserts AccountTeamRole Object
        prepdata();
        
        //Updates AccountTeamRole Object
        accTeamRoles[0].Account_Access__c = 'Read Only';
        accTeamRoles[0].Case_Access__c = 'Read Only';
        accTeamRoles[0].Contact_Access__c = 'Read Only';
        accTeamRoles[0].Opportunity_Access__c = 'Read Only';
        
        Database.update(accTeamRoles);
        roles = [SELECT Id, Account_Access__c, Case_Access__c, Contact_Access__c, Opportunity_Access__c FROM Account_Team_Role__c WHERE Id = :accTeamRoles[0].Id];
       
        System.assertEquals('Read Only', roles[0].Account_Access__c);
        System.assertEquals('Read Only', roles[0].Case_Access__c);
        System.assertEquals('Read Only', roles[0].Contact_Access__c);
        System.assertEquals('Read Only', roles[0].Opportunity_Access__c);
        
        //Deletes AccountTeamRole Object
        Database.delete(accTeamRoles);
        roles = [SELECT Id FROM Account_Team_Role__c WHERE Id = :roles[0].Id];
        
        System.assertEquals(true, roles.isEmpty());
        
        //Undeletes AccountTeamRole Object
        Database.undelete(accTeamRoles);
        roles = [SELECT Id FROM Account_Team_Role__c WHERE Id = :accTeamRoles[0].Id];
        
        System.assertEquals(false, roles.isEmpty());
    }
}