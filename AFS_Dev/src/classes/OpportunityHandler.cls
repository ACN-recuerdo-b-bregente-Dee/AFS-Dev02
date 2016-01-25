/**
   @Author  Honelee F. Padilla
   @name    OpportunityHandler
   @CreateDate 04/15/2015
   @Description Opportunity Handler to call helper class
   @Version <1.0>
   @reference <Referenced program names>
  */
/**Start of Opportunity Handler*/
public with sharing class OpportunityHandler {

    public static boolean firstRunForBeforeUpdate = true;
    public static boolean firstRunForAfterUpdate = true;
    
    
    /**Opportunity Handler Constructor*/
    public OpportunityHandler(){
        //Add constructor routine
    }
    
    /**Call your helper class for Before Insert*/
    public void onBeforeInsert(Opportunity[] newOpportunities){
        //Call your helper class        
    }
    
    /**Call your helper class for After Insert*/
    public void onAfterInsert(Map<Id, Opportunity> newOpportunityMap){
        //Call your helper class
    }
    
    /**Call your helper class for Before Update*/
    public void onBeforeUpdate(Map<Id, Opportunity> oldOpportunityMap,  Map<Id, Opportunity> newOpportunityMap){
        //Call your helper class
        
        if (firstRunForBeforeUpdate) {
            firstRunForBeforeUpdate= false;
           // OpportunityBL.requireFields(newOpportunityMap.values());
           // AttributeBL.validateAttribute(newOpportunityMap.values(), (Opportunity) Trigger.new[0]); 
            OpportunityBL.populateStageEntryDates(oldOpportunityMap.values(), newOpportunityMap.values());   
            OpportunityBL.populateComplexityCategory(newOpportunityMap.values());        
            CreateSnapshots.createQuotes(oldOpportunityMap.values(), newOpportunityMap.values());
            OpportunityBL.sendEmailToLegal(oldOpportunityMap.values(),newOpportunityMap.values());
            
        }
    }
    
    /**Call your helper class for After Update*/
    public void onAfterUpdate(Map<Id, Opportunity> oldOpportunityMap,  Map<Id, Opportunity> newOpportunityMap){
        //Call your helper class
        String getErrorMessage = UTIL_Constants.STRING_EMPTY;
        Opportunity opps = (Opportunity) Trigger.new[0];
        
        if (firstRunForAfterUpdate) {
           firstRunForAfterUpdate= false;
           getErrorMessage += OpportunityBL.requireFields(oldOpportunityMap,newOpportunityMap.values());
           //OpportunityBL.setRevenueSchedule(oldOpportunityMap, newOpportunityMap);
           RevenueBL.rescheduleRevenue(oldOpportunityMap.values(), newOpportunityMap.values());
           
        }
        getErrorMessage += AttributeBL.validateAttribute(oldOpportunityMap.values(), newOpportunityMap.values());
        
        if(!getErrorMessage.equals(UTIL_Constants.STRING_EMPTY) || getErrorMessage.length() != 0)
        {
            opps.AddError(getErrorMessage, false);
        }
    }
    
    /**Call your helper class for Before Delete*/
    public void onBeforeDelete(Opportunity[] OpportunitiesToDelete, Map<ID, Opportunity> OpportunityMap){
        //Call your helper class
    }
    
    /**Call your helper class for After Delete*/
    public void onAfterDelete(Opportunity[] deletedOpportunities, Map<ID, Opportunity> OpportunityMap){
        //Call your helper class
    }
    
    /**Call your helper class for Undelete*/
    public void onUndelete(Opportunity[] restoredOpportunities){
        //Call your helper class
    }
    
}