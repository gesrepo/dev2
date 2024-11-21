public class ExhibitTriggerHandler {
    public static void updateExhibitCancelledOnCongress(List<Exhibit__c> listExhibit, Set<Id> setUpdatedExhibitIds, Set<Id> setCongressIds) {
        /*List<GES_Connect_Corporate_Accounts__c> listCongressToUpdate = new List<GES_Connect_Corporate_Accounts__c>();
        Map<Id, List<Exhibit__c>> mapExhibit = new Map<Id, List<Exhibit__c>>();
        for(Exhibit__c exhibit : [select Canceled__c, Activity_Type_Exhibit_Instance_c__c, Activity_Type_Exhibit_Instance_c__r.Exhibit_Cancelled__c from Exhibit__c
                                    where Activity_Type_Exhibit_Instance_c__c IN: setCongressIds AND Id NOT IN: setUpdatedExhibitIds]) {
            if(!mapExhibit.containsKey(exhibit.Activity_Type_Exhibit_Instance_c__c)) {
                mapExhibit.put(exhibit.Activity_Type_Exhibit_Instance_c__c, new List<Exhibit__c>());
            }
            mapExhibit.get(exhibit.Activity_Type_Exhibit_Instance_c__c).add(exhibit);
        }
        for(Exhibit__c updatedExhibit : listExhibit) {
            if(mapExhibit.get(updatedExhibit.Activity_Type_Exhibit_Instance_c__c) != null) {
                Boolean checkExhibitNotCancelled = false;
                GES_Connect_Corporate_Accounts__c congress = new GES_Connect_Corporate_Accounts__c();
                for(Exhibit__c exhibit : mapExhibit.get(updatedExhibit.Activity_Type_Exhibit_Instance_c__c)) {
                    congress = exhibit.Activity_Type_Exhibit_Instance_c__r;
                    if(!exhibit.Canceled__c) {
                        checkExhibitNotCancelled = true;
                        break;
                    }
                }
                if(!checkExhibitNotCancelled ) {
                    congress.Exhibit_Cancelled__c = true;
                    listCongressToUpdate.add(congress);
                }
            }
        }
        if(listCongressToUpdate.size() > 0) {
            update listCongressToUpdate;
        }*/
    }
}