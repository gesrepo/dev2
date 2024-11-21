public class GC_EmailUtils {
    
    public class FileAttachmentsWrapper {
        public Id ParentId;
        public ContentVersion contentVer;
        public String Name;
        public Blob Body;
    }
    
    public static Map<Id, List<Messaging.Emailfileattachment>> getFileAttchmentsForMultiple(Set<Id> setParentIds) {
        List<FileAttachmentsWrapper> listAttachment = new List<FileAttachmentsWrapper>();
        Map<Id, List<FileAttachmentsWrapper>> mapAttachmentsToParent= new Map<Id, List<FileAttachmentsWrapper>>();
        Map<Id, Id> mapContentDocId = new Map<Id, Id>();
        Map<Id, List<Messaging.Emailfileattachment>> mapEmailFileAttchToParent = new Map<Id, List<Messaging.Emailfileattachment>> ();
        List<ContentDocumentLink> listContentDocument = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: setParentIds];
        for(ContentDocumentLink cdl : listContentDocument) {
            mapContentDocId.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
        }
        system.debug('mapContentDocId==='+mapContentDocId.keyset().size());
        try{
            for(ContentVersion contentVersion_2 : [SELECT Id, Title, versionData, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: mapContentDocId.keySet()]) {
                FileAttachmentsWrapper att = new FileAttachmentsWrapper();
                Id parentId = mapContentDocId.get(contentVersion_2.ContentDocumentId);
                att.parentId = parentId;
                att.Body = contentVersion_2.versionData;
                att.Name = contentVersion_2.Title;
                listAttachment.add(att);
                if(!mapAttachmentsToParent.containsKey(parentId)){
                    mapAttachmentsToParent.put(parentId,new List<FileAttachmentsWrapper>());
                }
                mapAttachmentsToParent.get(parentId).add(att);
            }
            system.debug('mapAttachmentsToParent==='+mapAttachmentsToParent.keyset());
            for(Id parentID: setParentIds){ 
                //system.debug('parentID2==='+parentID);
                if(!mapEmailFileAttchToParent.containsKey(parentID)){
                    mapEmailFileAttchToParent.put(parentID, new List<Messaging.Emailfileattachment>());
                }
                for(FileAttachmentsWrapper a : mapAttachmentsToParent.get(parentID)) {
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    efa.setFileName(a.Name);
                    efa.setBody(a.Body);
                    mapEmailFileAttchToParent.get(parentID).add(efa);
                    
                }
            }   
        }catch(exception e){
            system.debug('error==='+e.getMessage());
            system.debug('error occurred==='+e.getStacktraceString());
        }
        
    
        return mapEmailFileAttchToParent;
        
        //return listAttachment;
    }
    
    public static List<Messaging.Emailfileattachment> getFileAttchmentsForSingle(Id recordId){
        Set<Id> setParentId= new Set<Id>();
        setParentId.add(recordId);
        Map<Id, List<Messaging.Emailfileattachment>> fileAttachments= new Map<Id, List<Messaging.Emailfileattachment>>();
        fileAttachments=getFileAttchmentsForMultiple(setParentId);
        List<Messaging.Emailfileattachment> allFiles= new List<Messaging.Emailfileattachment>();
        allFiles.addAll(fileAttachments.get(recordId));
        
        return allFiles;
    }
    
    public static Map<Id, List<ContentVersion>> getContentDocs(Set<Id> setParentIds) {
        Map<Id, Id> mapContentDocId = new Map<Id, Id>();
        Map<Id, List<ContentVersion>> result = new Map<Id, List<ContentVersion>>();
        List<ContentDocumentLink> listContentDocument = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: setParentIds];
        for(ContentDocumentLink cdl : listContentDocument) {
            mapContentDocId.put(cdl.ContentDocumentId, cdl.LinkedEntityId);
        }
         try{
            for(ContentVersion contentVersion_2 : [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN: mapContentDocId.keySet()]){
                Id parentId = mapContentDocId.get(contentVersion_2.ContentDocumentId);
                if(!result.containsKey(parentID)){
                    result.put(parentID, new List<ContentVersion>());
                }
                result.get(parentID).add(contentVersion_2);
            }
        }catch(exception e){
            system.debug('error==='+e.getMessage());
            system.debug('error occurred==='+e.getStacktraceString());
            return null;
        }
        return result;
    }
    
}