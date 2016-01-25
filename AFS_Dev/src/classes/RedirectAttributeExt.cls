/**
 *  @Author Pablito Abalos
 *  @name AddAttributeExt
 *  @CreateDate <Date>
 *  @Description <purpose of the class>
 *  @Version <1.0>
 *  @reference <Referenced program names>
 */
public class RedirectAttributeExt {

    private final Attribute__c attribute;
    private final Id opportunityId;
    private List<User> userList = new List<User>();
   /**
   * This is Constructor which assign the value of attribute and opportunity id upon load.
   * @param ApexPages.StandardController.
   * @return none
   */
    public RedirectAttributeExt(ApexPages.StandardController stdController) {
        this.attribute = (Attribute__c)stdController.getRecord();
        this.opportunityId = [SELECT Opportunity_Name__c from Attribute__c WHERE Id = :attribute.Id][0].Opportunity_Name__c;
        this.userList = [select user.id, user.Email, user.FirstName, user.LastName, user.profile.name, user.Username, user.IsActive FROM user, user.profile where user.id =: UserInfo.getUserId() Limit 1];
    }
    
   /**
   * This is return addAttribute page
   * @param None
   * @return PageReference
   */
    public PageReference redirect() {
 
        PageReference redirectPage = Page.AddAttribute;
        redirectPage.getParameters().put(UTIL_Constants.id, opportunityId );
        redirectPage.setRedirect(true);
        return redirectPage;
    }

}