public class Create_BoothStagging {
    public Static map<Id,boolean> configure_BoothStagging(map<Id,opportunity> Booths, List<Map<String, object>> assets){
        System.debug('Inside Create_BoothStagging.configure_BoothStagging');
        Set<id> keys= Booths.keySet();
        List<Field_map__c> mapping = new List<Field_map__c>();
        map<string,Field_map__c> FM = Field_map__c.getall();
            
        map<Id,boolean> boothStatus=new map<Id,boolean>();
        List<Booth_Staging__c> BoothStagesToInsert = new List<Booth_Staging__c> ();
        
        for (Id key : keys){
            Boolean Flag=false;
            opportunity opty= Booths.get(key);
            
            for(Map<String, object> asset: assets){
                system.debug('TEST:'+FM.get('Booth_staging__c.Service_Zone___c'));
                if(asset.get(FM.get('Booth_staging__c.Service_Zone___c').Ascential_SourceField__c)==opty.Event_Code__c){
                    Flag=True;
                    Booth_Staging__c Booth_Stage= new Booth_Staging__c();
                    string Name='';
                    string Nameboard='';
                    string PostZipCode='';
                    
                    //Booth_Stage.Account_ID__c=opty.AccountId;
                    Booth_Stage.Opportunity__c=opty.id;
                    Booth_Stage.Booth_Upload__c=key;
                    Booth_Stage.Address_1__c=(string) asset.get(FM.get('Booth_staging__c.Address_1__c').Ascential_SourceField__c);
                    //Booth_Stage.Address_2__c=(string) asset.get(FM.get('Booth_staging__c.Address_2__c').Ascential_SourceField__c);
                    Booth_Stage.Stand_Number__c=(string) asset.get(FM.get('Booth_staging__c.stand_number__c').Ascential_SourceField__c);
                    Booth_Stage.Stand_Type__c=(string) asset.get(FM.get('Booth_staging__c.stand_type__c').Ascential_SourceField__c);
                    Booth_Stage.Booth_Size__c=(decimal) asset.get(FM.get('Booth_staging__c.booth_size___c').Ascential_SourceField__c);
                    Booth_Stage.Company__c=(string) asset.get(FM.get('Booth_staging__c.company___c').Ascential_SourceField__c);
                    Nameboard=(string) asset.get(FM.get('Booth_staging__c.Nameboard_Name___c').Ascential_SourceField__c);
                    if(Nameboard!= Null){
                        if(Nameboard.length()>50){
                            Booth_Stage.Nameboard_Name__c=Nameboard.left(50);  
                        }
                        else{
                            Booth_Stage.Nameboard_Name__c=Nameboard;
                        }
                    }
                    
                    Name= (string) asset.get((FM.get('Booth_staging__c.first_name___c').Ascential_SourceField__c));
                    system.debug('Create_BoothStagging Name: ' + Name);
                    if(Name!= Null){
                        //system.debug('setting up name for booth stagging');
                        Booth_Stage.First_Name__c= Name.split(' ',2)[0];
                        //system.debug(':==>First Name='+Name.split(' ',2)[0]);
                        try{
                        if(Name.split(' ',2)[1]!= Null){
                            Booth_Stage.Last_Name__c=Name.split(' ',2)[1];
                            //system.debug(':==>Last Name='+Name.split(' ',2)[1]);
                        }
                        } catch(exception e) {
                        }                        
                    }
                    
                    Booth_Stage.City__c=(string) asset.get(FM.get('Booth_staging__c.city___c').Ascential_SourceField__c);
                    Booth_Stage.State_County__c=(string) asset.get(FM.get('Booth_staging__c.state_county__c').Ascential_SourceField__c);
                    PostZipCode=(string) asset.get(FM.get('Booth_staging__c.post_zip___c').Ascential_SourceField__c);
                    if(PostZipCode!= Null){
                        if(PostZipCode.length()>15){
                            Booth_Stage.Post_Zip_Code__c=PostZipCode.left(15); 
                        }
                        else{
                            Booth_Stage.Post_Zip_Code__c=PostZipCode;
                        }
                    }
                    
                    Booth_Stage.Country__c=(string) asset.get(FM.get('Booth_staging__c.country___c').Ascential_SourceField__c);
                    Booth_Stage.Phone_Number__c=(string) asset.get(FM.get('Booth_staging__c.phone_number___c').Ascential_SourceField__c);
                    Booth_Stage.Fax__c=(string) asset.get(FM.get('Booth_staging__c.fax___c').Ascential_SourceField__c);
                    Booth_Stage.Email__c=(string) asset.get(FM.get('Booth_staging__c.email___c').Ascential_SourceField__c);
                    Booth_Stage.Website__c=(string) asset.get(FM.get('Booth_staging__c.website___c').Ascential_SourceField__c);
                    Booth_Stage.Operations_Zone__c=(string) asset.get(FM.get('Booth_staging__c.Operations_Zone___c').Ascential_SourceField__c);
                    Booth_Stage.Booth_Length__c= string.valueOf(asset.get(FM.get('Booth_staging__c.Booth_Length___c').Ascential_SourceField__c));
                    Booth_Stage.Booth_Width__c=string.valueOf(asset.get(FM.get('Booth_staging__c.Booth_Width___c').Ascential_SourceField__c));
                    Booth_Stage.Service_Zone__c=(string) asset.get(FM.get('Booth_staging__c.Service_Zone___c').Ascential_SourceField__c);
                    Booth_Stage.Open_Sides__c= Integer.valueOf(asset.get(FM.get('Booth_staging__c.Open_Sides___c').Ascential_SourceField__c));
                    Booth_Stage.Organiser_Exhibitor_Id__c=(string) asset.get(FM.get('Booth_staging__c.Organiser_Exhibitor').Ascential_SourceField__c);
                    Booth_Stage.Organiser_Order_Id__c=(string) asset.get(FM.get('Booth_staging__c.Organiser_Order_Id').Ascential_SourceField__c);                    
                    
                    BoothStagesToInsert.add(Booth_Stage);
                    
                }
                boothStatus.put(key,Flag);
            }
        }
        try{
            if(BoothStagesToInsert.size()>0){
                insert BoothStagesToInsert;
                system.debug('BoothStagesToInsert===>'+BoothStagesToInsert);
            }
            else{
                System.debug('No booth stages to insert');
            }
            
        }
        catch(DMLException e){
            system.debug('Error:'+e);
        }
        System.debug('Exiting Create_BoothStagging.configure_BoothStagging');
        return boothStatus;   
    }
}