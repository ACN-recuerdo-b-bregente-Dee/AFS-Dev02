public with sharing class CustomScheduleExt {
    
    public Opportunity oppRecord {get; set;}
    public Map<Id, LineItemSchedule> lineItemSchedules {get; set;}
    public List<LineItemSchedule> lineItemSched {get; set;}
    public boolean hasNoSchedules {get; set;}
    public List<String> processedDateRange {get; set;}
    public List<SelectOption> revenueYears {get; set;}
    public List<SelectOption> revenueMonths {get; set;}
    public String fromYearRange {get; set;}
    public String toYearRange {get; set;}
    public String fromMonthRange {get; set;}
    public String toMonthRange {get; set;}
    
    
    public List<String> dateRange {get; set;}
    private List<String> consultingDates {get; set;}
    private List<String> outsourcingDates {get; set;}
    
     /**
    *  This helper class, hold temporarily the value of the Opportunity Line Item and Schedules
    */
    public class LineItemSchedule {
        public Map<String, Custom_Schedule__c> customSchedules {get;set;}
        public OpportunityLineItem oppLineItem {get; set;}
        public String revenue {get; set;}
        public Decimal totalCustomRevenue {get; set;}
        public String customRevenue {get; set;}
    }

    /**
    * Constructor for ScheduleExt Class.
    * @param ApexPages.StandardController stdcontroller.
    * @return void
    */
    public CustomScheduleExt(ApexPages.StandardController stdcontroller) {
        hasNoSchedules = true;
        Id oppId = ApexPages.currentPage().getParameters().get('oppId');
        
        oppRecord =  [SELECT Id, Name,
            (SELECT Id, Name, Product2.Name, TotalPrice, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c, Consulting_Start_Date__c, Consulting_End_Date__c
                FROM OpportunityLineItems WHERE Type_of_Work__c =: UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING OR Type_of_Work__c =: UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING LIMIT 50000)
            FROM Opportunity WHERE Id = :oppId LIMIT 1];
            
        List<OpportunityLineItem> oppLineItems = oppRecord.OpportunityLineItems;
        
        if(!oppLineItems.isEmpty()){
            
            Map<Id, OpportunityLineItem> lineItemMap = new Map<Id, OpportunityLineItem>();
            
            OpportunityLineItem outSourcingLineItem = null;
            OpportunityLineItem consultingLineItem = null;
            boolean isConsultingFound = false;
            boolean isOutsourcingFound = false;
            
            for(OpportunityLineItem lineItem : oppLineItems) {
                lineItemMap.put(lineItem.Id, lineItem);
                if(!isConsultingFound && lineItem.Type_of_Work__c.equals(UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING)){
                    consultingLineItem = lineItem;
                    System.debug(LoggingLevel.DEBUG,'----------------CName: '+lineItem.Name + '  Id:' +lineItem.Id);
                    isConsultingFound = true;
                }
                if(!isOutsourcingFound && lineItem.Type_of_Work__c.equals(UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING)){
                    outSourcingLineItem = lineItem;
                    System.debug(LoggingLevel.DEBUG,'----------------OName: '+lineItem.Name + '  Id:' +lineItem.Id);
                    isOutsourcingFound = true;
                }
            }
            
            List<Custom_Schedule__c> customSchedules = retrieveSchedules(lineItemMap.keySet());
            
            if(!customSchedules.isEmpty()){
                hasNoSchedules = false;
                lineItemSchedules = classifySchedules(customSchedules, lineItemMap);
                outsourcingDates = new List<String>();
                consultingDates = new List<String>();
                
                if(isOutsourcingFound){
                    
                    outsourcingDates = generateDateRange(lineItemSchedules.get(outSourcingLineItem.Id));
                }
                
                if(isConsultingFound){
                    consultingDates = generateDateRange(lineItemSchedules.get(consultingLineItem.Id));
                }
                
                addNoScheduleRevenue();
                lineItemSched = lineItemSchedules.values();
                
                dateRange = outsourcingDates;
                dateRange.addAll(consultingDates);
                
                sortDate(dateRange);
                
                filterDate(dateRange[0].split('-')[0], dateRange[dateRange.size()-1].split('-')[0], dateRange[0].split('-')[1], dateRange[dateRange.size()-1].split('-')[1]);
                populateFilter(dateRange[0].split('-')[0], dateRange[dateRange.size()-1].split('-')[0]);
            }
            
        }
    }
    
    private List<Custom_Schedule__c> retrieveSchedules(Set<Id> lineItemIds){
       return [SELECT Date__c, Revenue__c, Comment__c, Type__c, Opportunity_Line_Item_Id__c, Schedule_Check__c, Custom_Revenue__c
                FROM Custom_Schedule__c WHERE Opportunity_Line_Item_Id__c IN :lineItemIds Order By Date__c LIMIT 50000];
    }
    
    private Map<Id, LineItemSchedule> classifySchedules(List<Custom_Schedule__c> customSchedules, Map<Id, OpportunityLineItem> lineItemMap){
        Map<Id, LineItemSchedule> classifiedItemSchedules = new Map<Id, LineItemSchedule>();
        LineItemSchedule tempItemSched = new LineItemSchedule();
        Map<String, Custom_Schedule__c> schedMap = new Map<String, Custom_Schedule__c>();
        
        System.debug(LoggingLevel.DEBUG,'----------------customSchedules: '+customSchedules.size());
         
        for(Custom_Schedule__c customSched : customSchedules){
            if(!classifiedItemSchedules.containsKey(customSched.Opportunity_Line_Item_Id__c)){
                tempItemSched = new LineItemSchedule();
                tempItemSched.customSchedules = new Map<String, Custom_Schedule__c>();
                System.debug(LoggingLevel.DEBUG,'----------------Related Id: '+customSched.Opportunity_Line_Item_Id__c);
                tempItemSched.oppLineItem = lineItemMap.get(customSched.Opportunity_Line_Item_Id__c);
                tempItemSched.totalCustomRevenue = 0.00;
                tempItemSched.customRevenue = '0.00';
                classifiedItemSchedules.put(customSched.Opportunity_Line_Item_Id__c, tempItemSched);
            }
            
            tempItemSched = classifiedItemSchedules.get(customSched.Opportunity_Line_Item_Id__c);
            String tempYearMonth = String.valueOf(customSched.Date__c).split('-')[0] +'-'+ String.valueOf(customSched.Date__c).split('-')[1];
            tempItemSched.customSchedules.put(tempYearMonth, customSched);
            tempItemSched.totalCustomRevenue += customSched.Custom_Revenue__c;
            tempItemSched.revenue = tempItemSched.oppLineItem.Revenue__c.format()+ '.' + String.valueOf(tempItemSched.oppLineItem.Revenue__c.setScale(2)).split('\\.')[1];
            tempItemSched.customRevenue = tempItemSched.totalCustomRevenue.format() + '.' + String.valueOf(tempItemSched.totalCustomRevenue.setScale(2)).split('\\.')[1];
            classifiedItemSchedules.put(customSched.Opportunity_Line_Item_Id__c, tempItemSched);   
        }
        
        return classifiedItemSchedules;
    }
    
    private List<String> generateDateRange(LineItemSchedule lineItemSched){
        String[] ret = new List<String>();
        
        for(Custom_Schedule__c customSched: lineItemSched.customSchedules.values()){
            ret.add(String.valueOf(customSched.Date__c));
        }
        return ret;
    }
    
    private void addNoScheduleRevenue(){
        List<String> tempDates = new List<String>();
        List<String> compareDates = new List<String>();
        for(Id oppLineItemId : lineItemSchedules.keySet()){
            
            if(lineItemSchedules.get(oppLineItemId).oppLineItem.Type_of_Work__c == UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING && consultingDates <> null && !consultingDates.isEmpty()){
                compareDates = outsourcingDates;
                tempDates = consultingDates;
            }
            
            if(lineItemSchedules.get(oppLineItemId).oppLineItem.Type_of_Work__c == UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING && outsourcingDates <> null && !outsourcingDates.isEmpty()){
                compareDates = consultingDates;
                tempDates = outsourcingDates;
            }
            Map<String, String> compareMap = new Map<String, String>();
            
            String tempYearMonth = '';
            for(String compareString : compareDates){
                tempYearMonth = compareString.split('-')[0] +'-'+ compareString.split('-')[1];
                compareMap.put(tempYearMonth, tempYearMonth);
            }
            
            for(String dateString : tempDates){
                tempYearMonth = dateString.split('-')[0] +'-'+ dateString.split('-')[1];
                if(!compareMap.containsKey(tempYearMonth)){
                    lineItemSchedules.get(oppLineItemId).customSchedules.put(tempYearMonth, new Custom_Schedule__c(Revenue__c = 0.00));
                }
            }
        }
    }
    
    private List<String> sortDate(List<String> dates){
        for(Integer i = 0; i < dates.size(); i++){
            Integer min = i;
            for(Integer j = i + 1; j < dates.size(); j++){
                if(dates[j] < dates[min]){
                    min = j;
                }
            }
            
            String temp = dates[i];
            dates[i] = dates[min];
            dates[min] = temp;
        }
        
        return dates;
    }
    
    private void filterDate(String fromDate, String toDate, String fromMonth, String toMonth) {
        processedDateRange = new List<String>();
        String filterFromYearMonth = fromDate + '-' + fromMonth;
        String filterToYearMonth = toDate + '-' + toMonth;
        String tempYearMonth = '';
        Map<String, String> dateMap = new Map<String, String>();
        for(String temp: dateRange){
            tempYearMonth = temp.split('-')[0] +'-'+ temp.split('-')[1];
            if(tempYearMonth >= filterFromYearMonth && tempYearMonth <= filterToYearMonth && !dateMap.containsKey(tempYearMonth)){
                processedDateRange.add(tempYearMonth);
                dateMap.put(tempYearMonth, tempYearMonth);
            }
        }
        
        fromYearRange = fromDate;
        toYearRange = toDate;
        
        fromMonthRange = fromMonth;
        toMonthRange = toMonth;
    }
    
    private void populateFilter(String fromDate, String toDate){
        Integer fromYear = Integer.valueOf(fromDate);
        Integer toYear = Integer.valueOf(toDate);
        revenueYears = new List<SelectOption>();
        while(fromYear <= toYear){
            revenueYears.add(new SelectOption(String.valueOf(fromYear),String.valueOf(fromYear)));
            fromYear++;
        }
        
        revenueMonths = new List<SelectOption>();
        revenueMonths.add(new SelectOption('01','Jan'));
        revenueMonths.add(new SelectOption('02','Feb'));
        revenueMonths.add(new SelectOption('03','Mar'));
        revenueMonths.add(new SelectOption('04','Apr'));
        revenueMonths.add(new SelectOption('05','May'));
        revenueMonths.add(new SelectOption('06','Jun'));
        revenueMonths.add(new SelectOption('07','Jul'));
        revenueMonths.add(new SelectOption('08','Aug'));
        revenueMonths.add(new SelectOption('09','Sep'));
        revenueMonths.add(new SelectOption('10','Oct'));
        revenueMonths.add(new SelectOption('11','Nov'));
        revenueMonths.add(new SelectOption('12','Dec'));
        
        
    }
    
    public PageReference changeDateRange(){
        System.debug(LoggingLevel.ERROR,'----------------From Month: '+fromMonthRange);
        System.debug(LoggingLevel.ERROR,'----------------To Month: '+toMonthRange);
    
        if(toYearRange + '-' + toMonthRange < fromYearRange + '-' + fromMonthRange){
            toYearRange = fromYearRange;
            toMonthRange = fromMonthRange;
        }
        
        String filterFromYearMonth = fromYearRange + '-' + fromMonthRange;
        String filterToYearMonth = toYearRange + '-' + toMonthRange;
        
        if(filterFromYearMonth < dateRange[0].split('-')[0] +'-'+ dateRange[0].split('-')[1]){
            fromYearRange = dateRange[0].split('-')[0];
            fromMonthRange = dateRange[0].split('-')[1];
        }
        
        if(filterToYearMonth > dateRange[dateRange.size()-1].split('-')[0] +'-'+ dateRange[dateRange.size()-1].split('-')[1]){
            toYearRange = dateRange[dateRange.size()-1].split('-')[0];
            toMonthRange = dateRange[dateRange.size()-1].split('-')[1];
        }
        
        filterDate(fromYearRange, toYearRange, fromMonthRange, toMonthRange);
        
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
    
    public PageReference doUpdate() {
        
        Decimal newTotalRevenue = 0;
        List<Custom_Schedule__c> toUpdate = new List<Custom_Schedule__c>();
        List<Custom_Schedule__c> temp = new List<Custom_Schedule__c>();
        List<String> failedProducts = new List<String>();
        
        for(LineItemSchedule lis: lineItemSchedules.values()){
            temp = new List<Custom_Schedule__c>();
            newTotalRevenue = 0;
            
            for(Custom_Schedule__c customSched: lis.customSchedules.values()) {
                if(customSched.Id <> null){
                    newTotalRevenue += customSched.Custom_Revenue__c;
                    temp.add(customSched);
                }
            }
            
            if(newTotalRevenue > lis.oppLineItem.Revenue__c){
                failedProducts.add(lis.oppLineItem.Product2.Name);
            }
            else{
                toUpdate.addAll(temp);
            }
            lis.customRevenue = newTotalRevenue.format() + '.' + String.valueOf(newTotalRevenue.setScale(2)).split('\\.')[1];
        }
        
        try{
            Database.update(toUpdate);
        }
        catch(Exception e){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error! Please contact administrator.'));
        }
        
        if(failedProducts.isEmpty()){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successful!'));
        }
        else{
            String productNames = '';
            
            for(String name : failedProducts){
                if(productNames.length() == 0){
                    productNames = name;
                }
                else{
                    productNames = productNames +', '+name;
                }
            }
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Product(s): [' + productNames + '] - exceeds its allocated total TCR. Please Check total.'));
        }
        
        return null;
    }
}