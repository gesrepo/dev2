/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestCustomUserObject {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        List<User> LoUsers = [Select Id, FirstName, LastName, Email From User Where Profile.Name = 'System Administrator'];
        User Usr = LoUsers[0];
        
        CustomUserObject CU1 = new CustomUserObject();
                
        CustomUserObject CU2 = new CustomUserObject(Usr);
        
        CustomUserObject CU3 = new CustomUserObject(Usr.Id, Usr.FirstName, Usr.LastName, Usr.Email, true, 1);
        
    }
}