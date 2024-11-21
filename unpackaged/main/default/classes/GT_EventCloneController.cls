public without sharing class GT_EventCloneController{
    
    @AuraEnabled
    Public Static String getRecordTypeId(String congressRecordId){
        GT_Event__c GESConnectEvent = [SELECT ID, RecordTypeId FROM GT_Event__c WHERE Id =: congressRecordId];
        return String.valueOf(GESConnectEvent.RecordTypeId);
    }
    
    @AuraEnabled
    public static string cloneEventWithChildren(string eventIdStr){
        try{
            set<string> eventIds= new set<string>();
            eventIds.addAll(eventIdStr.split(','));
            Map<id,GT_Event__c> map_EventOriClo = new Map<id,GT_Event__c>();
            List<GT_Event__c> clonedEvents= new List<GT_Event__c>();
            List<GT_Event__c> originalEvents= new List<GT_Event__c>();
            
            //clone events
            string eventQuery='SELECT ';
            eventQuery+=fieldStringGenerator(GT_Event__c.sObjectType.getDescribe());
            eventQuery+=' FROM GT_Event__c WHERE id IN :eventIds';
            for(GT_Event__c singleEvent: Database.query(eventQuery)){
                GT_Event__c clonedEvent=singleEvent.clone(false, true);
                clonedEvent.External_Id__c=singleEvent.name+singleEvent.id;
                //clonedEvent.Event_Start_Date__c=Date.newInstance(2020, 1, 1);  //Amarab 03/22/2021 SCA-877
                //clonedEvent.Event_End_Date__c=Date.newInstance(2020, 1, 1);  //Amarab 03/22/2021 SCA-877
                //clonedEvent.Congress_Start_Date__c=Date.newInstance(2020, 1, 1);  //Amarab 03/22/2021 SCA-877
                //clonedEvent.Congress_End_Date__c=Date.newInstance(2020, 1, 1);  //Amarab 03/22/2021 SCA-877
                clonedEvent.Event_Start_Date__c=Date.newInstance(system.today().year(), 1, 1);
                clonedEvent.Event_End_Date__c=Date.newInstance(system.today().year(), 1, 1);
                clonedEvent.Congress_Start_Date__c=Date.newInstance(system.today().year(), 1, 1);
                clonedEvent.Congress_End_Date__c=Date.newInstance(system.today().year(), 1, 1);
                clonedEvent.EventCloned__c = false;
                clonedEvent.Event_Cloned_Date__c = null;
                clonedEvent.Attendees_Registered__c = null; //SAL-1306 - removed field from cloning process  12/04/23 - Sajid
                clonedEvent.No_Attendees__c = null; //SAL-1306 - removed field from cloning process  12/04/23 - Sajid
                clonedEvents.add(clonedEvent);
                map_EventOriClo.put(singleEvent.id,clonedEvent);

                singleEvent.EventCloned__c = true;
                singleEvent.Event_Cloned_Date__c = Datetime.now();
                originalEvents.add(singleEvent);
            }
            insert clonedEvents;
            update originalEvents;
            
            // clone exhibits
            List<GT_Exhibit__c> clonedExhibits= new List<GT_Exhibit__c>();
            Map<id,GT_Exhibit__c> exMap= new Map<id,GT_Exhibit__c>();
            Map<id,List<Gt_Brand__c>> brandMap= new Map<id,List<Gt_Brand__c>>();
            
            String productQuery= '( SELECT ';
            productQuery+=fieldStringGenerator(GT_Brand__c.sObjectType.getDescribe());      
            string exhibitQuery='SELECT '+fieldStringGenerator(GT_Exhibit__c.sObjectType.getDescribe())+',';
            exhibitQuery+=productQuery;
            //exhibitQuery+=' FROM Brands__r  ) '; //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            //exhibitQuery+= ' FROM GT_Exhibit__c WHERE GES_Connect_Event__c IN :eventIds';
            exhibitQuery+=' FROM Brands__r WHERE Canceled__c = FALSE ) ';
            exhibitQuery+= ' FROM GT_Exhibit__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            
            for(GT_Exhibit__c singleEx : Database.query(exhibitQuery)){
                GT_Exhibit__c clonedEx = singleEx.clone(false, true);
                clonedEx.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                clonedEx.External_Id__c=singleEx.Name+singleEx.id;
                clonedEx.GES_Connect_Event__c=map_EventOriClo.get(singleEx.GES_Connect_Event__c).id;
                clonedEx.Activity_Level__c=null;
                exMap.put(singleEx.id,clonedEx);
                clonedExhibits.add(clonedEx);
                for(GT_Brand__c singleBr:singleEx.Brands__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleEx.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleEx.id)){
                        brandMap.put(singleEx.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleEx.id).add(clonedBr);
                }
                
            }
            insert clonedExhibits;
            
            // clone GT_Sponsorship__c records 
                       
            List<GT_Sponsorship__c> clonedSpons= new List<GT_Sponsorship__c>();
            Map<string,GT_Sponsorship__c> sponMap= new Map<string,GT_Sponsorship__c>();
            string sponQuery='SELECT '+fieldStringGenerator(GT_Sponsorship__c.sObjectType.getDescribe())+',';
            sponQuery+=productQuery;
            //sponQuery+=' FROM Brands__r  ) ';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            //sponQuery+= ' FROM GT_Sponsorship__c WHERE GES_Connect_Event__c IN :eventIds';
            sponQuery+=' FROM Brands__r WHERE Canceled__c = FALSE   ) ';  
            sponQuery+= ' FROM GT_Sponsorship__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            
            for(GT_Sponsorship__c singleSp : Database.query(sponQuery)){
                GT_Sponsorship__c clonedSp = singleSp.clone(false, true);
                clonedSp.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                clonedSp.External_Id__c=singleSp.Name+singleSp.id;
                clonedSp.GES_Connect_Event__c=map_EventOriClo.get(singleSp.GES_Connect_Event__c).id;
                clonedSp.Activity_Level__c=null;
                clonedSpons.add(clonedSp);
                sponMap.put(singleSp.id,clonedSp);
                for(GT_Brand__c singleBr:singleSp.Brands__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleSp.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleSp.id)){
                        brandMap.put(singleSp.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleSp.id).add(clonedBr);
                }           
            }
            insert clonedSpons;
            
            // clone GT_Speaking_Engagement__c records
            
            List<GT_Speaking_Engagement__c> clonedSpeaks= new List<GT_Speaking_Engagement__c>();
            Map<string,GT_Speaking_Engagement__c> speakMap= new Map<string,GT_Speaking_Engagement__c>();
            string speakQuery='SELECT '+fieldStringGenerator(GT_Speaking_Engagement__c.sObjectType.getDescribe())+',';
            speakQuery+=productQuery;
            //speakQuery+=' FROM Brands__r  ) ';
            //speakQuery+= ' FROM GT_Speaking_Engagement__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            speakQuery+=' FROM Brands__r WHERE Canceled__c = FALSE ) ';
            speakQuery+= ' FROM GT_Speaking_Engagement__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            
            for(GT_Speaking_Engagement__c singleSpeak : Database.query(speakQuery)){
                GT_Speaking_Engagement__c clonedSpeak = singleSpeak.clone(false, true);
                clonedSpeak.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                clonedSpeak.External_Id__c=singleSpeak.Name+singleSpeak.id;
                clonedSpeak.GES_Connect_Event__c=map_EventOriClo.get(singleSpeak.GES_Connect_Event__c).id;
                clonedSpeak.Activity_Level__c=null;
                speakMap.put(singleSpeak.id,clonedSpeak);
                clonedSpeaks.add(clonedSpeak);
                for(GT_Brand__c singleBr:singleSpeak.Brands__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleSpeak.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleSpeak.id)){
                        brandMap.put(singleSpeak.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleSpeak.id).add(clonedBr);
                }           
            }
            insert clonedSpeaks;
            
            //clone GT_Meeting_Room__c records
            List<GT_Meeting_Room__c> clonedMrs= new List<GT_Meeting_Room__c>();
            List<GT_Event_RL__c> clonedEvs= new List<GT_Event_RL__c>();
            List<GT_Reg_Attend_Only__c> clonedRegs= new List<GT_Reg_Attend_Only__c>();
            List<GT_Sporting_Event__c> clonedSports= new List<GT_Sporting_Event__c>();
            List<GT_Membership__c> clonedMembers= new List<GT_Membership__c>();
            Map<string,GT_Meeting_Room__c> meetMap= new Map<string,GT_Meeting_Room__c>();
            Map<string,GT_Event_RL__c> evtMap= new Map<string,GT_Event_RL__c>();
            Map<string,GT_Reg_Attend_Only__c> regMap= new Map<string,GT_Reg_Attend_Only__c>();
            Map<string,GT_Sporting_Event__c> sportMap= new Map<string,GT_Sporting_Event__c>();
            Map<string,GT_Membership__c> memMap= new Map<string,GT_Membership__c>();
            
            string meetQuery='SELECT '+fieldStringGenerator(GT_Meeting_Room__c.sObjectType.getDescribe())+',';
            meetQuery+=productQuery;
            //meetQuery+=' FROM Brands__r  ) ';
            //meetQuery+= ' FROM GT_Meeting_Room__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            meetQuery+=' FROM Brands__r WHERE Canceled__c = FALSE ) ';
            meetQuery+= ' FROM GT_Meeting_Room__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            
            for(GT_Meeting_Room__c singleMr : Database.query(meetQuery)){
                GT_Meeting_Room__c clonedMr = singleMr.clone(false, true);
                clonedMr.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                clonedMr.External_Id__c=singleMr.Name+singleMr.id;
                clonedMr.GES_Connect_Event__c=map_EventOriClo.get(singleMr.GES_Connect_Event__c).id;
                clonedMr.Activity_Level__c=null;
                meetMap.put(singleMr.id,clonedMr);
                clonedMrs.add(clonedMr);
                for(GT_Brand__c singleBr:singleMr.Brands__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleMr.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleMr.id)){
                        brandMap.put(singleMr.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleMr.id).add(clonedBr);
                }
            }
            insert clonedMrs;
            
            //clone GT_Event_RL__c records
            string evtQuery='SELECT '+fieldStringGenerator(GT_Event_RL__c.sObjectType.getDescribe())+',';
            evtQuery+=productQuery;
            //evtQuery+=' FROM Brands__r  ) ';
            //evtQuery+= ' FROM GT_Event_RL__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            evtQuery+=' FROM Brands__r WHERE Canceled__c = FALSE ) ';
            evtQuery+= ' FROM GT_Event_RL__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            for(GT_Event_RL__c singleEv : Database.query(evtQuery)){
                GT_Event_RL__c clonedEv = singleEv.clone(false, true);
                clonedEv.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                clonedEv.External_Id__c=singleEv.Name+singleEv.id;
                clonedEv.GES_Connect_Event__c=map_EventOriClo.get(singleEv.GES_Connect_Event__c).id;
                clonedEv.Activity_Level__c=null;
                evtMap.put(singleEv.id,clonedEv);
                clonedEvs.add(clonedEv);
                for(GT_Brand__c singleBr:singleEv.Brands__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleEv.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleEv.id)){
                        brandMap.put(singleEv.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleEv.id).add(clonedBr);
                }
            }
            insert clonedEvs;
            
            // SAL-1306 - GT_Reg_Attend_Only__c clone process no longer needed - 12/04/23 - Sajid
            /*
             //clone GT_Reg_Attend_Only__c records
            
            string regQuery='SELECT '+fieldStringGenerator(GT_Reg_Attend_Only__c.sObjectType.getDescribe())+',';
            regQuery+=productQuery;
            //regQuery+=' FROM Brands__r  ) ';
            //regQuery+= ' FROM GT_Reg_Attend_Only__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            regQuery+=' FROM Brands__r WHERE Canceled__c = FALSE ) ';
            regQuery+= ' FROM GT_Reg_Attend_Only__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            for(GT_Reg_Attend_Only__c singleReg : Database.query(regQuery)){
                GT_Reg_Attend_Only__c clonedReg = singleReg.clone(false, true);
                clonedReg.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                clonedReg.External_Id__c=singleReg.Name+singleReg.id;
                clonedReg.GES_Connect_Event__c=map_EventOriClo.get(singleReg.GES_Connect_Event__c).id;
                clonedReg.Activity_Level__c=null;
                regMap.put(singleReg.id,clonedReg);
                clonedRegs.add(clonedReg);
                for(GT_Brand__c singleBr:singleReg.Brands__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleReg.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleReg.id)){
                        brandMap.put(singleReg.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleReg.id).add(clonedBr);
                }
            }
            insert clonedRegs;
            */ 
            //end-SAL-1306
            
            //clone GT_Sporting_Event__c records
            string sportQuery='SELECT '+fieldStringGenerator(GT_Sporting_Event__c.sObjectType.getDescribe())+',';
            sportQuery+=productQuery;
            //sportQuery+=' FROM Products__r ) ';
            //sportQuery+= ' FROM GT_Sporting_Event__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            sportQuery+=' FROM Products__r WHERE Canceled__c = FALSE) ';
            sportQuery+= ' FROM GT_Sporting_Event__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            for(GT_Sporting_Event__c singleSport: Database.query(sportQuery)){
                GT_Sporting_Event__c clonedSport= singleSport.clone(false, true);
                clonedSport.External_Id__c=singleSport.Name+singleSport.id;
                clonedSport.GES_Connect_Event__c=map_EventOriClo.get(singleSport.GES_Connect_Event__c).id;
                sportMap.put(singleSport.id,clonedSport);
                clonedSports.add(clonedSport);
                for(GT_Brand__c singleBr:singleSport.Products__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);          
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleSport.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleSport.id)){
                        brandMap.put(singleSport.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleSport.id).add(clonedBr);
                }
            }
            insert clonedSports;
            
            //clone GT_Membership__c records
            string memQuery='SELECT '+fieldStringGenerator(GT_Membership__c.sObjectType.getDescribe())+',';
            memQuery+=productQuery;
            //memQuery+=' FROM Products__r ) ';
            //memQuery+= ' FROM GT_Membership__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            memQuery+=' FROM Products__r WHERE Canceled__c = FALSE) ';
            memQuery+= ' FROM GT_Membership__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            for(GT_Membership__c singleMember: Database.query(memQuery)){
                GT_Membership__c clonedMember= singleMember.clone(false, true);
                clonedMember.External_Id__c=singleMember.Name+singleMember.id;
                clonedMember.GES_Connect_Event__c=map_EventOriClo.get(singleMember.GES_Connect_Event__c).id;
                memMap.put(singleMember.id,clonedMember);
                clonedMembers.add(clonedMember);
                for(GT_Brand__c singleBr:singleMember.Products__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleMember.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleMember.id)){
                        brandMap.put(singleMember.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleMember.id).add(clonedBr);
                }
            }
            insert clonedMembers;
            
            // clone Meeting_Planning
            List<GT_Meeting_Planning__c> clonedMeetingPlanning= new List<GT_Meeting_Planning__c>();
            Map<id,GT_Meeting_Planning__c> meetPlanMap= new Map<id,GT_Meeting_Planning__c>();  
                 
            string meetingPlanningQuery='SELECT '+fieldStringGenerator(GT_Meeting_Planning__c.sObjectType.getDescribe())+',';
            meetingPlanningQuery+=productQuery;
            //meetingPlanningQuery+=' FROM Products__r  ) ';
            //meetingPlanningQuery+= ' FROM GT_Meeting_Planning__c WHERE GES_Connect_Event__c IN :eventIds';  //Amarab 04-21-2021 SCA-876 Do not clone Cancelled Activities and Products
            meetingPlanningQuery+=' FROM Products__r WHERE Canceled__c = FALSE ) ';
            meetingPlanningQuery+= ' FROM GT_Meeting_Planning__c WHERE Canceled__c = FALSE AND GES_Connect_Event__c IN :eventIds';
            
            for(GT_Meeting_Planning__c singleMP : Database.query(meetingPlanningQuery)){
                GT_Meeting_Planning__c clonedMP = singleMP.clone(false, true);
                clonedMP.Cloned__c = true;  //Amarab 04-21-2021 SCA-876 cloning bug duplicate products
                //clonedMP.External_Id__c=singleMP.Name+singleMP.id;
                clonedMP.GES_Connect_Event__c=map_EventOriClo.get(singleMP.GES_Connect_Event__c).id;
                //clonedMP.Activity_Level__c=null;
                meetPlanMap.put(singleMP.id,clonedMP);
                clonedMeetingPlanning.add(clonedMP);
                for(GT_Brand__c singleBr:singleMP.Products__r){
                    GT_Brand__c clonedBr= singleBr.clone(false, true);
                    clonedBr.GES_Connect_Event__c=map_EventOriClo.get(singleMP.GES_Connect_Event__c).id;
                    clonedBr.External_Id__c= singleBr.name+singleBr.id;
                    if(!brandMap.containsKey(singleMP.id)){
                        brandMap.put(singleMP.id,new List<GT_Brand__c>());
                    }
                    brandMap.get(singleMP.id).add(clonedBr);
                }
                
            }
            insert clonedMeetingPlanning;
                       
            List<GT_Brand__c> clonedBrands = new List<GT_Brand__c>();
            for(id parentId:brandMap.keySet()){
                if(exMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Exhibit__c= exMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(sponMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Sponsorship__c= sponMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(speakMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Speaking_Engagement__c= speakMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(meetMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Meeting_Room__c= meetMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(evtMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Event__c= evtMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(regMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Registration_Attend_Only__c= regMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(sportMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Sporting_Event__c= sportMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(memMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Membership__c= memMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
                if(meetPlanMap.containsKey(parentId)){
                    for(GT_Brand__c singleBrand:brandMap.get(parentId)){
                        singleBrand.Meeting_Planning__c= meetPlanMap.get(parentId).id;
                        clonedBrands.add(singleBrand);
                    }
                }
            }
            insert clonedBrands;          
            for(GT_Event__c x: clonedEvents){
                system.debug('clonedEvent===='+x.RecordTypeId);
                system.debug('clonedEvent===='+x.id);
            }
            string resultMsg='';
            if(System.Label.GT_PharmaRecordTypeIds.containsIgnoreCase(clonedEvents[0].RecordTypeId)){
                resultMsg='Success! This congress has been cloned. All congress details including activities and brands are now available in the cloned congress.';
            }else{              
                resultMsg='Success! This event has been cloned. All event details including activities and products/brands are now available in the cloned event.';
            }
            return clonedEvents[0].id+','+resultMsg;
        }catch(exception e){
            system.debug('error==='+e.getMessage()+'@@@@'+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    public static string fieldStringGenerator(Schema.DescribeSObjectResult r){
        string resultingQuery='';
        for(string apiName : r.fields.getMap().keySet()){
            resultingQuery+=apiName+',';
        }
        return (resultingQuery.removeEnd(','));
    }
}