@isTest
public class CA_EventContollerTest {
    
    @testSetup
    public static void testsetupMethod(){
        LC_TestUtils.insertMainEventPersonSetObj();
    }

    @isTest
    public static void allTestMethod(){
        CA_EventContoller.getHomePageSettings();
        CA_EventContoller.getObjSettings();
        List<user> digitalItAdmins=[select id,Alias,Email,UserName, profile.id from user where profile.Name='Digital Products/IT Admin' AND isActive=TRUE];
        System.runAs(digitalItAdmins[0]) {
            CA_EventContoller.getHomePageSettings();
            CA_EventContoller.getObjSettings();
        }

    }
}