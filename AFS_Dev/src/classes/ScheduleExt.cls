public with sharing class ScheduleExt {
    public List<OpportunityLineItem> oppLineItems {get; set;}
    public List<Custom_Schedule__c> customSchedules {get; set;}
    public boolean hasNoSchedules {get; set;}
    public String totalRevenue {get; set;}
    public String totalCustomRevenue {get; set;}
    
    /**
    * Constructor for ScheduleExt Class.
    * @param ApexPages.StandardController stdcontroller.
    * @return void
    */
    public ScheduleExt(ApexPages.StandardController stdcontroller) {
        customSchedules = new List<Custom_Schedule__c>();
        Id oppLineItemId = ApexPages.currentPage().getParameters().get('oppId');
        
        oppLineItems =
            [SELECT Id, Opportunity.Name, Product2.Name, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c,
                Consulting_Start_Date__c, Consulting_End_Date__c
                FROM OpportunityLineItem WHERE Id = :oppLineItemId LIMIT 50000];
                
        customSchedules = retrieveSchedules(oppLineItemId);
        
        Decimal customRevenue = 0;
        
        for(Custom_Schedule__c customSchedule: customSchedules){
            customRevenue += customSchedule.Custom_Revenue__c;
        }
        
        totalRevenue = oppLineItems[0].Revenue__c.format() + '.' + String.valueOf(oppLineItems[0].Revenue__c.setScale(2)).split('\\.')[1];
        totalCustomRevenue = customRevenue.format() + '.' + String.valueOf(customRevenue.setScale(2)).split('\\.')[1];
        
    }
    
    private List<Custom_Schedule__c> retrieveSchedules(String oppLineItemId){
       return [SELECT Date__c, Revenue__c, Comment__c, Type__c, Opportunity_Line_Item_Id__c, Schedule_Check__c, Custom_Revenue__c
                FROM Custom_Schedule__c WHERE Opportunity_Line_Item_Id__c = :oppLineItemId LIMIT 50000];
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
    
    public PageReference save() {
    
        Decimal newTotalRevenue = 0;
        
        for(Custom_Schedule__c customSched: customSchedules) {
            newTotalRevenue += customSched.Custom_Revenue__c;
        }
        
        totalCustomRevenue = newTotalRevenue.format() + '.' + String.valueOf(newTotalRevenue.setScale(2)).split('\\.')[1];
        
        if(newTotalRevenue > oppLineItems[0].Revenue__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'New Total Revenue Exceeds $' +oppLineItems[0].Revenue__c));
        }
        else{
            Database.update(customSchedules);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successful!'));
        }
        return null;
    }

        
    
}