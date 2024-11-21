/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger logic for CA_Meeting_Planning__c Object
* 2020-03-12 : Original Version, rsinha
**/

public without sharing class CA_MePlTriggerHandler {
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
        List<CA_Meeting_Planning__c> createdSPs=[SELECT id,name,I_D_Supervisor__c,GES_Project_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Event_Manager__c,Event_Manager_Onsite__c,GES_Account_Executive_Onsite__c,GES_Account_Manager_Onsite__c,GES_Meeting_Planner__c,On_Site_Meeting_Contact__c,GES_PM_Phone__c,Event_Manager_Phone__c,GES_AM_Phone__c,GES_AE_Phone__c,I_D_Phone__c,GES_PM_Email__c,Event_Manager_Email__c,GES_AM_Email__c,GES_AE_Email__c,I_D_Email__c,GES_EMO_Email__c,GES_EMO_Phone__c,GES_AEO_Email__c,GES_AEO_Phone__c,GES_AMO_Email__c,GES_AMO_Phone__c,GES_MP_Email__c,GES_MP_Phone__c,GES_MCO_Email__c,GES_MCO_Phone__c FROM CA_Meeting_Planning__c WHERE id IN :recordIDs];
        for(CA_Meeting_Planning__c sp:createdSPs){
            fullNames.add(sp.I_D_Supervisor__c);
            fullNames.add(sp.GES_Project_Manager__c);
            fullNames.add(sp.GES_Account_Manager__c);
            fullNames.add(sp.GES_Account_Executive__c);
            fullNames.add(sp.Event_Manager__c);
            fullNames.add(sp.Event_Manager_Onsite__c);
            fullNames.add(sp.GES_Account_Executive_Onsite__c);
            fullNames.add(sp.GES_Account_Manager_Onsite__c);
            fullNames.add(sp.GES_Meeting_Planner__c);
            fullNames.add(sp.On_Site_Meeting_Contact__c);
        }
        
        //get the list of contacts and put them in a map
        for(CA_Manager__c singleContact:[SELECT id,name,Email__c,Phone__c,Full_Name_Forward__c,Full_Name_Reverse__c FROM CA_Manager__c WHERE (Full_Name_Forward__c IN :fullNames OR Full_Name_Reverse__c IN :fullNames)]){
            contactMap.put(singleContact.Full_Name_Forward__c,singleContact);
            contactMap.put(singleContact.Full_Name_Reverse__c,singleContact);
        }
        
        //update the recently created exhibits with contact information
        for(CA_Meeting_Planning__c sp:createdSPs){            
            if(contactMap.containsKey(sp.I_D_Supervisor__c)){
                sp.I_D_Phone__c=contactMap.get(sp.I_D_Supervisor__c).Phone__c;
                sp.I_D_Email__c=contactMap.get(sp.I_D_Supervisor__c).Email__c;
            }
            if(contactMap.containsKey(sp.GES_Project_Manager__c)){
                sp.GES_PM_Phone__c=contactMap.get(sp.GES_Project_Manager__c).Phone__c;
                sp.GES_PM_Email__c=contactMap.get(sp.GES_Project_Manager__c).Email__c;
            }
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
            if(contactMap.containsKey(sp.Event_Manager_Onsite__c)){
                sp.GES_EMO_Phone__c=contactMap.get(sp.Event_Manager_Onsite__c).Phone__c;
                sp.GES_EMO_Email__c=contactMap.get(sp.Event_Manager_Onsite__c).Email__c;
            }
            if(contactMap.containsKey(sp.GES_Account_Executive_Onsite__c)){
                sp.GES_AEO_Phone__c=contactMap.get(sp.GES_Account_Executive_Onsite__c).Phone__c;
                sp.GES_AEO_Email__c=contactMap.get(sp.GES_Account_Executive_Onsite__c).Email__c;
            }
            if(contactMap.containsKey(sp.GES_Account_Manager_Onsite__c)){
                sp.GES_AMO_Phone__c=contactMap.get(sp.GES_Account_Manager_Onsite__c).Phone__c;
                sp.GES_AMO_Email__c=contactMap.get(sp.GES_Account_Manager_Onsite__c).Email__c;
            }
            if(contactMap.containsKey(sp.GES_Meeting_Planner__c)){
                sp.GES_MP_Phone__c=contactMap.get(sp.GES_Meeting_Planner__c).Phone__c;
                sp.GES_MP_Email__c=contactMap.get(sp.GES_Meeting_Planner__c).Email__c;
            }
            if(contactMap.containsKey(sp.On_Site_Meeting_Contact__c)){
                sp.GES_MCO_Phone__c=contactMap.get(sp.On_Site_Meeting_Contact__c).Phone__c;
                sp.GES_MCO_Email__c=contactMap.get(sp.On_Site_Meeting_Contact__c).Email__c;
            }
            
        }
        
        database.update (createdSPs,false);
    }
    
    Public static void deleteProducts(set<Id> recordIDs){
        List<CA_Product__c> prodToBeDeleted=[SELECT id,name FROM CA_Product__c WHERE Meeting_Planning__c IN :recordIDs];
        if(prodToBeDeleted.size()>0){
            database.delete(prodToBeDeleted, false);
        }
        
    }
    
    Public static void updateCancelState(List<CA_Meeting_Planning__c> allMePlan){
        for(CA_Meeting_Planning__c ev:allMePlan){
            if(ev.Cancelled__c==False){
                ev.Cancellation_Date_Time__c=NULL;
                ev.Reason_For_Cancellation__c=NULL;
            }
        }
    }
    Public static void cancelProducts(List<CA_Meeting_Planning__c> allSpons, set<Id> recordIDs){
        /*set<Id> recordIDs = new set<Id>();
        for(CA_Meeting_Planning__c sp:allSpons){
            if(sp.Cancelled__c==true){
                recordIDs.add(sp.id);
            }
        }*/
        if(recordIDs.size()>0){
            List<CA_Product__c> prodToBeCancelled=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Cancelled_Date__c,Reason_for_Cancellation__c,Meeting_Planning__r.Cancelled__c,Meeting_Planning__r.Cancellation_Date_Time__c,Meeting_Planning__r.Reason_For_Cancellation__c FROM CA_Product__c WHERE Meeting_Planning__c IN :recordIDs];
            for(CA_Product__c sp:prodToBeCancelled){
                sp.Cancelled__c=sp.Meeting_Planning__r.Cancelled__c;
                if(sp.Meeting_Planning__r.Cancelled__c==true){
                    sp.Cancellation_Date_Time__c=sp.Meeting_Planning__r.Cancellation_Date_Time__c;
                    sp.Reason_For_Cancellation__c=sp.Meeting_Planning__r.Reason_For_Cancellation__c;
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