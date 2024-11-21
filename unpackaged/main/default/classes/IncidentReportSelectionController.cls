/**
*   @Description    Controller for Incident Report Selection component. 
*                   Allows user to select from a list of Incident Reports.
*/
public class IncidentReportSelectionController {

    public List<Claims__Incident_Report__c> reports {get; set;}  

    public List<Claims__Incident_Report__c> reportsCon {
        get {
            return (List<Claims__Incident_Report__c>)setCon.getRecords();
        } 
        set;
    }  

    public Integer noOfRecords {get; set;}

    public ApexPages.StandardSetController setCon {
        get {
            if (reports != null) {                
                setCon = new ApexPages.StandardSetController(reports);
                setCon.setPageSize(10);
                noOfRecords = setcon.getResultSize();
            }        
            return setCon;
        }
        set;
    }
}