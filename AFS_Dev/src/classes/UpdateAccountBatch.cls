global class UpdateAccountBatch implements Database.Batchable<sObject> {

public static final String FIN_BATCHQUERY = 'SELECT Id from Account where Account.Source__c = \'STaR\' and (Account.Type = \'Client\' or Account.Type = \'Customer\')'; 

    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = FIN_BATCHQUERY;
        return Database.getQueryLocator(query); 
    }
    
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<sObject> accountList) {
       database.update(accountList, false); 
    }
    
    /* Any post-processing will be run here */
    global void finish(Database.BatchableContext BC) {
    
    }
}