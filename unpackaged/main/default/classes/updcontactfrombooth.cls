public class updcontactfrombooth{

public updcontactfrombooth(){
}

 @future
    public static void updsyncmarketo(set<id> cmliststr){
      
    
     if(cmliststr.size()>0 ){
     list<CampaignMember>  cmlist2 = new list<CampaignMember>(); 
     cmlist2 = [select Booth__c from CampaignMember where id=:cmliststr];
            set<id> boothlist = new set<id>();
            list<Oracle_Show_Booth_Contact__c> boothcontlist = new list<Oracle_Show_Booth_Contact__c>();
            list<Contact> contactlist = new list<contact>();
            
            for(CampaignMember  cm: cmlist2){
                boothlist.add(cm.Booth__c);
            }
            boothcontlist  = [select id,Contact__c,Contact__r.Sync_with_Marketo__c,Sync_with_Marketo__c from Oracle_Show_Booth_Contact__c where Oracle_Show_Booth__c =: boothlist  ];
            system.debug('boothlist---------------'+boothlist);
            
            list<Oracle_Show_Booth_Contact__c> updboothcontlist = new list<Oracle_Show_Booth_Contact__c>();
           set<id> contactlistsyncids = new set<id>();

            
            for(Oracle_Show_Booth_Contact__c obc: boothcontlist){
                obc.Sync_with_Marketo__c  = true;
                contactlistsyncids.add(obc.Contact__c);
                updboothcontlist.add(obc);
            }
            
            if(updboothcontlist.size()>0){
                update updboothcontlist;
            }
            try{
          if(contactlistsyncids.size() > 0){
     list<contact> contactlistsync  = new list<contact>();
           //contactlistsync = [select Sync_with_Marketo__c from Contact where id=:contactlistsyncids]; 
           contactlistsync = [select Sync_with_Marketo__c, LeadSource from Contact where id=:contactlistsyncids]; 
            
            list<contact> updcontact = new list<contact>();
            for(contact obc: contactlistsync){
                obc.Sync_with_Marketo__c = true; 
                obc.LeadSource = 'Exhibitor List'; // Amarab 04/12/2021 SFDC-163 Default Lead Source Field to Exhibitor List on Contact Object            
                updcontact.add(obc);
            }
            
            if(updcontact.size()>0){
            update updcontact;
            }
         }   
          } catch(exception e){}
        }
    }
 }