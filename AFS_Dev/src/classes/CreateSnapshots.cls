/**
* Class Name            CreateSnapshots
* Date                  04/14/2015
* Description           Apex class that will automatically create a quote when an Opportunity is Approved to the next stage. 
*/

/*
 * Class for CreateSnapshots
 */
public class CreateSnapshots {
    /*
     * Method for CreateQuotes
     */
    public static void createQuotes(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities) {

    //create a new Quote record
    //everytime the Approved Status/Stage is updated.
        for (Integer i = 0; i < newOpportunities.size(); i++) {

            if (oldOpportunities[i].Approved_Status_Stage__c != newOpportunities[i].Approved_Status_Stage__c) {

                Quote newQuote = new Quote(
                   
                        Name = UTIL_Constants.QUOTE_NAME +  newOpportunities[i].Approved_Status_Stage__c, 
                        OpportunityId = newOpportunities[i].Id,
                        Pricebook2Id = newOpportunities[i].Pricebook2Id,
                        Approved_Status_Stage__c = newOpportunities[i].Approved_Status_Stage__c,
                        Consulting_Start__c = newOpportunities[i].Consulting_Start__c,
                        Consulting_End__c = newOpportunities[i].Consulting_End__c,
                        ActualContractSigningDate__c = newOpportunities[i].Actual_Contract_Sign_Date__c,
                        //Stage__c = newOpportunities[i].Stagename,
                        DraftRFPReleaseDate__c = newOpportunities[i].Draft_RFP_Release_Date__c,
                        CloseDate__c = newOpportunities[i].CloseDate,
                        OutsourcingEnd__c = newOpportunities[i].Outsourcing_End__c,
                        OutsourcingStart__c = newOpportunities[i].Outsourcing_Start__c,
                        PeakCapitalBalance__c = newOpportunities[i].Peak_Capital_Balance__c,
                        ProposalSubmissionDate__c = newOpportunities[i].Proposal_Submission_Date__c,
                        ReportingStatus__c = newOpportunities[i].Reporting_Status__c,
                        Reporting_Status_Date__c = newOpportunities[i].Reporting_Status_Since__c,
                        RFPReleaseDate__c = newOpportunities[i].RFP_Release_Date__c,
                        Hierarchy_Level__c = newOpportunities[i].Hierarchy_Level__c,
                        Total_Current_Revenue__c = newOpportunities[i].Total_Current_Revenue__c,
                        Follow_On_Revenue__c = newOpportunities[i].Follow_On_Revenue__c,
                        Services_Revenue__c = newOpportunities[i].Services_Revenue__c,
                        Total_Deal_Potential__c = newOpportunities[i].Total_Deal_Potential__c,
                        Subcontractor_Involvement__c = newOpportunities[i].Subcontractor_Involvement__c,
                        Solution_Baseline_Review_Date__c = newOpportunities[i].Solution_Baseline_Review__c,
                        Black_Hat_Review_Date__c = newOpportunities[i].Black_Hat_Review__c,
                        PTW_Review_Date__c = newOpportunities[i].PTW_Review__c,
                        Color_Team_Review_Date__c = newOpportunities[i].Color_Team_Review_Date__c,
                        PRG_Review_Date__c = newOpportunities[i].PRG_Review_Date__c,
                        Contract_Management_Review_Date__c = newOpportunities[i].Date_of_Contract_Management_Review_Date__c,
                        Complexity_Category__c = newOpportunities[i].Complexity_Category__c,
                        Complexity_Description__c = newOpportunities[i].Complexity_Description__c,
                        QA_Assessment_Stage_2B__c = newOpportunities[i].QA_Assessment_Stage_2B__c,
                        QA_Assessment_Stage_3__c = newOpportunities[i].QA_Assessment_Stage_3__c,
                        QA_Risk_Tier_Stage_2B__c = newOpportunities[i].QA_Risk_Tier_Stage_2B__c,
                        QA_Risk_Tier_Stage_3__c = newOpportunities[i].QA_Risk_Tier_Stage_3__c,
                        Stage_1A_Entry_Date__c = newOpportunities[i].Stage_1A_Entry_Date__c,
                        Stage_1B_Entry_Date__c = newOpportunities[i].Stage_1B_Entry_Date__c,
                        Stage_2A_Entry_Date__c = newOpportunities[i].Stage_2A_Entry_Date__c,
                        Stage_2B_Entry_Date__c = newOpportunities[i].Stage_2B_Entry_Date__c,
                        Stage_3_Entry_Date__c = newOpportunities[i].Stage_3_Entry_Date__c,
                        Overall_Total_HW_SW__c = newOpportunities[i].Overall_Total_HW_SW__c,
                        TCR_OI__c = newOpportunities[i].TCR_OI__c,
                        TDP_OI__c = newOpportunities[i].TDP__c,
                        Financial_Notes__c = newOpportunities[i].Financial_Notes__c,
                        Probability__c = newOpportunities[i].Probability,
                        Primary_Function__c = newOpportunities[i].Primary_Function__c,
                        Total_WTD_Revenue__c = newOpportunities[i].Total_WTD_Revenue__c

                );
                //insert newQuote;
                Database.insert(newQuote, false);
               
                //this will copy and insert the fields values of 
                //opportunity products to quote line item
                List<QuoteLineItem> lineItems = new List<QuoteLineItem>();
                for (OpportunityLineItem oli : 
                    [SELECT PricebookEntryId, Product2Id, Quantity, UnitPrice, Revenue__c, Total_Costs__c, OI__c, Target_OI__c , 
                    HW_SW_Costs__c, Subcontractor_Expenses__c, Other_Cost_Components__c, OI_Value__c, Target_Difference__c
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :newOpportunities[i].Id LIMIT 5000]) { // Default maximum of SOQL rows to 5000
                    lineItems.add(
                    
                        new QuoteLineItem(
                            PricebookEntryId = oli.PricebookEntryId, 
                            Product2Id = oli.Product2Id, 
                            Quantity = oli.Quantity, 
                            UnitPrice = oli.UnitPrice,
                            QuoteId = newQuote.Id,
                            Revenue__c = oli.Revenue__c,
                            Target_OI__c = oli.Target_OI__c,
                            Total_Costs__c = oli.Total_Costs__c,
                            OI__c = oli.OI__c,
                            HW_SW_Costs__c = oli.HW_SW_Costs__c,
                            Subcontractor_Expenses__c = oli.Subcontractor_Expenses__c,
                            Other_Cost_Components__c = oli.Other_Cost_Components__c,
                            OI_Value__c = oli.OI_Value__c,
                            Target_Difference__c = oli.Target_Difference__c
                            
                        )
                    );
                }
                //insert lineItems;
                Database.insert(lineItems, false);
                //this will copy and insert the fields values of 
                //opportunity financial summary to quote financial summary               
                List<Quote_Financial_Summary__c> qfs = new List<Quote_Financial_Summary__c>();
                for (Financial_Summary__c ofs : 
                    [SELECT 
                        Financial_Summary_Type__c,HW_SW_Costs__c,OI__c,OI_Value__c,
                        Opportunity__c,Other_Costs__c,Revenue__c,Subcontractor_Expenses__c,
                        Target_Difference__c, Target_Percentage__c, Total_Costs__c,WTD_Current_Revenue__c
                    FROM Financial_Summary__c
                    WHERE Opportunity__c = :newOpportunities[i].Id LIMIT 5000]) { // Default maximum of SOQL rows to 5000
                    qfs.add(
                        new Quote_Financial_Summary__c(
                            Financial_Summary_Type__c = ofs.Financial_Summary_Type__c,
                            HW_SW_Costs__c = ofs.HW_SW_Costs__c,
                            OI__c = ofs.OI__c,
                            OI_Value__c = ofs.OI_Value__c,
                            Opportunity__c = ofs.Opportunity__c,
                            Other_Costs__c = ofs.Other_Costs__c,
                            Revenue__c = ofs.Revenue__c,
                            Subcontractor_Expenses__c = ofs.Subcontractor_Expenses__c,
                            Target_Difference__c = ofs.Target_Difference__c,
                            Target_OI__c = ofs.Target_Percentage__c,
                            Total_Costs__c = ofs.Total_Costs__c,
                            WTD_Current_Revenue__c = ofs.WTD_Current_Revenue__c,
                            Quote__c = newQuote.Id
                        )
                    );
                }
                //insert qfs;
                Database.insert(qfs, false);
            }
        }
    }
}