public without sharing class LC_CreateSTMFromContact {
    
    @AuraEnabled
    public static List<AS_Tile__c> getTilesForShowTeamMember(String projectNumber1) {
        List<AS_Tile__c> allowedTiles = new List<AS_Tile__c>();
        List<string> atShowTiles= new List<string>();
        atShowTiles.add('Tasks');
        atShowTiles.add('Orders');
        atShowTiles.add('Attendee Management');
        atShowTiles.add('Analytics');
        atShowTiles.add('Service Tickets');
        atShowTiles.add('Social Media');
        atShowTiles.add('ProofBook');
        atShowTiles.add('Exhibitors');
        atShowTiles.add('Accomodation');
        atShowTiles.add('Graphic Proofing');
        
        try{
            if(System.Label.LC_AtShowOverride.contains(UserInfo.getProfileId())){
                List<GC_Connect2_Show__c> showList=[SELECT id, name, SharePoint_Link__c, Sponsorship_Link__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber1];
                if(string.isNotBlank(showList[0].SharePoint_Link__c)){
                    atShowTiles.add('SharePoint');
                }
                if(string.isNotBlank(showList[0].Sponsorship_Link__c)){
                    atShowTiles.add('Sponsorship');
                }
                allowedTiles= [SELECT id, Name, Image_Link__c FROM AS_Tile__c WHERE (Is_Active__c=true AND Image_Link__c!=null AND Name In :atShowTiles) ORDER BY Order_Of_Display__c ];
            }else{
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                String jobNumber = '';
                stm= [SELECT id, Name, Tiles_Access__c,Connect2_Show__r.SharePoint_Link__c,Connect2_Show__r.Sponsorship_Link__c FROM GC_Show_Team_Member__c WHERE User__c=:UserInfo.getUserId() AND Connect2_Show__r.Job_Number__c=:projectNumber1 LIMIT 1];
                string[] accessGivenForTiles = stm.Tiles_Access__c.split(';');
                if(string.isNotBlank(stm.Connect2_Show__r.SharePoint_Link__c)){
                    atShowTiles.add('SharePoint');
                }
                if(string.isNotBlank(stm.Connect2_Show__r.Sponsorship_Link__c)){
                    atShowTiles.add('Sponsorship');
                }
                //system.debug('accessGivenForTiles=='+accessGivenForTiles);
                allowedTiles= [SELECT id, Name, Image_Link__c FROM AS_Tile__c WHERE  (Is_Active__c=true AND name IN :accessGivenForTiles AND Name In :atShowTiles) ORDER BY Order_Of_Display__c ];
                //system.debug('allowedTiles=='+allowedTiles);
            }
            
        }catch(exception e){
            allowedTiles = new List<AS_Tile__c>();
            system.debug('error=='+e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        
        return allowedTiles;
    }
    
    @AuraEnabled
    public static contact initializeContact(string showId){
        contact newExternalContact;
        try{
            newExternalContact= new contact(RecordTypeId=System.Label.LC_ContactTypeExternal);
            GC_Connect2_Show__c currentShow= [SELECT id, name, Opportunity_Id__c FROM GC_Connect2_Show__c WHERE id=:showId];
            Opportunity  parentOppty=[SELECT id, name, AccountId, Account.ownerId FROM Opportunity  WHERE id= :currentShow.Opportunity_Id__c];
            newExternalContact.AccountId= parentOppty.AccountId;
            newExternalContact.ownerId= parentOppty.Account.ownerId;
        }catch(exception e){
            system.debug(e.getMessage());
            system.debug(e.getStackTraceString());
        }
        return newExternalContact;
    }
    
    @AuraEnabled
    public static string saveNewContact(contact externalContact, List<string> tilesToAccess, string stmRole, string showId){
        //system.debug('externalContact==='+externalContact);
        //system.debug('listOfTiles==='+tilesToAccess);
        //system.debug('stmRole==='+stmRole);
        try{
            contact con= new contact();
            con.LastName=externalContact.LastName;
            con.FirstName=externalContact.FirstName;
            con.salutation=externalContact.salutation;
            con.AccountId=externalContact.AccountId;
            con.email=externalContact.email;
            con.phone=string.valueOf(externalContact.phone);
            con.recordtypeid=System.Label.LC_ContactTypeExternal;
            
            String profileIdForCommUser='00e40000000x34VAAQ';
            AS_Tile__c tileToGetUID=[SELECT id, name, UniqueId_Number__c from AS_Tile__c WHERE Name='Tasks'];
            String uniqueIdentifier= '_PC'+ string.valueOf(tileToGetUID.UniqueId_Number__c);
            upsert con;
            system.debug('con inserted==='+con);
            //create a customer portal user and then trigger an email to him
            User newExternalUser = new User(contactId=con.Id, username=con.Email+'_pc', firstname=con.FirstName,
                                            lastname=con.LastName, email=con.Email,communityNickname = con.LastName + uniqueIdentifier,
                                            alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)+uniqueIdentifier), profileid = profileIdForCommUser, emailencodingkey='UTF-8',
                                            languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');
            
            if(stmRole=='Show Organizer - Read Only' || stmRole=='Show Organizer'){
                newExternalUser.GC_Show_Role__c='GC Community Client'; 
            }else{
                
            }
            
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail= true;
            Database.saveresult sr = Database.insert(newExternalUser,dlo);
            String errorMesaage='';
            if (sr.isSuccess()) {
                tileToGetUID.UniqueId_Number__c = tileToGetUID.UniqueId_Number__c + 1;
                update tileToGetUID;
                // Operation was successful, so get the ID of the record that was processed and create a Show Team Member 
                GC_Show_Team_Member__c newSTM= new GC_Show_Team_Member__c();
                newSTM.Connect2_Show__c=showId;
                newSTM.User__c= newExternalUser.Id;
                newSTM.Show_Role__c= stmRole;
                newSTM.Tiles_Access__c= String.join(tilesToAccess,';');
                insert newSTM;
                //System.debug('Successfully inserted user. Account ID: ' + sr.getId());
                //System.debug('Successfully inserted newSTM: ' + newSTM.Id);
                return 'Show Team Member added successfully.';
            }
            else {
                for(Database.Error err : sr.getErrors()) {
                    errorMesaage = err.getStatusCode() + ': ' + err.getMessage();
                }
                //throw new AuraHandledException(errorMesaage);
                return errorMesaage;
            }
            
        }catch(exception e){
            //throw new AuraHandledException(e.getMessage());
            return (e.getMessage()) ;
        }
        
        
    }
    
    @AuraEnabled
    public static string getShowLinks(string showProjectNum, string tileName){
        List<GC_Connect2_Show__c> showList= new List<GC_Connect2_Show__c>();
        string result='https://www.ges.com';
        try{
            showList=[SELECT id, name, SharePoint_Link__c, Sponsorship_Link__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:showProjectNum];
            if(tileName=='Sponsorship'){
                result= showList[0].Sponsorship_Link__c;
            }else if(tileName=='SharePoint'){
                result= showList[0].SharePoint_Link__c;
            }else{
                result=result;
            }
        }catch(exception e){
            system.debug(e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException('Woops! Something went wrong.' + e.getMessage()); 
        }
        //system.debug('result==='+result);
        return result;
    }
}