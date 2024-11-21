/**

* @author Ethos Solutions - www.ethos.com

* @description Utility class for page parameters and messages

* 2016-04-13 : Original Version

**/

public class GC_PageUtil {
    
    public static String getParam(String pName) {
        
        return ApexPages.currentPage().getParameters().get(pName);
        
    }
    
    
    
    public static String setParam(String pName, String pVal) {
        
        return ApexPages.currentPage().getParameters().put(pName, pVal);
        
    }
    
    
    
    public static void AddDeveloperMessage(String label, String message) {
        
        AddDeveloperMessage(label + ': ' + message);
        
    }
    
    
    
    public static void AddDeveloperMessage(String message) {
        
        if (UserInfo.getUserName().contains('ethosdev') || UserInfo.getUserName().contains('bfaber')) {
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, message);
            
            ApexPages.addMessage(myMsg);
            
        }
        
    }
    
    
    
    public static void AddInfoMessage(String message) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, message);
        
        ApexPages.addMessage(myMsg);
        
    }
    
    
    
    public static void AddErrorMessage(String message) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, message);
        
        ApexPages.addMessage(myMsg);
        
    }
    
    
    
    public static void AddWarningMessage(String message) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, message);
        
        ApexPages.addMessage(myMsg);
        
    }
    
    
    
    public static void AddFatalMessage(String message) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, message);
        
        ApexPages.addMessage(myMsg);
        
    }
    
    
    
    public static void AddConfirmMessage(String message) {
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, message);
        
        ApexPages.addMessage(myMsg);
        
    }
    
    
    
    public static Boolean testLightning = false;
    
    
    
    public static Boolean IsLightningUI() {
        
        if (Test.isRunningTest() && testLightning) {
            
            return true;
            
        }
        
        
        
        return UserInfo.getUiTheme().contains('Theme4d');
        
    }
    
    
    
    public static Boolean IsClassicUI() {
        
        return UserInfo.getUiTheme().contains('Theme3');
        
    }
    
    
    
    /**

* @description Useful utility for checking whether we're in the community realm or visual force sfdc realm.

* @param Param data type Param description

* @param Param data type Param description

* @return returns /apex if we're in salesforce.

**/
    
    public static String CheckApexDomain() {
        
        if (Test.isRunningTest()) {
            
            return '';
            
        }
        
        
        
        if (ApexPages.currentPage().getUrl().contains('/apex/')) {
            
            System.debug('returning apex');
            
            return '/apex';
            
        } else {
            
            System.debug('returning blank');
            
            return '';
            
        }
        
    }
    
    
    
    public static GC_GES_Order_Task__c cloneTask(GC_GES_Order_Task__c got) {
        
        GC_GES_Order_Task__c newOrderTask = got.clone(false);
        
        newOrderTask.Status__c = 'New';
        
        newOrderTask.Submitted_Date__c = null;
        
        newOrderTask.Order_Line_ID__c = null;
        
        newOrderTask.Line_Item_Number__c = null;
        
        newOrderTask.Line_Item_Status__c = null;
        
        newOrderTask.Order_Header_ID__c = null;
        
        newOrderTask.Order_Number__c = null;
        
        newOrderTask.Revision__c = 1;
        
        newOrderTask.Original_Task_Revision2__c = null;
        
        newOrderTask.Last_Revision__c = null;
        
        newOrderTask.Previous_Revision__c = null;
        
        newOrderTask.Core_Cancelled__c = false;
        
        newOrderTask.OwnerId = UserInfo.getUserId();
        
        
        
        return newOrderTask;
        
    }
    
    
    
    public static GC_Vendor_Order_Task__c cloneTask(GC_Vendor_Order_Task__c vot) {
        
        GC_Vendor_Order_Task__c newVot = vot.clone(false);
        
        newVot.Status__c = 'New';
        
        newVot.Last_Revision__c = null;
        
        newVot.Revision__c = 1;
        
        newVot.Submitted_Date__c = null;
        
        newVot.Previous_Revision__c = null;
        
        newVot.OwnerId = UserInfo.getUserId();
        
        return newVot;
        
    }
    
    
    public static Map<Id,List<contentdocumentlink>> cloneTaskFiles(Set<Id> gotIds){
        List<contentdocumentlink> existingOrderTaskRelatedfiles = new List<contentdocumentlink>();
        Map<Id,List<contentdocumentlink>> clonedFilesMap = new Map<Id,List<contentdocumentlink>>();
        
        existingOrderTaskRelatedfiles = [SELECT id,ContentDocumentId,IsDeleted,ShareType,SystemModstamp,Visibility,LinkedEntityId  FROM contentdocumentlink wHERE LinkedEntityId IN :gotIds];
        
        if(existingOrderTaskRelatedfiles.size() > 0){
            for(contentdocumentlink existingFile : existingOrderTaskRelatedfiles){
                contentdocumentlink clonedFile = existingFile.clone(false, true, false, false);
                
                clonedFile.LinkedEntityId = existingFile.LinkedEntityId;
                clonedFile.ContentDocumentId = existingFile.ContentDocumentId;
                clonedFile.ShareType = existingFile.ShareType;
                clonedFile.Visibility= existingFile.Visibility;
                if(!clonedFilesMap.containsKey(clonedFile.LinkedEntityId)){
                    clonedFilesMap.put(clonedFile.LinkedEntityId, new List<contentdocumentlink>());
                }
                clonedFilesMap.get(clonedFile.LinkedEntityId).add(clonedFile);
            }
        }
        return clonedFilesMap;
    }
    
    public static GC_Order__c cloneOrder(GC_Order__c orderToClone) {
        
        Savepoint sp = Database.setSavepoint();
        
        GC_Order__c newOrder;
        
        List<GC_GES_Order_Task__c> gTasks = new List<GC_GES_Order_Task__c>();
        
        List<GC_Vendor_Order_Task__c> vTasks = new List<GC_Vendor_Order_Task__c>();
        
        Set<id>gotIds= new Set<id>();
        Map<id,GC_GES_Order_Task__c> mapClonedToExistingGOT = new Map<id,GC_GES_Order_Task__c>();
        
        
        try {
            
            newOrder = orderToClone.clone(false);
            
            newOrder.OwnerId = UserInfo.getUserId();
            
            newOrder.Status__c = 'New';
            
            newOrder.Order_Number__c = null;
            
            insert newOrder;
            
            List<GC_GES_Order_Task__c> gots = GC_GESOrderTaskDao.getInstance().getByGesOrderId(orderToClone.Id);
            
            for (GC_GES_Order_Task__c got : gots) {
                
                GC_GES_Order_Task__c newGot = GC_PageUtil.cloneTask(got);
                
                newGot.Order__c = newOrder.Id;
                mapClonedToExistingGOT.put(got.id, newGot);
                gotIds.add(got.id);
                
                gTasks.add(newGot);
                
            }
            
            insert gTasks;
            List<contentdocumentlink> allClonedFiles= new List<contentdocumentlink>();
            map<id, List<contentdocumentlink>> clonedFilesMap= cloneTaskFiles(gotIds);
            for(Id oldGotId: mapClonedToExistingGOT.keySet()){
                if(clonedFilesMap.containsKey(oldGotId)){
                    for(contentdocumentlink clonedFile: clonedFilesMap.get(oldGotId)){
                        clonedFile.LinkedEntityId = mapClonedToExistingGOT.get(oldGotId).id;
                        allClonedFiles.add(clonedFile);
                    }
                }
            }
            insert allClonedFiles;           
            
            List<GC_Vendor_Order_Task__c> vots = GC_VendorOrderTaskDao.getInstance().getByGesOrderId(orderToClone.Id);
            
            
            
            for (GC_Vendor_Order_Task__c vot : vots) {
                
                GC_Vendor_Order_Task__c newVot = GC_PageUtil.cloneTask(vot);
                
                newVot.Order__c = newOrder.Id;
                
                vTasks.add(newVot);
                
            }
            
            
            
            insert vTasks;
            
            
            
            return newOrder;
            
        } catch (Exception e) {
            
            Database.rollback(sp);
            
            GC_PageUtil.AddErrorMessage(' Failed to Clone the Order: ' + e.getMessage());
            
            return null;
            
        }
        
    }
    
    
    
    public static Boolean validateGesTask(GC_GES_Order_Task__c got) {
        
        Set<String> errors = new Set<String>();
        
        
        
        if (String.isBlank(got.Item_Number__c)) {
            
            got.Item_Number__c.addError('Item is Required');
            
            errors.add('  Item is Required');
            
        }
        
        
        
        if (String.isBlank(got.Item_Template__c)) {
            
            got.Item_Template__c.addError('Item Template is Required');
            
            errors.add('  Item Template Required');
            
        }
        
        
        
        if (String.isNotBlank(got.Description__c)
            
            && got.Description__c == 'GRAPHICS FOR GEM STRUCTURE'
            
            && String.isBlank(got.Parent_GEM_Structure__c)) {
                
                got.Parent_GEM_Structure__c.addError('Active GEM Structure is required');
                
                errors.add('  Active GEM Structure is required');
                
            }
        
        
        
        if (String.isNotBlank(got.Item_Template__c)) {
            
            
            
            if (got.QuantityNum__c == null) {
                
                got.QuantityNum__c.addError('Quantity is Required');
                
                errors.add('  Quantity is Required');
                
            }
            
            
            
            if (got.Item_Template__c.contains('Carpet') && got.UOM__c == 'SF') {
                
                if (String.isBlank(String.valueOf(got.Carpet_Length__c))) {
                    
                    got.Carpet_Length__c.addError('Carpet Length is Required');
                    
                    errors.add('  Carpet Length is Required');
                    
                }
                
                
                
                if (String.isBlank(String.valueOf(got.Carpet_Width__c))) {
                    
                    got.Carpet_Width__c.addError('Carpet Width is Required');
                    
                    errors.add('  Carpet Width is Required');
                    
                }
                
            }
            
            
            
            if (got.Item_Template__c == 'Carpet' || got.Item_Template__c == 'Custom Carpet') {
                
                if (got.Electrical_Ordered__c == null) {
                    
                    got.Electrical_Ordered__c.addError('Electrical Ordered is Required');
                    
                    errors.add('  Electrical Ordered is Required');
                    
                }
                
                
                
                if (got.Electrical_Under__c == null) {
                    
                    got.Electrical_Under__c.addError('Electrical Under is Required');
                    
                    errors.add('  Electrical Under is Required');
                    
                }
                
            }
            
            
            
            if (got.Item_Template__c == 'Custom Graphics') {
                
                if (String.isBlank(String.valueOf(got.Sign_Length__c))) {
                    
                    got.Sign_Length__c.addError('Sign Length is Required');
                    
                    errors.add('  Sign Length is Required');
                    
                }
                
                
                
                if (String.isBlank(String.valueOf(got.Sign_Width__c))) {
                    
                    got.Sign_Width__c.addError('Sign Width is Required');
                    
                    errors.add('  Sign Width is Required');
                    
                }
                
            }
            
        }
        
        
        
        //if (got.Booth_Area_Discount_Override__c != null && got.Booth_Area_Discount_Override__c > 1.0 && got.Booth_Area_Discount_Override__c < 0.0) {
        
        //    errors.add('  Booth Area Discount override needs to be 0 - 100');
        
        //}
        
        
        
        //if (errors.size() > 0 && String.isNotBlank(got.Name)) {
        
        //    GC_PageUtil.AddErrorMessage('Validation Errors on ' + got.Name);
        
        //}
        
        //for (String error : errors) {
        
        //    GC_PageUtil.AddErrorMessage(error);
        
        //}
        
        return errors.size() == 0;
        
    }
    
    
    
    
    
    public static String exportToCSV(String orderIds, Boolean isCommunity) {
        
        try {
            
            // Get the orders
            
            List<String> orderList = orderIds.split(',');
            
            Set<String> orderSet = new Set<String>();
            
            
            
            for (String theOrderList : orderList) {
                
                orderSet.add(theOrderList);
                
            }
            
            
            
            // Requiry the Orders
            
            List<GC_Order__c> orders = GC_OrderDao.getInstance().getOrderByIds(orderSet);
            
            
            
            // Query the Tasks
            
            List<GC_GES_Order_Task__c> gots = GC_GESOrderTaskDao.getInstance().getGesOrderTaskOrderByOrderSet(orderSet);
            
            List<GC_Vendor_Order_Task__c> vots = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskByOrderSet(orderSet);
            
            
            
            List<GC_OrderHolder> orderWrappers = new List<GC_OrderHolder>();
            
            
            
            for (GC_Order__c order : orders) {
                
                GC_OrderHolder orderHolder = new GC_OrderHolder(order);
                
                
                
                for (GC_GES_Order_Task__c gotItem : gots) {
                    
                    if (gotItem.Order__c == order.Id) {
                        
                        orderHolder.gesTasks.add(gotItem);
                        
                    }
                    
                }
                
                
                
                for (GC_Vendor_Order_Task__c votItem : vots) {
                    
                    if (votItem.Order__c == order.Id) {
                        
                        orderHolder.vendorTasks.add(votItem);
                        
                    }
                    
                }
                
                
                
                orderWrappers.add(orderHolder);
                
            }
            
            
            
            String generatedCSVFile = '';
            
            
            
            // Custom metadata query to determine the order of placement on the CSV file.  Useful when the admin needs to adjust the ordering without code changes.
            
            List<GC_OrderCSV__mdt> orderCSVList;
            
            
            
            if (isCommunity) {
                
                orderCSVList = [Select Field_Label__c, Field_Name__c, Order_No__c, Is_Rich_Text__c from GC_OrderCSV__mdt where Hide_Community__c = false Order By Order_No__c];
                
            } else {
                
                orderCSVList = [Select Field_Label__c, Field_Name__c, Order_No__c, Is_Rich_Text__c from GC_OrderCSV__mdt order by Order_No__c];
                
            }
            
            
            
            List<String> allLabels = new List<String>();
            
            
            
            for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                
                allLabels.add(orderCSV.Field_Label__c);
                
            }
            
            
            
            generatedCSVFile += String.join(allLabels, ',') + '\n';
            
            
            
            for (GC_OrderHolder orderWrapper : orderWrappers) {
                
                // Skip Orders without Tasks
                
                if (orderWrapper.gesTasks.size() == 0 && orderWrapper.vendorTasks.size() == 0) {
                    
                    continue;
                    
                }
                
                
                
                //--Order Task Details
                
                String taskHeaderRow = '';
                
                
                
                // Map by Name and CSV String
                
                Map<String, String> taskDataMap = new Map<String, String>();
                
                
                
                for (GC_GES_Order_Task__c task : orderWrapper.gesTasks) {
                    
                    List<String> taskData = new List<String>();
                    
                    
                    
                    // Skip all tasks that are not active for printing.
                    
                    //SAL-420 - Avinash - 21/07/2017 - Commenting the below lines- Start
                    
                    /*if (task.Status__c != 'Active') {

continue;

}*/
                    
                    //SAL-420 - Avinash - 21/07/2017 - End
                    
                    
                    
                    for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                        
                        String parseStrVal = getFieldData(orderCSV.Field_Name__c, task, orderCSV.Is_Rich_Text__c).replaceAll('<[/a-zAZ0-9]*>', ' ');
                        
                        parseStrVal = parseStrVal.stripHtmlTags();
                        
                        taskData.add(parseStrVal);
                        
                    }
                    
                    
                    
                    taskDataMap.put(task.Name, String.join(taskData, ',') + '\n');
                    
                }
                
                
                
                // Vendor tasks will have a bunch of blank rows but it will get caught and return an empty string;
                
                for (GC_Vendor_Order_Task__c task : orderWrapper.vendorTasks) {
                    
                    List<String> taskData = new List<String>();
                    
                    
                    
                    for (GC_OrderCSV__mdt orderCSV : orderCSVList) {
                        
                        if (orderCSV.Field_Name__c == 'Revision__c') {
                            
                            task.Revision__c = null;
                            
                        }
                        
                        
                        
                        String parseStrVal = getFieldData(orderCSV.Field_Name__c, task, orderCSV.Is_Rich_Text__c).replaceAll('<[/a-zAZ0-9]*>', ' ');
                        
                        parseStrVal = parseStrVal.stripHtmlTags();
                        
                        taskData.add(parseStrVal);
                        
                    }
                    
                    
                    
                    taskDataMap.put(task.Name, String.join(taskData, ',') + '\n');
                    
                }
                
                
                
                for (String taskName : taskDataMap.keySet()) {
                    
                    generatedCSVFile += taskDataMap.get(taskName) + '\n';
                    
                }
                
            }
            
            
            
            return generatedCSVFile;
            
        } catch (Exception e) {
            
            
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage()));
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getStackTraceString()));
            
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
                
            } else if (fieldName.contains('__r.')
                       
                       && fnSplit.size() == 2
                       
                       && (task.getsObject(fnSplit[0]) == null
                           
                           || task.getsObject(fnSplit[0]).get(fnSplit[1]) == null)) {
                               
                               
                               
                               return '';
                               
                           } else {
                               
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
                               
                               return stringValue;
                               
                           }
            
        } catch (Exception e) {
            
            return '';
            
        }
        
    }
    
}