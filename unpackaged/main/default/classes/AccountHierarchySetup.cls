/**
* File Name: AccountHierarchySetup
* Description : It is used to get parent duns and as per parent duns populate account id in the child   account.
* Copyright : GES
* @author : Kumud Thakur | kumud.thakur@birlasoft.com | 
 * 
 * Modification Log 
 * =============================================================== 
 *    Ver  |Date          |Author                     |Modification
*    1.0  |10-may-2017  |kumud.thakur@birlasoft.com  |New Class created
*/

public class AccountHierarchySetup{


 
       final map<String,DatacloudDandBCompany> mapDunsParentDuns=new Map<String,DatacloudDandBCompany>();
         /*
                        method :setupAccountHierarchy
                        parameter: list of account
                        desc: create a set of duns number of account and pass duns number to get parent duns number and set up account hierarchy
                        return: void
                        @Author : Kumud thakur
        */
        public void setupAccountHierarchy(List<Account> listAccounts){
        
                final set<String> setDunsNumber=new Set<String>();  // set to collect duns number
                final List<Account> listAccountUpdate=new List<Account>();
                for(Account instAcc:listAccounts){  // iterate over receive account
                                
                        if(String.isNotBlank(instAcc.Dunsnumber)){
                                        
                                        setDunsNumber.add(instAcc.Dunsnumber);// duns number of account in the set
                        }
                }// end of loop
                        
                final map<string,Account> mapDunsAccount=getParentAccount(setDunsNumber);
                
                //setParentGlobalInfo(setDunsNumber);
                
                for(Account instAcc:listAccounts){
                    
                    if(mapDunsAccount.containsKey(instAcc.dunsNumber) && mapDunsAccount.get(instAcc.dunsNumber).id!=instAcc.id){
                       
                         instAcc.parentId=mapDunsAccount.get(instAcc.dunsNumber).id;
                         instAcc.Custom_Parent_Account__c=mapDunsAccount.get(instAcc.dunsNumber).id;  // it is populate to show child account under parent account.
                    }
                    if(mapDunsParentDuns.containskey(instAcc.dunsNumber)){ instAcc.Alternate_Name__c=mapDunsParentDuns.get(instAcc.dunsNumber).Name; instAcc.parent_duns_number__C=mapDunsParentDuns.get(instAcc.dunsNumber).ParentOrHqDunsNumber; instAcc.Parent_Business_Name__c=mapDunsParentDuns.get(instAcc.dunsNumber).ParentOrHqBusinessName; 
                    instAcc.Global_Ultimate_Business_Name__c=mapDunsParentDuns.get(instAcc.dunsNumber).GlobalUltimateBusinessName;instAcc.Global_Ultimate_Duns_Number__c=mapDunsParentDuns.get(instAcc.dunsNumber).GlobalUltimateDunsNumber;
                        
                        
                    }
                    
                    if(String.isNotBlank(instAcc.parent_duns_number__C) &&  instAcc.parent_duns_number__C!='000000000' && instAcc.parent_duns_number__C!=instAcc.dunsNumber && String.isNotBlank(instAcc.parentID)){
                        
                        instAcc.Processed_Flag__c=true;
                    }
                    listAccountUpdate.add(instAcc);
                    
                    
                }
                system.debug('*******listAccountUpdate*'+listAccountUpdate);
                if(!listAccountUpdate.isEmpty()){
                    update listAccountUpdate;
                }
        
        }// end of methid

        
        public map<string,Account> getParentAccount(final Set<String> setDunsNumber ){
        
                map<String,Set<String>> mapParentDunsDunsNo=new map<String,Set<String>>();
                final map<string,Account> mapDunsAccount=new map<String,Account>();
                
               
                for(DatacloudDandBCompany instDBcmpny:[SELECT Name,dunsnumber,ParentOrHqDunsNumber,ParentOrHqBusinessName,GlobalUltimateBusinessName,GlobalUltimateDunsNumber,PrimarySicDesc  FROM DatacloudDandBCompany where dunsnumber in : setDunsNumber]){
                       mapDunsParentDuns.put(instDBcmpny.dunsnumber,instDBcmpny); if(instDBcmpny.ParentOrHqDunsNumber!='000000000'){
                           if(mapParentDunsDunsNo.containsKey(instDBcmpny.ParentOrHqDunsNumber)){  mapParentDunsDunsNo.get(instDBcmpny.ParentOrHqDunsNumber).add(instDBcmpny.dunsnumber);
                                                }else{  mapParentDunsDunsNo.put(instDBcmpny.ParentOrHqDunsNumber,new set<String>{instDBcmpny.dunsnumber});
                                                }
                                                
                                }
                                
                
                
                }// end of loop
                
                system.debug('=====mapDunsParentDuns===='+mapDunsParentDuns+'8888888888mapParentDunsDunsNo'+mapParentDunsDunsNo);
                if(Test.isRunningTest()){
                
                    mapParentDunsDunsNo.put('001326495',new Set<String>{'015280873','122526325'}); // because in DatacloudDandBCompany we cannot insert data using test class
                    
                
                }
                for(Account instAcc:[select Id,dunsnumber from account where dunsnumber in :mapParentDunsDunsNo.keySet()]){
                
                                for(String  strDunsno:mapParentDunsDunsNo.get(instAcc.dunsnumber)){
                                
                                                mapDunsAccount.put(strDunsno,instAcc);
                                
                                }// end of  inner loop
                }// end of outer loop
                

                
                return mapDunsAccount;         
        }

         

}