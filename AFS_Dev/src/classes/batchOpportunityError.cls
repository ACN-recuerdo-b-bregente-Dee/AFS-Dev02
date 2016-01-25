global class batchOpportunityError implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, Name FROM Opportunity WHERE Opportunity.IsClosed = false' ;
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope)
    {
    Savepoint sp = Database.setSavepoint();

    List<Opportunity_Error_Log__c> oppError = new List<Opportunity_Error_Log__c>();
    List<Id> Error = new List<Id>();
    
    Integer counter = 0;
    
    for (Database.SaveResult sr : Database.update(scope, false)) {
        if (!sr.isSuccess()) {
            Error.add(scope[counter].Id);
        }
        counter++;
    }   
        System.Debug('The String OppErrorbefore1: ' + Error);
        Database.rollback(sp);
        System.Debug('The String OppErrorbefore2: ' + Error);
        for(integer i = 0; i < Error.size(); i++){
        Opportunity_Error_Log__c oppErrorLog = new Opportunity_Error_Log__c(Opportunity_ID__c = Error[i]);
            oppError.add(oppErrorLog);
        }
        Database.update(oppError, false);
        System.Debug('The String OppErrorafter: ' + Error);
    }
    
    global void finish(Database.BatchableContext BC)
    {
    }
}