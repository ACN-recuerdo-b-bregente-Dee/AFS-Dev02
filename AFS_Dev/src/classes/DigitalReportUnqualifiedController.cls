public class DigitalReportUnqualifiedController {

    public static Decimal opportunityTotalCurrency {get;set;}
    public static Decimal accentureTotalCurrency = 0;  
    public static Decimal accentureTotalPercentage {get;set;}
    public static Decimal otherTotalPercentage = 0;       
    public List<chartData> getData() 
    {
        return getChartData();
    } 
    
    public List<Attribute__c> digitalPipeline {get; set;}
    public List<Attribute__c> nonDigitalPipeline {get; set;}
    public List<Attribute__c> noAttributePipeline {get; set;}
    public List<Attribute__c> grandTotal {get; set;}
    public Map<Id, Opportunity> allOpportunities {get; set;}
    public Integer digitalSize {get; set;}
    public Integer nonDigitalSize {get; set;}
    public Integer noAttributeSize {get; set;}
    public Integer grandTotalSize {get; set;}
    public String digitalSum {get; set;}
    public String nonDigitalSum {get; set;}
    public String noAttributeSum {get; set;}
    public String digitalOppSum {get; set;}
    public String nonDigitalOppSum {get; set;}
    public String noAttributeOppSum {get; set;}
    public String grandSum {get; set;}
    public String grandOppSum {get; set;}
    
    List<chartData> chartSource {get;set;}
    public List<chartData> getChartData(){
        chartSource = new List<chartData>();
  

        Decimal opportunityTotalPercentage = 0;

        Decimal otherTotalCurrency = 0;
        //Decimal otherTotalPercentage = 0;
        Decimal interactiveTotalCurrency = 0;
        Decimal analyticsTotalCurrency = 0;
        Decimal mobilityTotalCurrency = 0;
        Decimal interactiveTotalPercentage = 0;
        Decimal analyticsTotalPercentage = 0;
        Decimal mobilityTotalPercentage = 0;
        
        AggregateResult[] totalOppTCR;
        AggregateResult[] totalAccentureTCR;
        AggregateResult[] totalInteractiveTCR;
        AggregateResult[] totalAnalyticsTCR;
        AggregateResult[] totalMobilityTCR;
        
        Opportunity[] allOpportunities = new List<Opportunity>([
        SELECT Id FROM Opportunity WHERE  Reporting_Status__c = 'Unqualified'  
        ]);
        
        //try{
        totalOppTCR =[SELECT SUM(Total_Current_Revenue__c) totalOppTCR FROM Opportunity WHERE Id IN: allOpportunities];
        totalAccentureTCR = [SELECT SUM(Accenture_Digital_TCR__c) totalAccentureTCR FROM Attribute__c WHERE Opportunity_Name__c IN:
                            allOpportunities AND Attribute_Type__c = 'Accenture Digital'];
        totalInteractiveTCR = [SELECT SUM(Accenture_Digital_TCR__c) totalInteractiveTCR FROM Attribute__c WHERE Opportunity_Name__c IN:
                                allOpportunities AND Attribute_Type__c = 'Accenture Digital' AND Attribute_Value__c = 'Interactive' ];
                                
        totalAnalyticsTCR = [SELECT SUM(Accenture_Digital_TCR__c) totalAnalyticsTCR FROM Attribute__c WHERE Opportunity_Name__c IN:
                                allOpportunities AND Attribute_Type__c = 'Accenture Digital' AND Attribute_Value__c = 'Analytics' ];
        totalMobilityTCR = [SELECT SUM(Accenture_Digital_TCR__c) totalMobilityTCR FROM Attribute__c WHERE Opportunity_Name__c IN:
                                allOpportunities AND Attribute_Type__c = 'Accenture Digital' AND Attribute_Value__c = 'Mobility' ];                         
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
        if(totalInteractiveTCR[0].get('totalInteractiveTCR') != NULL){
            interactiveTotalCurrency = (decimal) totalInteractiveTCR[0].get('totalInteractiveTCR'); 
            interactiveTotalPercentage = (interactiveTotalCurrency / accentureTotalCurrency) * accentureTotalPercentage ;  
        }
        if(totalAnalyticsTCR[0].get('totalAnalyticsTCR') != NULL){
            analyticsTotalCurrency = (decimal) totalAnalyticsTCR[0].get('totalAnalyticsTCR');
            analyticsTotalPercentage = (analyticsTotalCurrency / accentureTotalCurrency) * accentureTotalPercentage ;
        }
        if(totalMobilityTCR[0].get('totalMobilityTCR') != NULL ){
            mobilityTotalCurrency = (decimal) totalMobilityTCR[0].get('totalMobilityTCR');
            mobilityTotalPercentage =  (mobilityTotalCurrency / accentureTotalCurrency ) * accentureTotalPercentage ;
        }
        
        
        
        
        //chartSource.add(new chartData('Accenture Digital : '+ accentureTotalPercentage.setScale(2) +'%\n$' + accentureTotalCurrency.format(), accentureTotalCurrency, accentureTotalPercentage.setScale(2)));
        chartSource.add(new chartData('Non-Digital Opp TCR: ' + otherTotalPercentage.setScale(2) +'%\n$' + otherTotalCurrency.format(), otherTotalCurrency, otherTotalPercentage.setScale(2)));
        chartSource.add(new chartData('Interactive: ' + interactiveTotalPercentage.setScale(2) +'%\n$' + interactiveTotalCurrency.format(), interactiveTotalCurrency,interactiveTotalPercentage.setScale(2)));
        chartSource.add(new chartData('Analytics:  ' + analyticsTotalPercentage.setScale(2) +'%\n$' + analyticsTotalCurrency.format(), analyticsTotalCurrency,analyticsTotalPercentage.setScale(2)));
        chartSource.add(new chartData('Mobility:  ' + mobilityTotalPercentage.setScale(2) +'%\n$' + mobilityTotalCurrency.format(), mobilityTotalCurrency,mobilityTotalPercentage.setScale(2)));      
        //}
        
        return chartSource;
    }
    //wrapper class
    public class chartData{
        public string name {get;set;}
        public decimal data {get;set;}
        public decimal dataPercentage {get;set;}
        public Decimal overalTotalCurrency  {get;set;}
        public Decimal accDigitalTotalCurrency {get;set;}
        public Decimal overallTotalPercent {get;set;}
        public decimal accDigitalTotalPercent {get;set;}
        public string formattedOveralTotalCurrency {get;set;}
        public string formatteAccDigitalTotalCurrency {get;set;}
        
        public chartData(string name, decimal data, decimal dataPercentage){
        this.name = name;
        this.data = data;
        this.dataPercentage = dataPercentage;
        this.overalTotalCurrency = opportunityTotalCurrency; 
        this.accDigitalTotalCurrency = accentureTotalCurrency; 
        this.overallTotalPercent = otherTotalPercentage;
        //this.accDigitalTotalPercent = accentureTotalPercentage.setScale(3); 
        this.accDigitalTotalPercent =  Math.round(accentureTotalPercentage* 100) / 100.00;
        this.formattedOveralTotalCurrency = '$' + String.valueOf(overalTotalCurrency.format());
        this.formatteAccDigitalTotalCurrency = '$' + String.valueOf(accentureTotalCurrency.format());
        //this.overalTotalCurrency = String.valueOf(Math.random() * 1000);
        
    }
    }
    
    public PageReference getReport() {
        allOpportunities = new Map<Id, Opportunity>([
        SELECT Id, Total_Current_Revenue__c FROM Opportunity WHERE  Reporting_Status__c = 'Unqualified'  
        ]);
        
        
        digitalPipeline = new List<Attribute__c>();
        nonDigitalPipeline = new List<Attribute__c>();
        noAttributePipeline = new List<Attribute__c>();
        grandTotal = new List<Attribute__c>();
        Set<Id> oppWithAttribute = new Set<Id>();
        Decimal dSum = 0;
        Decimal ndSum = 0;
        Decimal noAttSum = 0;
        Decimal dOppSum = 0;
        Decimal ndOppSum = 0;
        Decimal noAttOppSum = 0;
        Decimal grandTotalOppTCR = 0;
        
        Set<Id> digitalOpp = new Set<Id>();
        Set<Id> nonDigitalOpp = new Set<Id>();
        Set<Id> allOpp = new Set<Id>();
        for(Attribute__c attribute : [SELECT Opportunity_Name__c, Attribute_Type__c, Attribute_Value__c, Attribute_TCR__c, AttributePercent__c
                                        FROM Attribute__c WHERE Opportunity_Name__c IN :allOpportunities.keySet()]){
            oppWithAttribute.add(attribute.Opportunity_Name__c);
            Decimal tcr = 0;
            if(attribute.Attribute_TCR__c != null){
                tcr = attribute.Attribute_TCR__c;
            }
            
            Decimal oppTcr = 0;
            if(allOpportunities.get(attribute.Opportunity_Name__c).Total_Current_Revenue__c != null){
                oppTcr = allOpportunities.get(attribute.Opportunity_Name__c).Total_Current_Revenue__c;
            }
            
            if(attribute.Attribute_Type__c.equals('Accenture Digital')){
                digitalPipeline.add(attribute);
                dSum += tcr;
                if(!digitalOpp.contains(attribute.Opportunity_Name__c)){
                    dOppSum += oppTcr;
                    digitalOpp.add(attribute.Opportunity_Name__c);
                }
            }
            else{
                nonDigitalPipeline.add(attribute);
                ndSum += tcr;
                if(!nonDigitalOpp.contains(attribute.Opportunity_Name__c)){
                    ndOppSum += oppTcr;
                    nonDigitalOpp.add(attribute.Opportunity_Name__c);
                }
            }
            
            if(!allOpp.contains(attribute.Opportunity_Name__c)){
                grandTotalOppTCR += oppTcr;
                allOpp.add(attribute.Opportunity_Name__c);
            }
        }
        
        for(Id oppId : allOpportunities.keySet()){
            if(!oppWithAttribute.contains(oppId)){
                noAttributePipeline.add(new Attribute__c(
                    Opportunity_Name__c = oppId,
                    Attribute_Type__c = '-',
                    Attribute_Value__c = '-',
                    AttributePercent__c = null
                    ));
                noAttOppSum += allOpportunities.get(oppId).Total_Current_Revenue__c;
                grandTotalOppTCR += allOpportunities.get(oppId).Total_Current_Revenue__c;
            }
        }
        
        digitalSize = digitalPipeline.size();
        nonDigitalSize = nonDigitalPipeline.size();
        noAttributeSize = noAttributePipeline.size();
        grandTotalSize = digitalSize + nonDigitalSize + noAttributeSize;
        
        digitalSum = dSum.format();
        nonDigitalSum = ndSum.format();
        noAttributeSum = noAttSum.format();
        digitalOppSum = dOppSum.format();
        nonDigitalOppSum = ndOppSum.format();
        noAttributeOppSum = noAttOppSum.format();
        grandSum = (dSum + ndSum + noAttSum).format();
        grandOppSum = grandTotalOppTCR.format();
        
        
        return null;
    }
    
    public PageReference getReports() {
        allOpportunities = new Map<Id, Opportunity>([
        SELECT Id, Total_Current_Revenue__c FROM Opportunity WHERE  Reporting_Status__c = 'Unqualified'  
        ]);
        
        
        digitalPipeline = new List<Attribute__c>();
        nonDigitalPipeline = new List<Attribute__c>();
        noAttributePipeline = new List<Attribute__c>();
        grandTotal = new List<Attribute__c>();
        Set<Id> oppWithAttribute = new Set<Id>();
        Decimal dSum = 0;
        Decimal ndSum = 0;
        Decimal noAttSum = 0;
        Decimal dOppSum = 0;
        Decimal ndOppSum = 0;
        Decimal noAttOppSum = 0;
        Decimal grandTotalOppTCR = 0;
        
        Set<Id> digitalOpp = new Set<Id>();
        Set<Id> nonDigitalOpp = new Set<Id>();
        Set<Id> allOpp = new Set<Id>();
        for(Attribute__c attribute : [SELECT Opportunity_Name__c, Attribute_Type__c, Attribute_Value__c, Attribute_TCR__c, AttributePercent__c
                                        FROM Attribute__c WHERE Opportunity_Name__c IN :allOpportunities.keySet()]){
            oppWithAttribute.add(attribute.Opportunity_Name__c);
            Decimal tcr = 0;
            if(attribute.Attribute_TCR__c != null){
                tcr = attribute.Attribute_TCR__c;
            }
            
            Decimal oppTcr = 0;
            if(allOpportunities.get(attribute.Opportunity_Name__c).Total_Current_Revenue__c != null){
                oppTcr = allOpportunities.get(attribute.Opportunity_Name__c).Total_Current_Revenue__c;
            }
            
            if(attribute.Attribute_Type__c.equals('Accenture Digital')){
                digitalPipeline.add(attribute);
                dSum += tcr;
                if(!digitalOpp.contains(attribute.Opportunity_Name__c)){
                    dOppSum += oppTcr;
                    digitalOpp.add(attribute.Opportunity_Name__c);
                }
            }
            else{
                nonDigitalPipeline.add(attribute);
                ndSum += tcr;
                if(!nonDigitalOpp.contains(attribute.Opportunity_Name__c)){
                    ndOppSum += oppTcr;
                    nonDigitalOpp.add(attribute.Opportunity_Name__c);
                }
            }
            
            if(!allOpp.contains(attribute.Opportunity_Name__c)){
                grandTotalOppTCR += oppTcr;
                allOpp.add(attribute.Opportunity_Name__c);
            }
        }
        
        for(Id oppId : allOpportunities.keySet()){
            if(!oppWithAttribute.contains(oppId)){
                nonDigitalPipeline.add(new Attribute__c(
                    Opportunity_Name__c = oppId,
                    Attribute_Type__c = null,
                    Attribute_Value__c = null,
                    AttributePercent__c = null
                    ));
                ndOppSum += allOpportunities.get(oppId).Total_Current_Revenue__c;
                grandTotalOppTCR += allOpportunities.get(oppId).Total_Current_Revenue__c;
            }
        }
        
        digitalSize = digitalPipeline.size();
        nonDigitalSize = nonDigitalPipeline.size();
        grandTotalSize = digitalSize + nonDigitalSize;
        
        digitalSum = dSum.format();
        nonDigitalSum = ndSum.format();
        digitalOppSum = dOppSum.format();
        nonDigitalOppSum = ndOppSum.format();
        grandSum = (dSum + ndSum).format();
        grandOppSum = grandTotalOppTCR.format();
        
        
        return null;
    }
    
    public pagereference goToReport(){
        PageReference pageRef = new PageReference('/00OJ0000000POAa');
        pageRef.setRedirect(true);
        return null;
    }
    
    public pagereference goToReportLink(){
        PageReference pageRef = new PageReference('/00OJ0000000POAa');
        pageRef.setRedirect(false);
        return pageRef;
    }
    

}