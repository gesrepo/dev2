/*
###########################################################################
# File..................: <<UpdateShowOpp>>
# Version...............: <<15.0>>
# Created by............: <<Astadia - Becky Bastien>>
# Created Date..........: <<21-January-2010>>
# Last Modified by......: <<>>
# Last Modified Date....: <<>>
# Description...........: <<This class will update opportunity name when a facilityId or showId changes>> 
#<<@future is used to allow more than 200 opps to be updated>>
# Created by the Astadia, Inc. 
# Company URL : http://www.astadia.com
###########################################################################*/
public class UpdateShowOpp 
{
    @future(callout=true)
    public static void updateOppsFromShow(Id showId, String showName) 
    {   
        system.debug('oldshow: ' + showId);
        Opportunity[] opp = [Select id,name,Facility__r.LMS_Facility_ID__c,YRMO__c,Show_Name__c from Opportunity where Show_Name__c =: showId];
        for(integer i=0; i<opp.size();i++)
        {
            system.debug('in opp loop');
            if( opp[i].Facility__r.LMS_Facility_ID__c != null)
            {                    
                opp[i].Name = showName + '-' + opp[i].YRMO__c + '-' + opp[i].Facility__r.LMS_Facility_ID__c;
            }
            else
            {
                opp[i].Name = showName + '-' + opp[i].YRMO__c + '-';
            }
        }
        update opp;
        
    }
    @future(callout=true)
    public static void updateOppsFromShow_Mass(Map<Id, String> showNamesMap) 
    {   
        Opportunity[] opp = [Select id,name,Facility__r.LMS_Facility_ID__c,YRMO__c,Show_Name__c from Opportunity where Show_Name__c IN :showNamesMap.keyset()];
        List<Opportunity> updateOpps = new List<Opportunity>();
        for(integer i=0; i<opp.size();i++)
        {
            string OppName;
            if( opp[i].Facility__r.LMS_Facility_ID__c != null)
            {
                OppName = showNamesMap.get(opp[i].Show_Name__c) + '-' + opp[i].YRMO__c + '-' + opp[i].Facility__r.LMS_Facility_ID__c;
            }
            else
            {
                OppName = showNamesMap.get(opp[i].Show_Name__c) + '-' + opp[i].YRMO__c + '-';
            }
            if (opp[i].Name != OppName) {
                opp[i].Name = OppName;
                updateOpps.add(opp[i]);
            }
            
        }
        update updateOpps;
        
    }
    
    @future(callout=true)
    public static void updateOppsFromAccount(Id acctId, String facilityId) 
    {  
        system.debug('in opp loop');
        Opportunity[] opp = [Select id,name,Facility__r.LMS_Facility_ID__c,YRMO__c,Show_Name__c,Show_Name__r.Show_ID__c from Opportunity where Facility__c =: acctId];
        for(integer i=0; i<opp.size();i++)
        {
            if( facilityId != null)
            {                    
                opp[i].Name = opp[i].Show_Name__r.Show_ID__c + '-' + opp[i].YRMO__c + '-' + facilityId;
            }
            else
            {
                opp[i].Name = opp[i].Show_Name__r.Show_ID__c + '-' + opp[i].YRMO__c + '-';
            }
        }
        update opp;
    }
    
    @future(callout=true)
    public static void updateOppsFromAccount_Mass(Map<Id, String> facilityNamesMap) 
    {  
        system.debug('in opp loop');
        Opportunity[] opp = [Select id,name,Facility__c,Facility__r.LMS_Facility_ID__c,YRMO__c,Show_Name__c,Show_Name__r.Show_ID__c from Opportunity where Facility__c IN :facilityNamesMap.keyset()];
        for(integer i=0; i<opp.size();i++)
        {
            if (facilityNamesMap.containsKey(opp[i].Facility__c))
            {                    
                opp[i].Name = opp[i].Show_Name__r.Show_ID__c + '-' + opp[i].YRMO__c + '-' + facilityNamesMap.get(opp[i].Facility__c);
            }
            else
            {
                opp[i].Name = opp[i].Show_Name__r.Show_ID__c + '-' + opp[i].YRMO__c + '-';
            }
        }
        update opp;
    }
}