@isTest
public class LC_showOnTheGoTest {
    @testsetup
    public static void testSetup(){
        Opportunity opp=LC_TestUtils.insertOpportunity();
        GC_Connect2_Show__c show=LC_TestUtils.insertShow(opp.Id,opp.Name);
        GC_Order__c order=LC_TestUtils.insertOrder(show.Id);
        GC_Show_Attribute__c venueAttribute=LC_TestUtils.insertVenueAttributes(show.Id);
        GC_Show_Attribute__c deptAttribute=LC_TestUtils.insertDeptAttributes(show.Id);
        GC_GES_Order_Task__c gesOt=LC_TestUtils.insertGOT(order.Id,venueAttribute.Id,deptAttribute.Id);
    }
    @isTest
    public static void testMethod1() {
        List<GC_Order__c> orders=[select Id,Name,Booth_Area__c,Order_Area_Description__c,Delivery_Date_Time__c from GC_Order__c where Booth_Area__c='new Booth Area'];
        GC_Connect2_Show__c show=[select id from GC_Connect2_Show__c where Show_Name__c = 'test show'];
        List<GC_Order__c> ordersList= new List<GC_Order__c>();
        List<string> orderIdsToExportAsCsv=new List<String>();
        List<string> selectedStatusToPrint=new List<String>();
        selectedStatusToPrint.add('New');
        selectedStatusToPrint.add('Active');
        selectedStatusToPrint.add('Approved');
        selectedStatusToPrint.add('Submitted');
        LC_showOnTheGo.generatePDFApex(ordersList,selectedStatusToPrint,true,true,false);
        for(GC_Order__c o:orders){
            ordersList.add(o);
            orderIdsToExportAsCsv.add(o.Id);
        }
        List<string> users=new List<string>();
        users.add('');
        List<string> onsitePerson=new List<string>();
        onsitePerson.add('');
        List<string> onsitePersonOther=new List<string>();
        onsitePersonOther.add('');
        selectedStatusToPrint.add('New');
        LC_showOnTheGo.generatePDFApex(ordersList,selectedStatusToPrint,true,true,false);
        LC_showOnTheGo.exportOrdersCSV(orderIdsToExportAsCsv,selectedStatusToPrint,show.Id);
        LC_showOnTheGo.generateOrdersCSV(ordersList,selectedStatusToPrint,show.Id);
        
        LC_showOnTheGo.generatePDFApex(ordersList,selectedStatusToPrint,true,true,true);
        LC_showOnTheGo.getPicklistValues(show.Id);
        LC_showOnTheGo.fetchTableData(show.Id);
        LC_showOnTheGo.getTableValue(show.Id,'new Booth Area','new order area',users,'new',system.today().addDays(10),system.today().addDays(5),system.today().addDays(15),system.today().addDays(3),system.today().addDays(6),system.today().addDays(3),system.today().addDays(3),'Shubhashree Joshi','Test Department attribut1','new Booth Area','Test Venue attribut1',onsitePerson,onsitePersonOther,selectedStatusToPrint);
        LC_showOnTheGo.isCommunity();
        LC_showOnTheGo.escapeSpecialCharacters('Test Department attribut1');
    }
       
    
}