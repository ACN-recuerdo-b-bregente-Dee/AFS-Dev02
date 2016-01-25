public with sharing class OpenOpportunityScheduleExt {

    public List<OpportunitySchedule> opportunitySchedules {get; set;}
    public String productName {get; set;}
    public String opportunityName {get; set;}
    public String accountName {get; set;}
    public String accountParentName {get; set;}
    
    public Class OpportunitySchedule{
        public boolean isSelected {get; set;}
        public Opportunity oppRecord {get; set;}
        public List<OpportunityLineItem> oppLineItemsWrap {get; set;}
        
        
    }
    
    /**
    * Constructor for openOpportunityScheduleExt Class.
    * @param ApexPages.StandardController stdcontroller.
    */
    public OpenOpportunityScheduleExt() {
        productName = '';
        opportunityName = '';
        accountName = '';
        accountParentName = '';
        processData(Database.query(getGeneralQuery()));
    }
    
    private void processData(List<Opportunity> oppList){
        opportunitySchedules = new List<OpportunitySchedule>();
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
        
        for(Opportunity oppRecord : oppList){
            opportunityMap.put(oppRecord.Id, oppRecord);
        }
            /**new Map<Id, Opportunity>([SELECT Id, Name,
            (SELECT Id, Name, Product2.Name, TotalPrice, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c, Consulting_Start_Date__c, Consulting_End_Date__c, VF_Checkbox__c, OpportunityId
                FROM OpportunityLineItems WHERE Type_of_Work__c =: UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING OR Type_of_Work__c =: UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING LIMIT 50000)
            FROM Opportunity WHERE Reporting_Status__c NOT IN ('Closed', 'Won', 'Lost') AND Type_of_Work__c IN ('C', 'O', 'C/O') LIMIT 50000]);**/
        
        for(Id oppId : opportunityMap.keySet()){
            if(!opportunityMap.get(oppId).OpportunityLineItems.isEmpty()){
                opportunitySchedules.add(new OpportunitySchedule());
                opportunitySchedules[opportunitySchedules.size()-1].isSelected = true;
                opportunitySchedules[opportunitySchedules.size()-1].oppRecord = opportunityMap.get(oppId);
                opportunitySchedules[opportunitySchedules.size()-1].oppLineItemsWrap = opportunityMap.get(oppId).OpportunityLineItems;
            }
            
        }
        
        if(opportunitySchedules.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Match Data Found'));        
        }
        
        //filterOppLineItemWithSchedule();
    }
    
    private String getGeneralQuery(){
        List<String> productTypes = new List<String>();
        productTypes.add('\''+UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING+'\'');
        productTypes.add('\''+UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING+'\'');
        
        String lineItemQuery = 'SELECT Id, Name, Product2.Name, TotalPrice, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c, Consulting_Start_Date__c, Consulting_End_Date__c,' +
                               ' VF_Checkbox__c, OpportunityId FROM OpportunityLineItems WHERE' +
                               ' Product2.Name LIKE \'%'+String.escapeSingleQuotes(productName)+'%\''+
                               ' AND Type_of_Work__c IN' + productTypes +
                               ' LIMIT 50000';
        
        String queryString = 'SELECT Id, Name, (' + lineItemQuery + ') FROM Opportunity WHERE Reporting_Status__c NOT IN (\'Closed\', \'Won\', \'Lost\') AND Type_of_Work__c IN (\'C\', \'O\', \'C/O\')';
                queryString += ' AND Name LIKE \'%'+String.escapeSingleQuotes(opportunityName)+'%\'';
                queryString += ' AND Account.Name LIKE \'%'+String.escapeSingleQuotes(accountName)+'%\'';
                if(!String.isEmpty(accountParentName)){
                    queryString += ' AND Summary_Customer__c LIKE \'%'+String.escapeSingleQuotes(accountParentName)+'%\'';
                }
                
                queryString += ' LIMIT 50000';
        
        System.debug(LoggingLevel.DEBUG,'----------------QueryString: '+queryString);
        return queryString;
    }
    
    private void filterOppLineItemWithSchedule(){
        Set<Id> oppIds = new Set<Id>();
        
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            for(OpportunityLineItem oppLineItem : oppSchedObj.oppLineItemsWrap){
                oppIds.add(oppLineItem.Id);
            }
        }
        
        Map<Id, AggregateResult> oppToRemove = new Map<Id, AggregateResult>();
        
        for(AggregateResult agg : [SELECT Id, COUNT(Opportunity_Line_Item_Id__c) lineCount FROM Custom_Schedule__c WHERE Opportunity_Line_Item_Id__c IN :oppIds GROUP BY Id]){
            if(Integer.valueOf(agg.get('lineCount')) == 0){
                oppToRemove.put(String.valueOf(agg.get('Id')), agg);
            }
        }
        
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            for(Integer i = oppSchedObj.oppLineItemsWrap.size()-1; i >= 0; i--){
                if(!oppToRemove.containsKey(oppSchedObj.oppLineItemsWrap[i].Id)){
                    oppSchedObj.oppLineItemsWrap.remove(i);
                }
            }
            
        }
        
    }
    
    public pageReference search(){
        /**
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            if(oppSchedObj.oppRecord.Name.containsIgnoreCase(opportunityName)){
                oppSchedObj.isSelected = true;
                
            }
            else{
                oppSchedObj.isSelected = false;
                
              
            }
        }*/
        
        processData(Database.query(getGeneralQuery()));
        
        return null;
    }
    
    public pageReference customSchedules(){
        pageReference page = null;
        boolean atleastOneSelected = false;
        List<Id> itemIds = new List<Id>();
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            for(OpportunityLineItem oppLineItem : oppSchedObj.oppLineItemsWrap){
                if(oppLineItem.VF_Checkbox__c){
                    itemIds.add(oppLineItem.Id);
                    atleastOneSelected = true;
                }
            }
        }
        String jsonString = JSON.serialize(itemIds);
        if(atleastOneSelected){
            page = new pageReference('https://smartafs--dev--c.cs10.visual.force.com/apex/opportunityRevenuePage?lineItems='+jsonString);
            page.setRedirect(true);
            
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select an Product Item'));
        }
            
        return page;
    }
    
    public pageReference selectAll(){
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            for(OpportunityLineItem oppLineItem : oppSchedObj.oppLineItemsWrap){
                if(!oppLineItem.VF_Checkbox__c){
                    oppLineItem.VF_Checkbox__c = true;
                }
            }
        }
        
        return null;
    }
    
    public pageReference unSelectAll(){
        
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            for(OpportunityLineItem oppLineItem : oppSchedObj.oppLineItemsWrap){
                if(oppLineItem.VF_Checkbox__c){
                    oppLineItem.VF_Checkbox__c = false;
                }
            }
        }
        return null;
    }
    
    public pageReference cancelOrReturn(){
        List<OpportunityLineItem> toUpdate = new List<OpportunityLineItem>();
        for(OpportunitySchedule oppSchedObj: opportunitySchedules){
            for(OpportunityLineItem oppLineItem : oppSchedObj.oppLineItemsWrap){
                if(oppLineItem.VF_Checkbox__c){
                    oppLineItem.VF_Checkbox__c = false;
                    toUpdate.add(oppLineItem);
                }
            }
        }
        
        if(!toUpdate.isEmpty()){
            Database.update(toUpdate);
        }
        
        PageReference page = new pageReference('https://smartafs--dev.cs10.my.salesforce.com/006?fcf=00BJ0000000yl3y&rolodexIndex=-1&page=1');
        page.setRedirect(true);
        return page;
    }
}