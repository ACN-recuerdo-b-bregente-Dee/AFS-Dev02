/******************************************************************************************************************************
* Name        - Update_Financial_Summary_Batch 
* Description - This batch class updates all the Opporunity Lime Items, which inturn fire a trigger which updates
*               the Financial Summary
*        
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                   Date                   Description
* ---------------------------------------------------------------------------
* Praveen                  04/30/2015             Batch to capture real time Case Age updates.(CR-DEF 01142)
* ******************************************************************************************************************************/
global class UpdateFinancialSummayBatch implements Database.Batchable<sObject> {

    /* Start method of Interface */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = UTIL_Constants.FIN_BATCHQUERY;
        return Database.getQueryLocator(query); 
    }
    
    /* Script statements to run on scope */
    global void execute(Database.BatchableContext BC, List<sObject> oppLineItemList) {
       database.update(oppLineItemList, false); 
    }
    
    /* Any post-processing will be run here */
    global void finish(Database.BatchableContext BC) {
    
    }
}