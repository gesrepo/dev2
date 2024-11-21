/************************************************************************************
        Date: 28/March/2017   
        Action : This is handler class of trigger 'TriggerOnBooth'.   
        Change desription:
        
        Developer         Date                  Description 
***************************************************************************************/
public with sharing class BoothTriggerHandler {  

 // To Update show opp on account from related shows
 public void updateShowOppNameOnAcc(List<Oracle_Show_Booth__c> newList, 
                                            List<Oracle_Show_Booth__c> oldList,
                                            Map<Id, Oracle_Show_Booth__c> newMap, 
                                            Map<Id, Oracle_Show_Booth__c> oldMap, 
                                            String eventType, String triggerType) {
            // set this label false if method need not to be executed                               
            if(Label.Label_updateShowOppNameOnAcc == 'true') {
            
                Set<Id> setOfAccountIds = new Set<Id>();
                List<Account> listToBeUpdated = new List<Account>();
                string strShowOpp;
                Map<Id, List<Oracle_Show_Booth__c>> mapOfIdToShow = new Map<Id, List<Oracle_Show_Booth__c>>();
                // for Insert
                if(eventType == 'After' && (triggerType == 'Insert' || triggerType == 'Undelete')) {
                    for(Oracle_Show_Booth__c newBooth : newList) {
                        if(newBooth.Account__c != null) {
                            setOfAccountIds.add(newBooth.Account__c);    
                        }
                    }
                }
                // for update in case accounts/show opp changed on booth, we have to update both new and old accounts
                if(eventType == 'After' && triggerType == 'Update') {
                    for(Oracle_Show_Booth__c updatedBooth : newList) {
                        if( (oldMap.get(updatedBooth.Id).Account__c != newMap.get(updatedBooth.Id).Account__c) 
                        || (oldMap.get(updatedBooth.Id).name != newMap.get(updatedBooth.Id).name) 
                        || (oldMap.get(updatedBooth.Id).Show_Occurrence__c != newMap.get(updatedBooth.Id).Show_Occurrence__c) ) {
                            if(oldMap.get(updatedBooth.Id).Account__c != null) 
                                setOfAccountIds.add(oldMap.get(updatedBooth.Id).Account__c);
                            if(newMap.get(updatedBooth.Id).Account__c != null)    
                                setOfAccountIds.add(newMap.get(updatedBooth.Id).Account__c);    
                        }    
                    }
                }        
                // for delete
                if(eventType == 'After' && triggerType == 'Delete') {for(Oracle_Show_Booth__c delBooth : oldList) { if(delBooth.Account__c!=null){
                        setOfAccountIds.add(delBooth.Account__c);  
                        }  
                    }
                }
                
                if(!setOfAccountIds.isEmpty()) {
                    // prepare a map of accountId to related booth
                    for(Oracle_Show_Booth__c accBooth : [select Id, Account__c, Show_Occurrence__r.name from Oracle_Show_Booth__c where Account__c IN : setOfAccountIds and Show_Occurrence__c!=null]) {
                        if(mapOfIdToShow.containsKey(accBooth.Account__c))
                            mapOfIdToShow.get(accBooth.Account__c).add(accBooth);
                        else
                            mapOfIdToShow.put(accBooth.Account__c, new List<Oracle_Show_Booth__c>{accBooth});
                    }
                
                
                    for(Id ids : setOfAccountIds) {
                        strShowOpp = '';
                        // check if booth exists on Account
                        if(mapOfIdToShow.get(ids) != null && !mapOfIdToShow.get(ids).isEmpty()) {    
                            Account acc = new Account(id = ids);
                            // iterate over all booth for an Account
                            for(Oracle_Show_Booth__c myBooth : mapOfIdToShow.get(ids)){
                                strShowOpp = strShowOpp + myBooth.Show_Occurrence__r.name + ',';
                            }
                            acc.Show_Opportunity__c = strShowOpp;
                            listToBeUpdated.add(acc);
                        }
                        else if(mapOfIdToShow.get(ids) == null ) { // if booth does not exist on account
                            Account acc = new Account(id = ids);
                            acc.Show_Opportunity__c = '';
                            listToBeUpdated.add(acc);
                        }
                    }  
                }
                
                if(!listToBeUpdated.isEmpty()) {
                        update listToBeUpdated; 
                }
            }
        }
    
    public void deleteCampaignMembers(List<Oracle_Show_Booth__c> newList, Map<Id, Oracle_Show_Booth__c> oldMap){
        
        Set<Id> boothIdSet = new Set<Id>();
        
        for(Oracle_Show_Booth__c boothRec : newList){
            Oracle_Show_Booth__c oldRec = oldMap.get(boothRec.Id);
            if(boothRec.INACTIVE_FLAG__c != oldRec.INACTIVE_FLAG__c && boothRec.INACTIVE_FLAG__c){
                boothIdSet.add(boothRec.Id);
            }
        }       
        
        if(!boothIdSet.isEmpty()){
            List<CampaignMember> campMemberList = [SELECT Id, Booth__c, CampaignId FROM CampaignMember WHERE Booth__c IN :boothIdSet];
            if(!campMemberList.isEmpty()){
                Database.DeleteResult[] delResult = Database.delete(campMemberList);
                
                Integer RecordCount = 0;
                
                for(Database.DeleteResult dr : delResult){
                     if (!dr.isSuccess()) {
                System.debug('Unable to delete campaign member.' + dr.getId() );

                for (Database.Error e: dr.getErrors()) {
                    System.debug(' ' + 'Error Code: ' + e.getStatusCode() + ' Error Message: ' + e.getMessage() + ' Affected fields: ' + e.getFields());
                }
            } else {
                System.debug('Deleted campaign member. Campaign Member Id: ' +  campMemberList[RecordCount].Id + ' Campaign Id: ' + campMemberList[RecordCount].CampaignId + ' Booth Id: ' + campMemberList[RecordCount].Booth__c);

            }
                    RecordCount += 1;
                }
            }
        }
    }
    
    public void insertCampaignMembers(List<Oracle_Show_Booth__c> newList, Map<Id, Oracle_Show_Booth__c> oldMap){
        Set<Id> boothIdSet = new Set<Id>();
        
        for(Oracle_Show_Booth__c boothRec : newList){
            Oracle_Show_Booth__c oldRec = oldMap.get(boothRec.Id);
            if(boothRec.INACTIVE_FLAG__c != oldRec.INACTIVE_FLAG__c && !boothRec.INACTIVE_FLAG__c){
                boothIdSet.add(boothRec.Id);
            }
        }
        
        if(!boothIdSet.isEmpty()){
            List<Oracle_Show_Booth_Contact__c> boothContactList = [SELECT Id, Email__c, Inactive__c, Oracle_Show_Booth__c, CreatedBy.Firstname, Oracle_Show_Booth__r.Inactive_Flag__c, 
                         Oracle_Show_Booth__r.Show_Occurrence__c, Oracle_Show_Booth__r.Show_Occurrence__r.Job_Number__c, 
                         Contact__r.Id, Oracle_Show_Booth__r.Account__c, Oracle_Show_Booth__r.Account__r.Type, 
                         Contact__r.HasOptedOutOfEmail, Contact__r.Owner.Alias, Contact__r.Inactive__c, 
                         Contact__r.Account.Inactive__c 
                  FROM Oracle_Show_Booth_Contact__c 
                  WHERE Oracle_Show_Booth__c IN: boothIdSet
        ];
            
            if(!boothContactList.isEmpty()){
                BoothContactTriggerHandler.insertCampaignMembers(boothContactList);
                //sfdc-228 - Texting Campaign and Campaign Member creation - 10/20/23 - Sajid
                BoothContactTriggerHandler.insertTextingCampaignAndCampaignMembers(boothContactList);
            }
        }
        
    }
}