trigger BrandTrigger on Brand__c (after update) {
    
    Set<Id> brandIdSet = new set<Id>();
    Set<Id> exhibitIdSet = new set<Id>();
    Set<Id> sponsorshipIdSet = new set<Id>();
    Set<Id> productTheaterIdSet = new set<Id>();
    Set<Id> symposiaIdSet = new set<Id>();
    Set<Id> meetingRoomIdSet = new set<Id>();
    BrandTriggerHandler dummyHandlerObject = new BrandTriggerHandler();
    //dummyHandlerObject.flag= true;
    
    for(Brand__c brand : trigger.new){
        if((Trigger.isInsert && brand.Canceled__c != Trigger.oldMap.get(brand.Id).Canceled__c) || ( Trigger.isUpdate && brand.Canceled__c != Trigger.oldMap.get(brand.Id).Canceled__c)){
            brandIdSet.add(brand.Id);
            if(brand.Exhibit_Instance__c!=null){
                exhibitIdSet.add(brand.Exhibit_Instance__c);
            }
            if(brand.Sponsorship__c!=null){
                sponsorshipIdSet.add(brand.Sponsorship__c);
            }
            if(brand.Product_Theater__c!=null){
                productTheaterIdSet.add(brand.Product_Theater__c);
            }
            if(brand.Symposia__c!=null){
                symposiaIdSet.add(brand.Symposia__c);
            }                      
            if(brand.Meeting_Room__c!=null){
                meetingRoomIdSet.add(brand.Meeting_Room__c);
            }         
            
        }   
    }
    system.debug('exhibitIdSet==='+exhibitIdSet.size());
    system.debug('sponsorshipIdSet==='+sponsorshipIdSet.size());
    system.debug('productTheaterIdSet==='+productTheaterIdSet.size());
    system.debug('symposiaIdSet==='+symposiaIdSet.size());
    system.debug('meetingRoomIdSet==='+meetingRoomIdSet.size());
    
    if(exhibitIdSet.size()>0){  
        dummyHandlerObject.cancelExhibit(exhibitIdSet);
        system.debug('enter cancel exhibit');
    }
    if(sponsorshipIdSet.size()>0){ 
        dummyHandlerObject.cancelSponsorship(sponsorshipIdSet);
        system.debug('enter cancelSponsorship');
    }
    if(productTheaterIdSet.size()>0){  
        dummyHandlerObject.cancelProductTheater(productTheaterIdSet);
        system.debug('enter cancelProductTheater');
    }
    if(symposiaIdSet.size()>0){    
        dummyHandlerObject.cancelSymposia(symposiaIdSet);
        system.debug('enter cancelSymposia');
    }
    if(meetingRoomIdSet.size()>0){ 
        dummyHandlerObject.cancelMeetingRoom(meetingRoomIdSet);
        system.debug('enter cancelMeetingRoom');
    }
    
}