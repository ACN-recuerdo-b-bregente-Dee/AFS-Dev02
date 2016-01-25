/**
 * Class Name: UpdateAccountBatchTest
 * @author:Lhea Valencia    
 * Date: 11/10/2015
 * Test Class for UpdateAccountBatch
 */
@isTest
private class UpdateAccountBatchTest {

    
     // Prepares the data to be used in testing
     static void prepareData(){
         List<User> users = TestData.createUsers(1, 'System Administrator');
         Database.insert(users);
         
         List<Account> accounts = TestData.createAccounts(1, 'Client');
         accounts[0].Client_Account_Lead__c = users[0].id; 
         accounts[0].Client_Classification__c = 'Diamond';
         accounts[0].Source__c = 'STaR';
         Database.insert(accounts);
     }
        
     // Tests the batch class
     static testmethod void testBatch() {
     
        prepareData();
        
        boolean isErrorExists = false;
        
        try{
            system.test.startTest();
            UpdateAccountBatch batch = new UpdateAccountBatch();
            database.executeBatch(batch); 
            system.test.stopTest();
        }
        catch(Exception e){
            isErrorExists = true;
        }
        
        System.assertEquals(false, isErrorExists);
     }
}