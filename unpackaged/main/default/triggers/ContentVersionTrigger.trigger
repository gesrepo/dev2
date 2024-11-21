trigger ContentVersionTrigger on ContentVersion (after insert, after update) {
    Set<Id> setConDocIds = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();

    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        for(ContentVersion cv : Trigger.New){
            if(cv.FileType == 'SNOTE'){
                setConDocIds.add(cv.ContentDocumentId);
            } 
        }
        
        if(!setConDocIds.isEmpty()){
            for(ContentDocumentLink cdl : [select id, ContentDocumentId, linkedentityid from ContentDocumentLink where ContentDocumentId IN : setConDocIds]){
                if (cdl.linkedEntityId.getSobjectType() == Quote__c.SObjectType){
                    parentIds.add(cdl.linkedEntityId);
                }
            }
        }
        
        if(!parentIds.isEmpty()){
            ContentVersionTriggerHandler.updateTMSTable(parentIds);
        }
    }
}