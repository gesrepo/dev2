@isTest
public class CA_EventControllerTest {
    
    @testSetup
    public static void testsetupMethod(){
        LC_TestUtils.insertMainEventPersonSetObj();
    }
    
    @isTest
    public static void allTestMethod(){
        CA_EventContoller.getHomePageSettings();
        CA_EventContoller.getObjSettings();
    }
    
}