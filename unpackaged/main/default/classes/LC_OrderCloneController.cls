public with sharing class LC_OrderCloneController {
    public string recordId{get; set;}
    public LC_OrderCloneController(ApexPages.StandardSetController controller){
        recordId=apexpages.currentpage().getparameters().get('id');
    }
    //Method to get the shows Created by loggedin user to Clone orders
    public class ShowWrapper{
        @AuraEnabled
        public Boolean isComm {get;set;}
        @AuraEnabled
        public Map<Id,String> showIdNameMap {get;set;}
        ShowWrapper(){}
    }
    @AuraEnabled
    public static ShowWrapper getopenShowOptions(){
        Map<Id,String> showsToAssociate=new Map<Id,String>();
        List<Id> showmem=new List<Id>();
        try{
            List<GC_Show_Team_Member__c> tempShowList;            
            tempShowList=[select id,connect2_show__c from GC_Show_Team_Member__c where User__c=:UserInfo.getUserId()];            
            for(GC_Show_Team_Member__c sm: tempShowList){
                showmem.add(sm.connect2_show__c);
            }
            List<GC_Connect2_Show__c> shows =[SELECT Id, Name,Show_Name__c,Facility__c,Facility_Address__c,Show_Start_Date__c,Show_End_Date__c 
                                                     FROM GC_Connect2_Show__c WHERE id IN :showmem];
            for(GC_Connect2_Show__c show : shows){
                string str='';
                str = show.Name+'|'+show.Show_Name__c+'|'+show.Facility__c+'|'+show.Show_Start_Date__c+'|'+show.Show_End_Date__c;
                showsToAssociate.put(show.Id,str);
            }            
            ShowWrapper sWrap = new ShowWrapper();
            sWrap.showIdNameMap = showsToAssociate;
            sWrap.isComm = LC_AppUtils.isCommunity();            
            return sWrap;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}