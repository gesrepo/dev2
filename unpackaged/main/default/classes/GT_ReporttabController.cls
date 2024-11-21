public class GT_ReporttabController {
	
    @AuraEnabled
    public Static String getProfileName(){
        id userId = userinfo.getProfileId();
        LIST<profile> ProfileName = new LIST<profile>();
		ProfileName = [select Name from profile where id = :userId LIMIT 1];
        system.debug(ProfileName[0].Name);
        Return ProfileName[0].Name;
    }
}