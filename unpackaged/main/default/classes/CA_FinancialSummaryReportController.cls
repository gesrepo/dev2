public class CA_FinancialSummaryReportController {
    
    @AuraEnabled 
    public static Generic_Template_Setting__mdt getConnectSettings() {
        
        Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;
        String customerName = '';
        
        switch on profileName {
            when 'GC Crown Castle' {
                customerName = 'Crown Castle';
            }
            when 'GC Novo Nordisk' {
                customerName = 'Novo Nordisk';
            }
            when 'GC Pharma Template' {
                customerName = 'Pharma Template';
            }
            when 'GC Merck' {
                customerName = 'Merck';
            }
            when else {
                customerName = 'Generic Template';
            }
        }
        List<Generic_Template_Setting__mdt> customSettings = [SELECT Program_Name__c,Customer_Name__c FROM Generic_Template_Setting__mdt WHERE Customer_Name__c =: customerName LIMIT 1]; 
        return customSettings[0]; 
    }
    
    @AuraEnabled
    public static dispWrapper getExhibitDetails(Id recordId) {
        
        //This is to run meetingPlanning code which is only for NNI
        //String profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;
        Generic_Template_Setting__mdt temp=getConnectSettings();
        String customerName = temp.Customer_Name__c;
        Boolean falseValue = false;
        dispWrapper returnDispWrapper = new dispWrapper();
        returnDispWrapper.getConnectEventList = new List<connectEventListWrapper>();
        returnDispWrapper.getExhibitList = new List<exhibitListWrapper>();
        returnDispWrapper.sponWrapper = new List<sponListWrapper>();
        returnDispWrapper.spkngengWrapper = new List<spkngengListWrapper>();
        returnDispWrapper.MtrmWrapper = new List<mtrmListWrapper>();
        returnDispWrapper.eventWrapper = new List<eventListWrapper>();
        returnDispWrapper.regattndonlyWrapper = new List<regattndonlyListWrapper>();
        returnDispWrapper.meetingPlanningWrapper = new List<meetingPlanningListWrapper>();
        returnDispWrapper.TotalCost = new List<totalCostListWrapper>();
        
        returnDispWrapper.getExhibitTotalDetails = new List<AggregateResult>();
        returnDispWrapper.getSponsorshipTotalDetails = new List<AggregateResult>();
        returnDispWrapper.getSpkngEngTotalDetails = new List<AggregateResult>();
        returnDispWrapper.getMtRmTotalDetails = new List<AggregateResult>();
        returnDispWrapper.getEventTotalDetails = new List<AggregateResult>();
        returnDispWrapper.getMeetingPlanningTotalDetails = new List<AggregateResult>();
        
        
        returnDispWrapper.getExhibitTotalDetails = [Select sum(GES_Costs_Actual__c)totalGESActualCost, sum(GES_Costs_Estimated__c)totalGESEstimatedCost, sum(Booth_Space_Costs_Actual__c)totalBoothActualCost, sum(Booth_Space_Costs_Estimated__c)totalBoothEstimatedCost,sum(Total_Cost__c)totalExhibitAdditional from CA_Product__c where Exhibit__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Exhibit__c != null and Event__c=:recordId];
        
        returnDispWrapper.getSponsorshipTotalDetails = [Select sum(Sponsorship_Costs_Actual__c)totalSponsorshipActualCost, sum(Sponsorship_Costs_Estimated__c)totalSponsorshipEstimatedCost, sum(Total_Cost__c)totalSponsorshipAdditional  from CA_Product__c where Sponsorship__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Sponsorship__c != null and Event__c=:recordId];
        
        returnDispWrapper.getSpkngEngTotalDetails = [Select sum(Speaking_Engagement_Costs_Actual__c)totalSpkngEngmtActualCost, sum(Speaking_Engagement_Costs_Estimated__c)totalSpkngEngmtEstimatedCost,sum(Total_Cost__c)totalSpEgAdditional from CA_Product__c where Speaking_Engagement__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Speaking_Engagement__c != null and Event__c=:recordId];
        
        returnDispWrapper.getMtRmTotalDetails = [Select sum(Meeting_Room_Services_Cost_Actual__c)totalMtRmServicesActualCost,sum(Meeting_Room_Services_Costs_Estimated__c)totalMtRmServicesEstimatedCost, sum(Meeting_Room_Costs_Actual__c)totalMtRmActualCost, sum(Meeting_Room_Costs_Estimated__c)totalMtRmEstimatedCost, sum(Total_Cost__c)totalMtRmAdditional from CA_Product__c where Meeting_Room__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Meeting_Room__c != null and Event__c=:recordId];
        
        returnDispWrapper.getEventTotalDetails = [Select sum(Event_Costs_Actual__c)totalEventActualCost, sum(Event_Costs_Estimated__c)totalEventEstimatedCost, sum(Total_Cost__c)totalEvtAdditional from CA_Product__c where CA_Event__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and CA_Event__c != null and Event__c=:recordId];
        
        returnDispWrapper.getMeetingPlanningTotalDetails = [Select sum(Meeting_Planning_Costs_Actual__c)totalMeetingPlanningActualCost, sum(Meeting_Planning_Costs_Estimated__c)totalMeetingPlanningEstimatedCost, sum(Total_Cost__c)totalMtPlAdditional from CA_Product__c where Meeting_Planning__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Meeting_Planning__c != null and Event__c=:recordId];
        
        Double gesActualTotal = double.valueOf(returnDispWrapper.getExhibitTotalDetails[0].get('totalGESActualCost'));
        Double exhibitActualTotal = double.valueOf(returnDispWrapper.getExhibitTotalDetails[0].get('totalBoothActualCost'));
        Double sponActualTotal = double.valueOf(returnDispWrapper.getSponsorshipTotalDetails[0].get('totalSponsorshipActualCost'));
        Double spkngmgmtActualTotal = double.valueOf(returnDispWrapper.getSpkngEngTotalDetails[0].get('totalSpkngEngmtActualCost'));
        Double mtrmActualTotal = double.valueOf(returnDispWrapper.getMtRmTotalDetails[0].get('totalMtRmActualCost'));
        Double mtrmServiceActualTotal = double.valueOf(returnDispWrapper.getMtRmTotalDetails[0].get('totalMtRmServicesActualCost'));
        Double eventActualTotal = double.valueOf(returnDispWrapper.getEventTotalDetails[0].get('totalEventActualCost'));
        //Double raonlyActualTotal = double.valueOf(returnDispWrapper.getRAonlyTotalDetails[0].get('totalRaOnlyActualCost'));
        Double MeetingPlanningActualTotal = double.valueOf(returnDispWrapper.getMeetingPlanningTotalDetails[0].get('totalMeetingPlanningActualCost'));
        //Double FBActualTotal = double.valueOf(returnDispWrapper.getSportingEventTotalDetails[0].get('totalFBActualCosts'));
        //Double sportingEventActualTotal = double.valueOf(returnDispWrapper.getSportingEventTotalDetails[0].get('totalSportingEventActualCost'));
        //Double membershipActualTotal = double.valueOf(returnDispWrapper.getMembershipTotalDetails[0].get('totalMembershipActualCost'));
        
        Double gesEstimatedTotal = double.valueOf(returnDispWrapper.getExhibitTotalDetails[0].get('totalGESEstimatedCost'));
        Double exhibitEstimatedTotal = double.valueOf(returnDispWrapper.getExhibitTotalDetails[0].get('totalBoothEstimatedCost'));
        Double sponEstimatedTotal = double.valueOf(returnDispWrapper.getSponsorshipTotalDetails[0].get('totalSponsorshipEstimatedCost'));
        Double spkngmgmtEstimatedTotal = double.valueOf(returnDispWrapper.getSpkngEngTotalDetails[0].get('totalSpkngEngmtEstimatedCost'));
        Double mtrmEstimatedTotal = double.valueOf(returnDispWrapper.getMtRmTotalDetails[0].get('totalMtRmEstimatedCost'));
        Double mtrmServiceEstimatedTotal = double.valueOf(returnDispWrapper.getMtRmTotalDetails[0].get('totalMtRmServicesEstimatedCost'));
        Double eventEstimatedTotal = double.valueOf(returnDispWrapper.getEventTotalDetails[0].get('totalEventEstimatedCost'));
       // Double raonlyEstimatedTotal = double.valueOf(returnDispWrapper.getRAonlyTotalDetails[0].get('totalRaOnlyEstimatedCost'));
        Double MeetingPlanningEstimatedTotal = double.valueOf(returnDispWrapper.getMeetingPlanningTotalDetails[0].get('totalMeetingPlanningEstimatedCost'));
        //Double FBEstimatedTotal = double.valueOf(returnDispWrapper.getSportingEventTotalDetails[0].get('totalFBEstimatedCosts'));
        //Double sportingEventEstimatedTotal = double.valueOf(returnDispWrapper.getSportingEventTotalDetails[0].get('totalSportingEventEstimatedCost'));
        //Double membershiptEstimatedTotal = double.valueOf(returnDispWrapper.getMembershipTotalDetails[0].get('totalMembershipEstimatedCost'));
        Double AdditionalCosts=0.00;
        if(temp.Customer_Name__c == 'Crown Castle'){
            AdditionalCosts=double.valueOf(returnDispWrapper.getAdditionalCosts[0].get('totalAdditionalCost'));
            if(AdditionalCosts==null)
                AdditionalCosts=0.00;
        }
        System.debug('AdditionalCosts>>>>>'+AdditionalCosts);
        gesActualTotal = (gesActualTotal == null) ? 0 : gesActualTotal;
        exhibitActualTotal =  exhibitActualTotal == null ? 0 : exhibitActualTotal;
        sponActualTotal =   sponActualTotal == null ? 0 : sponActualTotal;
        spkngmgmtActualTotal =  spkngmgmtActualTotal == null ? 0 : spkngmgmtActualTotal;
        mtrmActualTotal =  mtrmActualTotal == null ? 0 : mtrmActualTotal;
        mtrmServiceActualTotal =  mtrmServiceActualTotal == null ? 0 : mtrmServiceActualTotal;
        eventActualTotal =  eventActualTotal == null ? 0 : eventActualTotal;
        //raonlyActualTotal =  raonlyActualTotal == null ? 0 : raonlyActualTotal;
        MeetingPlanningActualTotal = MeetingPlanningActualTotal == null ? 0 : MeetingPlanningActualTotal;
        //FBActualTotal = FBActualTotal == null ? 0 : FBActualTotal;
        //sportingEventActualTotal = sportingEventActualTotal == null ? 0 : sportingEventActualTotal;
        //membershipActualTotal = membershipActualTotal == null ? 0 : membershipActualTotal;
        
        
        
        gesEstimatedTotal = gesEstimatedTotal == null ? 0 : gesEstimatedTotal;
        exhibitEstimatedTotal =  exhibitEstimatedTotal == null ? 0 : exhibitEstimatedTotal;
        sponEstimatedTotal =   sponEstimatedTotal == null ? 0 : sponEstimatedTotal;
        spkngmgmtEstimatedTotal =  spkngmgmtEstimatedTotal == null ? 0 : spkngmgmtEstimatedTotal;
        mtrmEstimatedTotal =  mtrmEstimatedTotal == null ? 0 : mtrmEstimatedTotal;
        mtrmServiceEstimatedTotal =  mtrmServiceEstimatedTotal == null ? 0 : mtrmServiceEstimatedTotal;
        eventEstimatedTotal =  eventEstimatedTotal == null ? 0 : eventEstimatedTotal;
        //raonlyEstimatedTotal =  raonlyEstimatedTotal == null ? 0 : raonlyEstimatedTotal;
        MeetingPlanningEstimatedTotal =  MeetingPlanningEstimatedTotal == null ? 0 : MeetingPlanningEstimatedTotal;
        //FBEstimatedTotal = FBEstimatedTotal == null ? 0 : FBEstimatedTotal;
        //sportingEventEstimatedTotal =  sportingEventEstimatedTotal == null ? 0 : sportingEventEstimatedTotal;
        //membershiptEstimatedTotal =  membershiptEstimatedTotal == null ? 0 : membershiptEstimatedTotal;
        
        
        Double TotalActualCost = gesActualTotal + exhibitActualTotal +  sponActualTotal + spkngmgmtActualTotal + mtrmActualTotal + mtrmServiceActualTotal + eventActualTotal + MeetingPlanningActualTotal +AdditionalCosts;
        
        Double TotalEstimatedCost = gesEstimatedTotal + exhibitEstimatedTotal + sponEstimatedTotal + spkngmgmtEstimatedTotal + mtrmEstimatedTotal + mtrmServiceEstimatedTotal + eventEstimatedTotal + MeetingPlanningEstimatedTotal;
        
        returnDispWrapper.TotalCost.Add(new totalCostListWrapper(TotalActualCost,TotalEstimatedCost,AdditionalCosts));
        
        List<CA_Main_Event__c> connectEventList =[Select id,Name_of_Event__c,Shipping_Country__c,Shipping_City__c,Shipping_State_Province__c, Event_Start_Date__c,Event_End_Date__c from CA_Main_Event__c where id=:recordId];
        
        if(connectEventList.size()>0)
        {
            String ConnectEventName = '';
            String ConnectEventLocation = '';
            Date CongressStartDate = System.today();
            Date CongressEndDate = System.today();
            Date EventStartDate = System.today();
            Date EventEndDate = System.today();
            
            for(CA_Main_Event__c cev: connectEventList)
            {
                ConnectEventName = cev.Name_of_Event__c;
                List<String> Locations = new List<String>();
                string city = (cev.Shipping_City__c == null)? '': cev.Shipping_City__c;
                string state = (cev.Shipping_State_Province__c == null)? '': cev.Shipping_State_Province__c;
                string country = (cev.Shipping_Country__c == null)? '': cev.Shipping_Country__c;
                
                
                if(!String.isBlank(city)){
                    Locations.add(city);
                }
                if(!String.isBlank(state)){
                    Locations.add(state);
                }
                if(!String.isBlank(country)){
                    if(country != 'United States' && country != 'US' && country != 'USA') {
                        Locations.add(country);
                    }
                }
                ConnectEventLocation = String.join(Locations, ', ');
                if(cev.Event_Start_Date__c != null)
                {
                    EventStartDate = cev.Event_Start_Date__c.addDays(1);                    
                }
                else
                {
                    EventStartDate = cev.Event_Start_Date__c;
                }
                
                if(cev.Event_End_Date__c != null)
                {
                    EventEndDate = cev.Event_End_Date__c.addDays(1);            
                }
                else
                {
                    EventEndDate = cev.Event_End_Date__c;
                }
                
                returnDispWrapper.getConnectEventList.Add(new connectEventListWrapper(ConnectEventName,
                                                                                      '',
                                                                                      ConnectEventLocation,                                
                                                                                      EventStartDate,
                                                                                      EventEndDate));                                                 
                ConnectEventName = '';
                ConnectEventLocation = '';
                EventStartDate = System.today();
                EventEndDate = System.today();
            }
            
        }
        
        List<CA_Exhibit__c> exhibitList =[Select Name,Exhibit_Name__c,(select Therapeutic_Area__c,GES_Costs_Estimated__c, GES_Costs_Actual__c, Total_Cost__c, Booth_Space_Costs_Actual__c,Booth_Space_Costs_Estimated__c
                                                                       from CA_Products__r where Cancelled__c =: falseValue and Exhibit__c != null and Event__c=:recordId) from CA_Exhibit__c where Cancelled__c =: falseValue and Event__c=:recordId];
        if(exhibitList.size()>0)
        {
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal GESEstimatedCost= 0.00;
            Decimal GESActualCost= 0.00;
            Decimal BotspActualCost= 0.00;
            Decimal BotspEstimatedCost= 0.00;
            Decimal AddtnlCost= 0.00;
            
            for(CA_Exhibit__c ex: exhibitList)
            {
                if(ex.CA_Products__r.size() > 0)
                {                
                    for(CA_Product__c br:ex.CA_Products__r)
                    {   
                        
                        if(!String.isBlank(br.Therapeutic_Area__c)) {
                            BrandNames.add(br.Therapeutic_Area__c);
                        }
                        
                        GESEstimatedCost+= (br.GES_Costs_Estimated__c!= null ? br.GES_Costs_Estimated__c: 0);
                        GESActualCost+= (br.GES_Costs_Actual__c!= null ? br.GES_Costs_Actual__c: 0);  
                        BotspEstimatedCost+= (br.Booth_Space_Costs_Estimated__c!= null ? br.Booth_Space_Costs_Estimated__c: 0);
                        BotspActualCost+=(br.Booth_Space_Costs_Actual__c!= null ? br.Booth_Space_Costs_Actual__c: 0);
                        AddtnlCost += (br.Total_Cost__c!= null ? br.Total_Cost__c: 0);
                    }
                }                
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                system.debug(ex.Exhibit_Name__c+'Brand'+ex.Name+ 'List of Data '+Brand+'+++++'+BrandName+'+++++'+BotspActualCost+'+++++'+BotspEstimatedCost);        
                returnDispWrapper.getExhibitList.Add(new exhibitListWrapper(ex.Name,
                                                                            ex.Exhibit_Name__c,                                                      
                                                                            BrandName,
                                                                            GESEstimatedCost,
                                                                            GESActualCost,
                                                                            BotspEstimatedCost,
                                                                            BotspActualCost,
                                                                            AddtnlCost));                                                 
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                GESEstimatedCost= 0.00;
                GESActualCost=0.00;
                BotspActualCost= 0.00;
                BotspEstimatedCost= 0.00;
                AddtnlCost = 0.00;
            }
            
        }
        List<CA_Sponsorship__c> sponList =[Select Name,Sponsorship_Name__c,(select Therapeutic_Area__c,Total_Cost__c,Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c
                                                                            from CA_Products__r where Cancelled__c =: falseValue and Sponsorship__c != null and Event__c =: recordId) from CA_Sponsorship__c where Cancelled__c =: falseValue and Event__c=:recordId];
        if(sponList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal SponEstimatedcost= 0.00;
            Decimal SponActualCost= 0.00;
            Decimal SponAddtnlCost= 0.00;
            
            for(CA_Sponsorship__c sp: sponList)
            {
                if(sp.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bd:sp.CA_Products__r)
                    {
                        
                            if(!String.isBlank(bd.Therapeutic_Area__c)) {
                                BrandNames.add(bd.Therapeutic_Area__c);
                            }
                        
                        // BrandspName+= bd.Brand_Name__c+', ';                        
                        SponEstimatedcost+= (bd.Sponsorship_Costs_Estimated__c != null ? bd.Sponsorship_Costs_Estimated__c : 0);
                        SponActualCost+=(bd.Sponsorship_Costs_Actual__c!= null ? bd.Sponsorship_Costs_Actual__c: 0);
                        SponAddtnlCost+=(bd.Total_Cost__c!= null ? bd.Total_Cost__c: 0);
                    }
                }                
                
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                returnDispWrapper.sponWrapper.Add(new sponListWrapper(sp.Name,sp.Sponsorship_Name__c,BrandName,SponEstimatedcost,SponActualCost, SponAddtnlCost));        
                
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                SponEstimatedcost= 0.00;
                SponActualCost= 0.00;   
                additionalCosts=0.00;
                SponAddtnlCost = 0.00;
            }
        }
        
        List<CA_Speaking_Engagement__c> spkngengList=[Select Name,Speaking_Engagement_Type__c,(select Therapeutic_Area__c,Speaking_Engagement_Costs_Actual__c,Total_Cost__c,Speaking_Engagement_Costs_Estimated__c from CA_Products__r where Cancelled__c =: falseValue and Speaking_Engagement__c != null and Event__c=:recordId) from CA_Speaking_Engagement__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(spkngengList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal spkngengEstimatedcost=0.00;
            Decimal spkngengActualCost= 0.00;
            Decimal spkngengAddtnlCost= 0.00;
            for(CA_Speaking_Engagement__c se: spkngengList)
            {
                if(se.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bnd : se.CA_Products__r)
                    {
                            if(!String.isBlank(bnd.Therapeutic_Area__c))    {
                                BrandNames.add(bnd.Therapeutic_Area__c);
                            }
                        
                        spkngengEstimatedcost+= (bnd.Speaking_Engagement_Costs_Estimated__c != null ? bnd.Speaking_Engagement_Costs_Estimated__c : 0);
                        spkngengActualCost+=(bnd.Speaking_Engagement_Costs_Actual__c!= null ? bnd.Speaking_Engagement_Costs_Actual__c: 0);
                        spkngengAddtnlCost+=(bnd.Total_Cost__c!= null ? bnd.Total_Cost__c: 0);
                    }
                    
                }                
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                returnDispWrapper.spkngengWrapper.Add(new spkngengListWrapper(se.Name,se.Speaking_Engagement_Type__c,BrandName,spkngengEstimatedcost,spkngengActualCost,spkngengAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                spkngengEstimatedcost= 0.00;
                spkngengActualCost= 0.00;
                spkngengAddtnlCost=0.00;
            }
        }
        
        List<CA_Meeting_Room__c> mtrmList=[Select Name,Meeting_Room_Name__c,(select Therapeutic_Area__c,Meeting_Room_Costs_Estimated__c,Total_Cost__c,Meeting_Room_Costs_Actual__c,Meeting_Room_Services_Cost_Actual__c,Meeting_Room_Services_Costs_Estimated__c from CA_Products__r where Cancelled__c =: falseValue and Meeting_Room__c != null and Event__c=:recordId) from CA_Meeting_Room__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(mtrmList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal mtrmEstimatedcost= 0.00;
            Decimal mtrmActualCost= 0.00;  
            Decimal mtrmSerEstimatedcost= 0.00;
            Decimal mtrmSerActualCost= 0.00;
            Decimal mtrmAddtnlCost=0.00;
            for(CA_Meeting_Room__c mtrm: mtrmList)
            {
                if(mtrm.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bndst : mtrm.CA_Products__r)
                    {
                            if(!String.isBlank(bndst.Therapeutic_Area__c))  {
                                BrandNames.add(bndst.Therapeutic_Area__c);
                            } 
                        
                        mtrmEstimatedcost+=(bndst.Meeting_Room_Costs_Estimated__c!= null ? bndst .Meeting_Room_Costs_Estimated__c: 0); 
                        mtrmActualCost+=(bndst.Meeting_Room_Costs_Actual__c != null ? bndst .Meeting_Room_Costs_Actual__c : 0); 
                        mtrmSerEstimatedcost+=(bndst.Meeting_Room_Services_Costs_Estimated__c!= null ? bndst .Meeting_Room_Services_Costs_Estimated__c: 0); 
                        mtrmSerActualCost+=(bndst.Meeting_Room_Services_Cost_Actual__c != null ? bndst .Meeting_Room_Services_Cost_Actual__c : 0);
                        mtrmAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                returnDispWrapper.MtrmWrapper.Add(new mtrmListWrapper(mtrm.Name,mtrm.Meeting_Room_Name__c,BrandName,mtrmEstimatedcost,mtrmActualCost,mtrmSerEstimatedcost,mtrmSerActualCost,mtrmAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                mtrmEstimatedcost= 0.00;
                mtrmActualCost= 0.00;
                mtrmSerEstimatedcost= 0.0;
                mtrmSerActualCost = 0.0;
                mtrmAddtnlCost=0.00;
                
            }
        } 
        List<CA_Event__c> eventList=[Select Name,Event_Name__c,(select Therapeutic_Area__c, Total_Cost__c,Event_Costs_Estimated__c,Event_Costs_Actual__c from CA_Products__r where Cancelled__c =: falseValue and Event__c != null and Event__c=:recordId) from CA_Event__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(eventList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal eventEstimatedcost= 0.00;
            Decimal eventActualCost= 0.00;  
            Decimal eventAddtnlCost= 0.00;
            for(CA_Event__c event: eventList)
            {
                if(event.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bndst : event.CA_Products__r)
                    {
                            if(!String.isBlank(bndst.Therapeutic_Area__c))  {
                                BrandNames.add(bndst.Therapeutic_Area__c);
                            }                      
                        eventEstimatedcost+=(bndst.Event_Costs_Estimated__c!= null ? bndst .Event_Costs_Estimated__c: 0); 
                        eventActualCost+=(bndst.Event_Costs_Actual__c != null ? bndst .Event_Costs_Actual__c : 0); 
                        eventAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                returnDispWrapper.eventWrapper.Add(new eventListWrapper(event.Name,event.Event_Name__c,BrandName,eventEstimatedcost,eventActualCost,eventAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                eventEstimatedcost= 0.00;
                eventActualCost= 0.00;
                eventAddtnlCost=0.00;
            }
        } 
        
        List<CA_Meeting_Planning__c> meetingPlanningList=[Select Name,Meeting_Planning_Name__c, (select Therapeutic_Area__c,Meeting_Planning_Costs_Estimated__c,Meeting_Planning_Costs_Actual__c from CA_Products__r where Cancelled__c =: falseValue and Meeting_Planning__c != null and Event__c=:recordId) from CA_Meeting_Planning__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(meetingPlanningList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal meetingPlanningEstimatedcost= 0.00;
            Decimal meetingPlanningActualCost= 0.00;  
            for(CA_Meeting_Planning__c meetingPlanning: meetingPlanningList)
            {
                if(meetingPlanning.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bndst : meetingPlanning.CA_Products__r)
                    {
                            if(!String.isBlank(bndst.Therapeutic_Area__c)){
                                BrandNames.add(bndst.Therapeutic_Area__c);
                            } 
                        
                        meetingPlanningEstimatedcost+=(bndst.Meeting_Planning_Costs_Estimated__c!= null ? bndst .Meeting_Planning_Costs_Estimated__c: 0); 
                        meetingPlanningActualCost+=(bndst.Meeting_Planning_Costs_Actual__c != null ? bndst .Meeting_Planning_Costs_Actual__c : 0); 
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                returnDispWrapper.meetingPlanningWrapper.Add(new meetingPlanningListWrapper(meetingPlanning.Id,meetingPlanning.Name, meetingPlanning.Meeting_Planning_Name__c,BrandName,meetingPlanningEstimatedcost,meetingPlanningActualCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                meetingPlanningEstimatedcost = 0.00;
                meetingPlanningActualCost = 0.00;
            }
        }
        
        system.debug(returnDispWrapper);
        return returnDispWrapper;
        
        
    }
    
    public class connectEventListWrapper {
        @AuraEnabled public String ConnectEventName{get; set;}
        @AuraEnabled public string congressName{get;set;}
         @AuraEnabled public Date congressStartDate{get; set;}
         @AuraEnabled public Date congressEndDate{get; set;} 
        @AuraEnabled public String ConnectEventLocation{get; set;}
        @AuraEnabled public Date EventStartDate{get; set;}
        @AuraEnabled public Date EventEndDate{get; set;}
        
        public connectEventListWrapper (String ConnectEventName,string congressName, String ConnectEventLocation,Date EventStartDate,Date EventEndDate) 
        {
            this.ConnectEventName= ConnectEventName;
            this.congressName=congressName;
            this.congressStartDate=congressStartDate;
            this.congressEndDate=congressEndDate;
            this.ConnectEventLocation= ConnectEventLocation;
            this.EventStartDate= EventStartDate;
            this.EventEndDate=EventEndDate;
        }
    }
    
    public class exhibitListWrapper {
        @AuraEnabled public String ExhibitId{get; set;}
        @AuraEnabled public String ExhibitName{get; set;}
        @AuraEnabled public String Brand{get; set;}
        @AuraEnabled public Decimal GESEstimatedCost{get; set;}
        @AuraEnabled public Decimal GESActualCost{get; set;}
        @AuraEnabled public Decimal BoothSpaceActualCost{get; set;}
        @AuraEnabled public Decimal BoothSpaceEstimatedCost{get; set;}
        @AuraEnabled public Decimal AdditionalCost{get; set;}
        
        
        public exhibitListWrapper (String ExhibitId,String ExhibitName,String Brand,Decimal GESEstimatedCost,Decimal GESActualCost,Decimal BoothSpaceEstimatedCost,Decimal BoothSpaceActualCost, Decimal AdditionalCost) 
        {
            this.ExhibitId= ExhibitId;
            this.ExhibitName= ExhibitName;
            this.Brand= Brand;
            this.GESEstimatedCost=GESEstimatedCost;
            this.GESActualCost=GESActualCost;
            this.BoothSpaceActualCost=BoothSpaceActualCost;
            this.BoothSpaceEstimatedCost=BoothSpaceEstimatedCost;
            this.AdditionalCost = AdditionalCost;
        }
    }
    
    public class sponListWrapper{
        @AuraEnabled public string SponId{get;set;}
        @AuraEnabled public string SponName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal BrandSponEstimatedCost{get;set;}
        @AuraEnabled public Decimal BrandSponActualCost{get;set;}
        @AuraEnabled public Decimal additonalCosts{get;set;}
        @AuraEnabled public Decimal BrandSponAddtnlCost{get;set;}
        
        public sponListWrapper(string SponId,string SponName,string BrandName,Decimal BrandSponEstimatedCost,Decimal BrandSponActualCost, Decimal BrandSponAddtnlCost){
            this.SponId= SponId;
            this.SponName= SponName;
            this.BrandName= BrandName;
            this.BrandSponEstimatedCost=BrandSponEstimatedCost;
            this.BrandSponActualCost=BrandSponActualCost;  
            this.BrandSponAddtnlCost = BrandSponAddtnlCost;
        }
    }
    
    public class spkngengListWrapper{
        @AuraEnabled public string spkngengId{get;set;}
        @AuraEnabled public string spkngengType{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal spkngengEstimatedCost{get;set;}
        @AuraEnabled public Decimal spkngengActualCost{get;set;}
        @AuraEnabled public Decimal spkngengAddtnlCost{get;set;}
        
        public spkngengListWrapper(string spkngengId,string spkngengType,string BrandName,Decimal spkngengEstimatedCost,Decimal spkngengActualCost, Decimal spkngengAddtnlCost){
            this.spkngengId= spkngengId;
            this.spkngengType= spkngengType;
            this.BrandName= BrandName;
            this.spkngengEstimatedCost=spkngengEstimatedCost;
            this.spkngengActualCost=spkngengActualCost; 
            this.spkngengAddtnlCost = spkngengAddtnlCost;
        }
    }
    
    public class mtrmListWrapper{
        @AuraEnabled public string MtrmId{get;set;}
        @AuraEnabled public string MtrmName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal MtrmEstimatedCost{get;set;}
        @AuraEnabled public Decimal MtrmActualCost{get;set;}
        @AuraEnabled public Decimal MtrmSerEstimatedCost{get;set;}
        @AuraEnabled public Decimal MtrmSerActualCost{get;set;}
        @AuraEnabled public Decimal MtrmAddtnlCost{get;set;}
        
        public mtrmListWrapper(string MtrmId,string MtrmName,string BrandName,Decimal MtrmEstimatedCost,Decimal MtrmActualCost,Decimal MtrmSerEstimatedCost,Decimal MtrmSerActualCost, Decimal MtrmAddtnlCost){
            this.MtrmId= MtrmId;
            this.MtrmName= MtrmName;
            this.BrandName= BrandName;
            this.MtrmEstimatedCost=MtrmEstimatedCost;
            this.MtrmActualCost=MtrmActualCost;  
            this.MtrmSerEstimatedCost=MtrmSerEstimatedCost;
            this.MtrmSerActualCost=MtrmSerActualCost;
            this.MtrmAddtnlCost = MtrmAddtnlCost;
        }
    }
    
    public class eventListWrapper{
        @AuraEnabled public string eventId{get;set;}
        @AuraEnabled public string eventName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal eventEstimatedCost{get;set;}
        @AuraEnabled public Decimal eventActualCost{get;set;}
        @AuraEnabled public Decimal eventAddtnlCost{get;set;}
        
        public eventListWrapper(string eventId,string eventName,string BrandName,Decimal eventEstimatedCost,Decimal eventActualCost, Decimal eventAddtnlCost){
            this.eventId= eventId;
            this.eventName= eventName;
            this.BrandName= BrandName;
            this.eventEstimatedCost=eventEstimatedCost;
            this.eventActualCost=eventActualCost;
            this.eventAddtnlCost=eventAddtnlCost;
        }
    }
    
    public class regattndonlyListWrapper{
        @AuraEnabled public string regattndonlyId{get;set;}
        @AuraEnabled public string regattndonlyName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal regattndonlyEstimatedCost{get;set;}
        @AuraEnabled public Decimal regattndonlyActualCost{get;set;}
        @AuraEnabled public Decimal regattndonlyAddtnlCost{get;set;}
        
        public regattndonlyListWrapper(string regattndonlyId,string regattndonlyName,string BrandName,Decimal regattndonlyEstimatedCost,Decimal regattndonlyActualCost, Decimal regattndonlyAddtnlCost){
            this.regattndonlyId= regattndonlyId;
            this.regattndonlyName= regattndonlyName;
            this.BrandName= BrandName;
            this.regattndonlyEstimatedCost=regattndonlyEstimatedCost;
            this.regattndonlyActualCost=regattndonlyActualCost;  
            this.regattndonlyAddtnlCost=regattndonlyAddtnlCost;
        }
    }
    
    public class meetingPlanningListWrapper{
        @AuraEnabled public string meetingPlanningId{get;set;}
        @AuraEnabled public string meetingPlanningStdName{get;set;}
        @AuraEnabled public string meetingPlanningName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal meetingPlanningEstimatedCost{get;set;}
        @AuraEnabled public Decimal meetingPlanningActualCost{get;set;}
        
        public meetingPlanningListWrapper(string meetingPlanningId,string meetingPlanningStdName, string meetingPlanningName, string BrandName,Decimal meetingPlanningEstimatedCost,Decimal meetingPlanningActualCost){
            this.meetingPlanningId= meetingPlanningId;
            this.meetingPlanningStdName= meetingPlanningStdName;
            this.meetingPlanningName = meetingPlanningName;
            this.BrandName= BrandName;
            this.meetingPlanningEstimatedCost=meetingPlanningEstimatedCost;
            this.meetingPlanningActualCost=meetingPlanningActualCost;  
        }
    }
    
    public class sportingEventListWrapper{
        @AuraEnabled public string sportingEventId{get;set;}
        @AuraEnabled public string sportingEventName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal FBActualCost{get;set;}
        @AuraEnabled public Decimal FBEstimatedCost{get;set;}
        @AuraEnabled public Decimal sportingEventEstimatedCost{get;set;}
        @AuraEnabled public Decimal sportingEventActualCost{get;set;}
        @AuraEnabled public Decimal sportingEventAddtnlCost{get;set;}
        
        public sportingEventListWrapper(string sportingEventId,string sportingEventName,string BrandName,Decimal FBActualCost,Decimal FBEstimatedCost, Decimal sportingEventEstimatedCost,Decimal sportingEventActualCost, Decimal sportingEventAddtnlCost){
            this.sportingEventId= sportingEventId;
            this.sportingEventName= sportingEventName;
            this.BrandName= BrandName;
            this.FBActualCost = FBActualCost;
            this.FBEstimatedCost = FBEstimatedCost;
            this.sportingEventEstimatedCost=sportingEventEstimatedCost;
            this.sportingEventActualCost=sportingEventActualCost;
            this.sportingEventAddtnlCost=sportingEventAddtnlCost;
        }
    }
    
    public class membershipListWrapper{
        @AuraEnabled public string membershipId{get;set;}
        @AuraEnabled public string membershipName{get;set;}
        @AuraEnabled public string BrandName{get;set;}
        @AuraEnabled public Decimal membershipEstimatedCost{get;set;}
        @AuraEnabled public Decimal membershipActualCost{get;set;}
        @AuraEnabled public Decimal membershipAddtnlCost{get;set;}
        
        public membershipListWrapper(string membershipId,string membershipName,string BrandName, Decimal membershipEstimatedCost,Decimal membershipActualCost, Decimal membershipAddtnlCost){
            this.membershipId= membershipId;
            this.membershipName= membershipName;
            this.BrandName= BrandName;
            this.membershipEstimatedCost=membershipEstimatedCost;
            this.membershipActualCost=membershipActualCost;
            this.membershipAddtnlCost=membershipAddtnlCost;
        }
    }
    
    public class totalCostListWrapper{
        @AuraEnabled public Double TotalActualCost{get;set;}
        @AuraEnabled public Double TotalEstimatedCost{get;set;}
        @AuraEnabled public Double TotalAdditionalCost{get;set;}
        
        public totalCostListWrapper(Double TotalActualCost,Double TotalEstimatedCost,Double TotalAdditionalCost){
            this.TotalActualCost= TotalActualCost;
            this.TotalEstimatedCost= TotalEstimatedCost;
            this.TotalAdditionalCost=TotalAdditionalCost;
        }
    }
    
    public class dispWrapper{
        @AuraEnabled public List<connectEventListWrapper> getConnectEventList{get;set;}
        @AuraEnabled public List<exhibitListWrapper> getExhibitList{get;set;}
        @AuraEnabled public List<sponListWrapper> sponWrapper{get;set;}
        @AuraEnabled public List<spkngengListWrapper> spkngengWrapper{get;set;}
        @AuraEnabled public List<mtrmListWrapper> MtrmWrapper{get;set;}
        @AuraEnabled public List<eventListWrapper> eventWrapper{get;set;}
        @AuraEnabled public List<regattndonlyListWrapper> regattndonlyWrapper{get;set;}
        @AuraEnabled public List<meetingPlanningListWrapper> meetingPlanningWrapper{get;set;}
        @AuraEnabled public List<sportingEventListWrapper> sportingEventWrapper{get;set;}
        @AuraEnabled public List<membershipListWrapper> membershipWrapper{get;set;}
        
        
        @AuraEnabled public List<AggregateResult> getExhibitTotalDetails{get;set;}
        @AuraEnabled public List<AggregateResult> getSponsorshipTotalDetails{get;set;} 
        @AuraEnabled public List<AggregateResult> getSpkngEngTotalDetails{get;set;} 
        @AuraEnabled public List<AggregateResult> getMtRmTotalDetails{get;set;} 
        @AuraEnabled public List<AggregateResult> getEventTotalDetails{get;set;} 
        //@AuraEnabled public List<AggregateResult> getRAonlyTotalDetails{get;set;}
        @AuraEnabled public List<AggregateResult> getMeetingPlanningTotalDetails{get;set;}
        @AuraEnabled public List<AggregateResult> getSportingEventTotalDetails{get;set;}
        @AuraEnabled public List<AggregateResult> getMembershipTotalDetails{get;set;}
        @AuraEnabled public List<AggregateResult> getAdditionalCosts{get;set;}
        @AuraEnabled public List<totalCostListWrapper> TotalCost{get;set;}
    }
    
    public Id recordId{get;set;} 
    public String programName {get; set;}
    public Generic_Template_Setting__mdt  customerNameMDT {get; set;}
    public String  customerName {get; set;}
    public List<connectEventListWrapper> connectEventwrapper {get; set;}
    public List<exhibitListWrapper> dispWrapper {get; set;}
    public List<sponListWrapper> sponWrapper {get; set;}
    public List<spkngengListWrapper> spkngengWrapper {get; set;}
    public List<mtrmListWrapper> MtrmWrapper {get; set;}
    public List<eventListWrapper> eventWrapper {get; set;}
    public List<regattndonlyListWrapper> regattndonlyWrapper {get; set;}
    public List<meetingPlanningListWrapper> meetingPlanningWrapper {get; set;}
    public List<SportingEventListWrapper> SportingEventWrapper {get; set;}
    public List<membershipListWrapper> membershipWrapper {get; set;}
    
    public List<AggregateResult> getExhibitTotalDetails {get; set;}
    public List<AggregateResult> getSponsorshipTotalDetails {get; set;} 
    public List<AggregateResult> getSpkngEngTotalDetails {get; set;} 
    public List<AggregateResult> getMtRmTotalDetails {get; set;} 
    public List<AggregateResult> getEventTotalDetails {get; set;} 
    //public List<AggregateResult> getRAonlyTotalDetails {get; set;}
    public List<AggregateResult> getMeetingPlanningTotalDetails {get; set;}
    public List<AggregateResult> getSportingEventTotalDetails {get; set;}
    public List<AggregateResult> getMembershipTotalDetails {get; set;}
    public List<AggregateResult> getAdditionalCosts{get;set;}
    public List<totalCostListWrapper> TotalCost {get; set;}
    public Boolean showAdditionalCost{get;set;}
    public CA_FinancialSummaryReportController(ApexPages.StandardController controller)
    {
        Generic_Template_Setting__mdt temp=getConnectSettings();
        Boolean falseValue = false;
        recordId =System.currentPageReference().getParameters().get('recordId'); 
        //programName = getConnectSettingsAP();
        programName ='Congress';
        customerNameMDT = getConnectSettings();
        customerName = customerNameMDT.Customer_Name__c;
        connectEventwrapper = new List<connectEventListWrapper>();
        dispWrapper = new List<exhibitListWrapper>();
        sponWrapper = new List<sponListWrapper>();
        spkngengWrapper = new List<spkngengListWrapper>();
        MtrmWrapper = new List<mtrmListWrapper>();
        eventWrapper = new List<eventListWrapper>();
        regattndonlyWrapper = new List<regattndonlyListWrapper>();
        meetingPlanningWrapper = new List<meetingPlanningListWrapper>();
        sportingEventWrapper = new List<sportingEventListWrapper>();
        membershipWrapper = new List<membershipListWrapper>();
        TotalCost = new List<totalCostListWrapper>();
        showAdditionalCost=false;
        getExhibitTotalDetails = [Select sum(GES_Costs_Actual__c)totalGESActualCost, sum(GES_Costs_Estimated__c)totalGESEstimatedCost, sum(Booth_Space_Costs_Actual__c)totalBoothActualCost, sum(Booth_Space_Costs_Estimated__c)totalBoothEstimatedCost, sum(Total_Cost__c)totalExhibitAdditional from CA_Product__c where Exhibit__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Exhibit__c != null and Event__c=:recordId];
        getSponsorshipTotalDetails = [Select sum(Sponsorship_Costs_Actual__c)totalSponsorshipActualCost, sum(Sponsorship_Costs_Estimated__c)totalSponsorshipEstimatedCost,sum(Total_Cost__c)totalSponsorshipAdditional from CA_Product__c where Sponsorship__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Sponsorship__c != null and Event__c=:recordId];
        getSpkngEngTotalDetails = [Select sum(Speaking_Engagement_Costs_Actual__c)totalSpkngEngmtActualCost, sum(Speaking_Engagement_Costs_Estimated__c)totalSpkngEngmtEstimatedCost,sum(Total_Cost__c)totalSpEgAdditional  from CA_Product__c where Speaking_Engagement__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Speaking_Engagement__c != null and Event__c=:recordId];
        getMtRmTotalDetails = [Select sum(Meeting_Room_Services_Cost_Actual__c)totalMtRmServicesActualCost,sum(Meeting_Room_Services_Costs_Estimated__c)totalMtRmServicesEstimatedCost, sum(Meeting_Room_Costs_Actual__c)totalMtRmActualCost, sum(Meeting_Room_Costs_Estimated__c)totalMtRmEstimatedCost,sum(Total_Cost__c)totalMtRmAdditional from CA_Product__c where Meeting_Room__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Meeting_Room__c != null and Event__c=:recordId];
        getEventTotalDetails = [Select sum(Event_Costs_Actual__c)totalEventActualCost, sum(Event_Costs_Estimated__c)totalEventEstimatedCost,sum(Total_Cost__c)totalEvtAdditional  from CA_Product__c where CA_Event__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Event__c != null and Event__c=:recordId];
        //getRAonlyTotalDetails = [Select sum(Reg_Attend_Cost_Actual_CrownCastle__c)totalRaOnlyActualCost, sum(Reg_Attend_Cost_Estimated_CrownCastle__c)totalRaOnlyEstimatedCost,sum(Total_Cost__c)totalRgAtAdditional from CA_Product__c where Registration_Attend_Only__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Registration_Attend_Only__c != null and Event__c=:recordId];
        getMeetingPlanningTotalDetails = [Select sum(Meeting_Planning_Costs_Actual__c)totalMeetingPlanningActualCost, sum(Meeting_Planning_Costs_Estimated__c)totalMeetingPlanningEstimatedCost,sum(Total_Cost__c)totalMtPlAdditional from CA_Product__c where Meeting_Planning__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Meeting_Planning__c != null and Event__c=:recordId];
        getSportingEventTotalDetails = [Select sum(F_B_Costs_Actual__c)totalFBActualCosts,sum(F_B_Costs_Estimated__c)totalFBEstimatedCosts,sum(Sporting_Event_Costs_Actual__c)totalSportingEventActualCost, sum(Sporting_Event_Costs_Estimated__c)totalSportingEventEstimatedCost,sum(Total_Cost__c)totalSpEvAdditional from CA_Product__c where Sporting_Event__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Sporting_Event__c != null and Event__c=:recordId];
        getMembershipTotalDetails = [Select sum(Membership_Costs_Actual__c)totalMembershipActualCost, sum(Membership_Costs_Estimated__c)totalMembershipEstimatedCost,sum(Total_Cost__c)totalMemberAdditional  from CA_Product__c where Membership__r.Cancelled__c =: falseValue and Cancelled__c =: falseValue and Membership__c != null and Event__c=:recordId];
        
        Double gesActualTotal = double.valueOf(getExhibitTotalDetails[0].get('totalGESActualCost'));
        Double exhibitActualTotal = double.valueOf(getExhibitTotalDetails[0].get('totalBoothActualCost'));
        Double sponActualTotal = double.valueOf(getSponsorshipTotalDetails[0].get('totalSponsorshipActualCost'));
        Double spkngmgmtActualTotal = double.valueOf(getSpkngEngTotalDetails[0].get('totalSpkngEngmtActualCost'));
        Double mtrmActualTotal = double.valueOf(getMtRmTotalDetails[0].get('totalMtRmActualCost'));
        Double mtrmServiceActualTotal = double.valueOf(getMtRmTotalDetails[0].get('totalMtRmServicesActualCost'));
        Double eventActualTotal = double.valueOf(getEventTotalDetails[0].get('totalEventActualCost'));
        //Double raonlyActualTotal = double.valueOf(getRAonlyTotalDetails[0].get('totalRaOnlyActualCost'));
        Double meetingPlanningActualTotal = double.valueOf(getMeetingPlanningTotalDetails[0].get('totalMeetingPlanningActualCost'));  
        Double FBActualTotal = double.valueOf(getSportingEventTotalDetails[0].get('totalFBActualCosts'));        
        Double sportingEventActualTotal = double.valueOf(getSportingEventTotalDetails[0].get('totalSportingEventActualCost'));
        Double membershipActualTotal = double.valueOf(getMembershipTotalDetails[0].get('totalMembershipActualCost'));
        
        
        Double gesEstimatedTotal = double.valueOf(getExhibitTotalDetails[0].get('totalGESEstimatedCost'));
        Double exhibitEstimatedTotal = double.valueOf(getExhibitTotalDetails[0].get('totalBoothEstimatedCost'));
        Double sponEstimatedTotal = double.valueOf(getSponsorshipTotalDetails[0].get('totalSponsorshipEstimatedCost'));
        Double spkngmgmtEstimatedTotal = double.valueOf(getSpkngEngTotalDetails[0].get('totalSpkngEngmtEstimatedCost'));
        Double mtrmEstimatedTotal = double.valueOf(getMtRmTotalDetails[0].get('totalMtRmEstimatedCost'));
        Double mtrmServiceEstimatedTotal = double.valueOf(getMtRmTotalDetails[0].get('totalMtRmServicesEstimatedCost'));
        Double eventEstimatedTotal = double.valueOf(getEventTotalDetails[0].get('totalEventEstimatedCost'));
        //Double raonlyEstimatedTotal = double.valueOf(getRAonlyTotalDetails[0].get('totalRaOnlyEstimatedCost'));
        Double meetingPlanningEstimatedTotal = double.valueOf(getMeetingPlanningTotalDetails[0].get('totalMeetingPlanningEstimatedCost'));
        Double FBEstimatedTotal = double.valueOf(getSportingEventTotalDetails[0].get('totalFBEstimatedCosts'));
        Double sportingEventEstimatedTotal = double.valueOf(getSportingEventTotalDetails[0].get('totalSportingEventEstimatedCost'));
        Double membershipEstimatedTotal = double.valueOf(getMembershipTotalDetails[0].get('totalMembershipEstimatedCost'));
        Double AdditionalCosts=0.00;
        if(temp.Customer_Name__c == 'Crown Castle')
            if(getAdditionalCosts[0].get('totalAdditionalCost') != null){
            system.debug('getAdditionalCosts[0].get(totalAdditionalCost)------------->'+getAdditionalCosts[0].get('totalAdditionalCost'));
            AdditionalCosts=double.valueOf(getAdditionalCosts[0].get('totalAdditionalCost'));
        }
        gesActualTotal = (gesActualTotal == null) ? 0 : gesActualTotal;
        exhibitActualTotal = (exhibitActualTotal == null) ? 0 : exhibitActualTotal;
        sponActualTotal =  (sponActualTotal == null) ? 0 : sponActualTotal;
        spkngmgmtActualTotal = (spkngmgmtActualTotal == null) ? 0 : spkngmgmtActualTotal;
        mtrmActualTotal = (mtrmActualTotal == null) ? 0 : mtrmActualTotal;
        mtrmServiceActualTotal = (mtrmServiceActualTotal == null) ? 0 : mtrmServiceActualTotal;
        eventActualTotal = (eventActualTotal == null) ? 0 : eventActualTotal;
        //raonlyActualTotal = (raonlyActualTotal == null) ? 0 : raonlyActualTotal;
        meetingPlanningActualTotal  = (meetingPlanningActualTotal == null) ? 0 : meetingPlanningActualTotal;
        FBActualTotal  = (FBActualTotal == null) ? 0 : FBActualTotal; 
        sportingEventActualTotal  = (sportingEventActualTotal == null) ? 0 : sportingEventActualTotal;
        membershipActualTotal  = (membershipActualTotal == null) ? 0 : membershipActualTotal;
        
        gesEstimatedTotal = gesEstimatedTotal == null ? 0 : gesEstimatedTotal;
        exhibitEstimatedTotal =  exhibitEstimatedTotal == null ? 0 : exhibitEstimatedTotal;
        sponEstimatedTotal =   sponEstimatedTotal == null ? 0 : sponEstimatedTotal;
        spkngmgmtEstimatedTotal =  spkngmgmtEstimatedTotal == null ? 0 : spkngmgmtEstimatedTotal;
        mtrmEstimatedTotal =  mtrmEstimatedTotal == null ? 0 : mtrmEstimatedTotal;
        mtrmServiceEstimatedTotal =  mtrmServiceEstimatedTotal == null ? 0 : mtrmServiceEstimatedTotal;
        eventEstimatedTotal =  eventEstimatedTotal == null ? 0 : eventEstimatedTotal;
        //raonlyEstimatedTotal =  raonlyEstimatedTotal == null ? 0 : raonlyEstimatedTotal;
        meetingPlanningEstimatedTotal =  meetingPlanningEstimatedTotal == null ? 0 : meetingPlanningEstimatedTotal;
        FBEstimatedTotal =  FBEstimatedTotal == null ? 0 : FBEstimatedTotal;
        sportingEventEstimatedTotal =  sportingEventEstimatedTotal == null ? 0 : sportingEventEstimatedTotal;
        membershipEstimatedTotal =  membershipEstimatedTotal == null ? 0 : membershipEstimatedTotal;
        
        Double TotalActualCost = gesActualTotal + exhibitActualTotal + sponActualTotal + spkngmgmtActualTotal + mtrmActualTotal + mtrmServiceActualTotal + eventActualTotal + meetingPlanningActualTotal + FBActualTotal + sportingEventActualTotal + membershipActualTotal+AdditionalCosts;
        Double TotalEstimatedCost = gesEstimatedTotal + exhibitEstimatedTotal + sponEstimatedTotal + spkngmgmtEstimatedTotal + mtrmEstimatedTotal + mtrmServiceEstimatedTotal + eventEstimatedTotal + meetingPlanningEstimatedTotal + FBEstimatedTotal + sportingEventEstimatedTotal + membershipEstimatedTotal;
        TotalCost.Add(new totalCostListWrapper(TotalActualCost,TotalEstimatedCost,AdditionalCosts));
        List<CA_Main_Event__c> connectEventList = [Select id, Name_of_Event__c, Shipping_Country__c, Shipping_City__c, Shipping_State_Province__c, Event_Start_Date__c, Event_End_Date__c from CA_Main_Event__c where id=:recordId];
        
        if(connectEventList.size() > 0)
        {
            String ConnectEventName = '';
            string congressName='';
            Date congressStartDate=system.today();
            Date congressEndDate=system.today();
            String ConnectEventLocation = '';
            Date EventStartDate = System.today();
            Date EventEndDate = System.today();
            
            for(CA_Main_Event__c cev: connectEventList)
            {
                ConnectEventName = cev.Name_of_Event__c;
                congressName='';
                List<String> Locations = new List<String>();
                string city = (cev.Shipping_City__c == null)? '': cev.Shipping_City__c;
                string state = (cev.Shipping_State_Province__c == null)? '': cev.Shipping_State_Province__c;
                string country = (cev.Shipping_Country__c == null)? '': cev.Shipping_Country__c;
                
                if(!String.isBlank(city)){
                    Locations.add(city);
                }
                if(!String.isBlank(state)){
                    Locations.add(state);
                }
                if(!String.isBlank(country)){
                    if(country != 'United States' && country != 'US' && country != 'USA') {
                        Locations.add(country);
                    }
                }
                ConnectEventLocation = String.join(Locations, ', ');
                EventStartDate = cev.Event_Start_Date__c;
                EventEndDate = cev.Event_End_Date__c;
                
                
                connectEventwrapper.Add(new connectEventListWrapper(ConnectEventName,
                                                                    congressName,
                                                                    ConnectEventLocation,                                                      
                                                                    EventStartDate,
                                                                    EventEndDate));                                                 
                ConnectEventName = '';
                congressName='';
                congressStartDate=system.today();
                congressEndDate=system.today();
                ConnectEventLocation = '';
                EventStartDate = System.today();
                EventEndDate = System.today();
            }
            
        }
        system.debug(connectEventwrapper);
        List<CA_Exhibit__c> exhibitList =[Select Name,Exhibit_Name__c,(select Therapeutic_Area__c,Therapeutic_Area_Subgroup__c,GES_Costs_Estimated__c,Total_Cost__c,GES_Costs_Actual__c,Booth_Space_Costs_Actual__c,Booth_Space_Costs_Estimated__c
                                                                       from CA_Products__r where Cancelled__c =: falseValue and Exhibit__c != null and Event__c=:recordId) from CA_Exhibit__c where Cancelled__c =: falseValue and Event__c=:recordId];
        if(exhibitList.size()>0)
        {
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal GESEstimatedCost= 0.00;
            Decimal GESActualCost= 0.00;
            Decimal BotspActualCost= 0.00;
            Decimal BotspEstimatedCost= 0.00;
            Decimal AddtnlCost = 0.00;
            
            for(CA_Exhibit__c ex: exhibitList)
            {
                system.debug('--------ex.Brands__r.size()' + ex.CA_Products__r.size());
                if(ex.CA_Products__r.size() > 0)
                {                
                    for(CA_Product__c br:ex.CA_Products__r)
                    {                        
                        
                            if(!String.isBlank(br.Therapeutic_Area__c)) {
                                BrandNames.add(br.Therapeutic_Area__c);
                            }
                        
                        GESEstimatedCost+= (br.GES_Costs_Estimated__c!= null ? br.GES_Costs_Estimated__c: 0);
                        GESActualCost+= (br.GES_Costs_Actual__c!= null ? br.GES_Costs_Actual__c: 0);  
                        BotspEstimatedCost+= (br.Booth_Space_Costs_Estimated__c!= null ? br.Booth_Space_Costs_Estimated__c: 0);
                        BotspActualCost+=(br.Booth_Space_Costs_Actual__c!= null ? br.Booth_Space_Costs_Actual__c: 0);
                        AddtnlCost += (br.Total_Cost__c!= null ? br.Total_Cost__c: 0);
                    }
                }                
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                system.debug(ex.Exhibit_Name__c+'Brand'+ex.Name+ 'List of Data '+Brand+'+++++'+BrandName+'+++++'+BotspActualCost+'+++++'+BotspEstimatedCost);        
                dispWrapper.Add(new exhibitListWrapper(ex.Name,
                                                       ex.Exhibit_Name__c,                                                      
                                                       BrandName,
                                                       GESEstimatedCost,
                                                       GESActualCost,
                                                       BotspEstimatedCost,
                                                       BotspActualCost,
                                                       AddtnlCost));                                                 
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                GESEstimatedCost= 0.00;
                GESActualCost=0.00;
                BotspActualCost= 0.00;
                BotspEstimatedCost= 0.00;
                AddtnlCost = 0.00;
            }
        }
        
        List<CA_Sponsorship__c> sponList =[Select Name,Sponsorship_Name__c,(select Therapeutic_Area__c,Therapeutic_Area_Subgroup__c,Total_Cost__c, Sponsorship_Costs_Actual__c,Sponsorship_Costs_Estimated__c
                                                                            from CA_Products__r where Cancelled__c =: falseValue and Sponsorship__c != null and Event__c =: recordId) from CA_Sponsorship__c where Cancelled__c =: falseValue and Event__c=:recordId];
        if(sponList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal SponEstimatedcost= 0.00;
            Decimal SponActualCost= 0.00;
            Decimal SponAddtnlCost = 0.00;
            for(CA_Sponsorship__c sp: sponList)
            {
                if(sp.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bd:sp.CA_Products__r)
                    {
                        
                            if(!String.isBlank(bd.Therapeutic_Area__c)) {
                                BrandNames.add(bd.Therapeutic_Area__c);
                            }
                        
                        SponEstimatedcost+= (bd.Sponsorship_Costs_Estimated__c != null ? bd.Sponsorship_Costs_Estimated__c : 0);
                        SponActualCost+=(bd.Sponsorship_Costs_Actual__c!= null ? bd.Sponsorship_Costs_Actual__c: 0);
                        SponAddtnlCost+=(bd.Total_Cost__c!= null ? bd.Total_Cost__c: 0);
                    }
                }                
                
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                sponWrapper.Add(new sponListWrapper(sp.Name,sp.Sponsorship_Name__c,BrandName,SponEstimatedcost,SponActualCost, SponAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                SponEstimatedcost= 0.00;
                SponActualCost= 0.00;  
                SponAddtnlCost = 0.00;
            }
        }
        
        List<CA_Speaking_Engagement__c> spkngengList=[Select Name,Speaking_Engagement_Type__c,(select Therapeutic_Area__c,Therapeutic_Area_Subgroup__c,Speaking_Engagement_Costs_Actual__c,Total_Cost__c,Speaking_Engagement_Costs_Estimated__c from CA_Products__r where Cancelled__c =: falseValue and Speaking_Engagement__c != null and Event__c=:recordId) from CA_Speaking_Engagement__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(spkngengList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal spkngengEstimatedcost=0.00;
            Decimal spkngengActualCost= 0.00;
            Decimal spkngengAddtnlCost= 0.00;
            for(CA_Speaking_Engagement__c se: spkngengList)
            {
                if(se.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bnd : se.CA_Products__r)
                    {
                        
                            if(!String.isBlank(bnd.Therapeutic_Area__c))    {
                                BrandNames.add(bnd.Therapeutic_Area__c);
                            }
                        
                        spkngengEstimatedcost+= (bnd.Speaking_Engagement_Costs_Estimated__c != null ? bnd.Speaking_Engagement_Costs_Estimated__c : 0);
                        spkngengActualCost+=(bnd.Speaking_Engagement_Costs_Actual__c!= null ? bnd.Speaking_Engagement_Costs_Actual__c: 0);
                        spkngengAddtnlCost+=(bnd.Total_Cost__c!= null ? bnd.Total_Cost__c: 0);
                    }
                }                
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                spkngengWrapper.Add(new spkngengListWrapper(se.Name,se.Speaking_Engagement_Type__c,BrandName,spkngengEstimatedcost,spkngengActualCost,spkngengAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                spkngengEstimatedcost= 0.00;
                spkngengActualCost= 0.00;
                spkngengAddtnlCost=0.00;
            }
        }
        
        List<CA_Meeting_Room__c> mtrmList=[Select Name,Meeting_Room_Name__c,(select Name,Therapeutic_Area__c,Therapeutic_Area_Subgroup__c,Meeting_Room_Costs_Estimated__c,Total_Cost__c,Meeting_Room_Costs_Actual__c,Meeting_Room_Services_Cost_Actual__c,Meeting_Room_Services_Costs_Estimated__c from CA_Products__r where Cancelled__c =: falseValue and Meeting_Room__c != null and Event__c=:recordId) from CA_Meeting_Room__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(mtrmList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal mtrmEstimatedcost= 0.00;
            Decimal mtrmActualCost= 0.00;  
            Decimal mtrmSerEstimatedcost= 0.00;
            Decimal mtrmSerActualCost= 0.00;
            Decimal mtrmAddtnlCost= 0.00;           
            for(CA_Meeting_Room__c mtrm: mtrmList)
            {
                if(mtrm.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bndst : mtrm.CA_Products__r)
                    {
                            if(!String.isBlank(bndst.Therapeutic_Area__c))  {
                                BrandNames.add(bndst.Therapeutic_Area__c);
                            }
                        
                        mtrmEstimatedcost+=(bndst.Meeting_Room_Costs_Estimated__c!= null ? bndst .Meeting_Room_Costs_Estimated__c: 0); 
                        mtrmActualCost+=(bndst.Meeting_Room_Costs_Actual__c != null ? bndst .Meeting_Room_Costs_Actual__c : 0); 
                        mtrmSerEstimatedcost+=(bndst.Meeting_Room_Services_Costs_Estimated__c!= null ? bndst .Meeting_Room_Services_Costs_Estimated__c: 0); 
                        mtrmSerActualCost+=(bndst.Meeting_Room_Services_Cost_Actual__c != null ? bndst .Meeting_Room_Services_Cost_Actual__c : 0);
                        mtrmAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                MtrmWrapper.Add(new mtrmListWrapper(mtrm.Name,mtrm.Meeting_Room_Name__c,BrandName,mtrmEstimatedcost,mtrmActualCost,mtrmSerEstimatedcost,mtrmSerActualCost,mtrmAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                mtrmEstimatedcost= 0.00;
                mtrmActualCost= 0.00;
                mtrmSerEstimatedcost= 0.0;
                mtrmSerActualCost = 0.0;
                mtrmAddtnlCost=0.00;
            }
        } 
        List<CA_Event__c> eventList=[Select Name,Room_Name_Number__c,(select Name,Therapeutic_Area__c,Therapeutic_Area_Subgroup__c,Total_Cost__c,Event_Costs_Estimated__c,Event_Costs_Actual__c from CA_Products__r where Cancelled__c =: falseValue and CA_Event__c != null and Event__c=:recordId) from CA_Event__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(eventList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal eventEstimatedcost= 0.00;
            Decimal eventActualCost= 0.00;  
            Decimal eventAddtnlCost= 0.00;  
            for(CA_Event__c event: eventList)
            {
                if(event.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bndst : event.CA_Products__r)
                    {
                            if(!String.isBlank(bndst.Therapeutic_Area__c))  {
                                BrandNames.add(bndst.Therapeutic_Area__c);
                            }
                                                
                        eventEstimatedcost+=(bndst.Event_Costs_Estimated__c!= null ? bndst .Event_Costs_Estimated__c: 0); 
                        eventActualCost+=(bndst.Event_Costs_Actual__c != null ? bndst .Event_Costs_Actual__c : 0); 
                        eventAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                eventWrapper.Add(new eventListWrapper(event.Name,event.Room_Name_Number__c,BrandName,eventEstimatedcost,eventActualCost,eventAddtnlCost));
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                eventEstimatedcost= 0.00;
                eventActualCost= 0.00;
                eventAddtnlCost=0.00;
            }
        } 
        
        /*
         List<GT_Reg_Attend_Only__c> regattndonlyList=[Select Name,Reg_Attend_Name__c,(select Name,Brand_Name__c,Brand_Name_Pharma__c,Total_Cost__c,Reg_Attend_Cost_Estimated_CrownCastle__c,Reg_Attend_Cost_Actual_CrownCastle__c from Brands__r where Cancelled__c =: falseValue and Registration_Attend_Only__c != null and GES_Connect_Event__c=:recordId) from GT_Reg_Attend_Only__c where Canceled__c =: falseValue and GES_Connect_Event__c=:recordId];
        
        if(regattndonlyList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal regattndonlyEstimatedcost= 0.00;
            Decimal regattndonlyActualCost= 0.00; 
            Decimal regattndonlyAddtnlCost= 0.00; 
            for(GT_Reg_Attend_Only__c regattndonly: regattndonlyList)
            {
                if(regattndonly.Brands__r.size() > 0)
                {
                    for(GT_Brand__c bndst : regattndonly.Brands__r)
                    {
                        if(customerName == 'Merck' || customerName == 'Pharma Template'){
                            if(!String.isBlank(bndst.Brand_Name_Pharma__c)) {
                                BrandNames.add(bndst.Brand_Name_Pharma__c);
                            }
                        }
                        else{
                            if(!String.isBlank(bndst.Brand_Name__c))    {
                                BrandNames.add(bndst.Brand_Name__c);
                            }
                        }
                                           
                        regattndonlyEstimatedcost+=(bndst.Reg_Attend_Cost_Estimated_CrownCastle__c!= null ? bndst .Reg_Attend_Cost_Estimated_CrownCastle__c: 0); 
                        regattndonlyActualCost+=(bndst.Reg_Attend_Cost_Actual_CrownCastle__c != null ? bndst .Reg_Attend_Cost_Actual_CrownCastle__c : 0); 
                        regattndonlyAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                regattndonlyWrapper.Add(new regattndonlyListWrapper(regattndonly.Name,regattndonly.Reg_Attend_Name__c,BrandName,regattndonlyEstimatedcost,regattndonlyActualCost,regattndonlyAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                regattndonlyEstimatedcost= 0.00;
                regattndonlyActualCost= 0.00;
                regattndonlyAddtnlCost=0.00;
            }
        }
        
        List<GT_Sporting_Event__c> sportingEventList = [Select Name,Sporting_event_Name__c,(select Name,Brand_Name__c,Brand_Name_Pharma__c,F_B_Costs_Actual__c,F_B_Costs_Estimated__c,Total_Cost__c,Sporting_Event_Costs_Estimated__c,Sporting_Event_Costs_Actual__c from Products__r where Cancelled__c =: falseValue and Sporting_Event__c != null and GES_Connect_Event__c=:recordId) from GT_Sporting_Event__c where Cancelled__c =: falseValue and GES_Connect_Event__c=:recordId];
        
        if(sportingEventList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal FBActualCosts= 0.00;
            Decimal FBEstimatedcosts= 0.00;
            Decimal sportingEventEstimatedcost= 0.00;
            Decimal sportingEventActualCost= 0.00;  
            Decimal sportingEventAddtnlCost= 0.00;  
            for(GT_Sporting_Event__c sportingEvent: sportingEventList)
            {
                if(sportingEvent.Products__r.size() > 0)
                {
                    for(GT_Brand__c bndst : sportingEvent.Products__r)
                    {
                        
                        if(customerName == 'Merck' || customerName == 'Pharma Template'){
                            if(!String.isBlank(bndst.Brand_Name_Pharma__c)) {
                                BrandNames.add(bndst.Brand_Name_Pharma__c);
                            }
                        }
                        else{
                            if(!String.isBlank(bndst.Brand_Name__c))    {
                                BrandNames.add(bndst.Brand_Name__c);
                            }
                        }
                          
                        FBActualCosts+=(bndst.F_B_Costs_Actual__c!= null ? bndst.F_B_Costs_Actual__c: 0); 
                        FBEstimatedcosts+=(bndst.F_B_Costs_Estimated__c!= null ? bndst.F_B_Costs_Estimated__c: 0); 
                        sportingEventEstimatedcost+=(bndst.Sporting_Event_Costs_Estimated__c!= null ? bndst.Sporting_Event_Costs_Estimated__c: 0); 
                        sportingEventActualCost+=(bndst.Sporting_Event_Costs_Actual__c != null ? bndst.Sporting_Event_Costs_Actual__c : 0); 
                        sportingEventAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                Brand=Brand.removeEnd(',');
                BrandName= BrandName.removeEnd(',');
                sportingEventWrapper.Add(new sportingEventListWrapper(sportingEvent.Name,sportingEvent.Sporting_event_Name__c,BrandName,FBActualCosts,FBEstimatedcosts,sportingEventEstimatedcost,sportingEventActualCost,sportingEventAddtnlCost));        
                Brand= '';
                Brands = new List<String>(); 
                BrandName= '';
                BrandNames = new List<String>();
                FBActualCosts= 0.00;
                FBEstimatedcosts= 0.00;
                sportingEventEstimatedcost= 0.00;
                sportingEventActualCost= 0.00;
                sportingEventAddtnlCost=0.00;
            }
        }
        */
        
        List<CA_Meeting_Planning__c> meetingPlanningList=[Select Name,Meeting_Planning_Name__c,(select Name,Therapeutic_Area__c,Therapeutic_Area_Subgroup__c,Meeting_Planning_Costs_Estimated__c,Meeting_Planning_Costs_Actual__c from CA_Products__r where Cancelled__c =: falseValue and Meeting_Planning__c != null and Event__c=:recordId) from CA_Meeting_Planning__c where Cancelled__c =: falseValue and Event__c=:recordId];
        
        if(meetingPlanningList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal meetingPlanningEstimatedcost= 0.00;
            Decimal meetingPlanningActualCost= 0.00;  
            for(CA_Meeting_Planning__c meetingPlanning: meetingPlanningList)
            {
                if(meetingPlanning.CA_Products__r.size() > 0)
                {
                    for(CA_Product__c bndst : meetingPlanning.CA_Products__r)
                    {
                        
                        
                            if(!String.isBlank(bndst.Therapeutic_Area__c))  {
                                BrandNames.add(bndst.Therapeutic_Area__c);
                            }
                                           
                        meetingPlanningEstimatedcost+=(bndst.Meeting_Planning_Costs_Estimated__c!= null ? bndst .Meeting_Planning_Costs_Estimated__c: 0); 
                        meetingPlanningActualCost+=(bndst.Meeting_Planning_Costs_Actual__c != null ? bndst .Meeting_Planning_Costs_Actual__c : 0); 
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                meetingPlanningWrapper.Add(new meetingPlanningListWrapper(meetingPlanning.Id,meetingPlanning.Name, meetingPlanning.Meeting_Planning_Name__c,BrandName,meetingPlanningEstimatedcost,meetingPlanningActualCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                meetingPlanningEstimatedcost= 0.00;
                meetingPlanningActualCost= 0.00;
            }
        }
        
        /*
        List<GT_Membership__c> membershipList=[Select Name,Membership_Name__c,(select Name,Brand_Name__c,Brand_Name_Pharma__c,Total_Cost__c,Membership_Costs_Estimated__c,Membership_Costs_Actual__c from Products__r where Cancelled__c =: falseValue and Membership__c != null and GES_Connect_Event__c=:recordId) from GT_Membership__c where Cancelled__c =: falseValue and GES_Connect_Event__c=:recordId];
        
        if(membershipList.size()>0)
        {            
            String Brand= '';
            List<String> Brands = new List<String>();
            List<String> BrandNames = new List<String>();
            String BrandName= '';
            Decimal membershipEstimatedcost= 0.00;
            Decimal membershipActualCost= 0.00;  
            Decimal membershipAddtnlCost = 0.00;
            for(GT_Membership__c membership: membershipList)
            {
                if(membership.Products__r.size() > 0)
                {
                    for(GT_Brand__c bndst : membership.Products__r)
                    {
                        if(customerName == 'Merck' || customerName == 'Pharma Template'){
                            if(!String.isBlank(bndst.Brand_Name_Pharma__c)) {
                                BrandNames.add(bndst.Brand_Name_Pharma__c);
                            }
                        }
                        else{
                            if(!String.isBlank(bndst.Brand_Name__c))    {
                                BrandNames.add(bndst.Brand_Name__c);
                            }
                        }
                                           
                        membershipEstimatedcost+=(bndst.Membership_Costs_Estimated__c!= null ? bndst .Membership_Costs_Estimated__c: 0); 
                        membershipActualCost+=(bndst.Membership_Costs_Actual__c != null ? bndst .Membership_Costs_Actual__c : 0); 
                        membershipAddtnlCost+=(bndst.Total_Cost__c!= null ? bndst.Total_Cost__c: 0);
                    }
                }               
                Brand = String.join(Brands, ',');   //Brand.replace('null',''); 
                BrandName= String.join(BrandNames, ', '); //BrandName.replace('null',''); 
                membershipWrapper.Add(new membershipListWrapper(membership.Name,membership.Membership_Name__c,BrandName,membershipEstimatedcost,membershipActualCost,membershipAddtnlCost));        
                Brand= '';
                Brands = new List<String>();
                BrandName= '';
                BrandNames = new List<String>();
                membershipEstimatedcost= 0.00;
                membershipActualCost= 0.00;
                membershipAddtnlCost=0.00;
            }
        }
        */
    }
    
    public String getConnectSettingsAP(){
        Id profileId = userinfo.getProfileId();
        String profileName = [SELECT Id, Name FROM Profile WHERE Id=:profileId].Name;
        String customerName = '';
        
       switch on profileName {
            when 'GC Crown Castle' {
                customerName = 'Crown Castle';
            }
            when 'GC Novo Nordisk' {
                customerName = 'Novo Nordisk';
            }
            when 'GC Pharma Template' {
                customerName = 'Pharma Template';
            }
            when 'GC Merck' {
                customerName = 'Merck';
            }
            when else {
                customerName = 'Generic Template';
            }
        }
        List<Generic_Template_Setting__mdt> customSettings = [SELECT Program_Name__c FROM Generic_Template_Setting__mdt WHERE Customer_Name__c =: customerName LIMIT 1]; 
        return customSettings[0].Program_Name__c; 
    }
}