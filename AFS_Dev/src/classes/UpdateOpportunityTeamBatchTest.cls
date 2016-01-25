/**
 * Class Name: UpdateOpportunityTeamBatchTest
 * @author:Recuerdo Bregente    
 * Date: 11/10/2015
 * Test Class for UpdateOpportunityTeamBatch
 */
@isTest
private class UpdateOpportunityTeamBatchTest {

    
     // Prepares the data to be used in testing
     static void prepareData(){
         List<User> users = TestData.createUsers(1, 'System Administrator');
         Database.insert(users);
         
         List<Account> accounts = TestData.createAccounts(1, 'Client');
         accounts[0].Client_Account_Lead__c = users[0].id; 
         accounts[0].Client_Classification__c = 'Diamond';
         Database.insert(accounts);
         
         List<Person__c> persons = TestData.createPersons(1);
         Database.insert(persons);
         
         List<Opportunity> opportunities = TestData.createOpportunities(1);
         opportunities[0].Source__c = 'STaR';
         opportunities[0].AccountId = accounts[0].Id;
         opportunities[0].PoC_Responsible__c = persons[0].Id;
         Database.insert(opportunities);
         
         opportunities[0].Source__c = 'STaR';
         Database.update(opportunities);
         
         List<Opportunity_Team_Roles__c> oppTeamRoles = TestData.createOppTeamRoles(1);
         oppTeamRoles[0].Opportunity_Name__c = opportunities[0].Id;
         oppTeamRoles[0].Name__c = persons[0].Id;
         Database.insert(oppTeamRoles);
     }
        
     // Tests the batch class
     static testmethod void testBatch() {
     
        prepareData();
        
        boolean isErrorExists = false;
        
        try{
            system.test.startTest();
            UpdateOpportunityTeamBatch batch = new UpdateOpportunityTeamBatch();
            database.executeBatch(batch); 
            system.test.stopTest();
        }
        catch(Exception e){
            isErrorExists = true;
        }
        
        System.assertEquals(false, isErrorExists);
     }
}