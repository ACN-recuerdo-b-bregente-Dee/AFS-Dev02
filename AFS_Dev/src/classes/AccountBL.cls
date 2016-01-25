/**
   @Author Marvin Bonifacio
   @name AccountBL
   @CreateDate <Date>
   @Description Class that contains the method/s that is being used in Account Object
   @Version <32.0>
   @reference <n/a>
  */
public class AccountBL{
    
    private static Map<Id, Account> staticAccountMap = new Map<Id, Account>{};
    
    
    /**
    * Author                 Marvin Bonifacio
    * Method Name            updateClientAccount
    * Description            Copying the value of portfolio and sub portfolio in customer and client accounts
    */ 
    public static void updateClientAccount(Account[] oldAccounts, Account[] newAccounts){
        Set<Id> clientIds = new Set<Id>{};
        Set<Id> customerIds = new Set<Id>{};
        Set<Id> subPortfolioIds = new Set<Id>{};
        Set<Id> portfolioIds = new Set<Id>{};
        Set<Id> accountIdsToUpdate = new Set<Id>{};
        Map<Id, Account> accountUpdateMap = new Map<Id, Account>{};
        Map<Id, Integer> accountIndexMap = new Map<Id, Integer>{};
                                
        //requery newAccounts
        List<Account> retrieveAllNewAcc = New List<Account>([
        SELECT Id, ParentId, Type, Portfolio__c, Sub_Portfolio__c FROM Account WHERE Id IN: newAccounts LIMIT 50000]);
        
        for (Integer i = 0; i < newAccounts.size(); i++) {
            if (newAccounts[i].Id <> null) {
                accountIndexMap.put(newAccounts[i].Id, i);
            }
            
            if (Trigger.isAfter && Trigger.isInsert) {
                if (newAccounts[i].Type.equals(UTIL_Constants.ACCOUNT_TYPE_CLIENT)) {
                    // Scenario 1 : Insert Client
                    customerIds.add(newAccounts[i].ParentId);
                }
                else if (newAccounts[i].Type.equals(UTIL_Constants.ACCOUNT_TYPE_CUSTOMER)) {
                    subPortfolioIds.add(newAccounts[i].ParentId);
                }
                else {}
            }
            else if (Trigger.isAfter && Trigger.isUpdate /*&& newAccounts[i].ParentId != oldAccounts[i].ParentId*/) {
                if (newAccounts[i].Type.equals(UTIL_Constants.ACCOUNT_TYPE_CLIENT)) {
                    // Scenario 2 : Updated Customer Account of Client
                    clientIds.add(newAccounts[i].Id);
                }
                else if (newAccounts[i].Type.equals(UTIL_Constants.ACCOUNT_TYPE_CUSTOMER)) {
                    // Scenario 3 : Updated Sub Portfolio of Customer
                    customerIds.add(newAccounts[i].Id);
                }
                else if (newAccounts[i].Type.equals(UTIL_Constants.ACCOUNT_TYPE_SUB_PORTFOLIO)) {
                    // Scenario 4 : Updated Portfolio of Sub Portfolio
                    subPortfolioIds.add(newAccounts[i].Id);
                }
                else if (newAccounts[i].Type.equals(UTIL_Constants.ACCOUNT_TYPE_PORTFOLIO)) {
                    // Scenario 4 : Updated Portfolio of Sub Portfolio
                    portfolioIds.add(newAccounts[i].Id);
                }                
                else {}
            }
            else {}
        }
        
        accountIdsToUpdate.addAll(clientIds);
        accountIdsToUpdate.addAll(customerIds);
        accountIdsToUpdate.addAll(subPortfolioIds);
        accountIdsToUpdate.addAll(portfolioIds);
        
        for (Account acc : [SELECT Id FROM Account WHERE (ParentId IN :customerIds OR ParentId IN: subPortfolioIds
                                OR Parent.ParentId IN :subPortfolioIds OR ParentId IN :portfolioIds OR Parent.ParentId IN :portfolioIds
                                OR Parent.Parent.ParentId IN :portfolioIds) LIMIT 10000]) {
            accountIdsToUpdate.add(acc.Id);
        }
        
        Map<Id, Account> accountMap  = getAccountMap(accountIdsToUpdate);
        
        //Populate both TEC_Portfolio & TEC_Sub_Portfolio of Client Account
        for (Account acc : retrieveAllNewAcc) {
            if (acc.Type.equals(UTIL_Constants.ACCOUNT_TYPE_CLIENT)) {
                if (accountMap.containsKey(acc.Id) && clientIds.contains(acc.Id)) {
                    Account lookupAccount = accountMap.get(acc.Id);
                    acc.Portfolio__c = lookupAccount.Parent.Parent.Parent.Name;
                    acc.Sub_Portfolio__c = lookupAccount.Parent.Parent.Name;
                    accountUpdateMap.put(acc.Id, acc);
                }
                else if (accountMap.containsKey(acc.ParentId) && Trigger.isInsert) {
                    Account lookupAccount = accountMap.get(acc.ParentId);
                    acc.Portfolio__c = lookupAccount.Parent.Parent.Name;
                    acc.Sub_Portfolio__c = lookupAccount.Parent.Name;
                    accountUpdateMap.put(acc.Id, acc);
                }
                else {}
            }
            else if (acc.Type.equals(UTIL_Constants.ACCOUNT_TYPE_CUSTOMER)) {
                if (accountMap.containsKey(acc.Id) && customerIds.contains(acc.Id)) {
                    Account lookupAccount = accountMap.get(acc.Id);
                    acc.Portfolio__c = lookupAccount.Parent.Parent.Name;
                    acc.Sub_Portfolio__c = lookupAccount.Parent.Name;
                    accountUpdateMap.put(acc.Id, acc);
                }
                else if (accountMap.containsKey(acc.ParentId) && Trigger.isInsert) {
                    Account lookupAccount = accountMap.get(acc.ParentId);
                    acc.Portfolio__c = lookupAccount.Parent.Name;
                    acc.Sub_Portfolio__c = lookupAccount.Name;
                    accountUpdateMap.put(acc.Id, acc);
                }
                else {}
            }
           else {}
        }
        
        for (String key : accountMap.keyset()) {
            Account acc = accountMap.get(key);
           if ((subPortfolioIds.contains(acc.Parent.ParentId) || customerIds.contains(acc.ParentId) || 
                portfolioIds.contains(acc.Parent.Parent.ParentId) || customerIds.contains(acc.Parent.ParentId) 
                ) && !clientIds.contains(acc.Id) && !Trigger.isInsert) {
                acc.Portfolio__c = acc.Parent.Parent.Parent.Name;
                acc.Sub_Portfolio__c = acc.Parent.Parent.Name;
                accountUpdateMap.put(acc.Id, acc);
            }
                else if ((subPortfolioIds.contains(acc.ParentId) || portfolioIds.contains(acc.Parent.ParentId)) 
                                                && !customerIds.contains(acc.Id) && !Trigger.isInsert) {
                acc.Portfolio__c = acc.Parent.Parent.Name;
                acc.Sub_Portfolio__c = acc.Parent.Name;
                accountUpdateMap.put(acc.Id, acc);
            }
            else {}
        }
        
        Integer index = 0;
        for (Database.SaveResult sr : Database.update(accountUpdateMap.values(), false)) {
            if (!sr.isSuccess()) {
                Database.Error err = sr.getErrors()[0];
                if (accountIndexMap.containsKey(sr.getId())) {
                    newAccounts[accountIndexMap.get(sr.getId())].addError(err.getStatusCode() + UTIL_Constants.COLON + err.getMessage() );
                }
            }
            else {}
            index++;
        }
    }

    /**
    * Author                 Marvin Bonifacio
    * Method Name            getAccountMap
    * Description            Method that will return a map collection of account
    */
    private static Map<Id, Account> getAccountMap(Set<Id> acctIds) {
        if(staticAccountMap.isEmpty()) {
            staticAccountMap = new Map<Id, Account>([SELECT Id, Name, Portfolio__c, Sub_Portfolio__c,
                                                     ParentId, Parent.ParentId, Parent.Parent.ParentId,
                                                     Parent.Name, Parent.Parent.Name, Parent.Parent.Parent.Name,
                                                     Parent.AccountNumber, Parent.Parent.AccountNumber, Parent.Parent.Parent.AccountNumber
                                                     FROM Account WHERE Id IN :acctIds LIMIT 10000]);
        }
        else {}
        return staticAccountMap;
    }
    
    /**
    * Author                 Lhea Valencia
    * Method Name            updateOpp
    * Description            Method that will copy the value of Account Plan OI% in account to Account Plan OI% in Opportunity if the Opportunity is still Open
    */
    public static void updateOpp(Map<Id, Account> newAcc, Map<Id, Account> oldAcc){
                    
        Set<Id> validAcc = new Set<Id>();
        Map<Id, Opportunity> allOppMap = new Map<Id, Opportunity>{};
        List<Opportunity> oppToBeUpdated = new List<Opportunity>();
        Map<Id, List<Id>> errorOpsToAccountMap = new Map<Id, List<Id>>{};
        Map<Id, List<String>> errorOppNameToAccountMap = new Map<Id, List<String>>{};
        Map<String, Custom_Error_Messages__c> cem = Custom_Error_Messages__c.getAll();   
         
        for(Account op: newAcc.values()){
            //determine if the specific field is changed in Account
            if (op.Account_Plan_OI__c <> oldAcc.get(op.Id).Account_Plan_OI__c){
                //collect accounts with the field updated.
                validAcc.add(op.Id);
            }
            System.debug('<<<<<<<<<<old values  >>>>>>>>>' + oldAcc.get(op.Id).Account_Plan_OI__c);
            System.debug('+++++++ new value +++++++++++' + newAcc.get(op.Id).Account_Plan_OI__c);
        }
        
        //query all opportunity of Accounts
        allOppMap = new Map<Id, Opportunity>([SELECT Id, Name, StageName ,Reporting_Status__c, AccountId FROM Opportunity WHERE 
        AccountId IN: validAcc LIMIT 10000]);         
        //Query all the opportunity of valid accounts
        for(Opportunity opp: allOppMap.values()){
             //Determine that opportunity is open
            if(opp.Reporting_Status__c <> UTIL_Constants.STAGENAME_CLIENT_WITHDREW && 
               opp.Reporting_Status__c <> UTIL_Constants.STAGENAME_AFS_WITHDREW && 
               opp.Reporting_Status__c <> UTIL_Constants.STAGENAME_WON && 
               opp.Reporting_Status__c <> UTIL_Constants.STAGENAME_LOST && 
               opp.Reporting_Status__c <> UTIL_Constants.STAGENAME_CLOSED
            ){
                    //Set the value of Opp field using the value of account's field
                    opp.Account_Plan_OI__c = newAcc.get(opp.AccountId).Account_Plan_OI__c;
                    oppToBeUpdated.add(opp);
            }
        }

        Integer index = 0;
        for (Database.SaveResult sr : Database.update(oppToBeUpdated, false)) {
            Id currentAccount = oppToBeUpdated[index].AccountId; //assuming AccountId is a required field in Opportunity
            if (!sr.isSuccess()) {
            
                //System.assertEquals(sr.getId(), String.valueOf(oppToBeUpdated[index].Id));
                Database.Error err = sr.getErrors()[0];
                //if (errorOpsToAccountMap.containsKey(currentAccount)) {
                if (errorOppNameToAccountMap.containsKey(currentAccount)) {
                    //errorOpsToAccountMap.get(currentAccount).add(oppToBeUpdated[index].Id);
                    errorOppNameToAccountMap.get(currentAccount).add(oppToBeUpdated[index].Name);
                }
                else {
                    //errorOpsToAccountMap.put(currentAccount, new List<Id>{oppToBeUpdated[index].Id});
                    errorOppNameToAccountMap.put(currentAccount, new List<String>{oppToBeUpdated[index].Name});
                }
            }
            index++;       
        }
        
        for (Account currentAccount: newAcc.values()) {
            //if (errorOpsToAccountMap.containsKey(currentAccount.Id)) {
            if (errorOppNameToAccountMap.containsKey(currentAccount.Id)) {
                newAcc.get(currentAccount.Id).addError(
                    cem.get(UTIL_Constants.ERROR_MSG_ACC_003_1).Error_Message__c
                    //+ ' [Number of impacted records : ' + errorOpsToAccountMap.get(currentAccount.Id).size() +'] '
                    //+ String.valueOf(errorOpsToAccountMap.get(currentAccount.Id))
                    //+ String.valueOf(errorOppNameToAccountMap.get(currentAccount.Id))
                    //+ String.valueOf(errorOppNameToAccountMap.get(currentAccount.Id)).remove('(').remove(')')
                    + String.valueOf(errorOppNameToAccountMap.get(currentAccount.Id)).replace('(','{').replace(')','}')
                    + cem.get(UTIL_Constants.ERROR_MSG_ACC_003_2).Error_Message__c
                );
            }
        }
    }
}