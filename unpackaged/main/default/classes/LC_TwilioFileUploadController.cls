public class LC_TwilioFileUploadController {
    
    @AuraEnabled
    public static List<ContentDistribution> createFileUrls(List<string> fileIds){
        System.debug('fileIds: '+fileIds);
        List<ContentVersion> listCV = [SELECT Id, Title FROM ContentVersion WHERE Id IN: fileIds];
        
        List<ContentDistribution> listCD = new List<ContentDistribution>();
        for(ContentVersion cv : listCV){
            ContentDistribution conDis = new ContentDistribution();
            conDis.Name = cv.Title;
            conDis.ContentVersionId = cv.Id;
            conDis.PreferencesAllowViewInBrowser= true;
            conDis.PreferencesExpires = true;
            conDis.ExpiryDate = DateTime.Now().AddDays(90);
            listCD.add(conDis);
        }
        if(listCD!= null && listCD.size()>0){
            insert listCD;
        }
        List<ContentDistribution> listCD1 = [SELECT Id, Name, DistributionPublicUrl FROM ContentDistribution where Id IN: listCD];
        return listCD1;
    }
}