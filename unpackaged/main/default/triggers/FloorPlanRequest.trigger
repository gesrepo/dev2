trigger FloorPlanRequest on Floor_Plan_Request__c (before update) {
	
    if(Trigger.isBefore && Trigger.isUpdate){
        List<Floor_Plan_Request__c> listFPR = new List<Floor_Plan_Request__c>();
        for(Floor_Plan_Request__c fpr : Trigger.New){
            if(fpr.Is_Approval_Submitted__c){
                listFPR.add(fpr);
            }
        }
        
        if(!listFPR.isEmpty()){
            FloorPlanRequestHandler.updateDueDate(listFPR);
        }
    } 
}