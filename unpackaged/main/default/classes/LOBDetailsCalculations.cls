public class LOBDetailsCalculations {

        public static void LOBDetailsCalculations(Set<Id> showIds) {
    
        List<Show__c> showUpdate = new List<Show__c>();
    
        List<Show__c> showList = [select id, AV_Not_Applicable__c, Housing_Not_Applicable__c, Registration_Not_Applicable__c from Show__c where id in :showIds];
        System.debug('Lucian:' + showIds);
        List<Opportunity> currOpps = [select id, Show_Close_Date__c, Show_End_Date_Time__c, Audio_Visual_Provider__c, Prime_Contractor__r.Name, Housing_Provider__c, Show_Name__c,
                                      Show_Occurrence__r.Show_Name__c, Registration_Provider__c, RecordType.Name, StageName, Show_Occurrence__r.Show_Close_Date__c, 
                                      Show_Occurrence__r.Show_End_Date_Time__c, Amount
                                      from Opportunity where Show_Name__c in :showIds or Show_Occurrence__r.Show_Name__c in :showIds];
        
        System.debug(currOpps.size());
        
        Map<Id, List<Opportunity>> currOppsMap = new Map<Id, List<Opportunity>>();
        for (Opportunity o : currOpps) {
            if (o.Show_Name__c != null) {
                if (!currOppsMap.containsKey(o.Show_Name__c)) {
                    currOppsMap.put(o.Show_Name__c, new List<Opportunity>());
                }
                currOppsMap.get(o.Show_Name__c).add(o);
            }
            if (o.Show_Occurrence__r.Show_Name__c != null) {
                if (!currOppsMap.containsKey(o.Show_Occurrence__r.Show_Name__c)) {
                    currOppsMap.put(o.Show_Occurrence__r.Show_Name__c, new List<Opportunity>());
                }
                currOppsMap.get(o.Show_Occurrence__r.Show_Name__c).add(o);
            }
        }
        
        List<Opportunity> AVOpp;
        List<Opportunity> HousingOpp;
        List<Opportunity> RegOpp;
        List<Opportunity> ExhOpp;
        Set<String> exhRecordTypes = new Set<String>{'Field Security-CR', 'Field Security-CV', 'Field Security-LO', 'Field Security-LPE', 'Field Security-DB','Field Security-IA','Field Security-NE','Field Security-LPM', 'Field Security-LR',
            'Field Security-TS', 'EMEA - Exhibition', 'EMEA - Floorplanning', 'Sales Rep Show Occurrence', 'EMEA - Europe', 'EMEA - Logistics', 'EMEA - Graphics', 'EMEA - Middle East', 
            'EMEA - Online Manual', 'EMEA - Specialist Lighting', 'EMEA - Venue Services', 'Master Show Occurrence', 'TS - New Business'};
        Set<String> exhRecordEMEATypes = new Set<String>{'EMEA - Exhibition', 'EMEA - Floorplanning', 'EMEA - Europe', 'EMEA - Logistics', 'EMEA - Graphics', 'EMEA - Middle East', 'EMEA - Online Manual', 'EMEA - Specialist Lighting', 'EMEA - Venue Services', 'TS - New Business'};
        Set<String> AVRecordTypes = new Set<String>{'AV - CR', 'AV - LO', 'AV - Master', 'AV - PO', 'AV - PS', 'AV - CV', 'AV - TS', 'EMEA - AV New Business', 'EMEA - AV', 'AV - DB', 'AV - IA'};
        Set<String> housingRecordTypes = new Set<String>{'US - Housing', 'EMEA – Housing'};
        Set<String> regRecordTypes = new Set<String>{'US - Registration', 'EMEA - Registration'};
        Set<String> stages = new Set<String>{'CR', 'CV', 'LO', 'LR', 'LP', 'TS', 'LPE', 'LPM', 'Won', 'Lost', 'TS - New Business', 'Closed Lost', 'DB', 'IA', 'NE'};
        for(Show__c s:showList){
            Date maxDate = Date.newInstance(2000, 1, 1);
            Date maxDate2 = Date.newInstance(2000, 1, 1);
            Date maxDate3 = Date.newInstance(2000, 1, 1);
            Date maxDate4 = Date.newInstance(2000, 1, 1);
            AVOpp = new List<Opportunity>();
            HousingOpp = new List<Opportunity>();
            RegOpp = new List<Opportunity>();
            ExhOpp = new List<Opportunity>();
            if (currOppsMap.containsKey(s.Id)) {
                for (Opportunity o : currOppsMap.get(s.Id)){
                    if(exhRecordTypes.contains(o.RecordType.Name) && stages.contains(o.StageName)){
                        ExhOpp.add(o);
                       }
                    if(AVRecordTypes.contains(o.RecordType.Name) && (stages.contains(o.StageName) || o.StageName == 'Done')){
                        AVOpp.add(o);
                    }
                    if(housingRecordTypes.contains(o.RecordType.Name) && stages.contains(o.StageName)){
                        HousingOpp.add(o);
                    }
                    if(regRecordTypes.contains(o.RecordType.Name) && stages.contains(o.StageName)){
                        RegOpp.add(o);
                    }
                }
            }
            
            // Exhibition
            s.Exhibition_Opportunity__c = null;
            s.Exhibition_Expiration_Date__c = null;
            s.Exhibition_Provider__c = null;
            s.Exhibition_Region__c = null;
            s.Exhibition_Currently_Under_Contract__c = false;
            s.Exhibition_Stage__c= null;
            s.Exhibition_Amount__c = null;
            
            for(Opportunity eo : ExhOpp){
                if(exhRecordEMEATypes.contains(eo.RecordType.Name)){
                    if(eo.Show_Close_Date__c > maxDate){
                        maxDate = eo.Show_Close_Date__c;
                        s.Exhibition_Opportunity__c = eo.id;
                        s.Exhibition_Expiration_Date__c = eo.Show_Close_Date__c;
                        s.Exhibition_Provider__c = eo.Prime_Contractor__r.Name;
                        s.Exhibition_Stage__c= eo.StageName;
                        s.Exhibition_Region__c = 'EMEA';
                        s.Exhibition_Amount__c = eo.Amount;
                        if(eo.Show_Close_Date__c > Date.today()){
                            s.Exhibition_Currently_Under_Contract__c = true;
                        } else{
                            s.Exhibition_Currently_Under_Contract__c = false;
                        }
                    }
                } else{
                    if(eo.Show_Close_Date__c > maxDate){
                        maxDate = eo.Show_Close_Date__c;
                        s.Exhibition_Opportunity__c = eo.id;
                        s.Exhibition_Expiration_Date__c = eo.Show_Close_Date__c;
                        s.Exhibition_Provider__c = eo.Prime_Contractor__r.Name;
                        s.Exhibition_Stage__c = eo.StageName;
                        s.Exhibition_Region__c = 'US';
                        s.Exhibition_Amount__c = eo.Amount;
                        if(eo.Show_Close_Date__c > Date.today()){
                            s.Exhibition_Currently_Under_Contract__c = true;
                        } else{
                            s.Exhibition_Currently_Under_Contract__c = false;
                        }
                    }
                }
            }
            
            // AV
            s.AV_Opportunity__c = null;
            s.AV_Expiration_Date__c = null;
            s.AV_Provider__c = null;
            s.AV_Region__c = null;
            s.AV_Currently_Under_Contract__c = false;
            s.AV_Stage__c= null;
            s.AV_Amount__c = null;
            if (s.AV_Not_Applicable__c == false) {
                for(Opportunity avo : AVOpp){
                    system.debug('avo..!'+avo);
                    if(avo.RecordType.Name == 'EMEA - AV New Business' || avo.RecordType.Name == 'EMEA - AV'){
                        if(avo.Show_Occurrence__r.Show_End_Date_Time__c >= maxDate2){
                            maxDate2 = date.newinstance(avo.Show_Occurrence__r.Show_End_Date_Time__c.year(), avo.Show_Occurrence__r.Show_End_Date_Time__c.month(), avo.Show_Occurrence__r.Show_End_Date_Time__c.day());
                            System.debug('maxdate2'+maxDate2);
                            s.AV_Opportunity__c = avo.id;
                            s.AV_Expiration_Date__c = date.newinstance(avo.Show_Occurrence__r.Show_End_Date_Time__c.year(), avo.Show_Occurrence__r.Show_End_Date_Time__c.month(), avo.Show_Occurrence__r.Show_End_Date_Time__c.day());
                            System.debug('av exp date'+s.AV_Expiration_Date__c);
                            s.AV_Stage__c= avo.StageName;
                            s.AV_Provider__c = avo.Audio_Visual_Provider__c;
                            s.AV_Region__c = 'EMEA';
                            s.AV_Amount__c = avo.Amount;
                            if(avo.Show_Occurrence__r.Show_End_Date_Time__c > Date.today()){
                                s.AV_Currently_Under_Contract__c = true;
                            } else{
                                s.AV_Currently_Under_Contract__c = false;
                            }
                        }
                    } else{
                        if(avo.Show_Occurrence__r.Show_Close_Date__c >= maxDate2){
                            maxDate2 = avo.Show_Occurrence__r.Show_Close_Date__c;
                            s.AV_Opportunity__c = avo.id;
                            s.AV_Expiration_Date__c = avo.Show_Occurrence__r.Show_Close_Date__c;
                            s.AV_Stage__c= avo.StageName;
                            s.AV_Provider__c = avo.Audio_Visual_Provider__c;
                            s.AV_Region__c = 'US';
                            s.AV_Amount__c = avo.Amount;
                            if(avo.Show_Occurrence__r.Show_Close_Date__c > Date.today()){
                                s.AV_Currently_Under_Contract__c = true;
                            } else{
                                s.AV_Currently_Under_Contract__c = false;
                            }
                        }
                    }
                }
            }
            
            // Housing
            s.Housing_Opportunity__c = null;
            s.Housing_Expiration_Date__c = null;
            s.Housing_Provider__c = null;
            s.Housing_Region__c = null;
            s.Housing_Currently_Under_Contract__c = false;
            s.Housing_Stage__c= null;
            s.Housing_Amount__c = null;
            if (s.Housing_Not_Applicable__c == false) {
                for(Opportunity ho : HousingOpp){
                    if(ho.RecordType.Name == 'EMEA – Housing'){
                        if(ho.Show_Occurrence__r.Show_Close_Date__c > maxDate3){
                            maxDate3 = ho.Show_Occurrence__r.Show_Close_Date__c;
                            s.Housing_Opportunity__c = ho.id;
                            s.Housing_Expiration_Date__c = ho.Show_Occurrence__r.Show_Close_Date__c;
                            s.Housing_Stage__c= ho.StageName;
                            s.Housing_Provider__c = ho.Housing_Provider__c;
                            s.Housing_Region__c = 'EMEA';
                            s.Housing_Amount__c = ho.Amount;
                            if(ho.Show_Occurrence__r.Show_Close_Date__c > Date.today()){
                                s.Housing_Currently_Under_Contract__c = true;
                            } else{
                                s.Housing_Currently_Under_Contract__c = false;
                            }
                        }
                    } else {
                        if(ho.Show_Occurrence__r.Show_Close_Date__c > maxDate3){
                            maxDate3 = ho.Show_Occurrence__r.Show_Close_Date__c;
                            s.Housing_Opportunity__c = ho.id;
                            s.Housing_Expiration_Date__c = ho.Show_Occurrence__r.Show_Close_Date__c;
                            s.Housing_Stage__c = ho.StageName;
                            s.Housing_Provider__c = ho.Housing_Provider__c;
                            s.Housing_Region__c = 'US';
                            s.Housing_Amount__c = ho.Amount;
                            if(ho.Show_Occurrence__r.Show_Close_Date__c > Date.today()){
                                s.Housing_Currently_Under_Contract__c = true;
                            } else{
                                s.Housing_Currently_Under_Contract__c = false;
                            }
                        }
                    }
                }
            }
            
            // Registration
            s.Registration_Opportunity__c = null;
            s.Registration_Expiration_Date__c = null;
            s.Registration_Provider__c = null;
            s.Registration_Region__c = null;
            s.Registration_Stage__c= null;
            s.Registration_Amount__c = null;
            s.Registration_Currently_Under_Contract__c = false;
            if (s.Registration_Not_Applicable__c == false) {
                for(Opportunity ro : RegOpp){
                    if(ro.RecordType.Name == 'EMEA - Registration'){
                        if(ro.Show_Occurrence__r.Show_Close_Date__c > maxDate4){
                            maxDate4 = ro.Show_Occurrence__r.Show_Close_Date__c;
                            s.Registration_Opportunity__c = ro.id;
                            s.Registration_Expiration_Date__c = ro.Show_Occurrence__r.Show_Close_Date__c;
                            s.Registration_Stage__c= ro.StageName;
                            s.Registration_Provider__c = ro.Registration_Provider__c;
                            s.Registration_Region__c = 'EMEA';
                            s.Registration_Amount__c = ro.Amount;
                            if(ro.Show_Occurrence__r.Show_Close_Date__c > Date.today()){
                                s.Registration_Currently_Under_Contract__c = true;
                            } else{
                                s.Registration_Currently_Under_Contract__c = false;
                            }
                        }
                    } else {
                        if(ro.Show_Occurrence__r.Show_Close_Date__c > maxDate4){
                            maxDate4 = ro.Show_Occurrence__r.Show_Close_Date__c;
                            s.Registration_Opportunity__c = ro.id;
                            s.Registration_Expiration_Date__c = ro.Show_Occurrence__r.Show_Close_Date__c;
                            s.Registration_Stage__c= ro.StageName;
                            s.Registration_Provider__c = ro.Registration_Provider__c;
                            s.Registration_Region__c = 'US';
                            s.Registration_Amount__c = ro.Amount;
                            if(ro.Show_Occurrence__r.Show_Close_Date__c > Date.today()){
                                s.Registration_Currently_Under_Contract__c = true;
                            } else{
                                s.Registration_Currently_Under_Contract__c = false;
                            }
                        } 
                    }
                }
            }
            
            showUpdate.add(s);
        }
        try{
        if(showUpdate.size() > 0){
        update showUpdate;
        }
        }catch(exception e){}
    }

  public static void NewLOBDetailsCalculations(Set<Id> showIds) {
  
     List<Show__c> showUpdate = new List<Show__c>();
      
          List<Show__c> showList = [select id, AV_Not_Applicable__c, Housing_Not_Applicable__c, Registration_Not_Applicable__c from Show__c where id in :showIds];
          System.debug('Lucian:' + showIds);
          List<Opportunity> currOpps = [select id, Show_Close_Date__c, Show_End_Date_Time__c, Audio_Visual_Provider__c, Prime_Contractor__r.Name, Housing_Provider__c, Show_Name__c,
                                        Show_Occurrence__r.Show_Name__c, Registration_Provider__c, RecordType.Name, StageName, Show_Occurrence__r.Show_Close_Date__c, 
                                        Show_Occurrence__r.Show_End_Date_Time__c, Amount
                                        from Opportunity where Show_Name__c in :showIds or Show_Occurrence__r.Show_Name__c in :showIds];
          
          
          Map<Id, List<Opportunity>> currOppsMap = new Map<Id, List<Opportunity>>();
          for (Opportunity o : currOpps) {
              if (o.Show_Name__c != null) {
                  if (!currOppsMap.containsKey(o.Show_Name__c)) {
                      currOppsMap.put(o.Show_Name__c, new List<Opportunity>());
                  }
                  currOppsMap.get(o.Show_Name__c).add(o);
              }
              if (o.Show_Occurrence__r.Show_Name__c != null) {
                  if (!currOppsMap.containsKey(o.Show_Occurrence__r.Show_Name__c)) {
                      currOppsMap.put(o.Show_Occurrence__r.Show_Name__c, new List<Opportunity>());
                  }
                  currOppsMap.get(o.Show_Occurrence__r.Show_Name__c).add(o);
              }
          }
                  List<Opportunity> ExhOpp1;
              List<Opportunity> AVOpp1;
              List<Opportunity> HousingOpp1;
              List<Opportunity> RegOpp1;
              
          Set<String> exhRecordTypes = new Set<String>{'Field Security-CR', 'Field Security-CV', 'Field Security-LO', 'Field Security-LPE', 'Field Security-DB','Field Security-IA','Field Security-NE','Field Security-LPM', 'Field Security-LR',
              'Field Security-TS', 'EMEA - Exhibition', 'EMEA - Floorplanning', 'Sales Rep Show Occurrence', 'EMEA - Europe', 'EMEA - Logistics', 'EMEA - Graphics', 'EMEA - Middle East', 
              'EMEA - Online Manual', 'EMEA - Specialist Lighting', 'EMEA - Venue Services', 'Master Show Occurrence', 'TS - New Business'};
        Set<String> exhRecordEMEATypes = new Set<String>{'EMEA - Exhibition', 'EMEA - Floorplanning', 'EMEA - Europe', 'EMEA - Logistics', 'EMEA - Graphics', 'EMEA - Middle East', 'EMEA - Online Manual', 'EMEA - Specialist Lighting', 'EMEA - Venue Services', 'TS - New Business'};
    Set<String> AVRecordTypes = new Set<String>{'AV - CR', 'AV - LO', 'AV - Master', 'AV - PO', 'AV - PS', 'AV - CV', 'AV - TS', 'EMEA - AV New Business', 'EMEA - AV', 'AV - DB', 'AV - IA'};
    Set<String> housingRecordTypes = new Set<String>{'US - Housing', 'EMEA – Housing'};
        Set<String> regRecordTypes = new Set<String>{'US - Registration', 'EMEA - Registration'};
          
          
          for(Show__c s:showList){
              Date maxDate = Date.newInstance(2000, 1, 1);
              Date maxDate2 = Date.newInstance(2000, 1, 1);
          Date maxDate3 = Date.newInstance(2000, 1, 1);
              Date maxDate4 = Date.newInstance(2000, 1, 1);
              ExhOpp1 = new List<Opportunity>();
              AVOpp1 = new List<Opportunity>();
              HousingOpp1 = new List<Opportunity>();
              RegOpp1 = new List<Opportunity>();
              if (currOppsMap.containsKey(s.Id)) {
                  for (Opportunity o : currOppsMap.get(s.Id)){
                     
                      if(exhRecordTypes.contains(o.RecordType.Name)){
                          ExhOpp1.add(o);
                         }   
                         
                         if(AVRecordTypes.contains(o.RecordType.Name) ){
              AVOpp1.add(o);
                  }
                                 
             if(housingRecordTypes.contains(o.RecordType.Name) ){
              HousingOpp1.add(o);
             }
                         
             if(regRecordTypes.contains(o.RecordType.Name) ){
               RegOpp1.add(o);
                    }
           
                  }
              }
             system.debug('ExhOpp1---------------'+ExhOpp1);
             system.debug('ExhOpp1---------------'+AVOpp1);
             system.debug('ExhOpp1---------------'+HousingOpp1);
             system.debug('ExhOpp1---------------'+RegOpp1);
             
              
              // Exhibition
              s.Exhibition_Opportunityp__c = null;             
              s.Exhibition_current_year__c = false;
              s.AV_Opportunityp__c = null;             
              s.AV_current_year__c = false;
              s.Housing_Opportunityp__c = null;             
              s.Housing_current_year__c = false;
              s.Registration_Opportunityp__c = null;             
              s.Registration_current_year__c = false;
             
             for(Opportunity eo : ExhOpp1){
             try{
             system.debug(eo.Show_Close_Date__c);
                      if(eo.Show_Close_Date__c > maxDate){
                          maxDate = eo.Show_Close_Date__c;
                          s.Exhibition_Opportunityp__c = eo.id;
                 }
                          if((eo.Show_Close_Date__c).Year() == (Date.today()).Year()){
                              s.Exhibition_current_year__c = true;
                          } 
                 }catch(exception e){}     
                 
            }
            
               for(Opportunity eo : AVOpp1){
               try{
                                              if(eo.Show_Close_Date__c > maxDate2){
                                                  maxDate2 = eo.Show_Close_Date__c;
                                                  s.AV_Opportunityp__c = eo.id;
                                                  }

                                                  if((eo.Show_Close_Date__c).Year() == (Date.today()).Year()){
                                                                                       system.debug('a2222222'+eo.Show_Close_Date__c);

                                                      s.AV_current_year__c = true;
                                                 } 
                    } catch(exception e){}                             
                    }
                    
                     for(Opportunity eo : HousingOpp1){
                     try{
                                             system.debug(eo.Show_Close_Date__c);
                                                      if(eo.Show_Close_Date__c > maxDate3){
                                                          maxDate3 = eo.Show_Close_Date__c;
                                                          s.Housing_Opportunityp__c = eo.id;
                                                 }
                                                          if((eo.Show_Close_Date__c).Year() == (Date.today()).Year()){
                                                          
                                                              s.Housing_current_year__c = true;
                                                          } 
                         } catch(exception e){}                          
                                                 
                    }
                    for(Opportunity eo : RegOpp1){
                    try{
                                                     system.debug(eo.Show_Close_Date__c);
                                                              if(eo.Show_Close_Date__c > maxDate4){
                                                                  maxDate4 = eo.Show_Close_Date__c;
                                                                  s.Registration_Opportunityp__c = eo.id;
                                                      }
                                                                  if((eo.Show_Close_Date__c).Year() == (Date.today()).Year()){
                                                                  
                                                                      s.Registration_current_year__c = true;
                                                                  } 
                                                           
                     }catch(exception e){}                                    
            }
  
  showUpdate.add(s);
              system.debug('opppp'+s);
          }
          system.debug('showupdatesize'+showUpdate.size());
        update showUpdate;
    
  }   
}