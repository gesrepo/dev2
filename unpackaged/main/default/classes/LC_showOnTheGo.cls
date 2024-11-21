public with sharing class LC_showOnTheGo {
    public class wrapperClass{
        @AuraEnabled   public Id urlParamsId;
        @AuraEnabled   public string signOrderOption;
        @AuraEnabled  public string workOrderOption;
        @AuraEnabled  public Boolean pdfByLocation;
        @AuraEnabled public List<String> wholeDataToExport;
        @AuraEnabled public List<String> listToExportPdfByLocation;
    }
    @AuraEnabled  (cacheable=true)
    public static LC_OrderFilterViewApexController.WrapperClass getPicklistValues(string showId){
    	return LC_OrderFilterViewApexController.getPicklistValues(showId);
    }
    @AuraEnabled (cacheable=true)
    public static List<GC_Order__c> fetchTableData(string showId){
        return LC_OrderFilterViewApexController.fetchTableData(showId);
    }
    public static String getDateString(Date dt) {
        return LC_OrderFilterViewApexController.getDateString(dt);
    }
    public static string escapeSpecialCharacters(string stringvalueToRemoveSpecialCharacters){
        return LC_OrderFilterViewApexController.escapeSpecialCharacters(stringvalueToRemoveSpecialCharacters);
    }    
    @AuraEnabled
    public static List<GC_Order__c> getTableValue(string showId,string deliveryLoc,string areaDesc,List<string> user,string keyword,
                                                  Date deliveryDate,Date completionDate,Date removalDate,Date createdFrom,Date createdTo,
                                                  Date modifiedFrom,Date modifiedTo,string vendors,string department,string delivery,
                                                  string venue,List<string> onsitePerson,List<string> onsitePersonOther,List<string> selectedStatusValues){
       //SAL-1214 - Passed false value as last parameter in the method - 03/18/24 - Sajid
       //return LC_OrderFilterViewApexController.getTableValue(showId, deliveryLoc, areaDesc, user, keyword, deliveryDate, completionDate, removalDate, createdFrom, createdTo, modifiedFrom, modifiedTo, vendors, department, delivery, venue, onsitePerson, onsitePersonOther,selectedStatusValues);
       return LC_OrderFilterViewApexController.getTableValue(showId, deliveryLoc, areaDesc, user, keyword, deliveryDate, completionDate, removalDate, createdFrom, createdTo, modifiedFrom, modifiedTo, vendors, department, delivery, venue, onsitePerson, onsitePersonOther,selectedStatusValues,false);
                                                  }
    //Method to generate PDF
    @AuraEnabled
    public static wrapperClass generatePDFApex(List<GC_Order__c> ordersSelected,List<string> selectedStatusValues,Boolean signOrder,Boolean workOrder,Boolean pdfByLocation){
        //system.debug('ordersSelected to generate pdf'+ordersSelected);
         //system.debug('ordersSelected to generate pdf'+ordersSelected.size());
        wrapperClass obj= new wrapperClass();
        List<GC_Order__c> selectedOrderShows = new List<GC_Order__c>();
        Set<String> orderIds = new Set<String>();
        string signOrderOpt,workOrderOpt;
        //Set<String> selectedLocations = new Set<String>();
        Set<String> selectedStatusValuesSet= new Set<String>();
        Map<String, Set<String>> selectedOrdersByLocation =new  Map<String, Set<String>>();
        selectedStatusValuesSet.addAll(selectedStatusValues);
       try{
            GC_Core_Interface_Log__c urlParamsObject = new GC_Core_Interface_Log__c();
            GC_OrderUtils.URLParameters urlParams = new GC_OrderUtils.URLParameters();
            for(GC_Order__c orders:ordersSelected){
                selectedOrderShows.add(orders);
                orderIds.add(orders.Id);
                //selectedLocations.add(orders.Booth_Area__c);
            }
            urlParams.orderIds = orderIds;
            urlParams.statusValues = selectedStatusValuesSet;
            urlParamsObject.Method_Name__c = 'PDF Print ' + DateTime.now() + ' ' + UserInfo.getUserName();
            urlParamsObject.Message_Content__c = JSON.serialize(urlParams);
            if(signOrder ==true){
                signOrderOpt='true';
            }
            if(workOrder ==true){
                workOrderOpt='true';
            }
            if(pdfByLocation == true){
                List<GC_Core_Interface_Log__c>  urlParamsObjectList = new List<GC_Core_Interface_Log__c>();
                for (GC_Order__c selectedOrders : selectedOrderShows){
                    if(selectedOrdersByLocation.containsKey(selectedOrders.Booth_Area__c)){
                        //continue;
                         selectedOrdersByLocation.get(selectedOrders.Booth_Area__c).add(selectedOrders.Id);
                    }
                    else{
                        selectedOrdersByLocation.put(selectedOrders.Booth_Area__c, new Set<String>());
                         selectedOrdersByLocation.get(selectedOrders.Booth_Area__c).add(selectedOrders.Id);
                    }
                    //selectedOrdersByLocation.get(selectedOrders.Booth_Area__c).add(selectedOrders.Id);
                }
                for(String key: selectedOrdersByLocation.keySet()){
                    GC_Core_Interface_Log__c urlParamsObject1 = new GC_Core_Interface_Log__c();
                    GC_OrderUtils.URLParameters urlParams1 = new GC_OrderUtils.URLParameters();
                    urlParams1.orderIds = selectedOrdersByLocation.get(key);
                    urlParams1.statusValues = selectedStatusValuesSet;
                    urlParamsObject1.Method_Name__c = 'PDF Print ' + DateTime.now() + ' ' + UserInfo.getUserName();
                    urlParamsObject1.Message_Content__c = JSON.serialize(urlParams1);
                    urlParamsObjectList.add(urlParamsObject1);
                }
                insert urlParamsObjectList;
                List<String> insertedList= new List<String>();
                for(GC_Core_Interface_Log__c c:urlParamsObjectList){
                    insertedList.add(c.Id);                    
                }
                obj.listToExportPdfByLocation=insertedList;
            }else{
                insert urlParamsObject;
                obj.urlParamsId=urlParamsObject.Id;
            }
            obj.signOrderOption=signOrderOpt;
            obj.workOrderOption=workOrderOpt;
            obj.pdfByLocation=pdfByLocation;
            return obj;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
   
    //Method to export Orders as csv
    @AuraEnabled (cacheable=true)
    public static List<String> exportOrdersCSV(List<String> OrderIds,List<String> selectedStatusValues,string showId){
        try{
            List<String> dataToExportForEachOrder=new List<String>();
            dataToExportForEachOrder=LC_OrderViewController.getDataToDownlaodAsCSV(OrderIds,selectedStatusValues,showId);
            return dataToExportForEachOrder;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage()); 
        }
    }
    @AuraEnabled (cacheable=true)
    public static List<String> generateOrdersCSV(List<GC_Order__c> OrderIds,List<String> selectedStatusValues,string showId){
        String signTitel = 'Sign_Title__c';
        String signCopy ='Sign_Copy__c';
        String showManagement = 'Show_Management_Field__c';
        List<String> selectedOrderIds = new List<String>();
        for(GC_Order__c orders:OrderIds){
                selectedOrderIds.add(orders.Id);
            }
        try {
            Set<String> orderSet = new Set<String>(selectedOrderIds);
            orderSet.addAll(selectedOrderIds);
            string whereClause='';
            List<String> selectedStatusWithInvertedCommas = new List<String>();
            if(selectedStatusValues!=null && selectedStatusValues.size()>0){
                for(Integer i=0;i<selectedStatusValues.size();i++){
                    string statusValues='\''+selectedStatusValues[i]+'\'';
                    selectedStatusWithInvertedCommas.add(statusValues);
                }
                whereClause += ' Status__c in'+selectedStatusWithInvertedCommas+'';
                  }
            List<GC_GES_Order_Task__c> gots = [
                Select Order__r.Connect2_Show__c,Order__r.Show_Name__c,Order__r.Name,Name,Owner.Name,Status__c,
                Submitted_Date__c,Formula_Booth_Area__c,Order__r.Order_Area_Description__c,Delivery_Location__c,
                SA_Venue_Location__r.Name,Delivery_Date_Time__c,Completion_Date_Time__c,Removal_Date_Time__c,
                QuantityNum__c,Price__c,UOM__c,Total__c,Show_Management_Field__c,Description__c,Item_Number__c,
                Item_Template__c,File_Reference_Link__c,User_Item_Description__c,Carpet_Length__c,
                Carpet_Width__c,Electrical_Ordered__c,Electrical_Under__c,Sign_Length__c,Sign_Width__c,Sign_Title__c,GOT_Sign_Type__c,GOT_Single_Double_Sided__c,GOT_Copy_Placement__c,Material__r.Name,Sign_Copy__c,Layout__c,Outdoors__c,
				Installation_Method__c,Save_Signs__c,GOT_Background__c,Booth_Area_Discount__c,Department__r.Name,
                Budget_Code__c,Order_Number__c,Line_Item_Number__c,Job_Number__c,Revision__c,Previous_Revision__c,Last_Revision__c
                from GC_GES_Order_Task__c where Order__r.Connect2_Show__c =:showId];
            
            System.debug('gotsSize&&&&&&&'+gots.size());
            List<GC_Vendor_Order_Task__c> vots = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskByStatus(orderSet,whereClause);
            List<String> generatedCSVFile = new List<String>();
            List<GC_OrderCSV__mdt> orderCSVList = new List<GC_OrderCSV__mdt>();
            List<String> allLabels = new List<String>();
            List<String> allFieldNames = new List<String>();
                orderCSVList = [Select Field_Label__c, Field_Name__c, Order_No__c, Is_Rich_Text__c from GC_OrderCSV__mdt where Hide_Community__c = false Order By Order_No__c];
            for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                allLabels.add(orderCSV.Field_Label__c);
                allFieldNames.add(orderCSV.Field_Name__c);
            }
            generatedCSVFile.add(String.join(allLabels, ',') + '\n');
                String taskHeaderRow = '';
                Map<String, String> taskDataMap = new Map<String, String>();
                for (GC_GES_Order_Task__c task : gots) {               
                    if(selectedStatusValues.contains(task.Status__c)){
                        String[] taskData = New String[]{};
                    taskData.add(task.Order__r.Show_Name__c);
                    taskData.add(task.Order__r.Name);
                    taskData.add(task.Name);
                    taskData.add(task.Owner.Name);
                    taskData.add(task.Status__c);
                    taskData.add(String.valueOf(task.Submitted_Date__c));
                    taskData.add(task.Formula_Booth_Area__c);
                    taskData.add(LC_OrderViewController.getFieldData('Order__r.Order_Area_Description__c', task, false).replaceAll('<[/a-zAZ0-9]*>', ' '));
                    taskData.add(LC_OrderViewController.getFieldData('Delivery_Location__c', task, false).replaceAll('<[/a-zAZ0-9]*>', ' '));
                    taskData.add(LC_OrderViewController.getFieldData('SA_Venue_Location__r.Name', task, false).replaceAll('<[/a-zAZ0-9]*>', ' '));
                    taskData.add(String.valueOf(task.Delivery_Date_Time__c));
                    taskData.add(String.valueOf(task.Completion_Date_Time__c));
                    taskData.add(String.valueOf(task.Removal_Date_Time__c));
                    taskData.add(String.valueOf(task.QuantityNum__c));
                    taskData.add(task.Price__c);
                    taskData.add(task.UOM__c);
                    taskData.add(String.valueOf(task.Total__c));
                    taskData.add(String.valueOf(LC_OrderViewController.getFieldData(showManagement, task, true).replaceAll('<[/a-zAZ0-9]*>', ' '))); //task.Show_Management_Field__c
                    taskData.add(LC_OrderViewController.getFieldData('Description__c', task, false).replaceAll('<[/a-zAZ0-9]*>', ' '));
                    taskData.add(task.Item_Number__c);
                    taskData.add(task.Item_Template__c);
                    taskData.add(task.File_Reference_Link__c);
                    taskData.add(task.User_Item_Description__c);
                    taskData.add(String.valueOf(task.Carpet_Length__c));
                    taskData.add(String.valueOf(task.Carpet_Width__c));
                    taskData.add(String.valueOf(task.Electrical_Ordered__c));
                    taskData.add(String.valueOf(task.Electrical_Under__c));
                    taskData.add(String.valueOf(task.Sign_Length__c));
                    taskData.add(String.valueOf(task.Sign_Width__c));
                    taskData.add(LC_OrderViewController.getFieldData(signTitel, task, false).replaceAll('<[/a-zAZ0-9]*>', ' ')); //task.Sign_Title__c
                    taskData.add(task.GOT_Sign_Type__c);
                    taskData.add(task.GOT_Single_Double_Sided__c);
                    taskData.add(task.GOT_Copy_Placement__c);
                    taskData.add(task.Material__r.Name);
                    taskData.add(LC_OrderViewController.getFieldData(signCopy, task, true).replaceAll('<[/a-zAZ0-9]*>', ' ')); //task.Sign_Copy__c
                    taskData.add(LC_OrderViewController.getFieldData('Layout__c', task, true).replaceAll('<[/a-zAZ0-9]*>', ' '));
                    taskData.add('FALSE'); //Outdoors__c
                    taskData.add(task.Installation_Method__c);
                    taskData.add(task.Save_Signs__c);
                    taskData.add(task.GOT_Background__c);
                    taskData.add(String.valueOf(task.Booth_Area_Discount__c));
                    taskData.add(''); //task.Date_Sent__c
                    taskData.add(''); //task.Vendor__r.Name
                    taskData.add(''); //task.Vendor2__r.Name
                    taskData.add(''); //task.Vendor3__r.Name
                    taskData.add(''); //task.Vendor4__r.Name
                    taskData.add(''); //task.Vendor5__r.Name
                    taskData.add(''); //task.Vendor_Instructions__c
					taskData.add(''); //task.Service_Type__r.Name
                    taskData.add(''); //task.Service_Type2__r.Name
                    taskData.add(''); //task.Service_Type3__r.Name
                    taskData.add(''); //task.Service_Type4__r.Name
                    taskData.add(''); //task.Service_Type5__r.Name
                    taskData.add(task.Department__r.Name);
                    taskData.add(task.Budget_Code__c);
                    taskData.add(task.Order_Number__c);
                    taskData.add(task.Line_Item_Number__c);
                    taskData.add(task.Job_Number__c);
                    taskData.add(String.valueOf(task.Revision__c));
                    taskData.add(task.Previous_Revision__c);
                    taskData.add(String.valueOf(task.Last_Revision__c));
                    taskData.add('');
                    taskData.add('');
                    taskData.add('');
                    taskData.add('');
                    taskData.add('');
                    taskDataMap.put(task.Name, String.join(taskData, ',') + '\n');
                    }
                }
                for (GC_Vendor_Order_Task__c task : vots) {
                    List<String> taskData = new List<String>();
                    for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                        if (orderCSV.Field_Name__c == 'Revision__c') {
                            task.Revision__c = null;
                        }
                        String parseStrVal = LC_OrderViewController.getFieldData(orderCSV.Field_Name__c, task, orderCSV.Is_Rich_Text__c).replaceAll('<[/a-zAZ0-9]*>', ' ');
                        taskData.add(parseStrVal);
                    }
                    taskDataMap.put(task.Name, String.join(taskData, ',') + '\n');
                }
                for (String taskName : taskDataMap.keySet()) {     
                    generatedCSVFile.add(taskDataMap.get(taskName));   
                }
            return generatedCSVFile;
        } catch (Exception e) {
            system.debug('error'+e.getMessage());
            system.debug('error'+e.getStackTraceString());
            return null;
        }
    }
    @AuraEnabled
    public static boolean isCommunity(){
        return LC_AppUtils.isCommunity();
    }
}