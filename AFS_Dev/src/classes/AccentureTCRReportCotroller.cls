public class AccentureTCRReportCotroller {

    public Decimal opportunityTotalCurrency = 0;
    public List<chartData> getData() 
    {
        return getChartData();
    } 
    
    List<chartData> chartSource {get;set;}
    public List<chartData> getChartData(){
        chartSource = new List<chartData>();

        Decimal accentureTotalCurrency = 0;
        Decimal opportunityTotalPercentage = 0;
        Decimal accentureTotalPercentage = 0;
        Decimal otherTotalCurrency = 0;
        Decimal otherTotalPercentage = 0;
        AggregateResult[] totalOppTCR;
        AggregateResult[] totalAccentureTCR;
        
        Opportunity[] allOpportunities = new List<Opportunity>([
        SELECT Id FROM Opportunity WHERE Reporting_Status__c = 'Qualified'
        ]);
        
        //try{
        totalOppTCR =[SELECT SUM(Total_Current_Revenue__c) totalOppTCR FROM Opportunity WHERE Id IN: allOpportunities];
        totalAccentureTCR = [SELECT SUM(Accenture_Digital_TCR__c) totalAccentureTCR FROM Attribute__c WHERE Opportunity_Name__c IN:
        allOpportunities AND Attribute_Type__c = 'Accenture Digital'];
        //} catch(Exception e){
        
        
        if(totalOppTCR[0].get('totalOppTCR') != NULL){
            opportunityTotalCurrency = (decimal) totalOppTCR[0].get('totalOppTCR');
        }
        if(totalAccentureTCR[0].get('totalAccentureTCR') != NULL){
            accentureTotalCurrency = (decimal) totalAccentureTCR[0].get('totalAccentureTCR');
            accentureTotalPercentage = (accentureTotalCurrency / opportunityTotalCurrency) * 100;
            otherTotalCurrency = (decimal) opportunityTotalCurrency - accentureTotalCurrency;
            otherTotalPercentage = 100 - accentureTotalPercentage;

        }
        
        chartSource.add(new chartData('Digital TCR: '+ accentureTotalPercentage.setScale(2) +'%\n$' + accentureTotalCurrency.format() + '.' + String.valueOf(accentureTotalCurrency.setScale(2)).split('\\.')[1], accentureTotalCurrency, accentureTotalPercentage.setScale(2)));
        chartSource.add(new chartData('Non Digital TCR: ' + otherTotalPercentage.setScale(2) +'%\n$' + otherTotalCurrency.format() + '.' + String.valueOf(otherTotalCurrency.setScale(2)).split('\\.')[1], otherTotalCurrency, otherTotalPercentage.setScale(2)));
        //}
        
        return chartSource;
    }
    //wrapper class
    public class chartData{
        public string name {get;set;}
        public decimal data {get;set;}
        public decimal dataPercentage {get;set;}
        
        public chartData(string name, decimal data, decimal dataPercentage){
        this.name = name;
        this.data = data;
        this.dataPercentage = dataPercentage;
    }
    }
    
    
    

}