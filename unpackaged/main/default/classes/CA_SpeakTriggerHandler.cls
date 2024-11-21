/**
* @description Trigger logic for CA Event Object
* @author Birlasoft : Vaishali
* @description Trigger logic  for CA_Speaking_Engagement__c
* 2020-04-23 : Original Version, VaishaliT
**/

public without sharing class CA_SpeakTriggerHandler {
    private static Boolean run = true;
    public static Boolean runOnce(){
        if(run){
            run = false;
            return true;
        }else{
            return run;
        }
    }
    
    public static void updateContactFields(set<Id> recordIDs){
        //system.debug('inside updateContactFields function for record id size==='+recordIDs.size());
        set<string> fullNames= new set<string>();
        Map<string,CA_Manager__c> contactMap= new Map<string,CA_Manager__c>();
        List<CA_Speaking_Engagement__c> createdSPs=[SELECT id,Name,Event_Manager__c,GES_Project_Manager__c,GES_Account_Executive__c,Event_Manager_Phone__c,GES_AE_Phone__c,Event_Manager_Email__c,GES_AE_Email__c,GES_Account_Manager__c,GES_AM_Phone__c,GES_AM_Email__c FROM CA_Speaking_Engagement__c WHERE id IN :recordIDs];
        for(CA_Speaking_Engagement__c sp:createdSPs){
            fullNames.add(sp.GES_Project_Manager__c);
            fullNames.add(sp.GES_Account_Manager__c);
            fullNames.add(sp.GES_Account_Executive__c);
            fullNames.add(sp.Event_Manager__c);
        }
        system.debug('## ' + fullNames);
        
        //get the list of contacts and put them in a map
        for(CA_Manager__c singleContact:[SELECT id,name,Email__c,Phone__c,Full_Name_Forward__c,Full_Name_Reverse__c FROM CA_Manager__c WHERE (Full_Name_Forward__c IN :fullNames OR Full_Name_Reverse__c IN :fullNames)]){
            contactMap.put(singleContact.Full_Name_Forward__c,singleContact);
            contactMap.put(singleContact.Full_Name_Reverse__c,singleContact);
        }
        system.debug('@@contactMap'+contactMap);
        //update the recently created exhibits with contact information
        for(CA_Speaking_Engagement__c sp:createdSPs){            

            if(contactMap.containsKey(sp.GES_Account_Manager__c)){
                sp.GES_AM_Phone__c=contactMap.get(sp.GES_Account_Manager__c).Phone__c;
                sp.GES_AM_Email__c=contactMap.get(sp.GES_Account_Manager__c).Email__c;
            }
            if(contactMap.containsKey(sp.GES_Account_Executive__c)){
                sp.GES_AE_Phone__c=contactMap.get(sp.GES_Account_Executive__c).Phone__c;
                sp.GES_AE_Email__c=contactMap.get(sp.GES_Account_Executive__c).Email__c;
            }
            if(contactMap.containsKey(sp.Event_Manager__c)){
                sp.Event_Manager_Phone__c=contactMap.get(sp.Event_Manager__c).Phone__c;
                sp.Event_Manager_Email__c=contactMap.get(sp.Event_Manager__c).Email__c;
            }
        }
        
        database.update (createdSPs,false);
    }
    
    Public static void deleteProducts(set<Id> recordIDs){
        List<CA_Product__c> prodToBeDeleted=[SELECT id,name FROM CA_Product__c WHERE Speaking_Engagement__c IN :recordIDs];
        if(prodToBeDeleted.size()>0){
            database.delete(prodToBeDeleted, false);
        }
        
    }
    
    Public static void updateCancelState(List<CA_Speaking_Engagement__c> allSpons){
        for(CA_Speaking_Engagement__c ev:allSpons){
            if(ev.Cancelled__c==False){
                ev.Cancellation_Date_Time__c=NULL;
                ev.Reason_For_Cancellation__c=NULL;
            }
        }
    }
    Public static void cancelProducts(List<CA_Speaking_Engagement__c> allSpons,set<Id> recordIDs){
        /*set<Id> recordIDs = new set<Id>();
        for(CA_Speaking_Engagement__c sp:allSpons){
            if(sp.Cancelled__c==true || sp.Cancelled__c==false){
                recordIDs.add(sp.id);
            }
        }*/
        if(recordIDs.size()>0){
            List<CA_Product__c> prodToBeCancelled=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Cancelled_Date__c,Reason_for_Cancellation__c,Speaking_Engagement__r.Cancelled__c,Speaking_Engagement__r.Cancellation_Date_Time__c,Speaking_Engagement__r.Reason_For_Cancellation__c FROM CA_Product__c WHERE Speaking_Engagement__c IN :recordIDs];
            for(CA_Product__c sp:prodToBeCancelled){
                sp.Cancelled__c=sp.Speaking_Engagement__r.Cancelled__c;
                if(sp.Speaking_Engagement__r.Cancelled__c==true){
                    sp.Cancellation_Date_Time__c=sp.Speaking_Engagement__r.Cancellation_Date_Time__c;
                    sp.Reason_For_Cancellation__c=sp.Speaking_Engagement__r.Reason_For_Cancellation__c;
                }
                else{
                    sp.Cancellation_Date_Time__c=NULL;
                    sp.Reason_For_Cancellation__c=NULL;
                }
            }
            if(prodToBeCancelled.size()>0){
                database.update(prodToBeCancelled, false);
            }
        }
    }
}