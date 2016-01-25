/**
   @Author Pablito Abalos
   @name AddAttributeExt
   @CreateDate 2/17/2015
   @Description manipulates the insert, update and delete multiple attributes on a single page as attributes and confirm allocation %s in one view
   @Version <1.0>
   @reference <Referenced program names>
  */
public with sharing class AddAttributeExt {

    public Opportunity OPP {get;set;}
    public Attribute__c ATT {get;set;}
    public List<Attribute__c> attributes {get;set;}
    public List<Attribute__c> toDelete {get;set;}    
    public Map<String, Offering> offerings {get;set;}
    public Map<String, Integer> collectTotal{get;set;}
    public Set<ID> attribID = new Set<Id>();
    ApexPages.StandardSetController controller;
    public List<Opportunitylineitem> oppLineItem = new List<Opportunitylineitem>();
    public Map<String, Custom_Error_Messages__c> message = Custom_Error_Messages__c.getAll();
    public Map<String, Attribute_help_desc__c> helpDescMessage = Attribute_help_desc__c.getAll();
    public List<Opportunity> opportunityRec = new List<Opportunity>();
    
    //public String helpMessage {get;set;}
    
    /**
    *  This helper class, hold temporarily the value of Attribute's list and its total allocation
    *  @name   Offering
    *  @param  none
    */
    public class Offering {
        public List<Attribute__c> Attributes {get;set;}
        public Integer Total {get;set;}
    }
    
   /**
   * This method will set the message value of helpMessage.
   * @param none
   * @return void
   */
    /*public void setMessage(){
        if(ATT.Attribute_Type__c != null){
            helpMessage = helpDescMessage.get(ATT.Attribute_Type__c).Description__c;
        }else{
            helpMessage = UTIL_Constants.STRING_EMPTY;
        }
        
    }*/
    
   /**
   * This is the attribute filter validation method which use to validate the data integrity of each attribute record.
   * @param Attribute__c attribute.
   * @return void
   */
    public AddAttributeExt(ApexPages.StandardSetController stdcontroller) {
        
        controller = stdcontroller;
        offerings = new Map<String, Offering>();
        collectTotal = new Map<String, Integer>();
        attributes = new List<Attribute__c>();
        toDelete = new List<Attribute__c>();

        //Retrieves the opportunity record base on the opportunity Id in the URL Parameter - Recuerdo
        List<Opportunity> opps = [
            SELECT Id, Name,
            (SELECT Id, Name, TotalPrice FROM OpportunityLineItems LIMIT 50000) 
            FROM Opportunity 
            WHERE Id = :ApexPages.currentPage().getParameters().get(UTIL_Constants.ID) LIMIT 50000
        ];
        
        //Instantiates a new Attribute record with opportunity is set to the retrieved opportunity record - Recuerdo
        if (!opps.isEmpty()) {
            OPP = opps[0];
            ATT = new Attribute__c(Opportunity_Name__c = OPP.Id);
        }
        
        //Retrieves all the Attribute records related to the retrieved opportunity record - Recuerdo
        attributes = [SELECT Name, id,Attribute_Check__c ,Attribute_TypeName__c, Attribute_Type__c, AttributeTxt__c, Attribute_TCR__c, Attribute_TDP__c, WTD_TDP__c, WTD_TCR__c, Attribute_Value__c, AttributePercent__c,Opportunity_Name__c FROM Attribute__c WHERE Opportunity_Name__c = :ApexPages.currentPage().getParameters().get(UTIL_Constants.ID) ORDER BY Attribute_Type__c, Attribute_Value__c ASC LIMIT 50000];
        //Retrieval of OpportunityLineItem records and Opportunity records are already done in the previous SOQL - Recuerdo
        oppLineItem = [SELECT Id, OpportunityId, Type__c, Revenue__c FROM OpportunityLineItem WHERE OpportunityId = : ApexPages.currentPage().getParameters().get(UTIL_Constants.ID) LIMIT 50000];
        opportunityRec = [Select id, Status_Stage_Requested__c from Opportunity where Id = :  ApexPages.currentPage().getParameters().get(UTIL_Constants.ID) limit 1];
  
        for (Attribute__c attribute : attributes) {
          if(attribute.Attribute_Type__c.equals(UTIL_Constants.TGP_OFFERINGS)){
                String [] name= attribute.Attribute_Value__c.split(UTIL_Constants.DASH);
                attribute.Attribute_TypeName__c = attribute.Attribute_Type__c +UTIL_Constants.SPACEDASH + name[0];
                pushAttribute(attribute);
                attribId.add(attribute.id);
          }
          else{
              if(attribute.Attribute_Type__c != null){
                  attribute.Attribute_TypeName__c = attribute.Attribute_Type__c;
                  pushAttribute(attribute);
                  attribId.add(attribute.id);
              }
           }    
        } 
    }
    
   /**
   * This is the attribute filter validation method which use to validate the data integrity of each attribute record.
   * @param Attribute__c attribute.
   * @return void
   */
    private void pushAttribute (Attribute__c attribute) {
        
        //If The type equals TGP then insert type + UTIL_Constants.SPACEDASH+name to field Attribute_TypeName__c
        if(attribute.Attribute_Type__c.equals(UTIL_Constants.TGP_OFFERINGS)){
            String [] typeName= attribute.Attribute_Value__c.split(UTIL_Constants.DASH);
            attribute.Attribute_TypeName__c = attribute.Attribute_Type__c +UTIL_Constants.SPACEDASH + typeName[0];
        }
        //else insert type to field Attribute_TypeName__c
        else{
            attribute.Attribute_TypeName__c = attribute.Attribute_Type__c;
        }
            if (offerings.containsKey(attribute.Attribute_TypeName__c)) {           
                if( Integer.valueOf(attribute.AttributePercent__c) != null){
                    collectTotal.put(attribute.Attribute_TypeName__c, collectTotal.get(attribute.Attribute_TypeName__c) + Integer.valueOf(attribute.AttributePercent__c));
                }
                if((attribute.Attribute_Type__c.trim().equals(UTIL_Constants.ALLIANCE) || (attribute.Attribute_Type__c.trim().equals(UTIL_Constants.HORIZONTALS_INITIATIVES)) || (attribute.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && Integer.valueOf(attribute.AttributePercent__c) == 100)) && Integer.valueOf(attribute.AttributePercent__c) >=1 && Integer.valueOf(attribute.AttributePercent__c) <=100 && attribute.Attribute_Value__c != null && attribute.AttributePercent__c != null){
                    
                    Offering offer = offerings.get(attribute.Attribute_TypeName__c);
                    offer.Attributes.add(attribute);
                    offer.Total += Integer.valueOf(attribute.AttributePercent__c);  
               }
               else if(!attribute.Attribute_Type__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && Integer.valueOf(attribute.AttributePercent__c) >=1 && collectTotal.get(attribute.Attribute_TypeName__c)<=100 && attribute.Attribute_Value__c != null && attribute.AttributePercent__c != null){
                    if(collectTotal.get(attribute.Attribute_TypeName__c)<=100 ){                           
                        Offering offer = offerings.get(attribute.Attribute_TypeName__c);
                        offer.Attributes.add(attribute);
                        if( Integer.valueOf(attribute.AttributePercent__c) != null){
                            offer.Total += Integer.valueOf(attribute.AttributePercent__c);
                        }
                    }
               }
               else if(attribute.Attribute_Type__c.trim().equals(UTIL_Constants.VENTURES_ACQUISITIONS) && !attribute.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && Integer.valueOf(attribute.AttributePercent__c) >=1 && Integer.valueOf(attribute.AttributePercent__c) <=100){                           
                        Offering offer = offerings.get(attribute.Attribute_TypeName__c);
                        offer.Attributes.add(attribute);
                        if( Integer.valueOf(attribute.AttributePercent__c) != null){
                            offer.Total += Integer.valueOf(attribute.AttributePercent__c);
                        }
               }
               else {
                    if(attribute.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && attribute.AttributePercent__c != 100){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_005).Error_Message__c));
                    }else if(Integer.valueOf(attribute.AttributePercent__c) >=1 && attribute.Attribute_Type__c != null && attribute.AttributePercent__c != null && attribute.Attribute_Value__c != null &&  !attribute.Attribute_Value__c.equals(checkForNA(attribute.Attribute_Type__c.trim())) ){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_003).Error_Message__c));  
                            attribute.Attribute_TypeName__c = null;
                    }                               
                    else {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_002).Error_Message__c));
                        attribute.Attribute_TypeName__c = null;
                    }
              }
         }else{
                if(Integer.valueOf(attribute.AttributePercent__c) != null && attribute.Attribute_Type__c != null){
                    collectTotal.put(attribute.Attribute_TypeName__c, Integer.valueOf(attribute.AttributePercent__c));
                }
                if(Integer.valueOf(attribute.AttributePercent__c) <=100 && attribute.Attribute_Type__c != null && attribute.AttributePercent__c != null && !attribute.Attribute_Value__c.equals(checkForNA(attribute.Attribute_Type__c.trim()))){
                    if(attribute.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && attribute.AttributePercent__c != 100){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_005).Error_Message__c));
                    }
                    else if(!attribute.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && attribute.AttributePercent__c >=1 && attribute.AttributePercent__c <=100 || (attribute.Attribute_Type__c.trim().equals(UTIL_Constants.ALLIANCE) || attribute.Attribute_Type__c.trim().equals(UTIL_Constants.HORIZONTALS_INITIATIVES) || attribute.Attribute_Type__c.trim().equals(UTIL_Constants.VENTURES_ACQUISITIONS)) ){
                        Offering offer = new Offering();              
                        offer.Attributes = new List<Attribute__c>{attribute};
                        offer.Total = Integer.valueOf(attribute.AttributePercent__c);
                        offerings.put(attribute.Attribute_TypeName__c, offer);
                
                    }                             
                }
                else {
                    if(Integer.valueOf(attribute.AttributePercent__c) >=1 && attribute.Attribute_Type__c != null && attribute.AttributePercent__c != null && attribute.Attribute_Value__c != null){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_003).Error_Message__c));  
                        attribute.Attribute_TypeName__c = null; 
                    }
                }
        } 
    }
    
   /**
   * This method will insert the attribute record(s) to force.com database
   * @param none
   * @return void
   */
    public PageReference insertAttributes() {
        for(attribute__c toUnCheck: attributes){
          toUnCheck.Attribute_Check__c = false;
        }
        Database.upsert(attributes, TRUE);
        return controller.cancel();
    }
    
   /**
   * This method will delete the attribute record(s) to force.com database
   * @param none
   * @return void
   */
    public void deleteAttributes() {
        Integer counter = 0;
        Integer delCounter = 0;
        List<Integer> counters = new List<Integer>();
        
        for(Attribute__c forDelete : attributes){
            if(forDelete.Attribute_Check__c == true){
                if(forDelete.id != null){
                    if(checkID(forDelete.id)){
                        toDelete.add(forDelete);
                    }
                }
                ++delCounter;
                counters.add(counter);
            }         
            ++counter;
        }
        if(!counters.isEmpty()){
            if(counters != null){
                for(Integer j = counters.size()-1; j>=0; --j){
                    attributes.remove(counters[j]);
                }
                
                offerings.clear();
                for (Attribute__c attribute : attributes) {
                        pushAttribute(attribute);
                }
            }
        }
        if(!toDelete.isEmpty()){
            try{
                Database.delete(toDelete, TRUE); 
            }catch(Exception e){
               System.Debug('Error on delete');
            }
        }           
        ATT = new Attribute__c(Opportunity_Name__c = OPP.Id);
    }
    
    /**
    * This method will check if theAttribute Id already exist in the database if yes it will return true.
   * @param ID
   * @return boolean
    */
    public boolean checkID(ID stringID){
        Boolean value = false;
        for(ID attForDel : attribId){
            if(stringID.equals(attForDel)){
                value = true;
            }
        }
        return value;
    }
    
    /**
    * This method holds the attribute value and attribute name with zero allocation.
    * this will check if attribute name should have zero allocation 
    * @Return the right Attribute Name for 0 allocation
    */
    public String checkForNA(String offName){
        Map<String,String> offerName = new Map<String,String>();
        offerName.put(UTIL_Constants.HORIZONTALS_INITIATIVES, UTIL_Constants.NOTLABEL);
        return offerName.get(offName);
    }
    
   /**
   * This method will update the existing attribute record(s) to force.com database
   * @param none
   * @return void
   */
    public void updateAttributes() {
        Attribute__c newUpdateAttrib = ATT;      
        Attribute__c updateAttrib = new Attribute__c();
        if(checkedCounter() == 1){
           
           String idToUpdate = null ;
           Integer indexNumber = 0;
           Integer tempHolder = null;
                
           for(Attribute__c recordCheck : attributes){
                if(recordCheck.Attribute_Type__c.equals(newUpdateAttrib.Attribute_Type__c) && recordCheck.Attribute_Check__c == true){ 
                    if(recordCheck.Attribute_Check__c == true){
                        updateAttrib = recordCheck;
                        tempHolder = indexNumber; 
                    }
               } 
               ++indexNumber;
            }
            if(tempHolder!=null){ 
                if(!isDuplicate(newUpdateAttrib,tempHolder)){
                    if(newUpdateAttrib.Attribute_type__c != null && newUpdateAttrib.Attribute_Value__c != null && newUpdateAttrib.AttributePercent__c != null){ 
                        if(checkedCounter() == 1){
                            if(!remainingAllocation(newUpdateAttrib, Integer.valueOf(newUpdateAttrib.AttributePercent__c), Integer.valueOf(updateAttrib.AttributePercent__c)) && !newUpdateAttrib.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && newUpdateAttrib.AttributePercent__c != 0 && newUpdateAttrib.AttributePercent__c <= 100){
                                
                                if(!remainingAllocation(attributes[tempHolder], Integer.valueOf(attributes[tempHolder].AttributePercent__c), Integer.valueOf(updateAttrib.AttributePercent__c))){
                                    attributes[tempHolder].AttributePercent__c = newUpdateAttrib.AttributePercent__c;
                                    attributes[tempHolder].AttributeTxt__c = String.valueOf(attributes[tempHolder].AttributePercent__c) +UTIL_Constants.PERCENT;
                                    attributes[tempHolder].Attribute_Value__c = newUpdateAttrib.Attribute_Value__c;
                                    attributes[tempHolder].Attribute_Check__c = false;
                                    attributes[tempHolder].Attribute_typeName__c = attributes[tempHolder].Attribute_TypeName__c;
                                            
                                    Offering offer = new Offering();               
                                    offer.Attributes = new List<Attribute__c>{attributes[tempHolder]};
                                    offer.Total = Integer.valueOf(attributes[tempHolder].AttributePercent__c);
                                    offerings.put(attributes[tempHolder].Attribute_TypeName__c, offer);
                                    offerings.clear();
                                    for (Attribute__c attribute : attributes) {
                                        pushAttribute(attribute);
                                    }
                                }
                                                       
                             }else{
                                
                                if(newUpdateAttrib.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && newUpdateAttrib.AttributePercent__c == 100){
                                    attributes[tempHolder].AttributePercent__c = newUpdateAttrib.AttributePercent__c;
                                    attributes[tempHolder].AttributeTxt__c = String.valueOf(attributes[tempHolder].AttributePercent__c) +UTIL_Constants.PERCENT;
                                    attributes[tempHolder].Attribute_Value__c = newUpdateAttrib.Attribute_Value__c;
                                    attributes[tempHolder].Attribute_Check__c = false;
                                    attributes[tempHolder].Attribute_typeName__c = attributes[tempHolder].Attribute_TypeName__c;
                                            
                                    Offering offer = new Offering();               
                                    offer.Attributes = new List<Attribute__c>{attributes[tempHolder]};
                                    offer.Total = Integer.valueOf(attributes[tempHolder].AttributePercent__c);
                                    offerings.put(attributes[tempHolder].Attribute_TypeName__c, offer);
                                    offerings.clear();
                                    for (Attribute__c attribute : attributes) {
                                        pushAttribute(attribute);
                                    }
                                }
                                    
                                 if(newUpdateAttrib.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && attributes[tempHolder].Attribute_Value__c != newUpdateAttrib.Attribute_Value__c && Integer.valueOf(newUpdateAttrib.AttributePercent__c) != 100){
                                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_005).Error_Message__c));
                                        for(attribute__c toUnCheck: attributes){
                                            toUnCheck.Attribute_Check__c = false;
                                        }
                                 }
                                 else if(newUpdateAttrib.AttributePercent__c != null){
                                    if(newUpdateAttrib.AttributePercent__c == 0){
                                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message.get(UTIL_Constants.ERROR_MSG_ATT_002).Error_Message__c));
                                        for(attribute__c toUnCheck: attributes){
                                            toUnCheck.Attribute_Check__c = false;
                                        }
                                    }else{
                                        if(newUpdateAttrib.Attribute_Value__c.trim()!= UTIL_Constants.AGILEX_STANDALONE){
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message.get(UTIL_Constants.ERROR_MSG_ATT_003).Error_Message__c));
                                            for(attribute__c toUnCheck: attributes){
                                                toUnCheck.Attribute_Check__c = false;
                                            }   
                                        }
                                        
                                    }                 
                                }
                            }
                        }
                    }   
                
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_006).Error_Message__c));
                }
            }
        }
        ATT = new Attribute__c(Opportunity_Name__c = OPP.Id);
        for(attribute__c toUnCheck: attributes){
          toUnCheck.Attribute_Check__c = false;
        }
    }
    /**
    * This method will check if there is a duplicate entry field Type and Value 
    * @param Attribute__C , attribAllocation, indexVal
    * @return boolean
    */
    public Boolean isDuplicate(Attribute__c attribAllocation, integer indexVal){
        boolean duplicate = false;
        Integer indexNumber = 0;
        for(Attribute__c isDuplicate : attributes){
            if(indexNumber != indexVal){
                if(isDuplicate.Attribute_Value__c.equals(attribAllocation.Attribute_Value__c) && 
                    isDuplicate.Attribute_type__c.equals(attribAllocation.Attribute_type__c)){
                    duplicate = true;
                }   
            }            
            ++indexNumber;
        }
        return duplicate;
    }
    
    /**
    * This method will check if Total attribute allocation  will exceeds 100. Will return true if the value exceeds 100%
    * @param Attribute__C , attribAllocation, Integer and Integer 
    * @return boolean
    */
    public Boolean remainingAllocation(Attribute__C attribAllocation, Integer newAllocation, Integer preAllocation){
        Boolean allocation = false;
            if(attribAllocation.Attribute_Type__c != null && attribAllocation.AttributePercent__c != null){
                attribAllocation.Attribute_TypeName__c = attribAllocation.Attribute_Type__c;
                Integer total = collectTotal.get(attribAllocation.Attribute_TypeName__c) - preAllocation + newAllocation ;
                if(total>100){
                    if(((attribAllocation.Attribute_Type__c.equals(UTIL_Constants.HORIZONTALS_INITIATIVES) || attribAllocation.Attribute_Type__c.equals(UTIL_Constants.ALLIANCE) || attribAllocation.Attribute_Type__c.equals(UTIL_Constants.VENTURES_ACQUISITIONS) && (newAllocation <= 100 && newAllocation >= 1)))){  
                        allocation = false;
                    }else {
                        allocation = true;
                    }
                }
            }
        return allocation;
    }
    
   /**
    * This method will number of Checked checkbox in addattribute VF page
    * @param None 
    * @return Integer
    */
    public Integer checkedCounter(){        
        Integer countCheckbox = 0;
        for(Attribute__c isChecked : attributes){
            if(isChecked.Attribute_Check__c == true){
                ++countCheckbox;
            }   
        }
        return countCheckbox;
    }
    
    /**
    * This method check for duplicate entry.
    * @param Attribute__c 
    * @Return boolean
    */
    public Boolean checkDuplicate(Attribute__c dupAttrib){
        Boolean dup = false;
        for(Attribute__c attribDup : attributes){
            if(dupAttrib.Attribute_Type__c != null && dupAttrib.Attribute_Value__c != null 
                    &&(((dupAttrib.id != null || attribDup.id != null) && dupAttrib.id != attribDup.id)
                        ||(dupAttrib.id == null && attribDup.id == null)))
            {
                if(dupAttrib.Attribute_Type__c.equals(attribDup.Attribute_Type__c) && dupAttrib.Attribute_Value__c.equals(attribDup.Attribute_Value__c)){
                    dup = true;
                }
            }
        }
        return dup;
    }
    
    /**
    * This method check if parameter service group exist in Financial Details
    * @param Attribute__c 
    * @Return boolean
    */
    public Boolean hasProduct(String attType) {
        Boolean product = false;
        String tempType = UTIL_Constants.STRING_EMPTY;
        Integer countType = 0;
        if(attType != null){
            if(attType.contains(UTIL_Constants.OFFERINGS)){
                String [] typeName= attType.split(UTIL_Constants.STRING_SPACE);
                tempType = typeName[0];
                
                for(Opportunitylineitem oppLineItems : oppLineItem){
                    if(oppLineItems.OpportunityId.equals(Opp.id)){
                        if(oppLineItems.Type__c != null){
                            if(oppLineItems.Type__c.contains(tempType) && oppLineItems.Revenue__c != null){
                                ++countType;
                            }
                        }
                    }
                }
               if(countType == 0){
                    product = true;
               }
            }
        }
        return product;
    }
    
    /**
    * This method will check if Agilex-Standalone is present if yes will validated if attribute % is equal not equal to 100.
    * @param Attribute__c 
    * @Return boolean
    */
    public Boolean checkStandAlone(Attribute__C attribs){
        Boolean stand = false;
        if(attribs.Attribute_Value__c.trim().equals(UTIL_Constants.AGILEX_STANDALONE) && Integer.Valueof(attribs.AttributePercent__c ) != 100){
            stand = true;
        }
        return stand;
    }
    
   /**
   * This method will put values on list map. 
   * and invoke method pushAttribute which a soft of filter criteria 
   * @param none
   * @Return void
   */
    public void addAttribute() {
        Attribute__c newAttribute = ATT;
        if(!checkDuplicate(ATT) && !hasProduct(newAttribute.Attribute_Type__c) && 0 < Integer.valueOf(newAttribute.AttributePercent__c )){
            if(newAttribute.Attribute_Type__c != null && newAttribute.Attribute_Value__c != null){
                pushAttribute(newAttribute);
            }
            else{
                if(newAttribute.Attribute_Type__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_027).Error_Message__c));
                }
                if(newAttribute.Attribute_Value__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message.get(UTIL_Constants.ERROR_MSG_ATT_028).Error_Message__c));
                }
            }
            if(newAttribute.AttributePercent__c >=1 && newattribute.AttributePercent__c <= 100 && newAttribute.Attribute_TypeName__c != null && newAttribute.Attribute_Value__c != null){
                if(!checkStandAlone(newAttribute)){
                    attributes.add(newAttribute);
                }                
                if(String.valueOf(newAttribute.AttributePercent__c)==null){
                    newAttribute.AttributeTxt__c = 0+UTIL_Constants.PERCENT;
                }
                else{
                  newAttribute.AttributeTxt__c = String.valueOf(newAttribute.AttributePercent__c) + UTIL_Constants.PERCENT;
                }
                ATT = new Attribute__c(Opportunity_Name__c = OPP.Id);
             //   setMessage();
            }else{
                if( Integer.valueOf(newAttribute.AttributePercent__c) != null && newAttribute.Attribute_Type__c != null && newAttribute.Attribute_Value__c != null){
                       if(newAttribute.Attribute_Type__c.equals(UTIL_Constants.TGP_OFFERINGS)){
                         String [] name = newAttribute.Attribute_Value__c.split(UTIL_Constants.DASH);
                         newAttribute.Attribute_TypeName__c = newAttribute.Attribute_Type__c +UTIL_Constants.SPACEDASH + name[0];
                      }
                      else{
                          if(newAttribute.Attribute_Type__c != null){
                              newAttribute.Attribute_TypeName__c = newAttribute.Attribute_Type__c;
                          }
                       }
                   
                   collectTotal.put(newAttribute.Attribute_TypeName__c, collectTotal.get(newAttribute.Attribute_TypeName__c) - Integer.valueOf(newAttribute.AttributePercent__c));
                }
            }
        }else{
            if(hasProduct(newAttribute.Attribute_Type__c)){
                String [] typeName= newAttribute.Attribute_Type__c.split(UTIL_Constants.STRING_SPACE);
                
                if(typeName[0].equals(UTIL_Constants.MC)){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_008).Error_Message__c));
                }
                else  if(typeName[0].equals(UTIL_Constants.SI)){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_010).Error_Message__c));
                }
                else  if(typeName[0].equals(UTIL_Constants.AO)){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_012).Error_Message__c));
                }
                else if(typeName[0].equals(UTIL_Constants.IO)){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_014).Error_Message__c));
                }
                else if(typeName[0].equals(UTIL_Constants.TC)){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_016).Error_Message__c));
                }
                
            }else{
                if(newAttribute.AttributePercent__c == null){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_002).Error_Message__c));
                }
                else if(newAttribute.AttributePercent__c <= 0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_002).Error_Message__c));
                }else{
                     ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,message.get(UTIL_Constants.ERROR_MSG_ATT_006).Error_Message__c));
                } 
           }
            
        }
    }
}