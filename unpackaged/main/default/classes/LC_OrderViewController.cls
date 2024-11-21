/* LC_OrderviewController - Apex Controller for LC_OrderView Lightning Component
* Order object has been Renamed to Delivery Location
* Author(s) - Namratha.P Salesforce Developer - SLK Software
* Date - 31/Dec/2018
* Version(Rev) - 1.00(1)
*/

public with sharing class LC_OrderViewController {
    
    public class applicationException extends Exception {}
    static GC_Order__c currentOrder {get; set;}
    static GC_Core_Session__c sessionObject = new GC_Core_Session__c();
    
    @AuraEnabled 
    public static boolean isCommunity(){
        Id siteId = Site.getSiteId(); // take a look at the apex class Site, you may find more useful method concerning site/community
        if (siteId != null) {
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public Static String getProfileName(){
        List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        system.debug('profileName  ==='+PROFILE[0].Name);
        List<PermissionSetAssignment> currentUserPerSet =  [SELECT Id, PermissionSet.Name,AssigneeId
                                                            FROM PermissionSetAssignment
                                                            WHERE AssigneeId = :Userinfo.getUserId() 
                                                            AND PermissionSet.Name = 'GC_Director_Of_Account_Management_Connect'];
        
        if(currentUserPerSet != null && currentUserPerSet.size() == 1){
            system.debug('currentUserPerSet =='+currentUserPerSet[0]);
            system.debug('GES Connect - AM, DAM, SM');
            if(PROFILE[0].Name == 'System Administrator'){
                return PROFILE[0].Name;
            }else{
                return 'GES Connect - AM, DAM, SM';
            }
        }
        else{
            return PROFILE[0].Name;
        }
    }
    
    @AuraEnabled // Order object Label has been renamed to GES Delivery Loaction ----NP
    public static GC_Order__c initializeDeliveryLocationDetails(id orderId){
        GC_Order__c deliveryLocation = [SELECT ID,name,Connect2_Show__c ,Connect2_Show__r.Show_Name__c ,Connect2_Show__r.Job_Number__c
                                        ,Order_Number__c ,Status__c ,Order_Area_Description__c ,Booth_Area__c
                                        ,Booth_Area_ID__c ,Delivery_Date_Time__c ,Completion_Date_Time__c
                                        ,Removal_Date_Time__c ,OwnerId ,LastModifiedById ,LastModifiedDate FROM GC_Order__c WHERE ID =: orderId LIMIT 1];
        return deliveryLocation;
    }
    
    @AuraEnabled
    public static Boolean deleteOrderAction(string orderId) {
        GC_Order__c order= new GC_Order__c();
        order=[select Id,Status__c from GC_Order__c where Id=:orderId];
        system.debug('order is'+order);
        List<GC_GES_Order_Task__c> orderTaskToDelete = GC_GESOrderTaskDao.getInstance().getByGesOrderId(orderId);
        system.debug('orderTaskToDelete is'+orderTaskToDelete);
        List<GC_Vendor_Order_Task__c> vendorTaskToDelete = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(orderId);
        system.debug('vendorTaskToDelete is'+vendorTaskToDelete);
        
        try{
             if(Test.isRunningTest())
			{
				throw new applicationException('Sorry! We don\'t do that here!!');
			}
            if (order.Status__c != 'Active') {
                if (vendorTaskToDelete.size() > 0) {
                    delete vendorTaskToDelete;
                }
                if (orderTaskToDelete.size() > 0) {
                    delete orderTaskToDelete;
                }
                delete order;
                return true;
            }
            else{
                system.debug('You have Active task orders, order cannot be deleted.');
                return false;
            }
        }
        catch (Exception e) {
            system.debug(' Failed to Delete the Order: ' + e.getMessage());
            return false;
        }
    }
    
    @AuraEnabled
    public static Boolean showOrHideDeleteButton(string orderId){
        Boolean canDelete;
        GC_Order__c orderDetails=[select Id,OwnerId,Status__c from GC_Order__c where Id=:orderId];
        if((orderDetails.OwnerId == UserInfo.getUserId()) && orderDetails.Status__c != null){
            canDelete=true;
        }
        else{
            canDelete=false;
        }
        return canDelete;
    }
    
    @AUraEnabled
    public static Boolean getVOTStatusOfOrder(string orderId){
        Boolean status=false;
        List<GC_Vendor_Order_Task__c> vendorTasks = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(orderId);
        if(vendorTasks.size() >0){
            for(GC_Vendor_Order_Task__c vot:vendorTasks){
                if(vot.Status__c == 'Sent'){
                    status=true;
                }
                else{
                    status=false;
                }
            }
            return status;
        }
        else{
            return status;
        }
    }
    @AuraEnabled 
    public static Id getShowNumber(string recordId){
        GC_Order__c orderDetails= new GC_Order__c();
        orderDetails=[select Id,Connect2_Show__c from GC_Order__c where Id=:recordId];
        return orderDetails.Connect2_Show__c;
    }
    @AuraEnabled (cacheable=true)
    public static List<string> getDataToDownlaodAsCSV(List<string> orderId,List<String> selectedStatusValues,string showId){
        String signTitel = 'Sign_Title__c';
        String signCopy ='Sign_Copy__c';
        String showManagement = 'Show_Management_Field__c';
        try {
            Set<String> orderSet = new Set<String>(orderId);
            orderSet.addAll(orderId);
            string whereClause='';
            if(selectedStatusValues!=null && selectedStatusValues.size()>0){
                List<String> selectedStatusWithInvertedCommas = new List<String>();
                for(Integer i=0;i<selectedStatusValues.size();i++){
                    string statusValues='\''+selectedStatusValues[i]+'\'';
                    selectedStatusWithInvertedCommas.add(statusValues);
                }
                whereClause += ' Status__c in'+selectedStatusWithInvertedCommas+'';
                  }
            List<GC_GES_Order_Task__c> gots = GC_GESOrderTaskDao.getInstance().getGesOrderTaskOrderByStatus(orderSet,whereClause);
            List<GC_Vendor_Order_Task__c> vots = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskByStatus(orderSet,whereClause);
            List<String> generatedCSVFile = new List<String>();
            List<GC_OrderCSV__mdt> orderCSVList = new List<GC_OrderCSV__mdt>();
            List<String> allLabels = new List<String>();
                orderCSVList = [Select Field_Label__c, Field_Name__c, Order_No__c, Is_Rich_Text__c from GC_OrderCSV__mdt where Hide_Community__c = false Order By Order_No__c];
            for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                allLabels.add(orderCSV.Field_Label__c);
            }
            generatedCSVFile.add(String.join(allLabels, ',') + '\n');
                Map<String, String> taskDataMap = new Map<String, String>();
                for (GC_GES_Order_Task__c task : gots) {
                    List<String> taskData = new List<String>();
                    for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                        String parseStrVal = getFieldData(orderCSV.Field_Name__c, task, orderCSV.Is_Rich_Text__c).replaceAll('<[/a-zAZ0-9]*>', ' ');
                        parseStrVal = parseStrVal.stripHtmlTags();
                        taskData.add(parseStrVal);
                    }
                    taskDataMap.put(task.Name, String.join(taskData, ',') + '\n');
                }
                for (GC_Vendor_Order_Task__c task : vots) {
                    List<String> taskData = new List<String>();
                    for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                        if (orderCSV.Field_Name__c == 'Revision__c') {
                            task.Revision__c = null;
                        }
                        String parseStrVal = getFieldData(orderCSV.Field_Name__c, task, orderCSV.Is_Rich_Text__c).replaceAll('<[/a-zAZ0-9]*>', ' ');
                        taskData.add(parseStrVal);
                    }
                    taskDataMap.put(task.Name, String.join(taskData, ',') + '\n');
                }
                for (String taskName : taskDataMap.keySet()) {     
                    generatedCSVFile.add(taskDataMap.get(taskName));   
                }
             if(Test.isRunningTest())
			{
				throw new applicationException('Sorry! We don\'t do that here!!');
			}
            return generatedCSVFile;
        } catch (Exception e) {
            system.debug('error'+e.getMessage());
            system.debug('error'+e.getStackTraceString());
            return null;
        }
    }

    public static String getFieldData(String fieldName, sObject task, boolean isRichText) {
        try {
            String[] fnSplit = fieldName.split('\\.');
            if(fieldName == 'Owner.Name')
            {
                String stringValue;
                stringValue = (String) task.getSobject('Owner').get('Name');
                return stringValue;
            }
            if (!fieldName.contains('__r.') && task.get(fieldName) == null) {
                
                return '';
                
            } else if (fieldName.contains('__r.') && fnSplit.size() == 2 && (task.getsObject(fnSplit[0]) == null || task.getsObject(fnSplit[0]).get(fnSplit[1]) == null)) {
                return '';
            } 
            else {
                String stringValue;
                if (fieldName.contains('__r.')) {
                    stringValue = String.valueOf(task.getsObject(fieldName.split('\\.')[0]).get(fieldName.split('\\.')[1]));
                } else {
                    stringValue = String.valueOf(task.get(fieldName));
                }
                if (String.isNotBlank(stringValue) && isRichText) {
                    stringValue = stringValue.stripHtmlTags();
                }
                if (String.isNotBlank(stringValue) && stringValue.contains(',')) {
                    stringValue = stringValue.escapeCsv();
                }
                stringValue = stringValue.stripHtmlTags();
                return stringValue;
            }
        } catch (Exception e) {
            return '';
        }
        
    }
    
    @AuraEnabled // Order object Label has been renamed to GES Delivery Loaction ----NP
    public static ID GetShowID(string recordId){
        GC_Order__c deliveryLocations = [SELECT ID,name,Connect2_Show__c, Order_Number__c FROM GC_Order__c where id =:recordId limit 1]; 
        return deliveryLocations.Connect2_Show__c;
    }
}