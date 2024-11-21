trigger BoothUploadAll on Booth_Upload__c (after update) {
    if(trigger.isUpdate){
        if(trigger.isAfter){
            generateCampaignAndCampaignMembers();
        }
    }
    
    public void generateCampaignAndCampaignMembers(){
        Booth_Upload__c booth;
        Id boothId;
        Id oppId;
        Id accId;
        for(Booth_Upload__c bu : trigger.new){
            Booth_Upload__c oldBooth = trigger.oldMap.get(bu.Id);
            if(bu.Status__c == 'Complete' && oldBooth.Status__c != 'Complete'){
                booth = bu;
                boothId = bu.Id;
                oppId = bu.Opportunity__c;
                accId = bu.Organiser_2__c;
            }
        }
        
        if(booth != null){            
            Set<Id> contactIds = new Set<Id>();
            //#336693 - map variable declaration to store contact Id and respective booth Id - 10-07-2023
            Map<Id,Id> contactIdsBoothIds = new Map<Id,Id>();
            Map<String, List<Booth_Staging__c>> bsMap = new Map<String, List<Booth_Staging__c>>();
            List<Booth_Staging__c> bsList = [select id, Account_ID__c, Contact_ID__c, Booth_ID_2__c, Booth_Upload__c from Booth_Staging__c where Account_ID__c != null AND Booth_ID_2__c != null AND Contact_ID__c != null AND Booth_Upload__c = :boothId];
            for(Booth_Staging__c bs : bsList){
                if(bsMap.get(bs.Booth_Upload__c) == null){
                    List<Booth_Staging__c> bsListTemp =  new List<Booth_Staging__c>();
                    bsListTemp.add(bs);
                    bsMap.put(bs.Booth_Upload__c, bsListTemp);
                } else {
                    List<Booth_Staging__c> bsListTemp = bsMap.get(bs.Booth_Upload__c);
                    bsListTemp.add(bs);
                    bsMap.put(bs.Booth_Upload__c, bsListTemp);
                }
                contactIds.add(bs.Contact_ID__c);
            	//#336693 - store contact Id and respective booth Id into the new map- 10-07-2023
                contactIdsBoothIds.put(bs.Contact_ID__c,bs.Booth_ID_2__c);
            }
            
            List<Contact> contactsList = [select email from Contact where id in:contactIds];
            Set<String> checkForDuplicates = new Set<String>();
            contactIds.clear();
            for(Integer i = 0; i < contactsList.size(); i++){
                if(checkForDuplicates.contains(contactsList[i].Email)){
                    //contactsList.remove(i);
                    //do nothing
                } else {
                    checkForDuplicates.add(contactsList[i].Email);
                    contactIds.add(contactsList[i].id);
                }
            }
            
            List<Opportunity> oppData = [select Name, Mth_Yr__c, Occurrence_Close_Date__c, Occurrence_Open_Date__c, Production_Location__c, SOP_Event_ID__c, Show_Name__c, YRMO__c, occurrence_city__c from Opportunity where id = :oppId AND Show_Name__c != null];
            
            if(oppData.size() > 0)
            {
                list<Contact> contactsToUpdate = new list<Contact>();   //Amarab 04/12/2021 SFDC-163 update contact lead source
                String campaignName = oppData[0].Name + ' - ' + oppData[0].SOP_Event_ID__c;

                List<Campaign> campaignList = [select id, Opportunity__c from Campaign where Name = :campaignName AND Opportunity__c = :oppId AND RecordType.Name = 'EMEA Campaign'];
                List<CampaignMember> newCampaignMembers = new List<CampaignMember>();
                system.debug(campaignList);
                system.debug(campaignList.size());
                if(campaignList.size() > 0){
                    Id campaignId = campaignList[0].Id;
                    system.debug('here');
                    for(CampaignMember cm : [select ContactId from CampaignMember where CampaignId = :campaignId]){
                        for(String c : contactIds){
                            if(c == cm.ContactId){
                                contactIds.remove(cm.ContactId);
                            }
                        }
                    }
                    
                    for(String cont : contactIds){
                        CampaignMember cm = new CampaignMember();
                        cm.CampaignId = campaignId;
                        cm.ContactId = cont;
                        cm.Exhibitor__c = accId;
                        cm.Status = 'Sent';
            			//#336693 - Avoided inner for loop to reduce the iteration - 10-07-2023
                        if(contactIdsBoothIds.get(cont) != null)
                            cm.Booth__c = contactIdsBoothIds.get(cont);
                       /* for(Booth_Staging__c bs : bsList){
                            if(cont == bs.Contact_ID__c){
                                cm.Booth__c = bs.Booth_ID_2__c;
                            }
                        }*/
                        newCampaignMembers.add(cm);
                        contactsToUpdate.add(new Contact(Id = cont, LeadSource = 'Exhibitor List'));   //Amarab 04/12/2021 SFDC-163 update contact lead source
                    }
                }
                
                if(campaignList.size() == 0){
                    Id emeaRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('EMEA Campaign').getRecordTypeId();
                    Campaign camp = new Campaign();
                    camp.Name = campaignName;
                    camp.Opportunity__c = oppData[0].Id;
                    camp.Show_City__c = oppData[0].occurrence_city__c;
                    camp.Show_Dates__c = oppData[0].YRMO__c;
                    camp.Type = 'Show';
                    camp.RecordTypeId = emeaRT;
                    insert camp;
                    campaignList.add(camp);   //Amarab 04/12/2021 SFDC-163 change campaign member status
                    
                    system.debug('new campaign' + camp);
                    system.debug('contactIds' + contactIds);
                    
                    for(String cont : contactIds){
                        CampaignMember cm = new CampaignMember();
                        /*for(Booth_Staging__c bs : bsList){
                            if(cont == bs.Contact_ID__c){
                                cm.Booth__c = bs.Booth_ID_2__c;
                            }
                        }*/
            			//#336693 - Avoided nested for loop to reduce the iteration - 10-07-2023
                        if(contactIdsBoothIds.get(cont) != null)
                            cm.Booth__c = contactIdsBoothIds.get(cont);
                        cm.CampaignId = camp.Id;
                        cm.ContactId = cont;
                        cm.Exhibitor__c = accId;
                        cm.Status = 'Sent';
                        newCampaignMembers.add(cm);
                        contactsToUpdate.add(new Contact(Id = cont, LeadSource = 'Exhibitor List'));   //Amarab 04/12/2021 SFDC-163 update contact lead source
                    }
                }
                
                system.debug('newCampaignMembersList' + newCampaignMembers);
            	//#336693 - Calling new batch class to avoid CPU Time limit exception for large imports - 10-07-2023
                if(!newCampaignMembers.isEmpty()){
                    CampaignMemberInsertBatch batch = new CampaignMemberInsertBatch(newCampaignMembers);
                    Database.executeBatch(batch, 100);
                }
                //insert newCampaignMembers;
                
                //Amarab 04/12/2021 SFDC-163 change campaign member status
                list<CampaignMemberStatus> cmslistnew = new list<CampaignMemberStatus>();          
                for(Campaign cd: campaignList)
                {
                    CampaignMemberStatus cms1 = new CampaignMemberStatus();                        
                    cms1.CampaignId = cd.id;            
                    cms1.label = 'Member';
                    
                    CampaignMemberStatus cms2 = new CampaignMemberStatus();            
                    cms2.CampaignId = cd.id;            
                    cms2.label = 'Opened';
                    
                    CampaignMemberStatus cms3 = new CampaignMemberStatus();            
                    cms3.CampaignId = cd.id;            
                    cms3.label = 'Clicked';
                    
                    CampaignMemberStatus cms4 = new CampaignMemberStatus();            
                    cms4.CampaignId = cd.id;            
                    cms4.label = 'Opted In';
                    
                    CampaignMemberStatus cms5 = new CampaignMemberStatus();            
                    cms5.CampaignId = cd.id;            
                    cms5.label = 'Downloaded';
                    
                    CampaignMemberStatus cms6 = new CampaignMemberStatus();            
                    cms6.CampaignId = cd.id;            
                    cms6.label = 'Filled Out Form';
                    
                    CampaignMemberStatus cms7 = new CampaignMemberStatus();            
                    cms7.CampaignId = cd.id;            
                    cms7.label = 'Begin Checkout';
                    
                    CampaignMemberStatus cms8 = new CampaignMemberStatus();           
                    cms8.CampaignId = cd.id;            
                    cms8.label = 'Ordered';
                    
                    CampaignMemberStatus cms9 = new CampaignMemberStatus();             
                    cms9.CampaignId = cd.id;            
                    cms9.label = 'Unsubscribed';                    
                    
                    cmslistnew.add(cms1);
                    cmslistnew.add(cms2);
                    cmslistnew.add(cms3);
                    cmslistnew.add(cms4);
                    cmslistnew.add(cms5);
                    cmslistnew.add(cms6);
                    cmslistnew.add(cms7);
                    cmslistnew.add(cms8);
                    cmslistnew.add(cms9);
                }      
                if(!cmslistnew.isEmpty()){          
                    insert cmslistnew;  
                }
                //Amarab 04/12/2021 SFDC-163 update contact lead source
                if(!contactsToUpdate.isEmpty()){
                    // update contactsToUpdate moved into batch - Najmal - #305622
                    contactsUpdateBatch batch = new contactsUpdateBatch(contactsToUpdate);
        			Database.executeBatch(batch, 100);
                    //update contactsToUpdate;
                }      
            }
        }        
    }
}