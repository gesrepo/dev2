trigger TriggerOnAccount on Account (after insert, after update, Before Delete,after delete) {
 
       String userName=UserInfo.getUsername();
       system.debug('**************userName from DemandTool'+userName); 
       boolean isActive=false;
       for( AccountMergeTriggerController__c accTriggerCtrl :AccountMergeTriggerController__c.getAll().values()){
               system.debug('**************accTriggerCtrl.username__C from Label'+accTriggerCtrl.username__C);
               if(userName.equalsIgnoreCase(accTriggerCtrl.username__C)){
                  
                   system.debug('************accTriggerCtrl.isActive__C'+accTriggerCtrl.isActive__C);
                   isActive=accTriggerCtrl.isActive__C;
                   break;
               }
       
       }
       
     
        
       if(isActive || Test.IsRunningTest()){
           
            AccountTriggerHandler trgHandler = new AccountTriggerHandler();
            if(trigger.isbefore && trigger.isDelete) {
                /* trgHandler.quoteUpdateOnAccountdelete(trigger.oldMap);
                 trgHandler.OpportunityUpdateOnAccountdelete(trigger.oldMap);
                 trgHandler.BoothUpdateOnAccountdelete(trigger.oldMap);
                 trgHandler.contactUpdateOnAccountdelete(trigger.oldMap);
                 trgHandler.ARcustomerUpdateOnAccountdelete(trigger.oldMap);*/
                 trgHandler.triggerControllerMethod(trigger.oldMap);
             
            }
  
        
                       
            if(trigger.isAfter && trigger.isDelete){
              //  trgHandler.CustomObjectUpdateOnAccountdelete(Trigger.old, Trigger.oldMap);
              //  trgHandler.triggerCntrlMethod(trigger.oldMap);
                
            }
            
             if(Trigger.isAfter && Trigger.isUpdate){
               for(Account acc:trigger.new){
                if(acc.id != null || Test.IsRunningTest()){
                AccountTriggerHandler.updAccountOwner(acc.id);
                }
            }
           } 
        
        }
        if(Trigger.isAfter && Trigger.isUpdate && !Isactive){
            Set<Id> setAccIDS=new Set<ID>();
            
            for(Account acc:trigger.new){
                
                /**if(trigger.newMap.get(acc.id).dunsNumber!=trigger.oldMap.get(acc.id).dunsNumber){*/
                    
                    setAccIDS.add(acc.id);
                /**}*/
            }
            if(!setAccIDS.isEmpty()|| Test.IsRunningTest()){
                
                AccountTriggerHandler.updateProcessedFlag(setAccIDS);
            }
            
     }
       /**
       AccountTriggerHandler_DUNS trgHandler_DUNS = new AccountTriggerHandler_DUNS();
        if(trigger.isAfter) {
            if(trigger.isInsert) {
                trgHandler_DUNS.updateSiteOnAccount(trigger.new, null, null, null, 'After', 'Insert');
            }
            if(trigger.isUpdate){
                trgHandler_DUNS.updateSiteOnAccount(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, 'After', 'Update');
            } 
        }*/
  
}