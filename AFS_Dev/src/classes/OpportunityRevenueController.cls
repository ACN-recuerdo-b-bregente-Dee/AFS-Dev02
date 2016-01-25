public with sharing class OpportunityRevenueController {

    public Map<Id, LineItemSchedule> lineItemSchedules {get; set;}
    public List<LineItemSchedule> lineItemSched {get; set;}
    public boolean hasNoSchedules {get; set;}
    public List<String> processedDateRange {get; set;}
    public String productName {get; set;}
    public String opportunityName {get; set;}
    public String accountName {get; set;}
    public List<OpportunityWrapper> opportunityRecords {get; set;}
    
    public List<SelectOption> revenueYears {get; set;}
    public List<SelectOption> revenueMonths {get; set;}
    public String fromYearRange {get; set;}
    public String toYearRange {get; set;}
    public String fromMonthRange {get; set;}
    public String toMonthRange {get; set;}
    
    
    public List<String> dateRange {get; set;}
    public Map<String, String> dateMap {get; set;}
    private List<OpportunityLineItem> oppLineItemList;
    private Set<Id> oppIds;
    
     /**
    *  This helper class, hold temporarily the value of the Opportunity Line Item and Schedules
    */
    public class LineItemSchedule {
        public Map<String, Custom_Schedule__c> customSchedules {get;set;}
        public OpportunityLineItem oppLineItem {get; set;}
        public String revenue {get; set;}
        public Decimal totalCustomRevenue {get; set;}
        public String customRevenue {get; set;}
        public boolean isSelected {get; set;}
    }
    
     /**
    *  This helper class, hold temporarily the value of the Opportunity object
    */
    public Class OpportunityWrapper {
        public boolean isSelected {get; set;}
        public Opportunity oppRecord {get; set;}
        
        public OpportunityWrapper(boolean isSelected, Opportunity oppRecord){
            this.isSelected = isSelected;
            this.oppRecord = oppRecord;
        }
    }

    /**
    * Constructor for ScheduleExt Class.
    * @param ApexPages.StandardController stdcontroller.
    * @return void
    */
    public OpportunityRevenueController() {
        productName = '';
        opportunityName = '';
        accountName = '';
        processData(Database.query(getGeneralQuery('', '')));
        populateOpportunities(oppIds);
    }
    
    private void processData(List<OpportunityLineItem> oppLineProducts){
        hasNoSchedules = true;
        
        System.debug(LoggingLevel.DEBUG,'----------------SizeBefore: ' +oppLineProducts.size());
        
        String lineItems = ApexPages.currentPage().getParameters().get('lineItems');
        List<Id> itemIds = (List<Id>) JSON.deserialize(lineItems, List<Id>.class);
        Set<Id> lineItemIds = new Set<Id>();
        for(Id itemId : itemIds){
            lineItemIds.add(itemId);
        }
        
        for(Integer i = oppLineProducts.size()-1; i >= 0; i--){
            if(!lineItemIds.contains(oppLineProducts[i].Id)){
                oppLineProducts.remove(i);
            }
        }
        
        System.debug(LoggingLevel.DEBUG,'----------------SizeAfter: ' +oppLineProducts.size());
        
        System.debug(LoggingLevel.DEBUG,'----------------Size: ' +itemIds.size()+'\nParameter: ' +itemIds+'\nLast String:'+itemIds[itemIds.size()-1]);
        
        oppLineItemList = oppLineProducts;
        
        if(!oppLineItemList.isEmpty()){
            hasNoSchedules = false;
            Map<Id, OpportunityLineItem> lineItemMap = new Map<Id, OpportunityLineItem>();
            oppIds = new Set<Id>();
            for(OpportunityLineItem oppLineItem : oppLineItemList){
                lineItemMap.put(oppLineItem.Id, oppLineItem);
                oppLineItem.VF_Checkbox__c = false;
                oppIds.add(oppLineItem.Opportunity.Id);
            }
            
            lineItemSchedules = classifySchedules(retrieveSchedules(lineItemMap.keySet()), lineItemMap);
            
            dateMap = generateDateRange(lineItemSchedules);
            
            addNoScheduleRevenue();
            lineItemSched = lineItemSchedules.values();
            
            dateRange = dateMap.values();
            
            sortDate(dateRange);
            
            filterDate(dateRange[0].split('-')[0], dateRange[dateRange.size()-1].split('-')[0], dateRange[0].split('-')[1], dateRange[dateRange.size()-1].split('-')[1]);
            populateFilter(dateRange[0].split('-')[0], dateRange[dateRange.size()-1].split('-')[0]);
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
                tempItemSched.isSelected = true;
                classifiedItemSchedules.put(customSched.Opportunity_Line_Item_Id__c, tempItemSched);
            }
            
            tempItemSched = classifiedItemSchedules.get(customSched.Opportunity_Line_Item_Id__c);
            String tempYearMonth = String.valueOf(customSched.Date__c).split('-')[0] +'-'+ String.valueOf(customSched.Date__c).split('-')[1];
            tempItemSched.customSchedules.put(tempYearMonth, customSched);
            tempItemSched.totalCustomRevenue += customSched.Custom_Revenue__c==null?0.00:customSched.Custom_Revenue__c;
            tempItemSched.revenue = tempItemSched.oppLineItem.Revenue__c.format()+ '.' + String.valueOf(tempItemSched.oppLineItem.Revenue__c.setScale(2)).split('\\.')[1];
            tempItemSched.customRevenue = tempItemSched.totalCustomRevenue.format() + '.' + String.valueOf(tempItemSched.totalCustomRevenue.setScale(2)).split('\\.')[1];
            classifiedItemSchedules.put(customSched.Opportunity_Line_Item_Id__c, tempItemSched);   
        }
        
        return classifiedItemSchedules;
    }
    
    private Map<String, String> generateDateRange(Map<Id, LineItemSchedule> lineItemSchedParam){
        Map<String, String> ret = new Map<String, String>();
        
        for(LineItemSchedule lineItem: lineItemSchedParam.values()){
            for(Custom_Schedule__c customSched: lineItem.customSchedules.values()){
                ret.put(String.valueOf(customSched.Date__c), String.valueOf(customSched.Date__c));
            }
        }
        return ret;
    }
    
    private void addNoScheduleRevenue(){
        List<String> tempDates = new List<String>();
        for(LineItemSchedule lineItem : lineItemSchedules.values()){           
            for(String dateString: dateMap.keySet()){
                String tempYearMonth = dateString.split('-')[0] +'-'+ dateString.split('-')[1];
                if(!lineItem.customSchedules.containsKey(tempYearMonth)){
                    lineItem.customSchedules.put(tempYearMonth, new Custom_Schedule__c(Revenue__c = 0.00));
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
    
    private void populateOpportunities(Set<Id> oppIds){
        opportunityRecords = new List<OpportunityWrapper>();
        
        for(Opportunity opp : [SELECT Id, Name FROM Opportunity WHERE ID IN :oppIds]){
            opportunityRecords.add(new OpportunityWrapper(true, opp));
        }
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
    
    private String getGeneralQuery(String productName, String opportunityName){
        
        String queryString = 'SELECT Id, Name, Product2.Name, TotalPrice, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c,' +
                'Consulting_Start_Date__c, Consulting_End_Date__c, VF_Checkbox__c, Opportunity.Name, Opportunity.Id' +
                ' FROM OpportunityLineItem';
                
                queryString += ' WHERE';
                queryString += ' Opportunity.Name LIKE \'%'+String.escapeSingleQuotes(opportunityName)+'%\'';
                queryString += ' AND Product2.Name LIKE \'%'+String.escapeSingleQuotes(productName)+'%\'';
                queryString += ' AND Opportunity.Account.Name LIKE \'%'+String.escapeSingleQuotes(accountName)+'%\'';
                queryString += ' LIMIT 50000';
        
        System.debug(LoggingLevel.DEBUG,'----------------QueryString: '+queryString);
        return queryString;
    }
    
    public PageReference doReturnOrCancel(){
        String oppLineItemId = ApexPages.currentPage().getParameters().get('oppId');
        pageReference page = new pageReference('https://smartafs--dev--c.cs10.visual.force.com/apex/openOpportunityPage');
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
            
            if(newTotalRevenue <> lis.oppLineItem.Revenue__c){
                failedProducts.add(lis.oppLineItem.Name);
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
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Product(s):' + productNames + ' ----- Exceeds or does not reach the expected total TCR. Please Check total.'));
        }
        
        return null;
    }
    
    public pageReference updateCheckbox(){
        
        
        return null;
    }
    
    public pageReference search(){
        List<OpportunityLineItem> lineItems = Database.query(getGeneralQuery(productName, opportunityName));
        if(!lineItems.isEmpty()){
            processData(lineItems);
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'No Data Found.'));
        }
        
        return null;
    }
    
    public pageReference selectQuery(){
        set<Id> selectedOppIds = new Set<Id>();
        
        for(OpportunityWrapper oppWrap: opportunityRecords){
            if(oppWrap.isSelected){
                selectedOppIds.add(oppWrap.oppRecord.Id);
            }
        }
        
        List<OpportunityLineItem> lineItems = [SELECT Id, Name, Product2.Name, TotalPrice, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, Outsourcing_End_Date__c,
                Consulting_Start_Date__c, Consulting_End_Date__c, VF_Checkbox__c, Opportunity.Name, Opportunity.Id 
                FROM OpportunityLineItem WHERE VF_Checkbox__c = true AND Opportunity.Id IN :selectedOppIds LIMIT 50000];
        
        processData(lineItems);
        
        return null;
    }
}