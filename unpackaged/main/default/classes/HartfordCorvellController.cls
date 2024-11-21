/**
* @Description - Controller for the Hartford record type
*/
public class HartfordCorvellController {

	public ApexPages.standardController stdController {get; set;}
	public List<Carrier__c> carriers {get; set;}
	public Claims__Claim__c claim {get; set;}
	private Id recordId {get; set;}

	/**
	* @Description - Constructor for the hartford record type controller
	* @Param - Standard Controller
	*/
	public HartfordCorvellController(ApexPages.standardController controller) {
		this.stdController = controller;
		claim = (Claims__Claim__c)this.stdController.getRecord();
		recordId = (Id)controller.getRecord().id;

		DescribeSObjectResult describeResult = Carrier__c.getSObjectType().getDescribe();
		List<String> fieldNames = new List<String>(describeResult.fields.getMap().keySet());

		String claimNo = String.valueOf(Claim.Name);
		String rType = 'Hartford';

		String query =
		    ' SELECT ' + String.join( fieldNames, ',' ) +
		    ' FROM ' + describeResult.getName() +
		    ' WHERE Claim_No__c = :claimNo' +
		    ' AND RecordType.Name = :rType';

		Carriers = Database.query(query);

		if (Carriers.size() == 0) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,
			                     Label.No_Linked_Claim));
		}
	}

}