/**
   @Author Pablito M. Abalos Jr.
   @name CalculateFinancialSummaryBL
   @CreateDate 3/20/2015
   @Description Implementation Class for FinancialSummary
   @Version <1.0>
   @reference
  */
public class CalculateFinancialSummaryBL{
   
   /**
    *  Aggregate value of revenue, total cost, HW/SW Costs, Subcontractor Expenses. 
    *  @name calFinancialSummary1
    *  @param OpportunityLineItem[]
    *  @return void
    *  @throws exception
    */    
    public static void calFinancialSummary1(OpportunityLineItem[] newOpportunityLineItem, boolean isDelete){
        
        Set<Id> setOpportunityId = new Set<Id>();
       
        for(OpportunityLineItem eachOpportunityLineItem : newOpportunityLineItem ){         
            if(eachOpportunityLineItem.opportunityId != null){
                setOpportunityId.add(eachOpportunityLineItem.opportunityId);
            }
        }
        
        Map<ID,list<AggregateResult>> mapAggregateResult = new Map<ID,list<AggregateResult>>();
        Map<ID,list<AggregateResult>> mapAggregateResultTypeofWork = new Map<ID,list<AggregateResult>>();
       
    //list<AggregateResult> lstExistingOpportunityLineItem = [Select Sum(Revenue__c), Type__c from opportunityLineitem where opportunityId in : setOpportunityId group by Type__c,opportunityId  ];   
       for(AggregateResult objAggregateResult : [Select Sum(Revenue__c),Sum(Total_Costs__c),Sum(HW_SW_Costs__c),Sum(Subcontractor_Expenses__c),Sum(Other_Cost_Components__c),sum(Target_OI_Temp_Calc__c),Type__c,opportunityId from opportunityLineitem where opportunityId in : setOpportunityId and Type__c != null group by Type__c,opportunityId LIMIT 5000]){ // Default maximum of SOQL rows to 5000
            System.debug('opportunity ID' + objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID));
            System.debug('Sum amount' + objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0));
           System.debug('Type__c=' + objAggregateResult.get(UTIL_Constants.Type_Field));
           ID opportunityId = (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID);
           List<AggregateResult> listAggregateResult = new List<AggregateResult>{};
           //build mapAggregateResult
           if(mapAggregateResult.containsKey(opportunityId)){
               listAggregateResult = new list<AggregateResult>();
               listAggregateResult = mapAggregateResult.get(opportunityId);
               listAggregateResult.add(objAggregateResult);
               mapAggregateResult.put(opportunityId,listAggregateResult);
               
           }else{
               listAggregateResult = new list<AggregateResult>();
               listAggregateResult.add(objAggregateResult);
               mapAggregateResult.put(opportunityId,listAggregateResult);
           }
        }
       System.debug('----------mapAggregateResult'+mapAggregateResult);
       for(AggregateResult objAggregateResult : [Select Sum(Revenue__c), Sum(Total_Costs__c),Sum(HW_SW_Costs__c),Sum(Subcontractor_Expenses__c),Sum(Other_Cost_Components__c),sum(Target_OI_Temp_Calc__c),Type_of_Work__c,opportunityId from opportunityLineitem where opportunityId in : setOpportunityId and Type_of_Work__c != null group by Type_of_Work__c,opportunityId LIMIT 5000]){ // Default maximum of SOQL rows to 5000
            System.debug('opportunity ID' + objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID));
            System.debug('Sum amount' + objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0));
           System.debug('Type_of_Work__c inside=' + objAggregateResult.get(UTIL_Constants.Type_Of_Work_Field));
           ID opportunityId = (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID);
           List<AggregateResult> listAggregateResult = new List<AggregateResult>{};
           //build mapAggregateResultTypeofWork
           if(mapAggregateResultTypeofWork.containsKey(opportunityId)){
               listAggregateResult = new list<AggregateResult>();
               listAggregateResult = mapAggregateResultTypeofWork.get(opportunityId);
               listAggregateResult.add(objAggregateResult);
               mapAggregateResultTypeofWork.put(opportunityId,listAggregateResult);
               
           }else{
               listAggregateResult = new list<AggregateResult>();
               listAggregateResult.add(objAggregateResult);
               mapAggregateResultTypeofWork.put(opportunityId,listAggregateResult);
           }
        }
       System.debug('----------mapAggregateResultTypeofWork'+mapAggregateResultTypeofWork);
       
       list<Financial_Summary__c> listobjFinancialSummary = new list<Financial_Summary__c>();
      // list<Financial_Summary__c> listDeleteobjFinancialSummary = new list<Financial_Summary__c>();
       list<AggregateResult> listExistingAggregateResult = new  list<AggregateResult>();
       list<AggregateResult> listExistingTypeofWorkAggregateResult = new  list<AggregateResult>();
       list<Financial_Summary__c> listFinancialSummary =[select id,Target_Percentage__c,Total_Costs__c,HW_SW_Costs__c,Subcontractor_Expenses__c,Other_Costs__c,Financial_Summary_Type__c,Revenue__c,Opportunity__c from Financial_Summary__c where Opportunity__c  in : setOpportunityId  LIMIT 5000]; // Default maximum of SOQL rows to 5000
       //Type
       
       for(Financial_Summary__c objFinancialSummary : listFinancialSummary){
           boolean blnAdded = false;
           if(mapAggregateResult.containsKey(objFinancialSummary.Opportunity__c)){
               System.debug('------------------1');
           for(AggregateResult objAggregateResult : mapAggregateResult.get(objFinancialSummary.Opportunity__c)){
               System.debug('------------------1objAggregateResult'+objAggregateResult);
               if((String)objAggregateResult.get(UTIL_Constants.Type_Field) == objFinancialSummary.Financial_Summary_Type__c 
                    && (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID) == objFinancialSummary.Opportunity__c){
                        System.debug('------------------2');
                       if( (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0) != objFinancialSummary.Revenue__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1) != objFinancialSummary.Total_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2) != objFinancialSummary.HW_SW_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3) != objFinancialSummary.Subcontractor_Expenses__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4) != objFinancialSummary.Other_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR5) != objFinancialSummary.Target_Percentage__c){
                             System.debug('------------------3');
                            objFinancialSummary.Revenue__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0);
                            objFinancialSummary.Total_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                            objFinancialSummary.HW_SW_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2);
                            objFinancialSummary.Subcontractor_Expenses__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3);
                            objFinancialSummary.Other_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4);
                            //Praveen 1
                             Decimal  expr1 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                            System.debug('----------------expr1 Type'+expr1);
                            Decimal  expr5 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5);
                            System.debug('----------------expr5 Type'+expr5);
                              Decimal total = 0.00;
                              
                              if(expr5 != null && expr5 !=0) { 
                                    total = (expr5-expr1)/expr5;
                              }else{
                                  total = 0.00;
                              }
                              
                             System.debug('----------------total'+total); 
                            System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1));
                             System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5));
                            objFinancialSummary.Target_Percentage__c =total*100;
                            listobjFinancialSummary.add(objFinancialSummary);
                       }
                       listExistingAggregateResult.add(objAggregateResult);
                        blnAdded = true;
               }
             }
           }
           //TypeofWork
           if(mapAggregateResultTypeofWork.containsKey(objFinancialSummary.Opportunity__c)){
           for(AggregateResult objAggregateResult : mapAggregateResultTypeofWork.get(objFinancialSummary.Opportunity__c)){
               if((String)objAggregateResult.get(UTIL_Constants.Type_of_Work_Field) == objFinancialSummary.Financial_Summary_Type__c 
                    && (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID) == objFinancialSummary.Opportunity__c){
                       if( (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0) != objFinancialSummary.Revenue__c 
                          || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1) != objFinancialSummary.Total_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2) != objFinancialSummary.HW_SW_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3) != objFinancialSummary.Subcontractor_Expenses__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4) != objFinancialSummary.Other_Costs__c
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR5) != objFinancialSummary.Target_Percentage__c 
                         ){
                            objFinancialSummary.Revenue__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0);
                             objFinancialSummary.Total_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                            objFinancialSummary.HW_SW_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2);
                            objFinancialSummary.Subcontractor_Expenses__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3);
                            objFinancialSummary.Other_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4);
                            System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5)'+
                            (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5));
                            Decimal  expr1 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                            System.debug('----------------expr1'+expr1);
                            Decimal  expr5 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5);
                            System.debug('----------------expr5'+expr5);
                            Decimal total = 0.00;
                            if(expr5 != null && expr5 !=0) { 
                                    total = (expr5-expr1)/expr5;
                            }else{
                                  total = 0.00;
                            }
                            System.debug('----------------total'+total); 
                            System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1));
                             System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5));
                            objFinancialSummary.Target_Percentage__c =total*100; 
                             
                            listobjFinancialSummary.add(objFinancialSummary);
                       }
                       listExistingTypeofWorkAggregateResult.add(objAggregateResult);
                        blnAdded = true;
               }
             }
           }
           System.debug('---------------------------blnAdded'+blnAdded);
               if(!blnAdded){
                   System.debug('---------------------------objFinancialSummary='+objFinancialSummary);
                   objFinancialSummary.Revenue__c = 0;
                   objFinancialSummary.Total_Costs__c = 0;
                   objFinancialSummary.HW_SW_Costs__c = 0;
                   objFinancialSummary.Subcontractor_Expenses__c = 0;
                   objFinancialSummary.Other_Costs__c = 0;
                   objFinancialSummary.Target_Percentage__c = 0;
                   
                   listobjFinancialSummary.add(objFinancialSummary);
                   //listDeleteobjFinancialSummary.add(objFinancialSummary);
               }
       }
       //System.debug('----------listDeleteobjFinancialSummary='+listDeleteobjFinancialSummary);
       System.debug('----------listExistingAggregateResult='+listExistingAggregateResult);
       System.debug('----------listExistingTypeofWorkAggregateResult='+listExistingTypeofWorkAggregateResult);
        System.debug('----------listobjFinancialSummary='+listobjFinancialSummary);
       // build by Type
       for(id idOpportunity : mapAggregateResult.keySet())
       {
           for(AggregateResult objAggregateResult : mapAggregateResult.get(idOpportunity)){
               boolean blnAdded = false;
               for(AggregateResult objExistingAggregateResult  : listExistingAggregateResult){
                      if((String)objAggregateResult.get(UTIL_Constants.Type_Field) == (String)objExistingAggregateResult.get(UTIL_Constants.Type_Field)
                              && (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID) == (String)objExistingAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID)){
                       blnAdded = true;
                       }
               }
               if(!blnAdded && (String)objAggregateResult.get(UTIL_Constants.Type_Field)!= null){
                   Financial_Summary__c objFinancialSummary = new Financial_Summary__c();
                   objFinancialSummary.Financial_Summary_Type__c = (String)objAggregateResult.get(UTIL_Constants.Type_Field);
                   objFinancialSummary.Revenue__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0);
                   objFinancialSummary.Opportunity__c = (String)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID);
                   objFinancialSummary.Total_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                   objFinancialSummary.HW_SW_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2);
                   objFinancialSummary.Subcontractor_Expenses__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3);
                   objFinancialSummary.Other_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4);
                   System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4));
                   
                   listobjFinancialSummary.add(objFinancialSummary);
               }
               
           }
       }
       //Work AggregateResult 
       for(id idOpportunity : mapAggregateResultTypeofWork.keySet())
       {
           for(AggregateResult objAggregateResult : mapAggregateResultTypeofWork.get(idOpportunity)){
               boolean blnAdded = false;
               for(AggregateResult objExistingAggregateResult  : listExistingTypeofWorkAggregateResult){
                      if((String)objAggregateResult.get(UTIL_Constants.Type_Of_Work_Field) == (String)objExistingAggregateResult.get(UTIL_Constants.Type_Of_Work_Field)
                              && (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID) == (String)objExistingAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID)){
                       blnAdded = true;
                       }
               }
               if(!blnAdded && (String)objAggregateResult.get(UTIL_Constants.Type_Of_Work_Field)!= null){
                   Financial_Summary__c objFinancialSummary = new Financial_Summary__c();
                   objFinancialSummary.Financial_Summary_Type__c = (String)objAggregateResult.get(UTIL_Constants.Type_Of_Work_Field);
                   objFinancialSummary.Revenue__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0);
                   objFinancialSummary.Opportunity__c = (String)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID);
                   objFinancialSummary.Total_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                   objFinancialSummary.HW_SW_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2);
                   objFinancialSummary.Subcontractor_Expenses__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3);
                   objFinancialSummary.Other_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4);
                   System.debug('------------------objFinancialSummary'+objFinancialSummary);
                   System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5));
                   
                   listobjFinancialSummary.add(objFinancialSummary);
               }
               
           }
       }
       System.debug('----------listobjFinancialSummary='+listobjFinancialSummary);
       
       
       if(!listobjFinancialSummary.isEmpty()){
          Database.upsert(listobjFinancialSummary, false);        
       }
       
       /// Total Line Item
       Map<ID,Financial_Summary__c> mapFinancialSummary = new Map<ID,Financial_Summary__c>();
       
       for(Financial_Summary__c objFinancialSummary : [Select Financial_Summary_Type__c,Revenue__c,Total_Costs__c,HW_SW_Costs__c,Subcontractor_Expenses__c,Other_Costs__c,Opportunity__c from Financial_Summary__c where Opportunity__c  in : setOpportunityId and Financial_Summary_Type__c =:UTIL_Constants.FINANCIAL_SUMMARY_TYPE_TOTAL LIMIT 5000]){ // Default maximum of SOQL rows to 5000
           mapFinancialSummary.put(objFinancialSummary.Opportunity__c, objFinancialSummary);
       }
       list<Financial_Summary__c> listTotalFinancialSummary = new list<Financial_Summary__c>();
       
       //list<AggregateResult> listAggregateResult =[select Sum(Revenue__c),Opportunity__c from Financial_Summary__c where Opportunity__c  in : setOpportunityId and Financial_Summary_Type__c != 'Total' group by Opportunity__c];
       
       for(AggregateResult objAggregateResult : [Select Sum(Revenue__c), Sum(Total_Costs__c),Sum(HW_SW_Costs__c),Sum(Subcontractor_Expenses__c),Sum(Other_Cost_Components__c),sum(Target_OI_Temp_Calc__c),opportunityId from opportunityLineitem where opportunityId in : setOpportunityId group by opportunityId LIMIT 5000]){
            System.debug('opportunity ID' + objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID));
            System.debug('Sum amount' + objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0));
           ID oppID = (ID)objAggregateResult.get(UTIL_Constants.objAggregateResult_OpportunityID);
          Financial_Summary__c objFinancialSummary = new Financial_Summary__c();
           if(mapFinancialSummary.containsKey(oppID)){
               objFinancialSummary = mapFinancialSummary.get(oppID);
               if(objFinancialSummary.Revenue__c != (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0)
                  || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1) != objFinancialSummary.Total_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2) != objFinancialSummary.HW_SW_Costs__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3) != objFinancialSummary.Subcontractor_Expenses__c 
                         || (Decimal) objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4) != objFinancialSummary.Other_Costs__c
                 ){
                   objFinancialSummary.Revenue__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0);
                   objFinancialSummary.Total_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                   objFinancialSummary.HW_SW_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2);
                   objFinancialSummary.Subcontractor_Expenses__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3);
                   objFinancialSummary.Other_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4);
                   Decimal  expr1 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                            System.debug('----------------expr1 Type'+expr1);
                            Decimal  expr5 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5);
                            System.debug('----------------expr5 Type'+expr5);
                              Decimal total = 0.00;
                              if(expr5 != null && expr5 != 0) { 
                                    total = (expr5-expr1)/expr5;
                              }else{
                                  total = 0;
                              }
                              
                             System.debug('----------------total'+total); 
                            System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1));
                             System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5)'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5));
                            objFinancialSummary.Target_Percentage__c =total*100;
                     
                   listTotalFinancialSummary.add(objFinancialSummary);
                }
               }
               else{
                   objFinancialSummary.Financial_Summary_Type__c = UTIL_Constants.FINANCIAL_SUMMARY_TYPE_TOTAL;
                   objFinancialSummary.Revenue__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR0);
                   objFinancialSummary.Opportunity__c = oppID;
                   objFinancialSummary.Total_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                   objFinancialSummary.HW_SW_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR2);
                   objFinancialSummary.Subcontractor_Expenses__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR3);
                   objFinancialSummary.Other_Costs__c = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_EXPR4);
                     Decimal  expr1 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1);
                            System.debug('----------------expr1 Type'+expr1);
                            Decimal  expr5 = (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5);
                            System.debug('----------------expr5 Type'+expr5);
                              Decimal total = 0.00;
                              if(expr5 != null && expr5 !=0) { 
                                    total = (expr5-expr1)/expr5;
                              }else{
                                  total = 0.00;
                              }
                             System.debug('----------------total new'+total); 
                            System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1) new'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr1));
                             System.debug('----------------(Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5) new'+
                               (Decimal)objAggregateResult.get(UTIL_Constants.objAggregateResult_expr5));
                            objFinancialSummary.Target_Percentage__c =total*100;
                   
                   listTotalFinancialSummary.add(objFinancialSummary);
               }
           
           
       }
        System.debug(LoggingLevel.ERROR,'--------------------listTotalFinancialSummary'+listTotalFinancialSummary);
       if(!listTotalFinancialSummary.isEmpty()){
           Database.upsert(listTotalFinancialSummary, false);

       }
       
   }
  
  /**
    *  Update All Service Group and Type of work on opportunity product level. 
    *  @name updateType
    *  @param OpportunityLineItem[]
    *  @return void
    *  @throws exception
    */ 
public static void updateType(OpportunityLineItem[] newOpportunityLineItem){
      
      set<ID> setProductID = new set<ID>();
      set<ID> setOppID = new set<ID>();
      for(OpportunityLineItem OpportunityLineItem : newOpportunityLineItem){
          setProductID.add(OpportunityLineItem.Product2Id);
          setOppID.add(OpportunityLineItem.OpportunityId);
      }
      
      MAP<ID,Product2> mapProduct = new MAP<ID,Product2> ([Select id,Type_of_Work__c,Target_OI__c,Type__c from Product2 where id IN: setProductID]);
      MAP<ID,Opportunity> mapOpp = new MAP<ID,Opportunity>([SELECT Id, Total_Current_Revenue__c,Reporting_Status__c FROM Opportunity WHERE Reporting_Status__c not in (:UTIL_Constants.STAGENAME_CLIENT_WITHDREW, :UTIL_Constants.STAGENAME_AFS_WITHDREW, :UTIL_Constants.STAGENAME_WON, :UTIL_Constants.STAGENAME_LOST, :UTIL_Constants.STAGENAME_CLOSED) and id IN:setOppID]);
      
      for(OpportunityLineItem OpportunityLineItem : newOpportunityLineItem){
          if(mapProduct.containsKey(OpportunityLineItem.Product2Id)){
              OpportunityLineItem.Type__c = mapProduct.get(OpportunityLineItem.Product2Id).Type__c;
              OpportunityLineItem.Type_of_Work__c = mapProduct.get(OpportunityLineItem.Product2Id).Type_of_Work__c;
          }
          if(mapOpp.containsKey(OpportunityLineItem.OpportunityId)){
               OpportunityLineItem.Target_OI__c = mapProduct.get(OpportunityLineItem.Product2Id).Target_OI__c;
          }
          
          if(OpportunityLineItem.Target_OI__c != null && OpportunityLineItem.Total_Costs__c != null){
                OpportunityLineItem.Target_OI_Temp_Calc__c = OpportunityLineItem.Total_Costs__c/(1-OpportunityLineItem.Target_OI__c/100);
                  System.debug('------------------OpportunityLineItem.Target_OI_Temp_Calc__c ='+OpportunityLineItem.Target_OI_Temp_Calc__c );
              }
              System.debug('------------------OpportunityLineItem.Type__c='+OpportunityLineItem.Type__c);
               System.debug('------------------OpportunityLineItem.Type_of_Work='+OpportunityLineItem.Type_of_Work__c);
                System.debug('------------------OpportunityLineItem.Target_OI='+OpportunityLineItem.Target_OI__c);
          }
      
      
  }
 // public void calculateTarget(){
      

}