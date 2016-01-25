/**
   @Author Honelee F.Padilla
   @name RevenueBL()
   @CreateDate 04/01/2015
   @Description To auto calculate Revenue Phasing Schedule and reschedule revenue phasing for updated Consulting and Outsourcing Dates.
   @Version 1.0
   @reference <Referenced program names>
  */
public with sharing class RevenueBL {

    public static Boolean isRevenueScheduled = false;

    /**
    *  To calculate revenue phasing schedule dates base on the type of work per product line item.
    *  @name   setRevenueSchedule()
    *  @param  OpportunityLineItem map of old opportunities , newOpportunityLineItemMap   map of current opportunities
    *  @return void
    *  @throws exception-NA
    */
    public static void setRevenueSchedule(Map<Id, OpportunityLineItem> newOpportunityLineItemMap, String origin) {
    
        if (!isRevenueScheduled) {
            isRevenueScheduled = true;
            OpportunityLineItemSchedule[] revenueSchedulesToInsert = new OpportunityLineItemSchedule[]{};
            Custom_Schedule__c[] customSchedulesToInsert = new Custom_Schedule__c[]{}; // Added Recuerdo 11-03-15
            Set<Id> lineItemIds = new Set<Id>{};
            Map<String, Custom_Error_Messages__c> cem = Custom_Error_Messages__c.getAll();
            Decimal revenue_update = UTIL_Constants.DEFAULT_ZERO_DECIMAL;
            
            Map<Id, OpportunityLineItem> oppLineItemMap = 
                new Map<Id, OpportunityLineItem>([SELECT Id, Product2.Name FROM OpportunityLineItem WHERE Id IN:newOpportunityLineItemMap.keySet() LIMIT 50000]);
            
            for (OpportunityLineItem lineItem : newOpportunityLineItemMap.values()) {
                if (lineItem.Revenue__c == null) {
                    revenue_update = UTIL_Constants.DEFAULT_ZERO_DECIMAL;
                }
                else{
                    revenue_update = lineItem.Revenue__c ;
                }
                    if (lineItem.Type_of_Work__c != null) {
                        
                        // Calculate revenue and schedule dates for Outsourcing type of work
                        if (lineItem.Type_of_Work__c.equals(UTIL_Constants.PRODUCT_TYPE_OF_WORK_OUTSOURCING)){
                            if (lineItem.Outsourcing_Start_Date__c <> null && lineItem.Outsourcing_End_Date__c <> null) {
                                Integer installments = lineItem.Outsourcing_Start_Date__c.monthsBetween(lineItem.Outsourcing_End_Date__c) + 1;                  
                                for (Integer i = 0; i < installments; i++) {
                                    revenueSchedulesToInsert.add(
                                        new OpportunityLineItemSchedule(
                                            OpportunityLineItemId = lineItem.Id,
                                            Revenue = (revenue_update / installments).SetScale(2),
                                            ScheduleDate = lineItem.Outsourcing_Start_Date__c.addMonths(i),
                                            Type = UTIL_Constants.SCHEDULE_TYPE_REVENUE
                                            )
                                        );
                                     // -Start- Added Recuerdo 11-03-15
                                     customSchedulesToInsert.add(
                                         new Custom_Schedule__c(
                                             Opportunity__c = lineItem.OpportunityId,
                                             Opportunity_Line_Item_Id__c = lineItem.Id,
                                             Product_Name__c = oppLineItemMap.get(lineItem.Id).Product2.Name,
                                             Revenue__c = (revenue_update / installments).SetScale(2),
                                             Date__c = lineItem.Outsourcing_Start_Date__c.addMonths(i),
                                             Type__c = UTIL_Constants.SCHEDULE_TYPE_REVENUE,
                                             Schedule_Check__c  = false
                                          )
                                     );
                                     // -End-
                                }
                                lineItemIds.add(lineItem.Id);
                            }
                        }
                    // Calculate revenue and schedule dates for Consulting type of work
                        if (lineItem.Type_of_Work__c.equals(UTIL_Constants.PRODUCT_TYPE_OF_WORK_CONSULTING)){
                            if (lineItem.Consulting_Start_Date__c <> null && lineItem.Consulting_End_Date__c <> null) {
                                Integer installments = lineItem.Consulting_Start_Date__c.monthsBetween(lineItem.Consulting_End_Date__c) + 1;
                                for (Integer i = 0; i < installments; i++) {
                                    revenueSchedulesToInsert.add(
                                        new OpportunityLineItemSchedule(
                                            OpportunityLineItemId = lineItem.Id,
                                            Revenue = (revenue_update / installments).SetScale(2),
                                            ScheduleDate = lineItem.Consulting_Start_Date__c.addMonths(i),
                                            Type = UTIL_Constants.SCHEDULE_TYPE_REVENUE
                                            )
                                        );
                                    // -Start- Added Recuerdo 11-03-15
                                    customSchedulesToInsert.add(
                                         new Custom_Schedule__c(
                                             Opportunity__c = lineItem.OpportunityId,
                                             Opportunity_Line_Item_Id__c = lineItem.Id,
                                             Product_Name__c = oppLineItemMap.get(lineItem.Id).Product2.Name,
                                             Revenue__c = (revenue_update / installments).SetScale(2),
                                             Date__c = lineItem.Consulting_Start_Date__c.addMonths(i),
                                             Type__c = UTIL_Constants.SCHEDULE_TYPE_REVENUE,
                                             Schedule_Check__c  = false
                                          )
                                     );
                                     // -End-
                                }
                                lineItemIds.add(lineItem.Id);
                            }  
                        }                   
                    }
    
    
            //Fetch line items to be deleted and inserted
            
               
            //if (!revenueSchedulesToDelete.isEmpty()) delete revenueSchedulesToDelete;
            //if (!revenueSchedulesToInsert.isEmpty()) insert revenueSchedulesToInsert;
            }
            
             try{
                    OpportunityLineItemSchedule[] revenueSchedulesToDelete = [SELECT Id from OpportunityLineItemSchedule 
                                                                          WHERE OpportunityLineItemId IN :lineItemIds ];
                    System.debug(LoggingLevel.ERROR,'----------------revenueSchedulesToDelete'+revenueSchedulesToInsert.size());
                    
                    if (!revenueSchedulesToDelete.isEmpty()){       
                        Database.delete(revenueSchedulesToDelete, true);
                    }
                    if (!revenueSchedulesToInsert.isEmpty()){
                        Database.insert(revenueSchedulesToInsert, true);
                        System.debug(LoggingLevel.ERROR,'--revenueSchedulesToInsert-'+revenueSchedulesToInsert);
                        //revenueSchedulesToInsert = new OpportunityLineItemSchedule[]{};
                    }
                    
                    // -Start- Added Recuerdo 11-03-15
                    Custom_Schedule__c[] customSchedulesToDelete = [SELECT Id from Custom_Schedule__c
                                                                          WHERE Opportunity_Line_Item_Id__c IN :lineItemIds];
                    
                    System.debug(LoggingLevel.ERROR,'----------------customSchedulesToDelete: '+customSchedulesToDelete.size());
                    
                    if (!customSchedulesToDelete.isEmpty()){       
                        Database.delete(customSchedulesToDelete, true);
                    }
                    if (!customSchedulesToInsert.isEmpty()){
                        Database.insert(customSchedulesToInsert, true);
                        System.debug(LoggingLevel.ERROR,'--customSchedulesToInsert-'+customSchedulesToInsert);
                    }
                    // -End-
                    
                } catch(exception e){
                System.debug(LoggingLevel.ERROR,'--Praveen-'+e.getMessage());
            }
        }
    }
    
      
    /**
    *  To get updated Outsourcing and Consulting Dates to reschedule revenue phasing schedule dates.
    *  @name   rescheduleRevenue()
    *  @param  oldOpportunities map of old opportunities , newOpportunities   map of current opportunities
    *  @return void
    *  @throws exception-NA
    */
    public static void rescheduleRevenue(Opportunity[] oldOpportunities, Opportunity[] newOpportunities) {
    
        Set<Id> opportunityIds = new Set<Id>();
        for (Integer i = 0; i < newOpportunities.size(); i++) {
            //Get Outsourcing Dates that were updated
            if (oldOpportunities[i].Outsourcing_Start__c != newOpportunities[i].Outsourcing_Start__c ||
                oldOpportunities[i].Outsourcing_End__c != newOpportunities[i].Outsourcing_End__c) {
                opportunityIds.add(newOpportunities[i].Id);
            }
            //Get Consulting Dates that were updated
            if (oldOpportunities[i].Consulting_Start__c != newOpportunities[i].Consulting_Start__c ||
                oldOpportunities[i].Consulting_End__c != newOpportunities[i].Consulting_End__c ) {
                opportunityIds.add(newOpportunities[i].Id);
            }
        }
        //Fetch Opportunity Line Items fields for mapping
        Map<Id, OpportunityLineItem> newOpportunityLineItemMap = new Map<Id, OpportunityLineItem>([
            SELECT Id, OpportunityId, Type__c, Type_of_Work__c, Revenue__c, Outsourcing_Start_Date__c, 
            Outsourcing_End_Date__c,  Consulting_Start_Date__c, Consulting_End_Date__c
            FROM OpportunityLineItem WHERE OpportunityId IN :opportunityIds]);
        
        //call method to re-calculate revenue schedule
        RevenueBL.setRevenueSchedule(newOpportunityLineItemMap, UTIL_Constants.REVENUE_BL_ORIGIN);
        setOpportunityRevenue(newOpportunityLineItemMap);
    }
    
    public static void setOpportunityRevenue(Map<Id, OpportunityLineItem> newOpportunityLineItemMap){
        Set<Id> oppIds = new Set<Id>();
        
        for(OpportunityLineItem oppLineItem : newOpportunityLineItemMap.values()){
           oppIds.add(oppLineItem.OpportunityId);
        }
    
        Map<Id, Opportunity> oppRecords = new Map<Id, Opportunity>(
            [SELECT Id, Total_Current_Revenue__c, Consulting_Start__c, Consulting_End__c, Outsourcing_Start__c, Outsourcing_End__c FROM Opportunity
            WHERE ID IN :oppIds LIMIT 50000]);
            
        Map<Id, Decimal> tcrMap = new Map<Id, Decimal>();
        for(AggregateResult agg : [SELECT Opportunity.Id oppId, SUM(Revenue__c) newTCR FROM
            OpportunityLineItem WHERE Opportunity.Id IN : oppRecords.keySet() GROUP BY Opportunity.Id LIMIT 50000]){
            tcrMap.put(String.valueOf(agg.get('oppId')), (Decimal)agg.get('newTCR'));
        }
            
        List<Opportunity_Schedule__c> schedules = new List<Opportunity_Schedule__c>();
        Set<Id> oppIdsToDelete = new Set<Id>();
        Date minDate = System.today();
        Date maxDate = System.today();
        for(Opportunity oppRecord : oppRecords.values()){
            System.debug(LoggingLevel.ERROR,'TCR====================== :' + tcrMap.get(oppRecord.Id));
            if(tcrMap.get(oppRecord.Id) > 0 && 
                    ((oppRecord.Consulting_Start__c <> null && oppRecord.Consulting_End__c <> null) || 
                    (oppRecord.Outsourcing_Start__c <> null && oppRecord.Outsourcing_End__c <> null))){
                    
                    minDate = oppRecord.Consulting_Start__c;
                    
                    if(oppRecord.Outsourcing_Start__c <> null && (minDate == null || minDate > oppRecord.Outsourcing_Start__c)){
                        minDate = oppRecord.Outsourcing_Start__c;
                    }
                    
                    maxDate = oppRecord.Consulting_End__c;
                    
                    if(oppRecord.Outsourcing_End__c <> null && (maxDate == null || maxDate < oppRecord.Outsourcing_End__c)){
                        maxDate = oppRecord.Outsourcing_End__c;
                    }
                    
                    Integer installments = minDate.monthsBetween(maxDate) + 1;                  
                    for (Integer i = 0; i < installments; i++) {
                        schedules.add(new Opportunity_Schedule__c(
                            Opportunity__c = oppRecord.Id,
                            Date__c = minDate.addMonths(i),
                            Revenue__c = (tcrMap.get(oppRecord.Id) / installments).SetScale(2),
                            Custom_Revenue__c = 0.00
                            )
                        );
                    }
                    
                    oppIdsToDelete.add(oppRecord.Id);
             }
        }
        
        try{
            List<Opportunity_Schedule__c> schedulesToDelete = [SELECT Id FROM Opportunity_Schedule__c WHERE Opportunity__c IN :oppIdsToDelete LIMIT 50000];
            
            if(!schedulesToDelete.isEmpty()){
                Database.delete(schedulesToDelete, true);
            }
            
            if(!schedules.isEmpty()){
               Database.insert(schedules, true);
               System.debug(LoggingLevel.ERROR,'INSERT====================== :' + schedules.size());
            }
            
        }catch(Exception e){
            System.debug(LoggingLevel.ERROR,e.getMessage());
        }
    }
    
}