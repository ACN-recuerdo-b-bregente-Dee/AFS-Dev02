/**
   @Author Lhea Valencia
   @name AccountTeamRoleBL
   @CreateDate 04/14/2015
   @Description Business Logic Class for Account Team Role object.
   @Version <1.0>
   @reference <Referenced program names>
  */
public class AccountTeamRoleBL {

    public static void insertAccountOwner( List<Account_Team_Role__c> newVal) {
        
        List<Account> accs = new List<Account>();
        List<Account_Team_Role__c> accTRole = new List<Account_Team_Role__c>();
        Set<Id> teamRoleIds = new Set<Id>();        
        Set<Id> accIds = new Set<Id>();
        Map<Id, Id> accIdAndOwner = new Map<Id, Id>{};
        
        for(Account_Team_Role__c accList : newVal) {
            teamRoleIds.add(accList.Id);
            accIds.add(accList.Account__c);
        }
        
        accs = [SELECT id, name, ownerId FROM Account where id=:accIds];
        for(Account acc : accs){
            accIdAndOwner.put(acc.id, acc.ownerId);
        }
        
        accTRole = [SELECT id, name , account_owner__c, account__c, status__c FROM Account_Team_Role__c where id IN :teamRoleIds AND status__c != 'Approved'];
        for(Account_Team_Role__c acctr : accTRole){
            acctr.status__c = 'New';
            acctr.account_owner__c = accIdAndOwner.get(acctr.account__c);
        }
        
        Database.update(accTRole);
    }
    
    public static void insertAccountTeam(Map<Id, Account_Team_Role__c> oldAccountTeamRoleMap,  Map<Id, Account_Team_Role__c> newAccountTeamRoleMap) {
        Map<Id, Account_Team_Role__c> approvedAccTeamRole = new Map<Id, Account_Team_Role__c>{};
        Map<Id, Id> approvedUserIds = new Map<Id, Id>{};
        Account_Team_Role__c newAccTeamRole = new Account_Team_Role__c();
        
        for(Id newId : newAccountTeamRoleMap.keySet()){
            newAccTeamRole = newAccountTeamRoleMap.get(newId);
            
            if(newAccTeamRole.status__c == 'Approved' && newAccTeamRole.Account_Owner__c != newAccTeamRole.Team_Member__c){
                approvedAccTeamRole.put(newId, newAccTeamRole);
                approvedUserIds.put(newAccTeamRole.Team_Member__c, newId);
            }
        }
        
        if(!approvedUserIds.isEmpty()){
            Map<Id, Account_Team_Role__c> addedAccTeamRole = commitNewAccountTeam(approvedUserIds, approvedAccTeamRole);
            commitNewAccountTeam(approvedUserIds, approvedAccTeamRole);
            List<Account_Team_Role__c> deleteAccountTeamRoles = [SELECT Id FROM Account_Team_Role__c WHERE Id IN :addedAccTeamRole.keySet()];
        }
    }
    
    public static Map<Id, Account_Team_Role__c> commitNewAccountTeam(Map<Id, Id> approvedUserIds, Map<Id, Account_Team_Role__c> approvedAccTeamRole){
        Map<Id, Account_Team_Role__c> addedAccTeamRole = new Map<Id, Account_Team_Role__c>();
        List<AccountShare> share = new List<AccountShare>();
        List<AccountShare> updateShare = new List<AccountShare>();
        List<AccountTeamMember> member = new List<AccountTeamMember>();
        Account_Team_Role__c accountTeamRole = new Account_Team_Role__c();
        AccountShare accountShare = new AccountShare();
        AccountTeamMember teamMember = new AccountTeamMember();
        
        for(Id userId: approvedUserIds.keySet()){
             accountTeamRole = approvedAccTeamRole.get(approvedUserIds.get(userId));
             
             teamMember = new AccountTeamMember();
             teamMember.AccountId = accountTeamRole.Account__c;
             teamMember.userId = accountTeamRole.Team_Member__c;
             teamMember.TeamMemberRole = accountTeamRole.Team_Role__c;
             member.add(teamMember);
             
             accountShare = new AccountShare();
             accountShare.AccountId = accountTeamRole.Account__c;
             accountShare.UserOrGroupId = accountTeamRole.Team_Member__c;
             accountShare.AccountAccessLevel = getAccessLevel(accountTeamRole.Account_Access__c);
             accountShare.ContactAccessLevel = getAccessLevel(accountTeamRole.Contact_Access__c);
             accountShare.CaseAccessLevel = getAccessLevel(accountTeamRole.Case_Access__c);
             accountShare.OpportunityAccessLevel = getAccessLevel(accountTeamRole.Opportunity_Access__c);
             share.add(accountShare);
             
             addedAccTeamRole.put(accountTeamRole.Id, accountTeamRole);
        }
        
        Database.insert(member);
        Database.insert(share);
        
        return addedAccTeamRole;
    }
    
    public static String getAccessLevel(String rawAccessLevel){
        String accessLevel = 'Read';
        
        if(rawAccessLevel == 'Read/Write'){
            accessLevel = 'Edit';
        }
        
        return accessLevel;
    }
}