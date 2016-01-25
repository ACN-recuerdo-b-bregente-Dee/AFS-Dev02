global class UpdateOpportunityTeamBatch implements Database.Batchable<sObject> {

public static final String FIN_BATCHQUERY = 'SELECT Id from Opportunity_Team_Roles__c where Opportunity_Name__r.Source__c = \'STaR\''; 

    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = FIN_BATCHQUERY;
        return Database.getQueryLocator(query); 
    }
    
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<sObject> oppTeamList) {
       database.update(oppTeamList, false); 
    }
    
    /* Any post-processing will be run here */
    global void finish(Database.BatchableContext BC) {
    
    }
}