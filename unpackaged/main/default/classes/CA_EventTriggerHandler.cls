/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger logic for CA Event Object
* 2020-03-11 : Original Version, rsinha
**/

public without sharing class CA_EventTriggerHandler {
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
        List<CA_Event__c> createdEvents=[SELECT id,name,I_D_Supervisor__c,Cancellation_Date_Time__c,GES_Project_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Event_Manager__c,GES_PM_Phone__c,Event_Manager_Phone__c,GES_AM_Phone__c,GES_AE_Phone__c,I_D_Phone__c,GES_PM_Email__c,Event_Manager_Email__c,GES_AM_Email__c,GES_AE_Email__c,Congress_Manager__c, Congress_Manager_Phone__c,Congress_Manager_Email__c,I_D_Email__c FROM CA_Event__c WHERE id IN :recordIDs];
        for(CA_Event__c se:createdEvents){
            fullNames.add(se.I_D_Supervisor__c);
            fullNames.add(se.GES_Project_Manager__c);
            fullNames.add(se.GES_Account_Manager__c);
            fullNames.add(se.GES_Account_Executive__c);
            fullNames.add(se.Event_Manager__c);
            fullNames.add(se.Congress_Manager__c);
        }
        
        //get the list of contacts and put them in a map
        for(CA_Manager__c singleContact:[SELECT id,name,Email__c,Phone__c,Full_Name_Forward__c,Full_Name_Reverse__c FROM CA_Manager__c WHERE (Full_Name_Forward__c IN :fullNames OR Full_Name_Reverse__c IN :fullNames)]){
            contactMap.put(singleContact.Full_Name_Forward__c,singleContact);
            contactMap.put(singleContact.Full_Name_Reverse__c,singleContact);
        }
        
        //update the recently created exhibits with contact information
        for(CA_Event__c se:createdEvents){            
            if(contactMap.containsKey(se.I_D_Supervisor__c)){
                se.I_D_Phone__c=contactMap.get(se.I_D_Supervisor__c).Phone__c;
                se.I_D_Email__c=contactMap.get(se.I_D_Supervisor__c).Email__c;
            }
            if(contactMap.containsKey(se.GES_Project_Manager__c)){
                se.GES_PM_Phone__c=contactMap.get(se.GES_Project_Manager__c).Phone__c;
                se.GES_PM_Email__c=contactMap.get(se.GES_Project_Manager__c).Email__c;
            }
            if(contactMap.containsKey(se.GES_Account_Manager__c)){
                se.GES_AM_Phone__c=contactMap.get(se.GES_Account_Manager__c).Phone__c;
                se.GES_AM_Email__c=contactMap.get(se.GES_Account_Manager__c).Email__c;
            }
            if(contactMap.containsKey(se.GES_Account_Executive__c)){
                se.GES_AE_Phone__c=contactMap.get(se.GES_Account_Executive__c).Phone__c;
                se.GES_AE_Email__c=contactMap.get(se.GES_Account_Executive__c).Email__c;
            }
            if(contactMap.containsKey(se.Event_Manager__c)){
                se.Event_Manager_Phone__c=contactMap.get(se.Event_Manager__c).Phone__c;
                se.Event_Manager_Email__c=contactMap.get(se.Event_Manager__c).Email__c;
            }
            if (contactMap.containsKey(se.Congress_Manager__c)){
                se.Congress_Manager_Phone__c=contactMap.get(se.Congress_Manager__c).Phone__c;
                se.Congress_Manager_Email__c=contactMap.get(se.Congress_Manager__c).Email__c;
            }
        }
        
        database.update (createdEvents,false);
    }
    
    Public static void deleteProducts(set<Id> recordIDs){
        List<CA_Product__c> prodToBeDeleted=[SELECT id,name FROM CA_Product__c WHERE CA_Event__c IN :recordIDs];
        if(prodToBeDeleted.size()>0){
            database.delete(prodToBeDeleted, false);
        }
        
    }
    
    Public static void updateCancelState(List<CA_Event__c> allEvents){
        for(CA_Event__c ev:allEvents){
            if(ev.Cancelled__c==False){
                ev.Cancellation_Date_Time__c=NULL;
                ev.Reason_For_Cancellation__c=NULL;
            }
        }
    }
    Public static void cancelProducts(List<CA_Event__c> allEvents, set<Id> recordIDs){
        /*set<Id> recordIDs = new set<Id>();
        for(CA_Event__c se:allEvents){
            if(se.Cancelled__c==true || se.Cancelled__c==false){
                recordIDs.add(se.id);
            }
        }*/
        if(recordIDs.size()>0){
            List<CA_Product__c> prodToBeCancelled=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Cancelled_Date__c,Reason_for_Cancellation__c,CA_Event__r.Cancelled__c,CA_Event__r.Cancellation_Date_Time__c,CA_Event__r.Reason_For_Cancellation__c FROM CA_Product__c WHERE CA_Event__c IN :recordIDs];
            for(CA_Product__c sp:prodToBeCancelled){
                sp.Cancelled__c=sp.CA_Event__r.Cancelled__c;
                if(sp.CA_Event__r.Cancelled__c==true){
                    sp.Cancellation_Date_Time__c=sp.CA_Event__r.Cancellation_Date_Time__c;
                    sp.Reason_For_Cancellation__c=sp.CA_Event__r.Reason_For_Cancellation__c;
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