public class GT_Consolidated_Event {
    @AuraEnabled  public static list<reportWrapper> fetchReports(String fromDt, String toDate,String leadSale, String selectedSocialMediaPromotion, String selectedEventTiedToCampaign)
    {
        System.debug('leadSale>>>'+leadSale);    
        Double sponActualTotal=0;
        Double sponEstimatedTotal=0;
        Date eFromDate=String.isBlank(fromDt)? null: date.valueOf(fromDt);
        Date eToDate= String.isBlank(toDate)? null: date.valueOf(toDate);
        String qryString='select Id,Shipping_City__c,Shipping_State_Province__c,Name_of_Event__c,Event_Start_Date__c,Event_End_Date__c,Event_Cancelled__c,GES_Supported_Event__c, Social_Media_Promo__c, Tied_to_Campaign__c,  ';
        qryString+='(select Project_Manager__c from Meeting_Rooms__r WHERE Canceled__c=false),(select Project_Manager_CrownCastle__c from Events__r WHERE Canceled__c=false), ';
        qryString+='(select Project_Manager_CrownCastle__c from Registration_Attend_Only__r WHERE Canceled__c=false),(select CC_Project_Manager__c from Sporting_Events__r WHERE Canceled__c=false),';
        qryString+='(select CC_Project_Manager__c from Memberships__r WHERE Canceled__c=false),(select Project_Manager_CrownCastle__c,Contacts_Made__c from Exhibits__r WHERE Canceled__c=false), ';
        qryString+='(select Project_Manager_CrownCastle__c from Symposia__r WHERE Canceled__c=false),(select id,Canceled__c,Project_Manager_CrownCastle__c from Sponsorships__r where Canceled__c=false), ';
        qryString+='(select id ,Sponsorship__c,Exhibit__c,Speaking_Engagement__c,Meeting_Room__c, Name,Brand_Name__c,Sponsorship_Cost_Actual_CrownCastle__c,Sponsorship_Cost_Estimated_CrownCastle__c,Booth_Space_Cost_Actual__c,Booth_Space_Cost_Estimated__c, ';
        qryString+='GES_Costs_Actual__c,GES_Costs_Estimated__c,Event_Costs_Actual_CrownCastle__c,Speaker_Cost_Estimated_CrownCastle__c,Speaker_Cost_Actual_CrownCastle__c , ';
        qryString+='Meeting_Room_Services_Cost_Actual_CC__c,Meeting_Room_Services_Cost_Estimated_CC__c,Meeting_Room_Cost_Actual_CrownCastle__c, ';
        qryString+=' Meeting_Room_Cost_Estimated_CrownCastle__c,F_B_Costs_Actual__c,F_B_Costs_Estimated__c,Sporting_Event_Costs_Actual__c,Sporting_Event_Costs_Estimated__c,';
        qryString+='Membership_Costs_Actual__c,Membership_Costs_Estimated__c,Event_Cost_Estimated_CrownCastle__c,Reg_Attend_Cost_Actual_CrownCastle__c, ';
        qryString+=' Reg_Attend_Cost_Estimated_CrownCastle__c,Event__c,Registration_Attend_Only__c,Sporting_Event__c,Membership__c, Sales_Leaders__c, Cost_Center__c, Sales_Leader_2__c, Amount_1__c,Amount_2__c,Amount_3__c,Amount_4__c,Amount_5__c,Amount_6__c,Amount_7__c    from Brands__r WHERE Canceled__c=false) from  GT_Event__c  where id!=null   ';  
       if(String.isNotEmpty(leadSale))
           qryString+=' and  id in(select GES_Connect_Event__c from GT_Brand__C where Sales_Leaders__c=:leadSale) ';
        
        if(eFromDate != null) {
            qryString+=' AND Event_Start_Date__c>=:eFromDate ';
        } 
        if(eToDate != null) {
            qryString+= ' AND  Event_Start_Date__c<=:eToDate ';
        }
        //Amarab 04/12/2021 Add 2 fields to the Report
        if(String.isNotBlank(selectedSocialMediaPromotion)){
            qryString+= ' AND Social_Media_Promo__c = \''+selectedSocialMediaPromotion+'\' ';
        }
        if(String.isNotBlank(selectedEventTiedToCampaign)){
            qryString+= ' AND Tied_to_Campaign__c = \''+selectedEventTiedToCampaign+'\' ';
        }
        qryString+=' Order By Event_Start_Date__c';
        System.debug('qryString>>>>>>'+qryString);      
        List<String> prod = new List<String>();
        List<String> division = new List<String>();
        List<Double> spnsorActual = new List<Double>();
        List<Double> spnsorEstimated = new List<Double>();
        List<reportWrapper> displayWrapper = new List<reportWrapper>();
        List<GT_Event__c> evtList = Database.query(qryString);
        Set<Id> sponsorId = new Set<Id>();
        Set<Id> exhbtId = new Set<Id>();
        Set<Id> spkId = new Set<Id>();
        Set<Id> meetingId = new Set<Id>();
        Set<Id> evntId = new Set<Id>();
        Set<Id> rgatId = new Set<Id>();
        Set<Id> sptEvtId = new Set<Id>();
        Set<Id> memberId = new Set<Id>();
        List<string> salesLead = new List<string>();
        for(GT_Event__c evt : evtList)
        {
            for(Integer i=0; i < evt.Sponsorships__r.size(); i++){
                sponsorId.add(evt.Sponsorships__r[i].Id);
                
            }
            for(Integer i=0; i < evt.Exhibits__r.size(); i++){
                exhbtId.add(evt.Exhibits__r[i].Id);
                
            }
            for(Integer i=0;i<evt.Symposia__r.size();i++){
                spkId.add(evt.Symposia__r[i].Id);
                
            }
            
            for(Integer i = 0; i < evt.Meeting_Rooms__r.size(); i++){
                meetingId.add(evt.Meeting_Rooms__r[i].Id);
                
            }
            for(Integer i = 0; i < evt.Events__r.size(); i++){
                evntId.add(evt.Events__r[i].Id);
                
            }
            for(Integer i = 0; i < evt.Registration_Attend_Only__r.size(); i++){
                rgatId.add(evt.Registration_Attend_Only__r[i].Id);
                
            }
            for(Integer i = 0; i < evt.Sporting_Events__r.size(); i++){
                sptEvtId.add(evt.Sporting_Events__r[i].Id);
                
            }
            for(Integer i = 0; i < evt.Memberships__r.size(); i++){
                memberId.add(evt.Memberships__r[i].Id);
                
            }
            
        }
        Map<Id, List<String>> sponsorMap = new Map<Id, List<String>>();
        Map<Id, List<String>> exbtMap = new Map<Id, List<String>>();
        Map<Id, List<String>> spkngMap = new Map<Id, List<String>>();
        Map<Id, List<String>> meetingMap = new Map<Id, List<String>>();
        Map<Id, List<String>> eventMap = new Map<Id, List<String>>();
        Map<Id, List<String>> regatMap = new Map<Id, List<String>>();
        Map<Id, List<String>> sportingMap = new Map<Id, List<String>>();
        Map<Id, List<String>> memberMap = new Map<Id, List<String>>();
        Map<Id, List<String>> sponsorMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> exbtMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> spkngMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> meetingMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> eventMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> regatMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> sportingMapDivision = new Map<Id, List<String>>();
        Map<Id, List<String>> memberMapDivision = new Map<Id, List<String>>();
        String qry='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c,Sponsorship_Cost_Actual_CrownCastle__c,Sponsorship_Cost_Estimated_CrownCastle__c  from Brands__r WHERE Canceled__c=false) from GT_Sponsorship__c where id in :sponsorId';
        List<GT_Sponsorship__c> spList=new List<GT_Sponsorship__c>();
        spList=Database.query(qry);
        System.debug('spList'+spList);
        for(GT_Sponsorship__c spn : spList) {
            if(!sponsorMap.containsKey(spn.id)) {
                sponsorMap.put(spn.id, new List<String>());
                sponsorMapDivision.put(spn.id, new List<String>());
            }
            for(Integer i=0;i<spn.Brands__r.size();i++){
                sponsorMap.get(spn.id).add(spn.Brands__r[i].Brand_Name__c);
                sponsorMapDivision.get(spn.id).add(spn.Brands__r[i].Product_Category_CrownCastle__c);
            }
        }
        
        String spkngQuery='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c from Brands__r WHERE Canceled__c=false) from GT_Speaking_Engagement__c  where id in :spkId';
        List<GT_Speaking_Engagement__c> spkList=new List<GT_Speaking_Engagement__c>();
        spkList=Database.query(spkngQuery);
        for(GT_Speaking_Engagement__c spk : spkList) {
            if(!spkngMap.containsKey(spk.id)) {
                spkngMap.put(spk.id, new List<String>());
                spkngMapDivision.put(spk.id, new List<String>());
            }
            for(Integer i=0;i<spk.Brands__r.size();i++){
                spkngMap.get(spk.id).add(spk.Brands__r[i].Brand_Name__c);
                spkngMapDivision.get(spk.id).add(spk.Brands__r[i].Product_Category_CrownCastle__c);
            }
        }
        
        String meetQry='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c from Brands__r WHERE Canceled__c=false) from GT_Meeting_Room__c  where id in :meetingId';
        List<GT_Meeting_Room__c> mtList=new List<GT_Meeting_Room__c>();
        mtList=Database.query(meetQry);
        for(GT_Meeting_Room__c mt : mtList) {
            if(!meetingMap.containsKey(mt.id)) {
                meetingMap.put(mt.id, new List<String>());
                meetingMapDivision.put(mt.id, new List<String>());
            }
            for(Integer i=0;i<mt.Brands__r.size();i++){
                meetingMap.get(mt.id).add(mt.Brands__r[i].Brand_Name__c);
                meetingMapDivision.get(mt.id).add(mt.Brands__r[i].Product_Category_CrownCastle__c);
            }
            
        }
        
        String evtQry='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c from Brands__r WHERE Canceled__c=false) from GT_Event_RL__c  where id in :evntId';
        List<GT_Event_RL__c> evList=new List<GT_Event_RL__c>();
        evList=Database.query(evtQry);
        for(GT_Event_RL__c ev : evList) {
            if(!eventMap.containsKey(ev.id)) {
                eventMap.put(ev.id, new List<String>());
                eventMapDivision.put(ev.id, new List<String>());
            }
            for(Integer i=0;i<ev.Brands__r.size();i++){
                eventMap.get(ev.id).add(ev.Brands__r[i].Brand_Name__c);
                eventMapDivision.get(ev.id).add(ev.Brands__r[i].Product_Category_CrownCastle__c);
            }
            
        }
        
        String rgQry='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c from Brands__r WHERE Canceled__c=false) from GT_Reg_Attend_Only__c  where id in :rgatId';
        List<GT_Reg_Attend_Only__c> rgList=new List<GT_Reg_Attend_Only__c>();
        rgList=Database.query(rgQry);
        for(GT_Reg_Attend_Only__c rg : rgList) {
            if(!regatMap.containsKey(rg.id)) {
                regatMap.put(rg.id, new List<String>());
                regatMapDivision.put(rg.id, new List<String>());
            }
            for(Integer i=0;i<rg.Brands__r.size();i++){
                regatMap.get(rg.id).add(rg.Brands__r[i].Brand_Name__c);
                regatMapDivision.get(rg.id).add(rg.Brands__r[i].Product_Category_CrownCastle__c);
            }
            
        }
        
        String spevtQry='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c from Products__r WHERE Canceled__c=false) from GT_Sporting_Event__c  where id in :sptEvtId';
        List<GT_Sporting_Event__c> sprtList=new List<GT_Sporting_Event__c>();
        sprtList=Database.query(spevtQry);
        for(GT_Sporting_Event__c sprt : sprtList) {
            if(!sportingMap.containsKey(sprt.id)) {
                sportingMap.put(sprt.id, new List<String>());
                sportingMapDivision.put(sprt.id, new List<String>());
            }
            for(Integer i=0;i<sprt.Products__r.size();i++){
                sportingMap.get(sprt.id).add(sprt.Products__r[i].Brand_Name__c);
                sportingMapDivision.get(sprt.id).add(sprt.Products__r[i].Product_Category_CrownCastle__c);
            }
            
        }
        
        String memberQry='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c from Products__r WHERE Canceled__c=false) from GT_Membership__c  where id in :memberId';
        List<GT_Membership__c> memberList=new List<GT_Membership__c>();
        memberList=Database.query(memberQry);
        for(GT_Membership__c mem : memberList) {
            if(!memberMap.containsKey(mem.id)) {
                memberMap.put(mem.id, new List<String>());
                memberMapDivision.put(mem.id, new List<String>());
            }
            for(Integer i=0;i<mem.Products__r.size();i++){
                memberMap.get(mem.id).add(mem.Products__r[i].Brand_Name__c);
                memberMapDivision.get(mem.id).add(mem.Products__r[i].Product_Category_CrownCastle__c);
            }
            
        }
        String qryStg='select id,Name,(select name,Brand_Name__c,Product_Category_CrownCastle__c,GES_Costs_Actual__c,Booth_Space_Cost_Actual__c,Booth_Space_Cost_Estimated__c, GES_Costs_Estimated__c    from Brands__r WHERE Canceled__c=false) from GT_Exhibit__c  where id in :exhbtId';
        
        List<GT_Exhibit__c> exList=new List<GT_Exhibit__c>();
        exList=Database.query(qryStg);
        for(GT_Exhibit__c exbt : exList) {
            if(!exbtMap.containsKey(exbt.id)) {
                exbtMap.put(exbt.id, new List<String>());
                exbtMapDivision.put(exbt.id, new List<String>());
            }
            for(Integer i=0;i<exbt.Brands__r.size();i++){
                exbtMap.get(exbt.id).add(exbt.Brands__r[i].Brand_Name__c);
                exbtMapDivision.get(exbt.id).add(exbt.Brands__r[i].Product_Category_CrownCastle__c);
            }
            
        }
        String activityString = '';
        String productString = '';
        String divisionString = '';
        String ccManager = '';
        String salesLeaders = '';
        Boolean flag = true;
        Set<String> sLeaders2 = new Set<String>();
        String salesLeaders2 = '';
        Set<String> sCostCenter = new Set<String>();
        String CostCenter = '';
        String noOfContsMade = ''; //SAL-1306 - 12/04/23 - Sajid
        for(GT_Event__c evt:evtList){
            if(evt.Brands__r.size()>0){
                for(integer i=0;i<evt.Brands__r.size();i++){
                    System.debug('evt.Brands__r[i].Sponsorship_Cost_Estimated_CrownCastle__c'+evt.Brands__r[i].Sponsorship_Cost_Estimated_CrownCastle__c);
                    if(evt.Brands__r[i].Sponsorship__c!=null){
                        spnsorActual.add(evt.Brands__r[i].Sponsorship_Cost_Actual_CrownCastle__c);
                        spnsorEstimated.add(evt.Brands__r[i].Sponsorship_Cost_Estimated_CrownCastle__c);
                    }
                    if(evt.Brands__r[i].Exhibit__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].GES_Costs_Estimated__c);
                        spnsorActual.add(evt.Brands__r[i].GES_Costs_Actual__c);
                        spnsorEstimated.add(evt.Brands__r[i].Booth_Space_Cost_Estimated__c);
                        spnsorActual.add(evt.Brands__r[i].Booth_Space_Cost_Actual__c);
                    }
                    
                    if(evt.Brands__r[i].Event__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].Event_Cost_Estimated_CrownCastle__c);
                        spnsorActual.add(evt.Brands__r[i].Event_Costs_Actual_CrownCastle__c);
                    }
                    
                    if(evt.Brands__r[i].Registration_Attend_Only__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].Reg_Attend_Cost_Estimated_CrownCastle__c);
                        spnsorActual.add(evt.Brands__r[i].Reg_Attend_Cost_Actual_CrownCastle__c);
                    }
                    
                    if(evt.Brands__r[i].membership__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].Membership_Costs_Estimated__c);
                        spnsorActual.add(evt.Brands__r[i].Membership_Costs_Actual__c);
                    }
                    if(evt.Brands__r[i].Meeting_Room__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].Meeting_Room_Services_Cost_Estimated_CC__c);
                        spnsorActual.add(evt.Brands__r[i].Meeting_Room_Services_Cost_Actual_CC__c);
                        spnsorEstimated.add(evt.Brands__r[i].Meeting_Room_Cost_Estimated_CrownCastle__c);
                        spnsorActual.add(evt.Brands__r[i].Meeting_Room_Cost_Actual_CrownCastle__c);
                    }
                    if(evt.Brands__r[i].Sporting_Event__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].F_B_Costs_Estimated__c);
                        spnsorActual.add(evt.Brands__r[i].F_B_Costs_Actual__c);
                        spnsorEstimated.add(evt.Brands__r[i].Sporting_Event_Costs_Estimated__c);
                        spnsorActual.add(evt.Brands__r[i].Sporting_Event_Costs_Actual__c);
                    }
                    if(evt.Brands__r[i].Speaking_Engagement__c!=null){
                        spnsorEstimated.add(evt.Brands__r[i].Speaker_Cost_Estimated_CrownCastle__c);
                        spnsorActual.add(evt.Brands__r[i].Speaker_Cost_Actual_CrownCastle__c);
                    }
                  
                    spnsorActual.add(evt.Brands__r[i].Amount_1__c );
                    spnsorActual.add(evt.Brands__r[i].Amount_2__c );
                    spnsorActual.add(evt.Brands__r[i].Amount_3__c );
                    spnsorActual.add(evt.Brands__r[i].Amount_4__c );
                    spnsorActual.add(evt.Brands__r[i].Amount_5__c );
                    spnsorActual.add(evt.Brands__r[i].Amount_6__c );
                    spnsorActual.add(evt.Brands__r[i].Amount_7__c );
                    
                   // salesLead.add(evt.Brands__r[i].Sales_Leaders__c);
                   if(evt.Brands__r[i].Sales_Leaders__c!=null && (!salesLeaders.contains(evt.Brands__r[i].Sales_Leaders__c))){
                        if(String.isBlank(salesLeaders))
                            salesLeaders=  evt.Brands__r[i].Sales_Leaders__c;
                        else
                            salesLeaders=salesLeaders+', '+evt.Brands__r[i].Sales_Leaders__c; 
                    }
                    
                    if(evt.Brands__r[i].Sales_Leader_2__c != null){
                        sLeaders2.add(evt.Brands__r[i].Sales_Leader_2__c);
                    }
                    
                    if(evt.Brands__r[i].Cost_Center__c != null){
                        sCostCenter.add(evt.Brands__r[i].Cost_Center__c);
                    }
                   
                }
            }
            salesLeaders2 = String.join(new list<String>(sLeaders2), ', ');
            CostCenter = String.join(new list<String>(sCostCenter), ', ');
            
            if(evt.Exhibits__r.size()>0){
                for(integer i=0;i<evt.Exhibits__r.size();i++){
                    prod=exbtMap.get(evt.Exhibits__r[i].id);
                    division = exbtMapDivision.get(evt.Exhibits__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                        
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Exhibits__r[i].Project_Manager_CrownCastle__c!=null && (!ccManager.contains(evt.Exhibits__r[i].Project_Manager_CrownCastle__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Exhibits__r[i].Project_Manager_CrownCastle__c;
                        else
                            ccManager=ccManager+', '+evt.Exhibits__r[i].Project_Manager_CrownCastle__c; 
                    }
                    
                    //SAL-1306 - 12/04/23 - Sajid
                    if(evt.Exhibits__r[i].Contacts_Made__c != null){
                        if(String.isBlank(noOfContsMade)){
                            noOfContsMade = String.valueOf(evt.Exhibits__r[i].Contacts_Made__c); 
                        }else{
                           noOfContsMade = noOfContsMade + ', ' + evt.Exhibits__r[i].Contacts_Made__c;  
                        }
                    }
                }
                if(flag){
                    activityString=activityString+'Exhibit';
                    flag=false;
                }
                else
                    activityString=activityString+', Exhibit';
            }
            
            if(evt.Sponsorships__r.size()>0){
                for(integer i=0;i<evt.Sponsorships__r.size();i++){
                    prod=sponsorMap.get(evt.Sponsorships__r[i].id);
                    division = sponsorMapDivision.get(evt.Sponsorships__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    if(evt.Sponsorships__r[i].Project_Manager_CrownCastle__c!=null && (!ccManager.contains(evt.Sponsorships__r[i].Project_Manager_CrownCastle__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Sponsorships__r[i].Project_Manager_CrownCastle__c;
                        else
                            ccManager=ccManager+', '+evt.Sponsorships__r[i].Project_Manager_CrownCastle__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Sponsorship';
                    flag=false;
                }
                else
                    activityString=activityString+', Sponsorship';
            }
            if(evt.Symposia__r.size()>0){
                for(integer i=0;i<evt.Symposia__r.size();i++){
                    prod=spkngMap.get(evt.Symposia__r[i].id);
                    division = spkngMapDivision.get(evt.Symposia__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Symposia__r[i].Project_Manager_CrownCastle__c!=null && (!ccManager.contains(evt.Symposia__r[i].Project_Manager_CrownCastle__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Symposia__r[i].Project_Manager_CrownCastle__c;
                        else
                            ccManager=ccManager+', '+evt.Symposia__r[i].Project_Manager_CrownCastle__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Speaking Engagement';
                    flag=false;
                }
                else
                    activityString=activityString+', Speaking Engagement';
                
            } 
            if(evt.Meeting_Rooms__r.size()>0){
                for(integer i=0;i<evt.Meeting_Rooms__r.size();i++){
                    prod=meetingMap.get(evt.Meeting_Rooms__r[i].id);
                    division = meetingMapDivision.get(evt.Meeting_Rooms__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Meeting_Rooms__r[i].Project_Manager__c!=null && (!ccManager.contains(evt.Meeting_Rooms__r[i].Project_Manager__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Meeting_Rooms__r[i].Project_Manager__c;
                        else
                            ccManager=ccManager+', '+evt.Meeting_Rooms__r[i].Project_Manager__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Meeting Room';
                    flag=false;
                }
                else
                    activityString=activityString+', Meeting Room';
                
            } 
            if(evt.Events__r.size()>0){
                for(integer i=0;i<evt.Events__r.size();i++){
                    prod=eventMap.get(evt.Events__r[i].id);
                    division = eventMapDivision.get(evt.Events__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Events__r[i].Project_Manager_CrownCastle__c!=null && (!ccManager.contains(evt.Events__r[i].Project_Manager_CrownCastle__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Events__r[i].Project_Manager_CrownCastle__c;
                        else
                            ccManager=ccManager+', '+evt.Events__r[i].Project_Manager_CrownCastle__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Event';
                    flag=false;
                }
                else
                    activityString=activityString+', Event';
                
            } 
            if(evt.Registration_Attend_Only__r.size()>0){
                for(integer i=0;i<evt.Registration_Attend_Only__r.size();i++){
                    prod=regatMap.get(evt.Registration_Attend_Only__r[i].id);
                    division = regatMapDivision.get(evt.Registration_Attend_Only__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Registration_Attend_Only__r[i].Project_Manager_CrownCastle__c!=null && (!ccManager.contains(evt.Registration_Attend_Only__r[i].Project_Manager_CrownCastle__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Registration_Attend_Only__r[i].Project_Manager_CrownCastle__c;
                        else
                            ccManager=ccManager+', '+evt.Registration_Attend_Only__r[i].Project_Manager_CrownCastle__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Registration or Attend Only';
                    flag=false;
                }
                else
                    activityString=activityString+', Registration or Attend Only';
                
            } 
            if(evt.Sporting_Events__r.size()>0){
                for(integer i=0;i<evt.Sporting_Events__r.size();i++){
                    prod=sportingMap.get(evt.Sporting_Events__r[i].id);
                    division = sportingMapDivision.get(evt.Sporting_Events__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Sporting_Events__r[i].CC_Project_Manager__c!=null && (!ccManager.contains(evt.Sporting_Events__r[i].CC_Project_Manager__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Sporting_Events__r[i].CC_Project_Manager__c;
                        else
                            ccManager=ccManager+', '+evt.Sporting_Events__r[i].CC_Project_Manager__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Sporting Event';
                    flag=false;
                }
                else
                    activityString=activityString+', Sporting Event';
                
            } 
            if(evt.Memberships__r.size()>0){
                for(integer i=0;i<evt.Memberships__r.size();i++){
                    prod=memberMap.get(evt.Memberships__r[i].id);
                    division = memberMapDivision.get(evt.Memberships__r[i].id);
                    for(Integer j=0;j<prod.size();j++){
                        if(prod[j]!=null && (!productString.contains(prod[j]))){
                            if(String.isBlank(productString))
                                productString=prod[j];
                            else
                                productString=productString+', '+prod[j];
                        }
                    }
                    
                    for(Integer j=0;j<division.size();j++){
                        if(division[j]!=null && (!divisionString.contains(division[j]))){
                            if(String.isBlank(divisionString))
                                divisionString=division[j];
                            else
                                divisionString=divisionString+', '+division[j];
                        }
                    }
                    
                    if(evt.Memberships__r[i].CC_Project_Manager__c!=null && (!ccManager.contains(evt.Memberships__r[i].CC_Project_Manager__c))){
                        if(String.isBlank(ccManager))
                            ccManager=  evt.Memberships__r[i].CC_Project_Manager__c;
                        else
                            ccManager=ccManager+', '+evt.Memberships__r[i].CC_Project_Manager__c; 
                    }
                }
                if(flag){
                    activityString=activityString+'Membership';
                    flag=false;
                }
                else
                    activityString=activityString+', Membership';
                
            } 
            
            for(Integer k=0;k<spnsorActual.size();k++){
                if(spnsorActual[k]!=null)
                    sponActualTotal=sponActualTotal+spnsorActual[k];
            }
            System.debug('spnsorEstimated>List>>>'+spnsorEstimated);
            for(Integer k=0;k<spnsorEstimated.size();k++){
                if(spnsorEstimated[k]!=null)
                    sponEstimatedTotal=sponEstimatedTotal+spnsorEstimated[k];
            }
            Double TotalActual=sponActualTotal;
            Double TotalEstimatedCost=  sponEstimatedTotal;  
            if(evt.Sponsorships__r.size()==0 && evt.Exhibits__r.size()==0 && evt.Symposia__r.size()==0 && evt.Meeting_Rooms__r.size()==0 && evt.Events__r.size()==0 && evt.Registration_Attend_Only__r.size()==0 && evt.Sporting_Events__r.size()==0 && evt.Memberships__r.size()==0 )
            {
                displayWrapper.add(new reportWrapper(
                    evt.Name_of_Event__c,
                    null,
                    null,
                    null,
                    evt.Event_Start_Date__c,
                    evt.Event_End_Date__c,
                    evt.Shipping_State_Province__c,
                    evt.Shipping_City__c,
                    0,
                    0,
                    evt.Event_Cancelled__c,
                    evt.GES_Supported_Event__c,
                    salesLeaders,
                    salesLeaders2,
                    null,
                    CostCenter,
                    evt.Social_Media_Promo__c,
                    evt.Tied_to_Campaign__c,
                    null //SAL-1306 -  12/04/23 - Sajid
                ));
            }
            else
                displayWrapper.add(new reportWrapper(evt.Name_of_Event__c,ccManager,productString,activityString,evt.Event_Start_Date__c,evt.Event_End_Date__c,evt.Shipping_State_Province__c,evt.Shipping_City__c,TotalActual,TotalEstimatedCost,evt.Event_Cancelled__c,evt.GES_Supported_Event__c,salesLeaders,salesLeaders2,divisionString, CostCenter, evt.Social_Media_Promo__c, evt.Tied_to_Campaign__c,noOfContsMade)); //SAL-1306 - passing noOfContsMade as a parameter  12/04/23 - Sajid
            salesLeaders='';
            ccManager='';
            productString='';
            divisionString='';
            activityString='';
            sponActualTotal=0.00; 
            sponEstimatedTotal=0.0;
            spnsorActual.clear();
            spnsorEstimated.clear();
            flag=true;
            sLeaders2 = new Set<String>();
            salesLeaders2 = '';
            sCostCenter = new Set<String>();
            CostCenter = '';
            noOfContsMade = null; //SAL-1306 -  12/04/23 - Sajid
        }
        System.debug('evtList'+evtList);
        return displayWrapper;

    }    
    
    public class reportWrapper {
        @AuraEnabled public String Name_Of_Event {get; set;}
        @AuraEnabled public String ccManager {get; set;}
        @AuraEnabled public String businessType {get; set;}
        @AuraEnabled public String Division {get; set;}
        @AuraEnabled public String Activity_Type {get; set;}
        @AuraEnabled public Date Event_Start_Date {get; set;}
        @AuraEnabled public Date Event_close_Date {get; set;}
        @AuraEnabled public String Shipping_State_Province {get; set;}
        @AuraEnabled public String sLeaders {get; set;}
        @AuraEnabled public String Shipping_City {get; set;}
        @AuraEnabled public Double TotalActualCost{get;set;}
        @AuraEnabled public Double TotalEstimatedCost{get;set;}
        @AuraEnabled public Boolean gesSupported{get;set;}
        @AuraEnabled public Boolean evtCancelled{get;set;}        
        @AuraEnabled public String sLeaders2{get;set;}
        @AuraEnabled public String sCostCenter{get;set;}
        @AuraEnabled public String socialMediaPromo{get;set;}
        @AuraEnabled public String eventTiedToCampaign{get;set;}
        @AuraEnabled public String noOfContsMade{get;set;} //SAL-1306 - 12/04/23 - Sajid
        
        public reportWrapper(String evt, String cc, String bType, String activity, Date startDdate, Date endDate, String state, string city, Double totalCost, Double actualCost, Boolean cancelled, Boolean evtSupported, String leaders, String leaders2, String productCatagory, String costCenter, String socialMediaPromo, String eventTiedToCampaign, String noOfContsMade){ //SAL-1306 -added noOfContsMade as a parameter 12/04/23 - Sajid
            Name_Of_Event = evt;
            ccManager = cc;
            businessType = bType;
            Activity_Type = activity;
            Event_Start_Date = startDdate;
            Event_close_Date = endDate;
            Shipping_State_Province = state;
            Shipping_City = city;
            TotalActualCost = totalCost;
            TotalEstimatedCost = actualCost;
            evtCancelled = cancelled;
            gesSupported = evtSupported;
            sLeaders = leaders;
            sLeaders2 = leaders2;
            Division = productCatagory;
            sCostCenter = CostCenter;
            this.socialMediaPromo = socialMediaPromo;
            this.eventTiedToCampaign = eventTiedToCampaign;
            this.noOfContsMade = noOfContsMade; //SAL-1306 - 12/04/23 - Sajid
        }
        
    }
    @AuraEnabled
    public static InitResponse init()
    {
        InitResponse ir = new InitResponse();
        ir.socialMediaPromotionOptions = getSocialMediaPromotionOptions();
        ir.eventTiedToCampaignOptions = getEventTiedToCampaignOptions();
        return ir;
    }
    @TestVisible
    private static list<Option> getSocialMediaPromotionOptions()
    {
        list<Option> options = new list<Option>();
        for( Schema.PicklistEntry f : GT_Event__c.Social_Media_Promo__c.getDescribe().getPicklistValues())
        {
            options.add(new Option( f.getValue(), f.getLabel()));
        }       
        return options;
    }
    @TestVisible
    private static list<Option> getEventTiedToCampaignOptions()
    {
        list<Option> options = new list<Option>();
        for( Schema.PicklistEntry f : GT_Event__c.Tied_to_Campaign__c.getDescribe().getPicklistValues())
        {
            options.add(new Option( f.getValue(), f.getLabel()));
        }  
        return options;
    }
    public class InitResponse
    {
        @AuraEnabled public list<Option> socialMediaPromotionOptions;
        @AuraEnabled public list<Option> eventTiedToCampaignOptions;
        public InitResponse()
        {
            socialMediaPromotionOptions = new list<Option>();
            eventTiedToCampaignOptions = new list<Option>();
        }
    }
    public class Option
    {
        @AuraEnabled public string value;
        @AuraEnabled public string label;
        public Option(string value, string label)
        {
            this.value = value;
            this.label = label;
        }
    }
}