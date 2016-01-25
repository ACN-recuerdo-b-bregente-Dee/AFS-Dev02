public with sharing class Opportunity_Chart_Controller 
{
    public List<Data> getData() 
    {
        return Opportunity_Chart_Controller.getChartData();
    } 
     
     // Actual Chart Data 
    public static List<Data> getChartData()
    {
        List<Data> data = new List<Data>();
        
        AggregateResult[] actualOppRec;
        AggregateResult[] pipelineOppRec;

        Decimal baselineVal;
        Decimal stretchVal;
        Decimal baselineVarianceVal;
        Decimal stretchVarianceVal;      
        Decimal actualOppRec2;
        Decimal pipelineOppRec2;
        
        baselineVal = 5;
        stretchVal = 6;
        
        try
        {
            actualOppRec = [SELECT SUM(Amount)sumAmt FROM Opportunity WHERE (Status_Stage_Requested__c = 'Won' AND CreatedDate = THIS_YEAR)];
            pipelineOppRec = [SELECT SUM(Amount)sumAmt2 FROM Opportunity WHERE Status_Stage_Requested__c != 'Won' AND   Status_Stage_Requested__c != 'Lost' AND CreatedDate = THIS_YEAR];
        }
        catch(QueryException e)
        {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Message: ' + e.getMessage()));
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error Location: ' + e.getStackTraceString()));
        }
        
        
        if(actualOppRec != null)
        {
            actualOppRec2 = (Decimal)actualOppRec[0].get('sumAmt');
        }
        else
        {
            actualOppRec2 = 0;
        }
        
        if(pipelineOppRec != null)
        {
            pipelineOppRec2 = (Decimal)pipelineOppRec[0].get('sumAmt2'); 
        }
        else
        {
            pipelineOppRec2 = 0;
        }
           
        baselineVarianceVal = baselineVal - (actualOppRec2 + pipelineOppRec2);
                
        if(baselineVarianceVal > 0)
        {
            stretchVarianceVal = stretchVal;
            data.add(new Data('FY16 Target', baselineVal, stretchVal, 0, 0, 0, 0));
            data.add(new Data('Year End Forecast', 0, 0, actualOppRec2,pipelineOppRec2,baselineVarianceVal,stretchVarianceVal));
        }
        else
        {
            stretchVarianceVal = stretchVal + baselineVarianceVal;
            data.add(new Data('FY16 Target', baselineVal, stretchVal, 0, 0, 0, 0));
            data.add(new Data('Year End Forecast', 0, 0, actualOppRec2,pipelineOppRec2,0,stretchVarianceVal));
        }        
        return data;
    }
    // Data Wrapper
    public class Data 
    {
        public String name { get; set; }
        public Decimal data1 { get; set; }
        public Decimal data2 { get; set; }
        public Decimal data3 { get; set; }
        public Decimal data4 { get; set; }
        public Decimal data5 { get; set; }
        public Decimal data6 { get; set; }
                
        public Data(String name, Decimal data1, Decimal data2, Decimal data3, Decimal data4, Decimal data5, Decimal data6) 
        {
            this.name = name;
            this.data1 = data1;
            this.data2 = data2; 
            this.data3 = data3;
            this.data4 = data4;
            this.data5 = data5;
            this.data6 = data6;            
        }
    }    
}