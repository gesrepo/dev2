public without sharing class GC_SecurityUtil {


    public static final String R_ACCT_MANAGER = 'GC Account Manager';
    public static final String R_CREATIVE_DIRECTOR = 'GC Creative Director';
    public static final String R_TRAFFIC_ADMIN = 'GC Traffic Administrator';
    public static final String R_DETAILER = 'GC Detailer';
    public static final String R_DIRECTOR_ACCT_MGMT = 'GC Director of Account Management';
    public static final String R_SALES_MGR = 'GC Sales Manager';
    public static final String R_GRAPHICS_PROJMAN = 'GC Graphics Project Manager';
    public static final String R_COMMUNITY_CLIENT = 'GC Community Client';
    public static final String R_COMMUNITY_VENDOR = 'GC Community Vendor';

    private static User currentUser;

    public static Boolean userHasRole(User u, String role) {
        if (u.Profile != null && u.Profile.Name != null && u.Profile.Name == role) {
            return true;
        }

        return u.GC_Show_Role__c == null ? false : u.GC_Show_Role__c.contains(role);
    }

	public static Boolean userHasRole(String role) {
        if (currentUser == null || currentUser.Id != UserInfo.getUserId()) {
            currentUser = [Select Id, GC_Show_Role__c, Profile.Name from User where Id = :UserInfo.getUserId()];
        }

        return userHasRole(currentUser, role);
    }
}