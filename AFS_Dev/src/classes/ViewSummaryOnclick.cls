/**
   @Author                       Honelee F. Padilla
   @name                         Summary_View_Onclick
   @CreateDate                   
   @Description                  Changes record type on button click to toggle between layouts of Opportunity.
   @Version                      1.0
   @reference                    <Referenced program names>
*/
global without sharing class ViewSummaryOnclick { 

    //private static Id mainRecordType  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(UTIL_Constants.OPP_REC_TYPE_MAIN).getRecordTypeId();
    //private static Id sViewRecordType  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(UTIL_Constants.OPP_REC_TYPE_SVIEW).getRecordTypeId();
    //private static Boolean callFrmSummaryViewClass = false;
 
    /**
    *  Method is passing the id and OG values on record type
    *  @name                 recordtypecahng
    *  @param                Id oppredId     <description>
    *  @param                String view     <description>
    *  @return               String          <Description about the return parameter>
    *  @throws exception     <exception description>
    */  
    /**
    webservice static String recordTypeCahng(Id oppredId,String view){

        String excepMsg = UTIL_Constants.STRING_EMPTY;
        try {
            Opportunity opjopp = new Opportunity() ;
            
            if(view!=null && view.equals(String.valueOf(sViewRecordType).substring(0,15))){
                opjopp=new Opportunity(Id=oppredId,RecordtypeId=mainRecordType);
            }
            else {
                if (view!=null && view.equals(String.valueOf(mainRecordType).substring(0,15))) {
                    opjopp = new Opportunity(Id=oppredId,RecordtypeId=sViewRecordType);
                }
            }

            if(opjopp!=null){
                callFrmSummaryViewClass = true;

                Database.update(opjopp, true);
                //update opjopp;
                callFrmSummaryViewClass = false;
            }
            //return excepMsg;
        }
        catch(DMLException e){
            excepMsg = e.getDMLMessage(0);
            //return excepMsg;

        }
        catch(Exception excp){
            excepMsg = excp.getMessage();
            return excepMsg;

        } 

        return excepMsg;
    }
    */
}