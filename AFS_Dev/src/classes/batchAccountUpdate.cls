global class batchAccountUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Name FROM Account WHERE Id=\'001J000001jNjaK\'';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope) {
         for(Account a : scope)
         {
             a.Name = a.Name + 'Updated';            
         }
         update scope;
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}