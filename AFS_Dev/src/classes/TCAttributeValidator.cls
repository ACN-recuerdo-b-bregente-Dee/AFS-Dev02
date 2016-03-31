//Purpose: to validate the opportunities' attributes. will make sure aggregate
//			percentage of each attribute is 100% and that there is at least 1
//			attribute of each type in every opportunity
//Date: 3/28/2016
//Written By: Raymond Garcia

global class TCAttributeValidator implements Database.Batchable<sObject> {
    //purpose: to start the lifecycle of the batch class
    //input: context of the class (context)
    //output: query locator
    global Database.QueryLocator start(Database.BatchableContext context){
        //write real query pull all open opportunities which have all tc items (still only use this opp as testing) util constants
        String oppType = AttributeValidator_Helper__c.getValues('Opportunity Placeholder').Parameter__c;
        string query = Util_Constants.ATTRIBUTE_VALIDATION_BATCHQUERY1 + Util_Constants.ATTRIBUTE_VALIDATION_BATCHQUERY2 + oppType;
        return Database.getQueryLocator(query);
    }
    //purpose: to run the logic of class
    //input: context of the class (context), list of opps from start query
    //output: none
    global void execute(Database.BatchableContext context, List<sObject> lineItems){
        List<Attribute__c> toUpdate  = new List<Attribute__c>();
        Set<Id> opps = new Set<Id>();
        
        //get a set of unique opps from the queried line items
        for(sObject lineItem: lineItems)
            opps.add(((OpportunityLineItem)lineItem).Opportunity.ID);
        
        for(Id currentOpp: opps)
            //validate each opportunity's attributes
            toUpdate.addAll(validateAttributes(currentOpp));
        
        UPSERT toUpdate;
    }
    //purpose: to validate the attributes, make sure aggregate percentage is 100% 
    //			and that there is at least one of each attribute
    //input: current opportunity id
    //output: list of any placeholder atttributes needed to validate opp
    global List<Attribute__c> validateAttributes(id currentOpp){
        String attributeType = AttributeValidator_Helper__c.getValues('Attribute Placeholder').Parameter__c;
        List<Attribute__c> validated = new List<Attribute__c>();
        decimal totalTCPercentage = 0,
                totalSPercentage = 0;
        
        //take a total of all attribute percentages
        //retrieve only TC attributes
        for(Attribute__c currentAttribute: [SELECT id, attribute_value__c, attribute_type__c, attributepercent__c FROM Attribute__c WHERE opportunity_name__c = :currentOpp AND attribute_type__c = :attributeType]){
          //total of tc attributes
          if(currentAttribute.attribute_type__c == Util_Constants.TGP_TC)
              totalTCPercentage += currentAttribute.attributepercent__c;           
          else if(currentAttribute.attribute_type__c == Util_Constants.TGP_Strategy)
              totalSPercentage += currentAttribute.attributepercent__c; 

          else
              System.debug(attributeType + ' is not a handled attribute type');
        }
        
        //check if placeholder is necessary (total is less than 100%), create if needed	
	  if(attributeType == Util_Constants.TGP_TC && totalTCPercentage < 100)
        {
            Attribute__c placeholderAttribute = new Attribute__c();
            placeholderAttribute.AttributePercent__c = 100 - totalTCPercentage;
            placeholderAttribute.AttributeTxt__c = String.valueOf(placeholderAttribute.AttributePercent__c);
            //placeholderAttribute.Attribute_TypeName__c = Util_Constants.TGP_TC;
            placeholderAttribute.Attribute_Type__c = Util_Constants.TGP_TC;
            placeholderAttribute.Attribute_Value__c = 'TC-Placeholder Attribute';
            placeholderAttribute.Opportunity_Name__c = currentOpp;
            validated.add(placeholderAttribute);
        }if(attributeType == Util_Constants.TGP_Strategy && totalSPercentage < 100)
        {
            Attribute__c placeholderAttribute = new Attribute__c();
            placeholderAttribute.AttributePercent__c = 100 - totalSPercentage;
            placeholderAttribute.AttributeTxt__c = String.valueOf(placeholderAttribute.AttributePercent__c);
            //placeholderAttribute.Attribute_TypeName__c = Util_Constants.TGP_TC;
            placeholderAttribute.Attribute_Type__c = Util_Constants.TGP_Strategy;
            placeholderAttribute.Attribute_Value__c = 'S-Placeholder Attribute';
            placeholderAttribute.Opportunity_Name__c = currentOpp;
            validated.add(placeholderAttribute);
                
        }
        
        //return any placeholders created
        return validated;
    }
    //purpose: to end the lifecycle of the batch class
    //input: context of the class (context)
    //output: none
    global void finish(Database.BatchableContext context){
    }

}