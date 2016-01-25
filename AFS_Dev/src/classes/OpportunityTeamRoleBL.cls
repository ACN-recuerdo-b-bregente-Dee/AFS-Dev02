/**
   @Author Honelee F. Padilla
   @name OpportunityTeamRoleBL
   @CreateDate 04/10/2015
   @Description To copy custom Opportunity Team Roles in standard Opportunity Team and OpportunityShare 
   @Version <1.0>
   @reference <Referenced program names>
  */
public without sharing class OpportunityTeamRoleBL {

    /**
    *  To delete Opportunity Team and copy over the Access level in standard Opportunity Team and OpportunityShare 
    *  @name deleteOpportunityTeam
    *  @param teamRolesToDelete - Team roles for deletion
    *  @return void
    *  @throws exception
    */
    public static void deleteOpportunityTeam(Opportunity_Team_Roles__c[] teamRolesToDelete){

        integer rw = 0;    
        Set<String> teamRoleIds = new Set<String>();
        Map<Id, String> personMap = new Map<Id, String>{};
        Map<String, User> userMap = new Map<String, User>{};
        Set<Id> userIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
        OpportunityShare[] opportunitySharesToDelete = new OpportunityShare[]{};
        OpportunityShare[] opportunitySharesToInsert = new OpportunityShare[]{};
        OpportunityTeamMember[] teamMembersToDelete = new OpportunityTeamMember[]{};
        OpportunityTeamMember[] teamMembersToInsert = new OpportunityTeamMember[]{};
        Map<String, OpportunityShare> shareDeleteMap = new Map<String, OpportunityShare>{};
        Map<String, Opportunity_Team_Roles__c[]> dupeTeamRoleMap = new Map<String, Opportunity_Team_Roles__c[]>{};
        
        for(Opportunity_Team_Roles__c team : teamRolesToDelete){
            personMap.put(team.Name__c, null);
            opportunityIds.add(team.Opportunity_Name__c);
            teamRoleIds.add(team.Id);  
        }
        
        for (Person__c person : [SELECT Id, Email__c FROM Person__c WHERE Status__c = :UTIL_Constants.PERSON_STATUS AND Id IN :personMap.keyset() LIMIT 5000]){// Default maximum of SOQL rows to 5000
            personMap.put(person.Id, person.Email__c);
        }
        
        for (User usr : [
            SELECT Id, Email FROM User
            WHERE IsActive = true
            AND Email IN :personMap.values()
            LIMIT 5000 // Default maximum of SOQL rows to 5000
        ]){
            userMap.put(usr.Email, usr);
        }
        
        for (User usr : [
            SELECT Id, Email FROM User
            WHERE IsActive = true
            AND Email IN :personMap.values()
            LIMIT 5000 // Default maximum of SOQL rows to 5000
        ]){
            userIds.add(usr.Id);
        }
                
        teamMembersToDelete = [
            SELECT OpportunityId, UserId, TeamMemberRole, Custom_Opportunity_Id__c
            FROM OpportunityTeamMember 
            WHERE Custom_Opportunity_Id__c IN: teamRoleIds
            LIMIT 5000 // Default maximum of SOQL rows to 5000
        ];
        
        for(OpportunityShare share: [
            SELECT UserOrGroupId,OpportunityId,Id 
            FROM OpportunityShare 
            WHERE UserOrGroupId IN: userIds 
            AND OpportunityId IN: opportunityIds
            LIMIT 5000 // Default maximum of SOQL rows to 5000
        ]){
            shareDeleteMap.put(share.UserOrGroupId+ UTIL_Constants.PIPE +share.OpportunityId, share);
        }
        
        for(Opportunity_Team_Roles__c share: [
            SELECT Name__c, Opportunity_Name__c, Opportunity_Access__c, Id , Role__c
            FROM Opportunity_Team_Roles__c 
            WHERE Name__c IN :personMap.keyset()
            AND Opportunity_Name__c IN: opportunityIds
            AND ID NOT IN :teamRoleIds
            LIMIT 5000 // Default maximum of SOQL rows to 5000
        ]){
            if (!dupeTeamRoleMap.containsKey(share.Name__c+ UTIL_Constants.PIPE +share.Opportunity_Name__c)) {
                dupeTeamRoleMap.put(share.Name__c+ UTIL_Constants.PIPE +share.Opportunity_Name__c, new Opportunity_Team_Roles__c[]{share});
            }
            dupeTeamRoleMap.get(share.Name__c+ UTIL_Constants.PIPE +share.Opportunity_Name__c).add(share);
        }
        // Get duplicate names but with diff roles
        for(Opportunity_Team_Roles__c team: teamRolesToDelete){
            if(shareDeleteMap.get(team.Name__c + UTIL_Constants.PIPE + team.Opportunity_Name__c) <> null){
                opportunitySharesToDelete.add(shareDeleteMap.get(team.Name__c + UTIL_Constants.PIPE + team.Opportunity_Name__c));
            }
            if (dupeTeamRoleMap.containsKey(team.Name__c + UTIL_Constants.PIPE + team.Opportunity_Name__c)) {
                for (Opportunity_Team_Roles__c role : dupeTeamRoleMap.get(team.Name__c + UTIL_Constants.PIPE + team.Opportunity_Name__c)) { 
                    if(role.Opportunity_Access__c.equals(UTIL_Constants.OPPORTUNITY_ACCESS_READWRITE)){
                        System.debug('Read Write');
                        OpportunityShare sharet = new OpportunityShare();
                        sharet.OpportunityId = role.Opportunity_Name__c;
                        sharet.OpportunityAccessLevel = UTIL_Constants.OPPORTUNITY_ACCESS_EDIT;
                        if (personMap.containsKey(team.Name__c)) {
                            if (userMap.containsKey(personMap.get(team.Name__c))) {
                                sharet.UserOrGroupId = userMap.get(personMap.get(team.Name__c)).Id; 
                            }
                        }
                        opportunitySharesToInsert.add(sharet);
                        //break;
                    }
                    
                    // Get name with Read/Write access
                    if(role.Opportunity_Access__c.equals(UTIL_Constants.OPPORTUNITY_ACCESS_READWRITE)){
                        System.debug('Read Write access');
                        OpportunityTeamMember member = new OpportunityTeamMember();
                        member.OpportunityId = role.Opportunity_Name__c;
                        member.TeamMemberRole = role.Role__c;
                        if (personMap.containsKey(team.Name__c)) {
                            if (userMap.containsKey(personMap.get(team.Name__c))) {
                                member.UserId = userMap.get(personMap.get(team.Name__c)).Id;
                            }
                        }

                        teamMembersToInsert.add(member);
                        rw = rw + 1;
                        //break;
                    }
                    
                    // Get name with Read only access                  
                    if(rw == 0){
                        if(role.Opportunity_Access__c.equals(UTIL_Constants.OPPORTUNITY_ACCESS_READONLY)){
                            System.debug('Read Only access');
                            OpportunityTeamMember member = new OpportunityTeamMember();
                            member.OpportunityId = role.Opportunity_Name__c;
                            member.TeamMemberRole = role.Role__c;
                            if (personMap.containsKey(team.Name__c)) {
                                if (userMap.containsKey(personMap.get(team.Name__c))) {
                                    member.UserId = userMap.get(personMap.get(team.Name__c)).Id;
                                }
                            }
                            teamMembersToInsert.add(member);
                        }
                    }           
                }
            }
        }
        
        try{
        
            database.delete(teamMembersToDelete,false);
            database.delete(opportunitySharesToDelete,false);
            database.insert(teamMembersToInsert,false);
            database.insert(opportunitySharesToInsert,false);
         } catch(exception e){
            System.debug(e.getMessage());
        }
    }

    /**
    *  To upsert Opportunity Team and copy over the Access level in standard Opportunity Team and OpportunityShare 
    *  @name upsertOpportunityTeam
    *  @param upsertedTeamRoles - Team Roles to be upserted
    *  @return void
    *  @throws exception
    */    
    public static void upsertOpportunityTeam(Opportunity_Team_Roles__c[] upsertedTeamRoles, Boolean isUpdate){
       
        OpportunityTeamMember[] teamMembersToInsert = new OpportunityTeamMember[]{};
        OpportunityTeamMember[] teamMembersToDelete = new OpportunityTeamMember[]{};
        OpportunityShare[] opportunitySharesToInsert = new OpportunityShare[]{};
        OpportunityShare[] opportunitySharesToDelete = new OpportunityShare[]{};
        Map<String, OpportunityShare> shareDeleteMap = new Map<String, OpportunityShare>();
        Map<Id, String> personMap = new Map<Id, String>{};
        Map<String, User> userMap = new Map<String, User>{};
        Set<String> teamRoleIds = new Set<String>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> opportunityIds = new Set<Id>();
    
        for(Opportunity_Team_Roles__c team: upsertedTeamRoles){
            personMap.put(team.Name__c, null);
            opportunityIds.add(team.Opportunity_Name__c);
            teamRoleIds.add(team.Id); 
        }
        
        for (Person__c person : [SELECT Id, Email__c FROM Person__c WHERE Status__c = :UTIL_Constants.PERSON_STATUS AND Id IN :personMap.keyset() LIMIT 5000]){ // Default maximum of SOQL rows to 5000
            personMap.put(person.Id, person.Email__c);
        }
        
        for (User usr : [
            SELECT Id, Email FROM User
            WHERE IsActive = true
            AND Email IN :personMap.values()
            LIMIT 5000
         // Default maximum of SOQL rows to 5000
        ]){
            userMap.put(usr.Email, usr);
        }
        
        for(Opportunity_Team_Roles__c team: upsertedTeamRoles){
            OpportunityTeamMember member = new OpportunityTeamMember();  
            member.OpportunityId = team.Opportunity_Name__c;  
            member.TeamMemberRole = team.Role__c;
            member.Custom_Opportunity_Id__c = team.Id;
            if (personMap.containsKey(team.Name__c)) {
                if (userMap.containsKey(personMap.get(team.Name__c))) {
                    member.UserId = userMap.get(personMap.get(team.Name__c)).Id;
                }
            }
            teamMembersToInsert.add(member);
            
            //Grant New Team Member with Edit Access via Opportunity ShareTable
            if(team.Opportunity_Access__c.equals(UTIL_Constants.OPPORTUNITY_ACCESS_READWRITE)){
                System.debug('Read Write');
                OpportunityShare sharet = new OpportunityShare();
                sharet.OpportunityId = team.Opportunity_Name__c;
                sharet.OpportunityAccessLevel = UTIL_Constants.OPPORTUNITY_ACCESS_EDIT;
                if (personMap.containsKey(team.Name__c)) {
                    if (userMap.containsKey(personMap.get(team.Name__c))) {
                        sharet.UserOrGroupId = userMap.get(personMap.get(team.Name__c)).Id; 
                    }
                }
                opportunitySharesToInsert.add(sharet);
            }
            
            //Update Team Member with Read Access via Opportunity ShareTable
            if(team.Opportunity_Access__c.equals(UTIL_Constants.OPPORTUNITY_ACCESS_READONLY)){
                System.debug('Read Write');
                OpportunityShare sharet = new OpportunityShare();
                sharet.OpportunityId = team.Opportunity_Name__c;
                sharet.OpportunityAccessLevel = UTIL_Constants.OPPORTUNITY_ACCESS_READ;
                if (personMap.containsKey(team.Name__c)) {
                    if (userMap.containsKey(personMap.get(team.Name__c))) {
                        sharet.UserOrGroupId = userMap.get(personMap.get(team.Name__c)).Id; 
                    }
                }
                opportunitySharesToInsert.add(sharet);
            }
            
        }
        
        if(isUpdate){
            //Standard OpportunityTeamMember Opportunity and User fields are not updatable in Apex. 
            //Workaround is to delete the existing Opp team member and toreinsert the update Opp team Member
            teamMembersToDelete = [
                SELECT OpportunityId, UserId, TeamMemberRole, Custom_Opportunity_Id__c 
                FROM OpportunityTeamMember 
                WHERE Custom_Opportunity_Id__c IN: teamRoleIds
                LIMIT 5000 // Default maximum of SOQL rows to 5000
            ];
            
            
            for(OpportunityShare share: [SELECT UserOrGroupId,OpportunityId,Id FROM OpportunityShare WHERE UserOrGroupId IN: userIds AND 
                                          OpportunityId IN: opportunityIds LIMIT 5000]){ // Default maximum of SOQL rows to 5000
                shareDeleteMap.put(share.UserOrGroupId+ UTIL_Constants.PIPE +share.OpportunityId, share);
            }
            
            for(Opportunity_Team_Roles__c upsertedTeamRole: upsertedTeamRoles){
                if(shareDeleteMap.get(upsertedTeamRole.Name__c + UTIL_Constants.PIPE + upsertedTeamRole.Opportunity_Name__c ) <> NULL){
                    opportunitySharesToDelete.add(shareDeleteMap.get(upsertedTeamRole.Name__c + UTIL_Constants.PIPE + upsertedTeamRole.Opportunity_Name__c ));
                }
            }
        }
            
        try{
            if(isUpdate){       
                database.Delete(teamMembersToDelete,false);
                database.Delete(opportunitySharesToDelete,false);
            }
           
            database.insert(teamMembersToInsert,false);
            database.insert(opportunitySharesToInsert,false);
            
        } catch(exception e){
            System.debug(e.getMessage());
        }
    }

    /**
    *  To validate and update the Sales Credit of the Opportunity Team Role
    *  @name validateSalesCredit
    *  @param newOppTeam - New Opportunity Team Roles to validate sales credit
    *  @return void
    *  @throws no exception
    */
    public static void validateSalesCredit (Map<Id, Opportunity_Team_Roles__c> newOppTeam) {
        System.debug('passClass');
        set<id> oTRoleSet = new set<id>();
                
        for (Opportunity_Team_Roles__c OTRole: newOppTeam.values()){
            oTRoleSet.add(OTRole.Opportunity_Name__c);
        }
         List <Opportunity> opp = new List <Opportunity>([
             select id ,(select id, name__c, role__c, sales_credit__c,Opportunity_Name__c from Opportunity_Teams_Sales_Credit__r LIMIT 5000)// Default maximum of SOQL rows to 5000
             from opportunity where id in:oTRoleSet LIMIT 5000]) ;// Default maximum of SOQL rows to 5000
        
        Map <String,decimal> roleMapCredit = new Map<String,decimal>();
        Map <String,decimal> userMapCredit = new Map<String,decimal>();
        
        Map<String, Custom_Error_Messages__c> cem = Custom_Error_Messages__c.getAll();
        
        for(Opportunity Op: Opp ) {
            roleMapCredit = new Map<String,decimal>();
            userMapCredit = new Map<String,decimal>();
            
            for(Opportunity_Team_Roles__c otr: Op.Opportunity_Teams_Sales_Credit__r){
       
                if(roleMapCredit.get(otr.role__c) <> NULL && otr.Sales_Credit__c <> NULL) {
                    if((roleMapCredit.get(otr.role__c) + otr.sales_credit__c) > 100){
                        System.debug('---------roleMapCredit.get(otr.role__c)'+roleMapCredit.get(otr.role__c));
                        System.debug('---------roleMapCredit.get(otr.sales_credit__c)'+otr.sales_credit__c);
                        //newOppTeam.get(otr.Id).AddError('limit exceeded on role');
                        for(Opportunity_Team_Roles__c c: newOppTeam.values()){
                         System.debug('--------- c='+ otr.Opportunity_Name__c);
                            System.debug('--------- c='+ Op.Id);
                            if(c.Opportunity_Name__c == Op.Id){
                                System.debug('--------- otr.Opportunity_Name__c='+ otr.Opportunity_Name__c);        
                                c.addError(cem.get(UTIL_Constants.ERROR_MSG_TEA_016).Error_Message__c);
                                
                            }
                        }
                    } else{
                        roleMapCredit.put(otr.role__c, (roleMapCredit.get(otr.role__c) + otr.sales_credit__c));
                      
                        
                    }
                }else {
                    roleMapCredit.put(otr.role__c, otr.sales_credit__c);
                }
                
                if(userMapCredit.get(otr.name__c)<> NULL && otr.Sales_Credit__c <> NULL){
                    if((userMapCredit.get(otr.name__c)+otr.sales_credit__c) > 100){
                        System.debug('>>from user' + otr.name__c);
                        System.debug('>>from user' + (userMapCredit.get(otr.name__c)+otr.sales_credit__c));
                        
                        for(Opportunity_Team_Roles__c c: newOppTeam.values()){
                         
                            if(c.Opportunity_Name__c == Op.Id){
                                //c.AddError(UTIL_Constants.ERROR_LIMIT_USER);
                                c.addError(cem.get(UTIL_Constants.ERROR_MSG_TEA_013).Error_Message__c);
                            }
                        }
                    }else {
                        userMapCredit.put(otr.name__c, (userMapCredit.get(otr.name__c) + otr.sales_credit__c));
                    }
                }else {
                    userMapCredit.put(otr.name__c, otr.Sales_Credit__c);
                }
                
            }
        }
    }
               
}