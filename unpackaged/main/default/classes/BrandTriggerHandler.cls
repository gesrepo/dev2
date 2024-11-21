public class BrandTriggerHandler {
    Boolean allBrandsCancelled= false;
    
    Public void cancelExhibit(Set<Id> activityIdSet){   
        Boolean allBrandsCancelled = false;
        List<Brand__c> brandList = new List<Brand__c>();
        List<Exhibit__c> activityList = [SELECT Id,Canceled__c, CanceledDate__c, (select id,Name,Canceled__c from Brand_Instance__r) FROM Exhibit__c WHERE ID IN :activityIdSet];
        for(Exhibit__c parent: activityList){
            brandList = parent.Brand_Instance__r;
            Integer count=0;
            for(Brand__c br:brandList){
                if(br.Canceled__c==true)
                {
                    count+=1;
                }           
            }
            //system.debug('count==='+count);
            if(count==brandList.size()){
                parent.Canceled__c=true;
                parent.CanceledDate__c = date.Today();
            }else{
                parent.Canceled__c=false;
                parent.CanceledDate__c = null;
            }
        }
        update activityList;
        system.debug('Exhibit List updated');
    }
    
    Public void cancelSponsorship(Set<Id> sponsorshipIdSet){  
        system.debug('inside cancelSponsorship ');
        Boolean allBrandsCancelled = false;
        List<Brand__c> brandList = new List<Brand__c>();
        List<Sponsorship__c> activityList = [SELECT Id,Canceled__c, CanceledDate__c,(select id,Name,Canceled__c from Brand__r) FROM Sponsorship__c WHERE ID IN :sponsorshipIdSet];
        for(Sponsorship__c parent: activityList){
            brandList = parent.Brand__r;
            Integer count=0;
            for(Brand__c br:brandList){
                if(br.Canceled__c==true)
                {
                    count+=1;
                }           
            }
           // system.debug('count==='+count);
            if(count==brandList.size()){
                parent.Canceled__c=true;
                parent.CanceledDate__c = date.Today();
            }else{
                parent.Canceled__c=false;
                parent.CanceledDate__c = null;
            }
        }
        update activityList;
        system.debug('sponsorship List updated');
    }
    
    Public void cancelProductTheater(Set<Id> productTheaterIdSet){  
        Boolean allBrandsCancelled = false;
        List<Brand__c> brandList = new List<Brand__c>();
        List<Product_Theater__c> activityList = [SELECT Id,Canceled__c, Canceled_Date__c,(select id,Name,Canceled__c from Brand__r) FROM Product_Theater__c WHERE ID IN :productTheaterIdSet];
        for(Product_Theater__c parent: activityList){
            brandList = parent.Brand__r;
            Integer count=0;
            for(Brand__c br:brandList){
                if(br.Canceled__c==true)
                {
                    count+=1;
                }           
            }
            system.debug('count==='+count);
            if(count==brandList.size()){
                parent.Canceled__c=true;
                parent.Canceled_Date__c= date.Today();
            }else{
                parent.Canceled__c=false;
                parent.Canceled_Date__c = null;
            }
        }
        update activityList;
    }
    
    Public void cancelSymposia(Set<Id> symposiaIdSet){  
        Boolean allBrandsCancelled = false;
        List<Brand__c> brandList = new List<Brand__c>();
        List<Symposia__c> activityList = [SELECT Id,Canceled__c,CanceledDate__c, (select id,Name,Canceled__c from Brand__r) FROM Symposia__c WHERE ID IN :symposiaIdSet];
        for(Symposia__c parent: activityList){
            brandList = parent.Brand__r;
            Integer count=0;
            for(Brand__c br:brandList){
                if(br.Canceled__c==true)
                {
                    count+=1;
                }           
            }
           // system.debug('count==='+count);
            if(count==brandList.size()){
                parent.Canceled__c=true;
                parent.CanceledDate__c = date.Today();
            }else{
                parent.Canceled__c=false;
                parent.CanceledDate__c = null;
            }
        }
        update activityList;
        system.debug('symposia list updated');
    }
    
    Public void cancelMeetingRoom(Set<Id> meetingRoomIdSet){    
        Boolean allBrandsCancelled = false;
        List<Brand__c> brandList = new List<Brand__c>();
        List<Meeting_Room__c> activityList = [SELECT Id,Canceled__c,CanceledDate__c, (select id,Name,Canceled__c from Brand__r) FROM Meeting_Room__c WHERE ID IN :meetingRoomIdSet];
        for(Meeting_Room__c parent: activityList){
            brandList = parent.Brand__r;
            Integer count=0;
            for(Brand__c br:brandList){
                if(br.Canceled__c==true)
                {
                    count+=1;
                }           
            }
           // system.debug('count==='+count);
            if(count==brandList.size()){
                parent.Canceled__c=true;
                parent.CanceledDate__c = date.Today();
            }else{
                parent.Canceled__c=false;
                parent.CanceledDate__c = null;
            }
        }
        update activityList;
        system.debug('meeting room list updated');
    }
}