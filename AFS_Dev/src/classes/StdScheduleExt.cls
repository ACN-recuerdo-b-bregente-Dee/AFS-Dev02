public with sharing class StdScheduleExt {
    public List<OpportunityLineItem> oppLineItems {get; set;}
    public List<OpportunityLineItemSchedule> customSchedules {get; set;}
    public boolean hasNoSchedules {get; set;}    
   /**
   * Constructor for StdScheduleExt Class.
   * @param ApexPages.StandardController stdcontroller.
   * @return void
   */
    public StdScheduleExt(ApexPages.StandardController stdcontroller) {
        customSchedules = new List<OpportunityLineItemSchedule>();
        Id oppLineItemId = ApexPages.currentPage().getParameters().get('oppId');
        
        oppLineItems =
            [SELECT Id, Opportunity.Name, Product2.Name, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c,
                Consulting_Start_Date__c, Consulting_End_Date__c
                FROM OpportunityLineItem WHERE Id = :oppLineItemId LIMIT 50000];
                
        customSchedules = retrieveSchedules(oppLineItemId);
        
    }
    
    private List<OpportunityLineItemSchedule> retrieveSchedules(String oppLineItemId){
       return [SELECT ScheduleDate, Revenue, Description, Type, OpportunityLineItemId
                FROM OpportunityLineItemSchedule WHERE OpportunityLineItemId = :oppLineItemId LIMIT 50000];
    }
    
    public PageReference createSchedules(){
        Id oppLineItemId = ApexPages.currentPage().getParameters().get('oppId');
        hasNoSchedules = false;
        
        customSchedules = retrieveSchedules(oppLineItemId);
        
        if(customSchedules.isEmpty() && !oppLineItems.isEmpty() && 
            (oppLineItems[0].Type_of_Work__c.equals(UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING) || oppLineItems[0].Type_of_Work__c.equals(UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING))){
          
            Map<Id, OpportunityLineItem> mapLineItem = new Map<Id, OpportunityLineItem>();
            mapLineItem.put(oppLineItems[0].Id, oppLineItems[0]);
            
            try{
                RevenueBL.isRevenueScheduled = false;
                RevenueBL.setRevenueSchedule(mapLineItem, UTIL_Constants.OPPLINEITEMHANDLER_LINE_MAP_INSERT);
            } catch(Exception e){
               hasNoSchedules = true; 
            }
            
            if(!hasNoSchedules){
                customSchedules = retrieveSchedules(oppLineItemId);
                if(customSchedules.isEmpty()){
                    hasNoSchedules = true;
                }
            }
        }
        
        return null;
    }

    public PageReference doReturn(){
        String oppLineItemId = ApexPages.currentPage().getParameters().get('oppId');
        pageReference page = new pageReference('https://smartafs--dev.cs10.my.salesforce.com/'+ oppLineItemId);
        page.setRedirect(true);
        return page;
    }    
    
    public PageReference doCancel(){
        String oppLineItemId = ApexPages.currentPage().getParameters().get('oppId');
        pageReference page = new pageReference('https://smartafs--dev.cs10.my.salesforce.com/'+ oppLineItemId);
        page.setRedirect(true);
        return page;
    }
        
    
}