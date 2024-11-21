public class CongressTriggerHandler {
    List<GES_Connect_Corporate_Accounts__c> updatedCongs= new  List<GES_Connect_Corporate_Accounts__c>();
    List<Brand__c> toBeUpdatedBrands= new  List<Brand__c>();
    List<SObject> toBeUpdatedActivities = new  List<SObject>();
    //Map<Id,Brand__c> toBeUpdatedBrands = new Map<Id,Brand__c>();
    
    Public void updateActivitiesAndBrands(List<String> updatedIDs){
        updatedCongs= [Select Id, CurrencyIsoCode, (Select Id, CurrencyIsoCode from Activity_Type_Exhibit_Instance__r),(Select Id, CurrencyIsoCode from Sponsorship_Instance__r),(Select Id, CurrencyIsoCode from Product_Theater__r),(Select Id, CurrencyIsoCode from Symposia__r),(Select Id, CurrencyIsoCode from Meeting_Room__r),(Select Id, CurrencyIsoCode from Brand__r) from GES_Connect_Corporate_Accounts__c where id in:updatedIDs];
        
        //toBeUpdatedBrands= [Select Id, CurrencyIsoCode from Brand__c where GES_Connect_Corporate_Accounts__c in :updatedIDs];
        for(GES_Connect_Corporate_Accounts__c varCong:updatedCongs) {
            if(varCong.Activity_Type_Exhibit_Instance__r.size()>0){
                for(Exhibit__c exhibit:varCong.Activity_Type_Exhibit_Instance__r ){
                    exhibit.CurrencyIsoCode=varCong.CurrencyIsoCode;
                    toBeUpdatedActivities.add(exhibit);
                }
            }
            if(varCong.Sponsorship_Instance__r.size()>0){
                for(Sponsorship__c sponsorship:varCong.Sponsorship_Instance__r ){
                    sponsorship.CurrencyIsoCode=varCong.CurrencyIsoCode;
                    toBeUpdatedActivities.add(sponsorship);
                }
            }
            if(varCong.Product_Theater__r.size()>0){
                for(Product_Theater__c productTheater:varCong.Product_Theater__r ){
                    productTheater.CurrencyIsoCode=varCong.CurrencyIsoCode;
                    toBeUpdatedActivities.add(productTheater);
                }
            }
            if(varCong.Symposia__r.size()>0){
                for(Symposia__c symposia:varCong.Symposia__r ){
                    symposia.CurrencyIsoCode=varCong.CurrencyIsoCode;
                    toBeUpdatedActivities.add(symposia);
                }
            }
            if(varCong.Meeting_Room__r.size()>0){
                for(Meeting_Room__c meetingRoom:varCong.Meeting_Room__r ){
                    meetingRoom.CurrencyIsoCode=varCong.CurrencyIsoCode;
                    toBeUpdatedActivities.add(meetingRoom);
                }
            }
            /*if(varCong.Brand__r.size()>0){
                for(Brand__c brand:varCong.Brand__r ){
                    brand.CurrencyIsoCode=varCong.CurrencyIsoCode;
                    toBeUpdatedBrands.add(brand);
                }
            }*/
            
        }
        update toBeUpdatedActivities;
        //update toBeUpdatedBrands; 
    }       
    Public void updateCancelledFieldsActivitiesAndProducts(List<String> updatedCancelledFieldIDs){
        
        list<GES_Connect_Corporate_Accounts__c> gesCorporateAccounts = new list<GES_Connect_Corporate_Accounts__c>();
        
        list<Exhibit__c> exhibitList = new list<Exhibit__c>();
        list<Exhibit__c> updateExhibitList = new list<Exhibit__c>();
        
        list<Meeting_Room__c> meetingRoomList = new list<Meeting_Room__c>();
        list<Meeting_Room__c> updateMeetingRoomList = new list<Meeting_Room__c>();
        
        list<Symposia__c> symposiaList = new list<Symposia__c>();
        list<Symposia__c> updatesymposiaList = new list<Symposia__c>();
        
        list<Product_Theater__c> productTheaterList = new list<Product_Theater__c>();
        list<Product_Theater__c> updateProductTheaterList = new list<Product_Theater__c>();
        
        list<Sponsorship__c> sponsorshipList = new list<Sponsorship__c>();
        list<Sponsorship__c> updateSponsorshipList = new list<Sponsorship__c>();
        
        list<Brand__c> brandList = new list<Brand__c>();
        list<Brand__c> updateBrandList = new list<Brand__c>();
        
        gesCorporateAccounts = [Select ID,name,Congress_Cancelled__c,Congress_Cancellation_Date__c,Reason_for_Cancellation__c from GES_Connect_Corporate_Accounts__c where ID in :updatedCancelledFieldIDs ];
        exhibitList = [Select ID,name,Canceled__c,Activity_Type_Exhibit_Instance_c__c	,CanceledDate__c,CancelReason__c from Exhibit__c where Activity_Type_Exhibit_Instance_c__c	 in :updatedCancelledFieldIDs];
        meetingRoomList = [Select ID,name,Canceled__c,Congress__c,CanceledDate__c,Cancel_Reason__c from Meeting_Room__c where Congress__c in :updatedCancelledFieldIDs];
        symposiaList = [Select ID,name,Canceled__c,Congress__c,CanceledDate__c,CancelReason__c from Symposia__c where Congress__c in :updatedCancelledFieldIDs];     
        productTheaterList = [Select ID,name,Canceled__c,Congress__c,Canceled_Date__c,Cancel_Reason__c from Product_Theater__c	 where Congress__c in :updatedCancelledFieldIDs];     
        sponsorshipList = [Select ID,name,Canceled__c,Sponsorship__c,CanceledDate__c,CancelReason__c from Sponsorship__c where Sponsorship__c in :updatedCancelledFieldIDs];     
        brandList = [Select ID,name,Canceled__c,GES_Connect_Corporate_Accounts__c,Cancelled_Date__c,Reason_for_Cancellation__c from Brand__c where GES_Connect_Corporate_Accounts__c in :updatedCancelledFieldIDs];
        
        for(GES_Connect_Corporate_Accounts__c gesCorpAccObj : gesCorporateAccounts){
            for(Exhibit__c exhibit : exhibitList){
                if(exhibit.Activity_Type_Exhibit_Instance_c__c == gesCorpAccObj.ID){
                    if(gesCorpAccObj.Congress_Cancelled__c == true){
                        if(exhibit.Canceled__c == false){
                            exhibit.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        exhibit.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        exhibit.CancelReason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateExhibitList.add(exhibit);
                        }
                    }
                    else{
                        exhibit.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        exhibit.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        exhibit.CancelReason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateExhibitList.add(exhibit);
                    }
                }
            }
            
            system.debug('updateExhibitList<<<<<<<<<<<<<<<<<<<<' + updateExhibitList);
            
            for(Meeting_Room__c meetingRoom : meetingRoomList){
                if(meetingRoom.Congress__c == gesCorpAccObj.ID){
                    if(gesCorpAccObj.Congress_Cancelled__c == true){
                        if(meetingRoom.Canceled__c == false){
                            meetingRoom.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                            meetingRoom.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                            meetingRoom.Cancel_Reason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                            updateMeetingRoomList.add(meetingRoom);
                        }
                    }
                    else{
                        meetingRoom.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        meetingRoom.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        meetingRoom.Cancel_Reason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateMeetingRoomList.add(meetingRoom);
                    }
                }
            } 
            
            for(Symposia__c symposia : symposiaList){
                if(symposia.Congress__c == gesCorpAccObj.ID){
                    if(gesCorpAccObj.Congress_Cancelled__c == true){
                        if(symposia.Canceled__c == false){
                            symposia.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                            symposia.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                            symposia.CancelReason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                            updateSymposiaList.add(symposia);
                        }
                    }
                    else{
                        symposia.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        symposia.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        symposia.CancelReason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateSymposiaList.add(symposia);
                    }
                }
            }
            
            for(Product_Theater__c productTheater : productTheaterList){
                if(productTheater.Congress__c == gesCorpAccObj.ID){
                    if(gesCorpAccObj.Congress_Cancelled__c == true){
                        if(productTheater.Canceled__c == false){
                            productTheater.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                            productTheater.Canceled_Date__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                            productTheater.Cancel_Reason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                            updateProductTheaterList.add(productTheater);
                        }
                    }
                    else{
                        productTheater.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        productTheater.Canceled_Date__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        productTheater.Cancel_Reason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateProductTheaterList.add(productTheater);
                    }
                }
            }
            
            for(Sponsorship__c sponsorship : sponsorshipList){
                if(sponsorship.Sponsorship__c == gesCorpAccObj.ID){
                    if(gesCorpAccObj.Congress_Cancelled__c == true){
                        if(sponsorship.Canceled__c == false){
                            sponsorship.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                            sponsorship.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                            sponsorship.CancelReason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                            updateSponsorshipList.add(sponsorship);
                        }
                    }
                    else{
                        sponsorship.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        sponsorship.CanceledDate__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        sponsorship.CancelReason__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateSponsorshipList.add(sponsorship);
                    }
                }
            }
            
            for(Brand__c brand : brandList){
                if(brand.GES_Connect_Corporate_Accounts__c == gesCorpAccObj.ID){
                    if(gesCorpAccObj.Congress_Cancelled__c == true){
                        if(brand.Canceled__c == false){
                            brand.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        brand.Cancelled_Date__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        brand.Reason_for_Cancellation__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateBrandList.add(brand);
                        }
                    }
                    else{
                        brand.Canceled__c = gesCorpAccObj.Congress_Cancelled__c;
                        brand.Cancelled_Date__c = Date.valueOf(gesCorpAccObj.Congress_Cancellation_Date__c);
                        brand.Reason_for_Cancellation__c = gesCorpAccObj.Reason_for_Cancellation__c;
                        updateBrandList.add(brand);
                    }
                }
            }
        }
        
        update updateBrandList;
        update updateExhibitList;
        update updateMeetingRoomList;
        update updateSymposiaList;
        update updateProductTheaterList;
        update updateSponsorshipList;
    }
}