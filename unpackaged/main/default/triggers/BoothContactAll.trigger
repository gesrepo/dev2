trigger BoothContactAll on Oracle_Show_Booth_Contact__c (after insert, after update, after delete, after undelete) {
    
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            BoothContactTriggerHandler.afterInsert(Trigger.new);
        }
        else if(Trigger.isUpdate){
            BoothContactTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    /*
    insertCampaignMember();
    
    public void insertCampaignMember(){
        
        Set<Id> bset = new Set<Id>();
        Set<Id> bcset = new Set<Id>();
        system.debug('trigger.new---------------'+trigger.new.size());
        for (Oracle_Show_Booth_Contact__c bc : trigger.new){
            if (bc.Email__c != null && !bc.Email__c.toUpperCase().contains('@GES')){
                bset.add(bc.Oracle_Show_Booth__c);
                bcset.add(bc.Id);
            }
        }
        
        system.debug('bset-----Oracle_Show_Booth__c--------------'+bset.size());
        system.debug('bset------Oracle_Show_Booth__c-------------'+bset);
         system.debug('bcset----Oracle_Show_Booth_Contact__c ---------------'+bcset.size());
        system.debug('bcset------Oracle_Show_Booth_Contact__c -------------'+bcset);
        List<Oracle_Show_Booth_Contact__c> bclist = new List<Oracle_Show_Booth_Contact__c>();
        Map<String, String> bcmap = new Map<String, String>();
        Map<Id, Id> bcmap2 = new Map<Id, Id>();
        
        //create booth contact list for the newly inserted records
        bclist = [SELECT Id, Inactive__c, Oracle_Show_Booth__c, CreatedBy.Firstname, Oracle_Show_Booth__r.Inactive_Flag__c, Oracle_Show_Booth__r.Show_Occurrence__c, Oracle_Show_Booth__r.Show_Occurrence__r.Job_Number__c, Contact__r.Id, Oracle_Show_Booth__r.Account__c, 
                  Oracle_Show_Booth__r.Account__r.Type, Contact__r.HasOptedOutOfEmail, Contact__r.Owner.Alias, Contact__r.Inactive__c,Contact__r.Account.Inactive__c  FROM Oracle_Show_Booth_Contact__c WHERE Id IN : bcset];
       system.debug('bclist ------Oracle_Show_Booth_Contact__c -------------'+bclist.size());
        for (Oracle_Show_Booth_Contact__c bcindex : bclist){
            
            //If booth contact is not associated to a booth, then skip it
            if (bcindex.Oracle_Show_Booth__c != null){
                //Verify if the associated booth is tied to a show opportunity. In addition, if it is associated to an account, make sure the account type is not EE
                if ((bcindex.Oracle_Show_Booth__r.Show_Occurrence__c != null) && ((bcindex.Oracle_Show_Booth__r.Account__c == null) || ((bcindex.Oracle_Show_Booth__r.Account__c != null) && (bcindex.Oracle_Show_Booth__r.Account__r.Type == null || (bcindex.Oracle_Show_Booth__r.Account__r.Type != null && bcindex.Oracle_Show_Booth__r.Account__r.Type.toUpperCase() != 'EE'))))){
                    //Opportunity associated to the booth contact must have a job number and must also be associated to a Contact
                    if ((bcindex.Oracle_Show_Booth__r.Show_Occurrence__r.Job_Number__c != null) && (bcindex.Contact__c != null)){
                        //Exclude record if associated contact email opt out is true or contact record is not owned by CorpAcct. Also exclude booth contact if associated contact is inactive or account associated to contact is inactive
                        //Added condition to exclude booth contact record if it is inactive or if it's associated booth is inactive
                        //if ( (bcindex.Inactive__c == false) && (bcindex.Oracle_Show_Booth__r.Inactive_Flag__c == false) && (bcindex.Contact__r.HasOptedOutOfEmail == false) && (bcindex.Contact__r.Owner.Alias == null || (bcindex.Contact__r.Owner.Alias != null && bcindex.CreatedBy.Firstname == 'Corporate Accounts')) && (bcindex.Contact__r.Inactive__c == false) && (bcindex.Contact__r.Account.Inactive__c == false)) {
                        if ( (bcindex.Inactive__c == false) && 
                        (bcindex.Oracle_Show_Booth__r.Inactive_Flag__c == false) && 
                        (bcindex.Contact__r.HasOptedOutOfEmail == false) && 
                            (bcindex.Contact__r.Owner.Alias == null || 
                            (bcindex.Contact__r.Owner.Alias != null && 
                            bcindex.CreatedBy.Firstname == 'Corporate Accounts')) && 
                            //bcindex.CreatedBy.Firstname == 'Exhibitor List')) && //Amarab 04/12/2021 SFDC-149 change Interface User First Name Last Name
                        (bcindex.Contact__r.Inactive__c == false) && 
                        (bcindex.Contact__r.Account.Inactive__c == false)) {
                            
                            //create map with 'booth contact id ~ contact id' as key, where the job number is stored
                            bcmap.put(bcindex.Id + '~' + bcindex.Contact__r.Id, bcindex.Oracle_Show_Booth__r.Show_Occurrence__r.Job_Number__c);
                            
                            //create map with booth contact id as key, where the booth id is stored
                            bcmap2.put(bcindex.Id, bcindex.Oracle_Show_Booth__c);
                        }
                        else
                            bset.remove(bcindex.Oracle_Show_Booth__c);
                    }
                }
            }
        }
        
        system.debug('bset------------------------'+bset.size());
        system.debug('bset------------------------'+bset);
        //create list that contains the booths associated with the newly created booth contacts
        List<Oracle_Show_Booth__c> blist = new List<Oracle_Show_Booth__c>();
        blist = [SELECT Id, Show_Occurrence__r.Job_Number__c, Account__c, Account__r.Type FROM Oracle_Show_Booth__c WHERE Id IN : bset];
         //system.debug('blist -----------------'+blist.size()); 
          //system.debug('blist -----------------'+blist); 
           //system.debug('blist account -----------------'+blist[0].Account__c); 
            //system.debug('blist account type-----------------'+blist[0].Account__r.Type ); 
            //system.debug('blist job number -----------------'+blist[0].Show_Occurrence__r.Job_Number__c ); 
        Set<String> oset = new Set<String>();
        String helpvar;
        for (Oracle_Show_Booth__c bindex : blist){
            
            //System.debug('Booth selected (blist) - Booth Id: ' + bindex.Id);
            
            if ((bindex.Account__c == null) || ((bindex.Account__c != null) && (bindex.Account__r.Type != 'EE'))){
                //create a set that contains the opportunity job numbers, from the booth list
                oset.add(bindex.Show_Occurrence__r.Job_Number__c);
                
                //save the current job number in a variable. This is needed to help dinamically build the query for the matching campaings by job number.
                helpvar = bindex.Show_Occurrence__r.Job_Number__c;
            }
        }
       system.debug('helpvar -----------------'+helpvar );
       system.debug('oset-----------------'+oset.size()); 
       system.debug('oset-----------------'+oset); 
       
         Set<String> osetnew = new Set<String>(oset);
        for(String ss: oset){
        if(ss != null){
        osetnew.add(ss);
          }
        }
       
        
        //remove the vriable from the created set
        oset.remove(helpvar);   
        
        
        List<Campaign> clist = new List<Campaign>();
        String s = null;
        
        //dynamic query to find campaigns that have names containing the job numbers
        
        //if at least one job number is found, first query on the variable
        if (helpvar != null)
            s = 'SELECT Id, Name FROM Campaign WHERE Status != \'Completed\' AND (Name LIKE \'%' + helpvar + '%\'';
        
        //continue building the dynamic query with the other job numbers from the set
        if(oset.size() > 0)  //updated on 20 march to to avoid QueryException
        for (String sindex : oset)
            s = s + 'OR Name LIKE \'%' + sindex + '%\'';
        if (s != null)
            s = s + ')';
        
        //execute query, a list of campaign is returned  
        if (s != null)  
            clist = database.query(s);
        Set<Id> cset = new Set<Id>();
        
        Set<String> campnames = new Set<String>();
        
        //a set of campaign ids is built
        for (Campaign cindex : clist) {
            campnames.add(cindex.name);
            cset.add(cindex.Id);
        }
        
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);    
        String seperate = '@-'+'-@'+h;
        String ustr = '';
        
        for(string sw : campnames)
        {
            ustr += sw+seperate;
        }
         system.debug('osetnew--------------------------'+osetnew.size());
        system.debug('osetnew--------------------------'+osetnew);
        list<string> osetnewres = new list<string>();
        if(osetnew != null){
        for(string si: osetnew){
         if(si  != null){  
            if(ustr.contains(si) == false){
            osetnewres.add(si);
            }
           }  
         }   
        //get Opportunity based on jobnumber
        list<Opportunity> jobopplist = [select id,Job_Number__c,occurrence_city__c,YRMO__c,Show_Name__r.id,Show_ID_LMS_Calculated__c,Show_Name_Calculated__c from Opportunity where Job_Number__c=:osetnewres];

        Map<string,Opportunity> jobopp = new Map<string,Opportunity>();
        for(Opportunity si: jobopplist){
            jobopp.put(si.Job_Number__c,si);     
        }
        list<Campaign> camplist = new list<Campaign>();
        for(string si: osetnewres){
           
                Id edmcRT = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('ED Marketing Campaigns').getRecordTypeId();
                Campaign camp = new Campaign();
                camp.Name = jobopp.get(si).YRMO__c+'_'+jobopp.get(si).Show_ID_LMS_Calculated__c+'_'+si;
                camp.Exhibition_Opportunity__c = jobopp.get(si).Id;
                camp.Show_ID__c = jobopp.get(si).Show_ID_LMS_Calculated__c;
                camp.Show_Name__c = jobopp.get(si).Show_Name_Calculated__c;
                camp.Show_City__c =  jobopp.get(si).occurrence_city__c;
                camp.Show_Dates__c =jobopp.get(si).YRMO__c;
                camp.Type = 'Direct Marketing';
                camp.IsActive = true;
                camp.GES_Show__c = true;
                camp.Marketing_Campaign__c = true;
                
                camp.Line_Of_Business__c = 'Exhibits'; // updated on 20 march to insert line of business default value "Exhibits"
                camp.Region__c = 'AMER';  // updated on 20 march to insert region default value "AMER"
                
                camp.RecordTypeId = edmcRT;
                camplist.add(camp);
                
            
        }
        
        insert camplist;         
        list<CampaignMemberStatus> cmslistnew = new list<CampaignMemberStatus>();  
        
        for(Campaign cd: camplist){
            cset.add(cd.id);
            clist.add(cd);       
            /*CampaignMemberStatus cms = new CampaignMemberStatus();  
                      
            cms.CampaignId = cd.id;  
                      
            cms.label = 'Attending';
            
            CampaignMemberStatus cms1 = new CampaignMemberStatus();    
                    
            cms1.CampaignId = cd.id;  
                      
            cms1.label = 'Attended';
            
            CampaignMemberStatus cms2 = new CampaignMemberStatus();  
                      
            cms2.CampaignId = cd.id;   
                     
            cms2.label = 'Download';
            
            CampaignMemberStatus cms3 = new CampaignMemberStatus();    
                    
            cms3.CampaignId = cd.id;  
                      
            cms3.label = 'Not Attending';
            
            CampaignMemberStatus cms4 = new CampaignMemberStatus();       
                 
            cms4.CampaignId = cd.id;   
                     
            cms4.label = 'Open';
            
            CampaignMemberStatus cms5 = new CampaignMemberStatus();  
                      
            cms5.CampaignId = cd.id;     
                   
            cms5.label = 'Registered';
            
            CampaignMemberStatus cms6 = new CampaignMemberStatus();   
                     
            cms6.CampaignId = cd.id;    
                    
            cms6.label = 'Responded';
            
            CampaignMemberStatus cms7 = new CampaignMemberStatus();   
                     
            cms7.CampaignId = cd.id;  
                      
            cms7.label = 'Unsubscribed';

            CampaignMemberStatus cms8 = new CampaignMemberStatus(); // updated on 20 march to add new campaignMemberstatus value"Did not open"      
                  
            cms8.CampaignId = cd.id;   
                     
            cms8.label = 'Did not open';

            CampaignMemberStatus cms9 = new CampaignMemberStatus(); // updated on 20 march to add new campaignMemberstatus value"Ordered" 
                       
            cms9.CampaignId = cd.id;     
                   
            cms9.label = 'Ordered';         
            
            CampaignMemberStatus cms10 = new CampaignMemberStatus();       
                 
            cms10.CampaignId = cd.id;            
            
            cms10.label = 'Visited Booth'; -Internal comment block end  //Amarab 04/12/2021 SFDC-163 change campaign member status
            
            CampaignMemberStatus cms = new CampaignMemberStatus();                        
            cms.CampaignId = cd.id;            
            cms.label = 'Member';
            
            /*CampaignMemberStatus cms1 = new CampaignMemberStatus();            
            cms1.CampaignId = cd.id;            
            cms1.label = 'Sent'; -Internal comment block end //Added by default 
            
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
                        
            cmslistnew.add(cms);
            //cmslistnew.add(cms1);
            cmslistnew.add(cms2);
            cmslistnew.add(cms3);
            cmslistnew.add(cms4);
            cmslistnew.add(cms5);
            cmslistnew.add(cms6);
            cmslistnew.add(cms7);
            cmslistnew.add(cms8); // updated on 20 march to add new campaignMemberstatus value"Ordered"
            cmslistnew.add(cms9);  // updated on 20 march to add new campaignMemberstatus value"Ordered"
            //cmslistnew.add(cms10);    //Amarab 04/12/2021 SFDC-163 change campaign member status     
                                     
        } 
               
        insert cmslistnew;
     }
        List<CampaignMember> cmlist = new List<CampaignMember>();
        Map<String, Set<Id>> cmmap = new Map<String, Set<Id>>();
        
        system.debug('cset--------------------'+cset);
        //retrieve the campaign members from the campaigns found
        cmlist = [SELECT Id, ContactId, CampaignId, Campaign.Name FROM CampaignMember WHERE CampaignId IN : cset];
        
        //build map that contains 'campaign id ~ campaign name' as key, which points to a set of contact ids for the campaign members under the particular campaign
        for (CampaignMember cmindex : cmlist){
            if (!cmmap.containsKey(cmindex.CampaignId + '~' + cmindex.Campaign.Name))
                cmmap.put(cmindex.CampaignId + '~' + cmindex.Campaign.Name, new Set<Id>{cmindex.ContactId});
            else
                cmmap.get(cmindex.CampaignId + '~' + cmindex.Campaign.Name).add(cmindex.ContactId);
        }
        
        //if the campaign has no campaign members, build a map with an empty set
        for (Campaign cindex : clist){
            
            //System.debug('Campaign (clist): ' + cindex);
            
            if (!cmmap.containsKey(cindex.Id + '~' + cindex.Name))
                cmmap.put(cindex.Id + '~' + cindex.Name, new Set<Id>());
        }
        
        List<CampaignMember> cmlist2 = new List<CampaignMember>();
        
        //go through the keys from the campaign map
        for (String cmindex : cmmap.keySet()){
            
            //System.debug('Campaign (cmmap): ' + cmindex);
            
            //go through the keys from the booth contact map
            for (String bcindex : bcmap.keySet()){
                
                //if the campaign name from the campaign map key contains the job number value from the booth contact map AND the set defined by the campaign map does not contain the contact id from the booth contact map, create new campaign member
                if ((cmindex.substringAfter('~').toUpperCase().contains(bcmap.get(bcindex).toUpperCase())) && (!cmmap.get(cmindex).contains(bcindex.substringAfter('~')))){
                    CampaignMember cm = new CampaignMember(ContactId = bcindex.substringAfter('~'), Status='Sent', Booth__c = bcmap2.get(bcindex.substringBefore('~')), CampaignId = cmindex.substringBefore('~'));
                    cmlist2.add(cm);
                }
            }
        }
        
        System.debug('Count of campaign members to be inserted (cmlist2): ' + cmlist2.size());
        
        Database.SaveResult[] cmInsertResult = Database.insert(cmlist2, false);
        
        Integer RecordCount = 0;
        
        for(Database.SaveResult sr : cmInsertResult)
        {
            if (!sr.isSuccess()) {
                System.debug('Unable to add booth contact as campaign member.');
                
                for(Database.Error e : sr.getErrors()) {
                    System.debug(' ' + 'Error Code: ' + e.getStatusCode() + ' Error Message: ' + e.getMessage() + ' Affected fields: ' + e.getFields());
                }
            }
            else
            {
                System.debug('Inserted campaign member. Campaign Id: ' + cmlist2[RecordCount].CampaignId + ' Contact Id: ' + cmlist2[RecordCount].ContactId);
                
            }
            
            RecordCount += 1;
        }
        
        set<id> cmliststr = new set<id>();
        if(cmlist2.size()>0 ){
          
            for(CampaignMember  cm: cmlist2){
                cmliststr.add(cm.id);
            }
          if(cmliststr.size()>0){
             if(!system.isFuture() && !system.isBatch() && !Test.isRunningTest()){ 
        
    
           updcontactfrombooth.updsyncmarketo(cmliststr);
           }
           }
        }
        
    }
    */
   
}