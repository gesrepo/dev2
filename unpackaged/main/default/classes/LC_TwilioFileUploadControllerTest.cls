@isTest
public class LC_TwilioFileUploadControllerTest {
    
    private static testMethod void testCreate() {
        ContentVersion cv = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert cv;
        List<string> cvIds = new List<string>();
        cvIds.add(cv.Id);
        
        Test.startTest();
        LC_TwilioFileUploadController.createFileUrls(cvIds);
        Test.stopTest();
    }
    
}