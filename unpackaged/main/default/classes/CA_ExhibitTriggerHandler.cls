/**
* @author SLK Software Services - www.slkgroup.com
* @description Trigger logic for CA Exhibit Object
* 2020-03-09 : Original Version, rsinha
**/

public without sharing class CA_ExhibitTriggerHandler {
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
        system.debug('inside updateContactFields function for record id size==='+recordIDs.size());
        set<string> fullNames= new set<string>();
        Map<string,CA_Manager__c> contactMap= new Map<string,CA_Manager__c>();
        List<CA_Exhibit__c> createdExhibits=[SELECT id,name,I_D_Supervisor__c,GES_Project_Manager__c,GES_Account_Manager__c,GES_Account_Executive__c,Exhibit_Manager__c,Event_Manager__c,G_PM_Phone__c,Event_Manager_Phone__c,AM_Phone__c,AE_Phone__c,I_D_Phone__c,G_PM_Email__c,Event_Manager_Email__c,AM_Email__c,AE_Email__c,I_D_Email__c FROM CA_Exhibit__c WHERE id IN :recordIDs];
        for(CA_Exhibit__c singleExhibit:createdExhibits){
            fullNames.add(singleExhibit.I_D_Supervisor__c);
            fullNames.add(singleExhibit.GES_Project_Manager__c);
            fullNames.add(singleExhibit.GES_Account_Manager__c);
            fullNames.add(singleExhibit.GES_Account_Executive__c);
            fullNames.add(singleExhibit.Exhibit_Manager__c);
            fullNames.add(singleExhibit.Event_Manager__c);
        }
        
        //get the list of contacts and put them in a map
        for(CA_Manager__c singleContact:[SELECT id,name,Email__c,Phone__c,Full_Name_Forward__c,Full_Name_Reverse__c FROM CA_Manager__c WHERE (Full_Name_Forward__c IN :fullNames OR Full_Name_Reverse__c IN :fullNames)]){
            contactMap.put(singleContact.Full_Name_Forward__c,singleContact);
            contactMap.put(singleContact.Full_Name_Reverse__c,singleContact);
        }
        
        //update the recently created exhibits with contact information
        for(CA_Exhibit__c singleExhibit:createdExhibits){            
            if(contactMap.containsKey(singleExhibit.I_D_Supervisor__c)){
                singleExhibit.I_D_Phone__c=contactMap.get(singleExhibit.I_D_Supervisor__c).Phone__c;
                singleExhibit.I_D_Email__c=contactMap.get(singleExhibit.I_D_Supervisor__c).Email__c;
            }
            if(contactMap.containsKey(singleExhibit.GES_Project_Manager__c)){
                singleExhibit.G_PM_Phone__c=contactMap.get(singleExhibit.GES_Project_Manager__c).Phone__c;
                singleExhibit.G_PM_Email__c=contactMap.get(singleExhibit.GES_Project_Manager__c).Email__c;
            }
            if(contactMap.containsKey(singleExhibit.GES_Account_Manager__c)){
                singleExhibit.AM_Phone__c=contactMap.get(singleExhibit.GES_Account_Manager__c).Phone__c;
                singleExhibit.AM_Email__c=contactMap.get(singleExhibit.GES_Account_Manager__c).Email__c;
            }
            if(contactMap.containsKey(singleExhibit.GES_Account_Executive__c)){
                singleExhibit.AE_Phone__c=contactMap.get(singleExhibit.GES_Account_Executive__c).Phone__c;
                singleExhibit.AE_Email__c=contactMap.get(singleExhibit.GES_Account_Executive__c).Email__c;
            }
            if(contactMap.containsKey(singleExhibit.Event_Manager__c)){
                singleExhibit.Event_Manager_Phone__c=contactMap.get(singleExhibit.Event_Manager__c).Phone__c;
                singleExhibit.Event_Manager_Email__c=contactMap.get(singleExhibit.Event_Manager__c).Email__c;
            }
        }
        
        database.update (createdExhibits,false);
        
        
    }
    
    Public static void deleteProducts(set<Id> recordIDs){
        List<CA_Product__c> prodToBeDeleted=[SELECT id,name FROM CA_Product__c WHERE exhibit__c IN :recordIDs];
        if(prodToBeDeleted.size()>0){
            database.delete(prodToBeDeleted, false);
        }
        
    }
    
    Public static void updateCancelState(List<CA_Exhibit__c> allExhibits){
        for(CA_Exhibit__c ev:allExhibits){
            if(ev.Cancelled__c==False){
                ev.Cancellation_Date_Time__c=NULL;
                ev.Reason_For_Cancellation__c=NULL;
            }
        }
    }
    Public static void cancelProducts(List<CA_Exhibit__c> allExhibits, set<Id> recordIDs){
       /* set<Id> recordIDs = new set<Id>();
        for(CA_Exhibit__c singleExhibit:allExhibits){
            if(singleExhibit.Cancelled__c==true || singleExhibit.Cancelled__c==false){
                recordIDs.add(singleExhibit.id);
            }
        }*/ 
        if(recordIDs.size()>0){
            List<CA_Product__c> prodToBeCancelled=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Cancelled_Date__c,Reason_for_Cancellation__c,exhibit__r.Cancelled__c,exhibit__r.Cancellation_Date_Time__c,exhibit__r.Reason_For_Cancellation__c FROM CA_Product__c WHERE exhibit__c IN :recordIDs];
            for(CA_Product__c sp:prodToBeCancelled){
                sp.Cancelled__c=sp.exhibit__r.Cancelled__c;
				if(sp.exhibit__r.Cancelled__c==true){
                    sp.Cancellation_Date_Time__c=sp.exhibit__r.Cancellation_Date_Time__c;
                    sp.Reason_For_Cancellation__c=sp.exhibit__r.Reason_For_Cancellation__c;
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