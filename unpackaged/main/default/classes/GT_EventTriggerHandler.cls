/**
    * @Author   :       Namratha
    * @Date     :       8-October-2018
    * @Desc     :       Trigger Handler for  GT_EventTrigger, trigger updates all the activities and product under Event
    when GT_Event cancelled field value is updated.
    * */
    
    public class GT_EventTriggerHandler {
        
        public Static String profileName ;
        
        public static void getConnectSettings() {
            Id profileId = userinfo.getProfileId();
            profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name; 
            //system.debug(profileName);
        }

        Public Static void updateActivities(list<String> eventId){            
            getConnectSettings();            
            list<GT_Event__c> gesEvent = new list<GT_Event__c>();            
            list<GT_Exhibit__c> exhibitList = new list<GT_Exhibit__c>();
            list<GT_Exhibit__c> updateExhibitList = new list<GT_Exhibit__c>();
            
            list<GT_Event_RL__c> eventList = new list<GT_Event_RL__c>();
            list<GT_Event_RL__c> updateEventList = new list<GT_Event_RL__c>();
            
            list<GT_Meeting_Room__c> meetingRoomList = new list<GT_Meeting_Room__c>();
            list<GT_Meeting_Room__c> updateMeetingRoomList = new list<GT_Meeting_Room__c>();
            
            list<GT_Reg_Attend_Only__c> regAttendList = new list<GT_Reg_Attend_Only__c>();
            list<GT_Reg_Attend_Only__c> updateRegAttendList = new list<GT_Reg_Attend_Only__c>();
            
            list<GT_Speaking_Engagement__c> speakingEnggList = new list<GT_Speaking_Engagement__c>();
            list<GT_Speaking_Engagement__c> updateSpeakingEnggList = new list<GT_Speaking_Engagement__c>();
            
            list<GT_Sponsorship__c> sponsorshipList = new list<GT_Sponsorship__c>();
            list<GT_Sponsorship__c> updateSponsorshipList = new list<GT_Sponsorship__c>();
            
            list<GT_Meeting_Planning__c> meetingPlanningList = new list<GT_Meeting_Planning__c>();
            list<GT_Meeting_Planning__c> updatemeetingPlanningList = new list<GT_Meeting_Planning__c>();
            
            list<GT_Sporting_Event__c> sportingEventList = new list<GT_Sporting_Event__c>();
            list<GT_Sporting_Event__c> updateSportingEventList = new list<GT_Sporting_Event__c>();
            
            list<GT_Membership__c> membershipList = new list<GT_Membership__c>();
            list<GT_Membership__c> updateMembershipList = new list<GT_Membership__c>();
            
            list<GT_Brand__c> productList = new list<GT_Brand__c>();
            list<GT_Brand__c> updateProductList = new list<GT_Brand__c>();
            
            gesEvent = [Select ID,name,Event_Cancelled__c,Congress_Cancelled__c,CurrencyIsoCode,Event_Cancellation_Date__c,Congress_Cancellation_Date__c,Reason_for_Cancellation__c from GT_Event__c where ID in :eventId ];
            exhibitList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,CurrencyIsoCode,Reason_for_Cancellation__c from GT_Exhibit__c where GES_Connect_Event__c in :eventId];
            eventList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Event_RL__c where GES_Connect_Event__c in :eventId];
            meetingRoomList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Meeting_Room__c where GES_Connect_Event__c in :eventId];     
            regAttendList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Reg_Attend_Only__c where GES_Connect_Event__c in :eventId];     
            speakingEnggList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Speaking_Engagement__c where GES_Connect_Event__c in :eventId];     
            sponsorshipList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Sponsorship__c where GES_Connect_Event__c in :eventId];     
            meetingPlanningList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Meeting_Planning__c where GES_Connect_Event__c in :eventId];     
            sportingEventList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Sporting_Event__c where GES_Connect_Event__c in :eventId];     
            membershipList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancellation_Date__c,Reason_for_Cancellation__c from GT_Membership__c where GES_Connect_Event__c in :eventId];     
            productList = [Select ID,name,Canceled__c,GES_Connect_Event__c,Cancelled_Date__c,Reason_for_Cancellation__c from GT_Brand__c where GES_Connect_Event__c in :eventId];
            
            for(GT_Event__c gesEventObj : gesEvent){
                
                for(GT_Exhibit__c exhibit : exhibitList){
                    if(exhibit.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(exhibit.Canceled__c == false){
                                    exhibit.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    exhibit.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    exhibit.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    exhibit.CurrencyIsoCode=gesEventObj.CurrencyIsoCode;
                                    updateExhibitList.add(exhibit);
                                }
                            } 
                            else{
                                exhibit.Canceled__c = gesEventObj.Event_Cancelled__c;
                                exhibit.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                exhibit.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                exhibit.CurrencyIsoCode=gesEventObj.CurrencyIsoCode;
                                updateExhibitList.add(exhibit);
                            }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(exhibit.Canceled__c == false){
                                    exhibit.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    exhibit.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    exhibit.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateExhibitList.add(exhibit);
                                }
                            } 
                            else{
                                exhibit.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                exhibit.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                exhibit.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                updateExhibitList.add(exhibit);
                            }
                        }
                    }
                }
                
                for(GT_Event_RL__c event : eventList){
                    if(event.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(event.Canceled__c == false){
                                    event.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    event.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    event.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateEventList.add(event);
                                }
                            }
                                else{
                                    event.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    event.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    event.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateEventList.add(event);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(event.Canceled__c == false){
                                    event.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    event.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    event.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateEventList.add(event);
                                }
                            }
                                else{
                                    event.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    event.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    event.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateEventList.add(event);
                                }
                        }
                    }
                } 
                
                for(GT_Meeting_Room__c meetingRoom : meetingRoomList){
                    if(meetingRoom.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(meetingRoom.Canceled__c == false){
                                    meetingRoom.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    meetingRoom.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    meetingRoom.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingRoomList.add(meetingRoom);
                                }
                            }
                                else{
                                    meetingRoom.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    meetingRoom.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    meetingRoom.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingRoomList.add(meetingRoom);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(meetingRoom.Canceled__c == false){
                                    meetingRoom.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    meetingRoom.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    meetingRoom.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingRoomList.add(meetingRoom);
                                }
                            }
                                else{
                                    meetingRoom.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    meetingRoom.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    meetingRoom.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingRoomList.add(meetingRoom);
                                }
                        }
                    }
                }  
                
                for(GT_Reg_Attend_Only__c regAttend : regAttendList){
                    if(regAttend.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(regAttend.Canceled__c == false){
                                    regAttend.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    regAttend.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    regAttend.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateRegAttendList.add(regAttend);
                                }
                            }
                                else{
                                    regAttend.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    regAttend.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    regAttend.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateRegAttendList.add(regAttend);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(regAttend.Canceled__c == false){
                                    regAttend.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    regAttend.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    regAttend.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateRegAttendList.add(regAttend);
                                }
                            }
                                else{
                                    regAttend.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    regAttend.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    regAttend.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateRegAttendList.add(regAttend);
                                }
                        }
                    }
                }
                
                for(GT_Speaking_Engagement__c speakingEngg : speakingEnggList){
                    if(speakingEngg.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(speakingEngg.Canceled__c == false){
                                    speakingEngg.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    speakingEngg.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    speakingEngg.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSpeakingEnggList.add(speakingEngg);
                                }
                            }
                                else{
                                    speakingEngg.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    speakingEngg.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    speakingEngg.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSpeakingEnggList.add(speakingEngg);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(speakingEngg.Canceled__c == false){
                                    speakingEngg.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    speakingEngg.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    speakingEngg.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSpeakingEnggList.add(speakingEngg);
                                }
                            }
                                else{
                                    speakingEngg.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    speakingEngg.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    speakingEngg.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSpeakingEnggList.add(speakingEngg);
                                }
                        }
                    }
                }
                
                for(GT_Sponsorship__c sponsorship : sponsorshipList){
                    if(sponsorship.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(sponsorship.Canceled__c == false){
                                    sponsorship.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    sponsorship.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    sponsorship.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSponsorshipList.add(sponsorship);
                                }
                            }
                                else{
                                    sponsorship.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    sponsorship.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    sponsorship.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSponsorshipList.add(sponsorship);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true ){
                                if(sponsorship.Canceled__c == false){
                                    sponsorship.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    sponsorship.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    sponsorship.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSponsorshipList.add(sponsorship);
                                }
                            }
                                else{
                                    sponsorship.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    sponsorship.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    sponsorship.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSponsorshipList.add(sponsorship);
                                }
                        }
                    }
                }
                
                for(GT_Meeting_Planning__c meetingPlanning : meetingPlanningList){
                    if(meetingPlanning.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(meetingPlanning.Canceled__c == false){
                                    meetingPlanning.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    meetingPlanning.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    meetingPlanning.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingPlanningList.add(meetingPlanning);
                                }
                            }
                                else{
                                    meetingPlanning.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    meetingPlanning.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    meetingPlanning.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingPlanningList.add(meetingPlanning);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(meetingPlanning.Canceled__c == false){
                                    meetingPlanning.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    meetingPlanning.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    meetingPlanning.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingPlanningList.add(meetingPlanning);
                                }
                            }
                                else{
                                    meetingPlanning.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    meetingPlanning.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    meetingPlanning.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMeetingPlanningList.add(meetingPlanning);
                                }
                        }
                    }
                }
                
                for(GT_Sporting_Event__c sportingEvent : sportingEventList){
                    if(sportingEvent.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(sportingEvent.Canceled__c == false){
                                    sportingEvent.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    sportingEvent.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    sportingEvent.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSportingEventList.add(sportingEvent);
                                }
                            }
                                else{
                                    sportingEvent.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    sportingEvent.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    sportingEvent.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSportingEventList.add(sportingEvent);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(sportingEvent.Canceled__c == false){
                                    sportingEvent.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    sportingEvent.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    sportingEvent.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSportingEventList.add(sportingEvent);
                                }
                            }
                                else{
                                    sportingEvent.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    sportingEvent.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    sportingEvent.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateSportingEventList.add(sportingEvent);
                                }
                        }
                    }
                }
                
                for(GT_Membership__c membership : membershipList){
                    if(membership.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(membership.Canceled__c == false){
                                    membership.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    membership.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    membership.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMembershipList.add(membership);
                                }
                            }
                                else{
                                    membership.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    membership.Cancellation_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    membership.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMembershipList.add(membership);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(membership.Canceled__c == false){
                                    membership.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    membership.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    membership.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMembershipList.add(membership);
                                }
                            }
                                else{
                                    membership.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    membership.Cancellation_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    membership.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateMembershipList.add(membership);
                                }
                        }   
                    }
                }
                
                for(GT_Brand__c product : productList){
                    if(product.GES_Connect_Event__c == gesEventObj.ID){
                        if(profileName == 'GC Crown Castle' || profileName == 'GT Event Client' || profileName == 'GT Event Vendor' || profileName == 'GC Sig Sauer'){
                            if(gesEventObj.Event_Cancelled__c == true){
                                if(product.Canceled__c == false){
                                    product.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    product.Cancelled_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    product.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateProductList.add(product);
                                }
                            }
                                else{
                                    product.Canceled__c = gesEventObj.Event_Cancelled__c;
                                    product.Cancelled_Date__c = Date.valueOf(gesEventObj.Event_Cancellation_Date__c);
                                    product.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateProductList.add(product);
                                }
                        }
                        else if(profileName == 'GC Novo Nordisk' || profileName == 'GC Pharma Template' || profileName == 'GC Merck'){
                            if(gesEventObj.Congress_Cancelled__c == true){
                                if(product.Canceled__c == false){
                                    product.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    product.Cancelled_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    product.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateProductList.add(product);
                                }
                            }
                                else{
                                    product.Canceled__c = gesEventObj.Congress_Cancelled__c;
                                    product.Cancelled_Date__c = Date.valueOf(gesEventObj.Congress_Cancellation_Date__c);
                                    product.Reason_for_Cancellation__c = gesEventObj.Reason_for_Cancellation__c;
                                    updateProductList.add(product);
                                }
                        }
                    }
                }
                
                update updateExhibitList;
                update updateEventList;
                update updateMeetingRoomList;
                update updateRegAttendList;
                update updateSpeakingEnggList;
                update updateSponsorshipList;
                update updateSportingEventList;
                update updateMeetingPlanningList;
                update updateMembershipList;
                update updateProductList;
            }
                
        }
        
        Public Static void deleteRelatedActivities(){
            List<GT_Exhibit__c> exhibitsRelatedToEvent=[select Id,GES_Connect_Event__c from GT_Exhibit__c where GES_Connect_Event__c IN:Trigger.OldMap.keyset()];
             delete exhibitsRelatedToEvent;
            List<GT_Sponsorship__c> sponsorshipRelatedToEvent=[select Id,GES_Connect_Event__c from GT_Sponsorship__c where GES_Connect_Event__c IN:Trigger.OldMap.keyset()];
             delete sponsorshipRelatedToEvent;
             List<GT_Meeting_Room__c> meetingRoomRelatedToEvent=[select Id,GES_Connect_Event__c from GT_Meeting_Room__c where GES_Connect_Event__c IN:Trigger.OldMap.keyset()];
             delete meetingRoomRelatedToEvent;
             List<GT_Speaking_Engagement__c> speakingEngagementRelatedList=[select Id,GES_Connect_Event__c from GT_Speaking_Engagement__c where GES_Connect_Event__c IN:Trigger.OldMap.keyset()];
             delete speakingEngagementRelatedList;
        }
        
        /*
            ** this mthod is used to create wrike folders/projects once a new Event record is created
            * @author  Rahul Sinha
            * @version 1.0
            * @since   09-16-2019
        */
        public static void callWrikeApi(set<Id> createdEvents){
            if(createdEvents.size()<=5){
                GT_WrikeHandler.createTaskInWrike(createdEvents);
            }
        }
    }