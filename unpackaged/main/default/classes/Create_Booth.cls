public class Create_Booth {
    public Static map<id,opportunity> create_BoothUpload(List<opportunity> optys){
        System.debug('Inside Create_Booth.create_BoothUpload');
        map<id,opportunity> Booths=new map<id,opportunity> ();
        list<Booth_Upload__c> BoothsToInsert= new list<Booth_Upload__c> ();
        for (opportunity opty: optys){ 
            Booth_Upload__c Booth= new Booth_Upload__c();
            Booth.Opportunity__c=opty.id;
            Booth.Organiser_2__c=opty.AccountId;
            Booth.Status__c='Incomplete';
            BoothsToInsert.add(Booth);            
        }
        System.debug('Test1');
        try{
            if(BoothsToInsert.size()>0 && !Test.isRunningTest()){
                try{
                    insert BoothsToInsert;
                    System.debug('Booth inserted=====>'+BoothsToInsert);
                }
                catch(DMLexception e){
                    System.debug('Error in Booth insertion=====>'+e);
                }
            }
            else{
                System.debug('No booth uploads to insert');
            }
            
        }
        catch(DMLException e){
            system.debug('Error:'+e);
        }
        
        for(opportunity opty: optys){
            opty.Last_Run_Date__c=date.today();
        }
        
        try{
            if(optys.size()>0){
                update optys;
                System.debug('opportunity update===>'+optys);
            }
            else{
                System.debug('No opportunity to update');
            }
            
        }
        catch(DMLException e){
            system.debug('Error:'+e);
        }
        
        for (Booth_Upload__c Booth: BoothsToInsert){
            for (opportunity opty: optys){
                if(Booth.Opportunity__c==opty.id){
                    Booths.put(Booth.Id,opty);
                }
            }
        }
        System.debug('Exiting Create_Booth.create_BoothUpload');
        return Booths;        
    }
    
    public Static void update_BoothUpload(map<Id,boolean> boothStatus){
        System.debug('Inside Create_Booth.update_BoothUpload');
        Set<id> keys= boothStatus.keySet();
        list<Booth_Upload__c> BoothsToUpdate= new list<Booth_Upload__c> ();
        for (Id key : keys){
            Booth_Upload__c Booth= new Booth_Upload__c();
            Booth.id= Key;
            
            if(boothStatus.get(key)){
                Booth.Status__c='Incomplete';
            }
            else{
                Booth.Status__c='Cancel';
            }
            BoothsToUpdate.add(Booth);
            system.debug(Booth);
        }
        
        try{
            if(BoothsToUpdate.size()>0){
                update BoothsToUpdate;
            }
            else{
                System.debug('No booth uploads to update');
            }
        }
        catch(DMLException e){
            system.debug('Error:'+e);
        }
        System.debug('Exiting Create_Booth.update_BoothUpload');
    }
}