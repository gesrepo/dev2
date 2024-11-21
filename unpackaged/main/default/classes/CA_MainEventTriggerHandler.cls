public class CA_MainEventTriggerHandler {
    
    private static Boolean run = true;
    public static Boolean runOnce(){
        if(run){
            run = false;
            return true;
        }else{
            return run;
        }
    }
	Public static void updateCancelState(List<CA_Main_Event__c > allEvents){
        for(CA_Main_Event__c ev:allEvents){
            if(ev.Event_Cancelled__c==False){
                ev.Event_Cancellation_Date__c=NULL;
                ev.Reason_for_Cancellation__c=NULL;
            }
        }
    }
    Public static void cancelActivities(List<CA_Main_Event__c > allEvents){
        set<Id> recordIDs = new set<Id>();
        for(CA_Main_Event__c ev:allEvents){
        	recordIDs.add(ev.id);
        }
        if(recordIDs.size()>0){
            List<CA_Exhibit__c> exList=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Exhibit__c WHERE Event__c IN :recordIDs];
            for(CA_Exhibit__c ev:exList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date_Time__c=ev.Event__r.Event_Cancellation_Date__c;
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
                    ev.Cancellation_Date_Time__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }

            List<CA_Event__c> evList=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Event__c WHERE Event__c IN :recordIDs];
            for(CA_Event__c ev:evList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date_Time__c=ev.Event__r.Event_Cancellation_Date__c;
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
                    ev.Cancellation_Date_Time__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }

            List<CA_Meeting_Planning__c> mpList=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Meeting_Planning__c WHERE Event__c IN :recordIDs];
            for(CA_Meeting_Planning__c ev:mpList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date_Time__c=ev.Event__r.Event_Cancellation_Date__c;
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
					ev.Cancellation_Date_Time__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }
            
            List<CA_Meeting_Room__c> mrList=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Meeting_Room__c WHERE Event__c IN :recordIDs];
            for(CA_Meeting_Room__c ev:mrList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date_Time__c=ev.Event__r.Event_Cancellation_Date__c;
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
					ev.Cancellation_Date_Time__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }
            
            List<CA_Speaking_Engagement__c> spList=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Speaking_Engagement__c WHERE Event__c IN :recordIDs];
            for(CA_Speaking_Engagement__c ev:spList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date_Time__c=ev.Event__r.Event_Cancellation_Date__c;
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
                    ev.Cancellation_Date_Time__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }
            List<CA_Sponsorship__c> sponList=[SELECT id,name,Cancelled__c,Cancellation_Date_Time__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Sponsorship__c WHERE Event__c IN :recordIDs];
            for(CA_Sponsorship__c ev:sponList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date_Time__c=ev.Event__r.Event_Cancellation_Date__c;
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
                    ev.Cancellation_Date_Time__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }
            List<CA_Sporting_Event__c> seList=[SELECT id,name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Sporting_Event__c WHERE Event__c IN :recordIDs];
            for(CA_Sporting_Event__c ev:seList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date__c=Date.Valueof(ev.Event__r.Event_Cancellation_Date__c);
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
                    ev.Cancellation_Date__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }
            
            List<CA_Membership__c> msList=[SELECT id,name,Cancelled__c,Cancellation_Date__c,Reason_for_Cancellation__c,Event__r.Event_Cancelled__c,Event__r.Event_Cancellation_Date__c,Event__r.Reason_For_Cancellation__c FROM CA_Membership__c WHERE Event__c IN :recordIDs];
            for(CA_Membership__c ev:msList){
                ev.Cancelled__c=ev.Event__r.Event_Cancelled__c;
                if(ev.Event__r.Event_Cancelled__c==true){
                    ev.Cancellation_Date__c=Date.Valueof(ev.Event__r.Event_Cancellation_Date__c);
                    ev.Reason_For_Cancellation__c=ev.Event__r.Reason_For_Cancellation__c;
                }
                else{
                    ev.Cancellation_Date__c=NULL;
                    ev.Reason_For_Cancellation__c=NULL;
                }
            }
            
            if(exList.size()>0){
                database.update(exList, false);
            }
            if(evList.size()>0){
                database.update(evList, false);
            }
            if(mpList.size()>0){
                database.update(mpList, false);
            }
            if(mrList.size()>0){
                database.update(mrList, false);
            }
            if(spList.size()>0){
                database.update(spList, false);
            }
            if(sponList.size()>0){
                database.update(sponList, false);
            }
            if(seList.size()>0){
                database.update(seList, false);
            }           
            if(msList.size()>0){
                database.update(msList, false);
            }
            
        }
    }
    

}