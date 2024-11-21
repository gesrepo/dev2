trigger trg_upd_oppname_facility on Account (after update) 
{
    if(Userinfo.getProfileID()==Label.MergeSystemAdminId){   
    
         return;    
           }
    
    Map<Id, String> facilityNamesMap = new Map<Id, String>();
    if (System.isFuture() || System.isBatch()) {            return;  
            }
    
    for(Account acct : Trigger.New) 
    {
        //If LMS Facility ID changed,then update the Related show Opportunity
        if(trigger.oldMap.get(acct.Id).LMS_Facility_ID__c != acct.LMS_Facility_ID__c)
        {
            if (!TriggerOptimizationUtility.trg_upd_oppname_facility_Handled.contains(acct.Id)) {     facilityNamesMap.put(acct.id, acct.LMS_Facility_ID__c);                              TriggerOptimizationUtility.trg_upd_oppname_facility_Handled.add(acct.Id);
            }
            /*
            Opportunity[] opp = [Select id,name,Facility__r.LMS_Facility_ID__c,YRMO__c,Show_Name__c,Show_Name__r.Show_ID__c from Opportunity where Facility__c =: acct.id];
            for(integer i=0; i<opp.size();i++)
            {
                if( acct.LMS_Facility_ID__c != null)
                {                    
                    opp[i].Name = opp[i].Show_Name__r.Show_ID__c + '-' + opp[i].YRMO__c + '-' + acct.LMS_Facility_ID__c;
                }
                else
                {
                    opp[i].Name = opp[i].Show_Name__r.Show_ID__c + '-' + opp[i].YRMO__c + '-';
                }
            }
            update opp;
            */
        }
    }
    UpdateShowOpp.updateOppsFromAccount_Mass(facilityNamesMap);
}