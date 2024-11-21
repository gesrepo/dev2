trigger ShowAll on Show__c (after update) {
system.debug('inside trigger 1');
if(breakBlockticketsLoop.bvalue){ 
system.debug('breakBlockticketsLoop');

breakBlockticketsLoop.bvalue=false;   
    if (Trigger.isAfter && Trigger.isUpdate) {
    system.debug('trigger fired');
        CalculateLOB();
    }
    
  }  
    public void CalculateLOB() {
        Set<Id> showIds = new Set<Id>();
         Set<Id> newshowIds = new Set<Id>();
        for (Show__c newShow : Trigger.new) {
        system.debug('showIds---------------'+showIds);
            Show__c oldShow = Trigger.oldMap.get(newSHow.Id);
            system.debug('showIds---------------'+showIds);
        system.debug('AV_Not_Applicable__c ---------------'+newShow.AV_Not_Applicable__c+'====='+oldShow.AV_Not_Applicable__c );     
        system.debug('Housing_Not_Applicable__c ---------------'+newShow.Housing_Not_Applicable__c +'====='+oldShow.Housing_Not_Applicable__c );     
system.debug('Registration_Not_Applicable__c ---------------'+newShow.Registration_Not_Applicable__c +'====='+oldShow.Registration_Not_Applicable__c );     

            if (newShow.AV_Not_Applicable__c != oldShow.AV_Not_Applicable__c || 
                    newShow.Housing_Not_Applicable__c != oldShow.Housing_Not_Applicable__c || 
                    newShow.Registration_Not_Applicable__c != oldShow.Registration_Not_Applicable__c) {
                    system.debug('showIdsinsidefirstfortrigger---------------'+showIds);
                if (!TriggerOptimizationUtility.ShowAll_Handled.contains(newShow.Id)) {
                
                    showIds.add(newShow.Id);
                    TriggerOptimizationUtility.ShowAll_Handled.add(newShow.Id);
                }
                
            }
            else{
                    if (!TriggerOptimizationUtility.ShowAll_Handled.contains(newShow.Id)) {
                
                    newshowIds.add(newShow.Id);
                    TriggerOptimizationUtility.ShowAll_Handled.add(newShow.Id);
                }
            }
       
        }
        if(showIds.size()>0){
       system.debug('LOBDetailsCalculations---------------'+showIds);
        LOBDetailsCalculations.LOBDetailsCalculations(showIds);

        }
        if(newshowIds.size()>0){
      system.debug('NewLOBDetailsCalculations---------------'+newshowIds);

       LOBDetailsCalculations.NewLOBDetailsCalculations(newshowIds);

        }
    }
}