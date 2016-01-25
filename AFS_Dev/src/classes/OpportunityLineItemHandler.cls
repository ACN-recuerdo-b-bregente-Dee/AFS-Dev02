/**
   @Author  Pablito Abalos
   @name    OpportunityLineItemHandler 
   @CreateDate 2/5/2015
   @Description Opportunity Handler to call helper class
   @Version <1.0>
   @reference <Referenced program names>
  */
public with sharing class OpportunityLineItemHandler {

    static boolean firstRunForUpdate = true;
    
    /**OpportunityLineItemHandler Handler Constructor*/
    public OpportunityLineItemHandler(){
        //Add constructor routine
    }
    
    /**Call your helper class for Before Insert*/    
    public void onBeforeInsert(OpportunityLineItem[] newOpportunityLineItems){
        //Call your helper class
        CalculateFinancialSummaryBL.updateType(newOpportunityLineItems);
    }
    
    
    //public void OnAfterInsert(OpportunityLineItem[] newOpportunityLineItems){
    /**Call your helper class for After Insert*/
    public void onAfterInsert(Map<Id, OpportunityLineItem> newOpportunityLineItemMap){
        //Call your helper class   
        RevenueBL.setRevenueSchedule(newOpportunityLineItemMap, UTIL_Constants.OPPLINEITEMHANDLER_LINE_MAP_INSERT);
        CalculateFinancialSummaryBL.calFinancialSummary1(newOpportunityLineItemMap.values(), false);
    }
    
    /**Call your helper class for Before Update*/                
    public void onBeforeUpdate(Map<Id, OpportunityLineItem> oldOpportunityLineItemMap,  Map<Id, OpportunityLineItem> newOpportunityLineItemMap){
        //Call your helper class
        CalculateFinancialSummaryBL.updateType(newOpportunityLineItemMap.values());        
        
    }
    
    
    //public void OnAfterUpdate(OpportunityLineItem[] newOpportunityLineItems){
    /**Call your helper class for After Update*/
    public void onAfterUpdate(Map<Id, OpportunityLineItem> oldOpportunityLineItemMap,  Map<Id, OpportunityLineItem> newOpportunityLineItemMap){
        //Call your helper class
        //if (firstRunForUpdate) {
          //  firstRunForUpdate = false;          
            RevenueBL.setRevenueSchedule(newOpportunityLineItemMap, UTIL_Constants.OPPLINEITEMHANDLER_LINE_MAP_UPDATE);
            CalculateFinancialSummaryBL.calFinancialSummary1(newOpportunityLineItemMap.values(), false);
            
        //}
    }
    
    /**Call your helper class for Before Delete*/
    public void onBeforeDelete(OpportunityLineItem[] OpportunityLineItemsToDelete, Map<ID, OpportunityLineItem> OpportunityLineItemMap){
        //Call your helper class
       // CalculateFinancialSummaryBL.calFinancialSummary1(OpportunityLineItemsToDelete, false);
    }
    
    /**Call your helper class for After Delete*/
    public void onAfterDelete(OpportunityLineItem[] deletedOpportunityLineItems, Map<ID, OpportunityLineItem> OpportunityLineItemMap){
        //Call your helper class
         CalculateFinancialSummaryBL.calFinancialSummary1(deletedOpportunityLineItems, false);
    }
    
    /**Call your helper class for UnDelete*/
    public void onUndelete(OpportunityLineItem[] restoredOpportunities){
        //Call your helper class
    }
    
}