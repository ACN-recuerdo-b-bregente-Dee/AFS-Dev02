/**
   @Author Pablito M. Abalos Jr
   @name AttributeTrigger
   @CreateDate 2/17/2015
   @Description This class validate attribute records on before update event.
   @Version <1.0>
   @reference 
 */
public class AttributeBL{
    public static List<Attribute__c> attrib = new List<Attribute__c>();
    public static List<Opportunitylineitem> oppLineItem = new List<Opportunitylineitem>();
    
    
    /**
    *  To validate Attribute record in opportunity level 
    *  @name validateAttribute
    *  @param Opportunity[] Old, New and Opportunity Sobject
    *  @return void
    *  @throws exception
    */
    public static String validateAttribute(Opportunity[] oldOpportunities , Opportunity[] newOpportunities){
        Map<String, Custom_Error_Messages__c> message = Custom_Error_Messages__c.getAll();
        Set<ID> oppsIDs = new Set<ID>();
        String attribErrorMessage = UTIL_Constants.STRING_EMPTY;
        
        for (Integer i = 0; i < newOpportunities.size(); i++) {
            System.debug('Value of: oldOpportunities: ' + oldOpportunities[i].Status_Stage_Requested__c + ' - ' +oldOpportunities[i].id+ ' newOpportunities: '+ newOpportunities[i].Status_Stage_Requested__c + ' - ' +newOpportunities[i].id);
            if (oldOpportunities[i].Status_Stage_Requested__c != newOpportunities[i].Status_Stage_Requested__c){

                Integer mC_OFFERING = 0, mC_OFFERINGTOTAL = 0, 
                        tGP_SI = 0 ,tGP_SITOTAL = 0, 
                        tGP_AO = 0,tGP_AOTOTAL =0, 
                        tGP_IO = 0,tGP_IOTOTAL = 0, 
                        tGP_TC = 0,tGP_TCTOTAL = 0;
                          
                Integer mC_OFFER = 0, sI = 0, aO = 0, iO = 0, tC = 0;
                
                
                
                for(Opportunity OppId : newOpportunities){
                    oppsIDs.add(OppId.id);
                }
                
                attrib = [SELECT id, Name, Attribute_Type__c, Attribute_Value__c, AttributePercent__c, Opportunity_Name__c FROM Attribute__c WHERE Opportunity_Name__c in : oppsIDs ORDER BY Attribute_Type__c, Attribute_Value__c ASC LIMIT 50000];
                oppLineItem = [SELECT Id, OpportunityId, Type__c, Revenue__c FROM OpportunityLineItem WHERE OpportunityId in : oppsIDs LIMIT 50000];
            
                for(Opportunity Opp : newOpportunities){
                    
                    

                    String [] typeNames = UTIL_Constants.STAGEREQ_2A_3.split(UTIL_Constants.STRING_COMMA);
                    
                    for(String typeName : typeNames){
                    
                        if (opp.Status_Stage_Requested__c ==typeName){
                            
                            for(Opportunitylineitem oppLineItems : oppLineItem){
                                if(oppLineItems.OpportunityId.equals(Opp.id)){
                                    if(oppLineItems.Type__c != null){
                                        if(oppLineItems.Type__c.equals(UTIL_Constants.PRODUCT_MC) && oppLineItems.Revenue__c != null){
                                            ++mC_OFFER;
                                        }
                                        if(oppLineItems.Type__c.equals(UTIL_Constants.PRODUCT_SI) && oppLineItems.Revenue__c != null){
                                            ++sI;
                                        }
                                        if(oppLineItems.Type__c.equals(UTIL_Constants.PRODUCT_AO) && oppLineItems.Revenue__c != null){
                                            ++aO;
                                        }
                                        if(oppLineItems.Type__c.equals(UTIL_Constants.PRODUCT_IO) && oppLineItems.Revenue__c != null){
                                            ++iO;
                                        }
                                        if(oppLineItems.Type__c.equals(UTIL_Constants.PRODUCT_TC) && oppLineItems.Revenue__c != null){
                                            ++tC;
                                        }
                                    }
                                }
                            }
                            if(!attrib.isEmpty()){
                                for(Attribute__c attr : attrib){
                                    if(attr.Opportunity_Name__c.equals(Opp.Id)){
                                                                       
                                        //MC Offerings validation
                                        if(attr.Attribute_Type__c.equals(UTIL_Constants.MC_OFERRING))
                                        {   
                                            mC_OFFERINGTOTAL += Integer.valueOf(attr.AttributePercent__c);                        
                                            ++mC_OFFERING;
                                        }
                                        //TGP SI validation
                                        if(attr.Attribute_Type__c.equals(UTIL_Constants.TGP_SI))
                                        {   
                                            tGP_SITOTAL += Integer.valueOf(attr.AttributePercent__c);                        
                                            ++tGP_SI;
                                        }
                                        //TGP AO valdiation
                                        if(attr.Attribute_Type__c.equals(UTIL_Constants.TGP_AO))
                                        {   
                                            tGP_AOTOTAL += Integer.valueOf(attr.AttributePercent__c);                        
                                            ++tGP_AO;
                                        }
                                        //TGP IO valdiation
                                        if(attr.Attribute_Type__c.equals(UTIL_Constants.TGP_IO))
                                         {   
                                            tGP_IOTOTAL += Integer.valueOf(attr.AttributePercent__c);                        
                                            ++tGP_IO;
                                        }
                                        //TGP TC validation
                                        if(attr.Attribute_Type__c.equals(UTIL_Constants.TGP_TC))
                                        {   
                                            tGP_TCTOTAL += Integer.valueOf(attr.AttributePercent__c);                        
                                            ++tGP_TC;
                                        }
                                    }
                                }
                            }
                            
                            //MC Offerings validation
                            if(mC_OFFERING==0  && mC_OFFER != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_007).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            if(mC_OFFERINGTOTAL != 0 && mC_OFFERINGTOTAL!=100 && mC_OFFER != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_022).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                                                    
                            if(mC_OFFERINGTOTAL != 0 && mC_OFFER == 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_017).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            //TGP SI validation
                            if(tGP_SITOTAL==0  && sI != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_009).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            if(tGP_SITOTAL != 0 && tGP_SITOTAL != 100 && sI != 0 ){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_023).Error_Message__c + UTIL_Constants.STRING_BREAK; 
                            }
                            
                            if(tGP_SITOTAL != 0 && sI == 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_018).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            //TGP AO validation
                            if(tGP_AOTOTAL==0  && aO != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_011).Error_Message__c + UTIL_Constants.STRING_BREAK; 
                            }
                            
                            if(tGP_AOTOTAL != 0 && tGP_AOTOTAL != 100 && aO != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_024).Error_Message__c+ UTIL_Constants.STRING_BREAK; 
                            }
                            
                            if(tGP_AOTOTAL != 0 && aO == 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_019).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            //TGP IO validation
                            if(tGP_IOTOTAL==0  && iO != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_013).Error_Message__c+ UTIL_Constants.STRING_BREAK;
                            }
                            
                            if(tGP_IOTOTAL != 0 && tGP_IOTOTAL != 100 && iO != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_025).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            if(tGP_IOTOTAL != 0 && iO == 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_020).Error_Message__c + UTIL_Constants.STRING_BREAK;
                            }
                            
                            //TGP TC validation
                            if(tGP_TCTOTAL==0  && tC != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE +message.get(UTIL_Constants.ERROR_MSG_ATT_015).Error_Message__c + UTIL_Constants.STRING_BREAK;  
                            }
                            
                            if(tGP_TCTOTAL != 0 && tGP_TCTOTAL != 100 && tC != 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_026).Error_Message__c + UTIL_Constants.STRING_BREAK; 
                            }
                            
                            if(tGP_TCTOTAL != 0 && tC == 0){
                                attribErrorMessage += UTIL_Constants.STRING_SPAN_SPACE + message.get(UTIL_Constants.ERROR_MSG_ATT_021).Error_Message__c+ UTIL_Constants.STRING_BREAK; 
                            }
                            
                            /*if(!attribErrorMessage.equals(UTIL_Constants.STRING_EMPTY) || attribErrorMessage.length() != 0)
                            {
                                Opps.AddError(attribErrorMessage.substring(0, attribErrorMessage.length() - 1));
                            }*/
                            
                        }
                    }
                }
            }
        }
        return attribErrorMessage; 
    }
}