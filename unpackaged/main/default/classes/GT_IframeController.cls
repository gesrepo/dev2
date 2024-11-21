public class GT_IframeController {
    @AuraEnabled 
    public static user fetchUser(){
        // query current user information  
        User oUser = [select user.id, user.profile.name FROM User Where user.id =: userInfo.getUserId()];
        return oUser;
    }
}