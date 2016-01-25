/**
 * Class Name: TestData
 * @author: Recuerdo Bregente
 * Date: 10/20/2015
 * Class for creating test data.
 */
@isTest(SeeAllData=true)
public class TestData{

    /**
    * @Method to create new user objects to be used for test class.
    */
    public static List<User> createUsers(Integer count, String profileType){
        Profile p = [select id from profile where name=:profileType limit 1];
        List<User> users = new List<User>();
        User newUser = new User();
        
        Integer counter = 0;
        for(; counter < count; counter++){
            newUser = new User();
            String name = 'user' + (counter+1);
            newUser.alias = 'userTest';
            newUser.email= name + '@sample.com';
            newUser.emailencodingkey='UTF-8';
            newUser.lastname='Test';
            newUser.languagelocalekey='en_US';   
            newUser.localesidkey='en_US';
            newUser.profileid = p.Id;
            newUser.timezonesidkey='America/Los_Angeles';
            newUser.username= name + '@sample.com.dev';
            users.add(newUser);
        }
        
        return users;
    }
    
    /**
    * @Method to create new Account objects to be used for test class.
    */
    public static List<Account> createAccounts(Integer count, String accountType){
         RecordType clientRecType = [Select Id FROM RecordType WHERE Name =:accountType LIMIT 1];
        List<Account> accounts= new List<Account>();
        Account newAccount = new Account();
        
        Integer counter = 0;
        for(; counter < count; counter++){
            newAccount = new Account();
            newAccount.RecordTypeId = clientRecType.Id;
            newAccount.Name = 'Sample Test Account' + (counter+1);
            newAccount.Status__c = 'Active';
            newAccount.Type = accountType;
            accounts.add(newAccount);
        }
        
        return accounts;
    }
    
    /**
    * @Method to create new AccountTeamRole objects to be used for test class.
    */
    public static List<Account_Team_Role__c> createAccountTeamRoles(Integer count, Id accountId){
        List<Account_Team_Role__c> accTeamRoles = new List<Account_Team_Role__c>();
        Account_Team_Role__c newAccTeamRole = new Account_Team_Role__c();
        
        Integer counter = 0;
        for(; counter < count; counter++){
            newAccTeamRole = new Account_Team_Role__c();
            newAccTeamRole.Account__c = accountId;
            newAccTeamRole.Account_Access__c = 'Read/Write';
            newAccTeamRole.Case_Access__c = 'Read/Write';
            newAccTeamRole.Contact_Access__c = 'Read/Write';
            newAccTeamRole.Opportunity_Access__c = 'Read/Write';
            newAccTeamRole.Team_Role__c = 'General';
            accTeamRoles.add(newAccTeamRole);
        }
        
        return accTeamRoles;
    }
    
    /**
    * @Method to create new Opportunity objects to be used for test class.
    */
    public static List<Opportunity> createOpportunities(Integer count){
        List<Opportunity> opportunities = new List<Opportunity>();
        Opportunity oppRecord = new Opportunity();
        
        String SOME_VALUE = 'Some Value';
        
        Integer counter = 0;
        for(; counter < count; counter++){
            oppRecord = new Opportunity();
            oppRecord.Name = 'Opportunity Test Class Zero';
            oppRecord.Source__c = 'Salesforce';
            oppRecord.STATUS_STAGE_REQUESTED__C = '0';
            oppRecord.Proposal_Submission_Date__c=System.today() + 4;
            oppRecord.Draft_RFP_Release_Date__c=System.today() + 2;
            oppRecord.Actual_Contract_Sign_Date__c=System.today() + 20;
            oppRecord.RFP_RELEASE_DATE__C = System.today() + 3;
            oppRecord.CLOSEDATE = System.today() + 115; 
            oppRecord.REPORTING_STATUS_SINCE__C = System.today() - 30; 
            oppRecord.TYPE = 'Competitive';
            oppRecord.STAGENAME = '0';
            oppRecord.APPROVED_STATUS_STAGE__C = '0';
            oppRecord.REPORTING_STATUS__C = 'Unqualified';
            oppRecord.Consulting_Start__c  = System.today() + 120; 
            oppRecord.Consulting_End__c = System.today() + 210;   
            oppRecord.Outsourcing_Start__c = System.today() + 150; 
            oppRecord.Outsourcing_End__c  = System.today() + 240; 
            oppRecord.Hierarchy_Level__c = 'Standalone';
            oppRecord.Probability = 0.1;
            oppRecord.Sales_Committed_for_First_Year__c = 2344;
            opportunities.add(oppRecord);
        }
        
        return opportunities;
    }
    
    /**
    * @Method to create new Person objects to be used for test class.
    */
    public static List<Person__c> createPersons(Integer count){
        List<Person__c> persons = new List<Person__c>();
        Person__c personRecord = new Person__c();
        
        Integer counter = 0;
        for(; counter < count; counter++){
            personRecord = new Person__c(
            Name='Test name',
            email__c='test@email.com',
            user_type__c='AFS'
            );
            
            persons.add(personRecord);
         }
         
         return persons;
        
    }
    
    /**
    * @Method to create new Opportunity Team Role objects to be used for test class.
    */
    public static List<Opportunity_Team_Roles__c> createOppTeamRoles(Integer count){
        List<Opportunity_Team_Roles__c> oppTeamRoles = new List<Opportunity_Team_Roles__c>();
        Opportunity_Team_Roles__c oppTeamRoleRecord = new Opportunity_Team_Roles__c();
        
        Integer counter = 0;
        for(; counter < count; counter++){
            oppTeamRoleRecord = new Opportunity_Team_Roles__c();
            oppTeamRoleRecord.Role__c = 'Opportunity Director';
            oppTeamRoleRecord.Opportunity_Access__c = 'Read Only';
            oppTeamRoleRecord.Sales_Credit__c= 2;
            oppTeamRoles.add(oppTeamRoleRecord);
         }
         
         return oppTeamRoles;
    }
}