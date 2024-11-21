public with sharing class LC_CoreUtils {
    
    public class LC_CoreUtilsException extends Exception {
    }
    
    public class LC_CoreUtilsWrapper {
        Public GC_Core_Session__c session;
        public List<GC_Core_Interface_Log__c> coreLogs;
        @AuraEnabled
        public List<String> errorMessages;
        public String errorMessage;
        public Integer errors;
        public GC_GES_Order_Task__c GoTask;
        public List<GC_GES_Order_Task__c> tasksToUpdate;
        @AuraEnabled
        public List<LC_GESItemWrapper> gesItemWrapper;
    }
    
    public class LC_GESItemWrapper {
        @AuraEnabled
        public String itemId;
        @AuraEnabled
        public String itemName;
        @AuraEnabled
        public String itemStatus;
    }
    
    public static GC_Core_Session__c loginToCore() {
        GC_Core_Session__c session = getSessionID();
        if (!session.Is_Logged_In__c || (session.Is_Logged_In__c && session.Core_Application_Login_Expiration__c < DateTime.now())) {
            if (Test.isRunningTest()) {
                session.Is_Logged_In__c = true;
                session.Core_Application_Login_Expiration__c = DateTime.Now().addDays(1);
            }
            else {
                CORE_SECURITY.UserLoginWithoutPassword_element request = new CORE_SECURITY.UserLoginWithoutPassword_element();
                request.AppSessionID = session.Core_Application_Session_ID__c;
                request.Email = UserInfo.getUserEmail();
                if (request.Email.ToLowerCase().contains('ethos')||request.Email.ToLowerCase().contains('knagaraj')|| request.Email.ToLowerCase().contains('rsinha') || request.Email.ToLowerCase().contains('mnewhouse')) {
                    request.Email = GC_OrderUtils.getCustomSettings().Default_Login_Email__c;
                }
                request.RetrieveSecurityGroups = false;
                CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
                CORE_SECURITY.AppSessionInfo a = s.UserLoginWithoutPassword(request);
                session.Is_Logged_In__c = true;
                session.Core_Application_Login_Expiration__c = a.Expiration;
            }
            if(!Test.isRunningTest()){
                update session;
            }
        }
        return session;
    }
    
    public static GC_Core_Session__c getSessionID() {
        GC_Core_Session__c session;
        List<GC_Core_Session__c> existingSession = [SELECT Id, Core_Application_Session_ID__c, Is_Logged_In__c, Core_Application_Session_Error_Message__c, Core_Application_Login_Error_Message__c, User_ID__c, Core_Application_Login_Expiration__c, Core_Application_Session_Expiration__c FROM GC_Core_Session__c WHERE OwnerId = :UserInfo.getUserId() order by LastModifiedDate desc];
        if (existingSession.size() == 0) {
            if (Test.isRunningTest()) {
                session = GC_TestUtils.createTestSession(); 
            }
            else {
                session = new GC_Core_Session__c();
                CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
                CORE_SECURITY.AppSessionInfo a = s.StartAppSession();
                session.Core_Application_Session_ID__c = a.SessionID;
                session.Core_Application_Session_Expiration__c = a.Expiration;
                session.Is_Logged_In__c = false;
                if(!Test.isRunningTest()){
                    insert session;
                }
            }
        }
        else if ((string.isBlank(existingSession[0].Core_Application_Session_ID__c) || (existingSession[0].Core_Application_Session_Expiration__c==null) || existingSession[0].Core_Application_Session_Expiration__c < DateTime.Now()) && existingSession.size() > 0) {
            if (Test.isRunningTest()) {
                session = GC_TestUtils.createTestSession();
            }
            else {
                session = existingSession.get(0);
                CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
                CORE_SECURITY.AppSessionInfo a = s.StartAppSession();
                session.Core_Application_Session_ID__c = a.SessionID;
                session.Core_Application_Session_Expiration__c = a.Expiration;
                session.Is_Logged_In__c = false;
                update session;
            }
        }
        else {
            session = existingSession.get(0);
        }
        return session;
    }
    
    public static LC_CoreUtils.LC_CoreUtilsWrapper processOrderBatchReturnsWrapper(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean isCancel, Map<Id, GC_Order__c> mapOrders) {
        LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtilsWrapper();
        List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();
        integer errors=0;
        List<String> errorMessage = new List<String>();
        CORE_ORDER.BasicHttpBinding_IOrderService submitQuery = new CORE_ORDER.BasicHttpBinding_IOrderService();
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        try {
            wwwViadComV3_v1.ProcessShowOrgOrderBatch_element submitRequest = new wwwViadComV3_v1.ProcessShowOrgOrderBatch_element();
            submitRequest.applicationSessionId = sessionId;
            wwwViadComDataV3_v1.ArrayOfShowOrgOrderEntryStatus submitResponse;
            if (Test.isRunningTest()) {
                submitResponse = GC_TestUtils.getProcessShowOrgOrderResponse(submitRequest,gesOrderTasksByName);
            }
            else {
                submitResponse = submitQuery.ProcessShowOrgOrderBatch(submitRequest);
            }
            system.debug('submitResponse =='+submitResponse );
            if (submitResponse != null && submitResponse.ShowOrgOrderEntryStatus != null) {
                Integer index = 0;
                for (wwwViadComDataV3_v1.ShowOrgOrderEntryStatus status : submitResponse.ShowOrgOrderEntryStatus) {
                    system.debug('status.orderno==='+String.valueOf(status.OrderNumber));
                    if(mapOrders != null && mapOrders.size() > 0){
                        currentOrder = mapOrders.get(gesOrderTasksByName.get(status.SourceOrderCode).Order__c);
                    }
                    GC_GES_Order_Task__c task = updateGesOrderTaskReturnsWrapper(status.SourceOrderCode, status, gesOrderTasksByName).GoTask;
                    errorMessage.addAll(updateGesOrderTaskReturnsWrapper(status.SourceOrderCode, status, gesOrderTasksByName).errorMessages);
                    if (task != null) {
                        if (isCancel && status.Success) {
                            task.Core_Cancelled__c = true;
                            task.Status__c = 'Canceled';
                            system.debug('status.Success==='+status.Success);
                        }
                        tasksToUpdate.add(task);
                        String logStatus = !status.Success || String.isNotBlank(status.ErrorMessage) ? 'Error' : 'Success';
                        String prettyPrintResponse = getLogOrderEntryContents(task.Name, status);
                        coreLogs.add(createNewLog('Process Order ' + task.Name, prettyPrintResponse, logStatus, currentOrder, task));
                    }
                    else {
                        errors++;
                        //errorMessage.add(task.Name+' Task is blank');
                        errorMessage.add('Task is blank');
                    }
                    if (status.OrderNumber != null) {
                        currentOrder.Order_Number__c = String.valueOf(status.OrderNumber);
                        system.debug(String.valueOf(status.OrderNumber));
                        currentOrder.Status__c = 'Active';
                        // TODO last submitted date here
                    }
                    else {
                        errors++;
                        //errorMessage.add(task.Name+' No Order Number');
                        errorMessage.add('No Order Number');
                    }
                }
            }
            else {
                if(mapOrders != null && mapOrders.size() > 0){
                    currentOrder = mapOrders.values()[0];
                }
                String errorMsg = submitResponse != null ? 'Nothing to Process' : 'Failed to obtain a valid response from Web Service while Processing Order';
                if(String.isNotBlank(errorMsg)){
                    errors++;
                    errorMessage.add(errorMsg); 
                }
                coreLogs.add(createNewLog('Process Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
            }
        }
        catch (Exception e) {
            String errorMsg = e.getMessage() + ' ' + e.getStackTraceString();
            errorMessage.add(errorMsg);
            coreLogs.add(createNewLog('Process Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
        }
        
        LC_CoreWrapper.coreLogs = new list<GC_Core_Interface_Log__c>();
        LC_CoreWrapper.tasksToUpdate = new list<GC_GES_Order_Task__c>();
        LC_CoreWrapper.errorMessages = new list<String>();
        LC_CoreWrapper.coreLogs.addAll(coreLogs);
        LC_CoreWrapper.tasksToUpdate.addAll(tasksToUpdate);
        LC_CoreWrapper.errorMessages.addAll(errorMessage);
        return LC_CoreWrapper;
    }
    
    public static GC_Core_Interface_Log__c createNewLog(String method, String message, String status) {
        GC_Core_Interface_Log__c newLog = new GC_Core_Interface_Log__c();
        newLog.Message_Content__c = message;
        newLog.Method_Name__c = method;
        newLog.Status__c = status;
        return newLog;
    }
    
    public static GC_Core_Interface_Log__c createNewLog(String method, String message, String status, GC_Order__c order, GC_GES_Order_Task__c task) {
        GC_Core_Interface_Log__c newLog = createNewLog(method, message, status);
        newLog.Order__c = order.Id;
        newLog.Order_Task__c = task.Id;
        return newLog;
    }
    
    public static GC_Core_Interface_Log__c createNewLog(String method, String message, String status, GC_Order__c order){
        GC_Core_Interface_Log__c newLog = createNewLog(method, message, status);
        newLog.Order__c = order.Id;
        return newLog;
    }
    
    public static LC_CoreUtils.LC_CoreUtilsWrapper updateGesOrderTaskReturnsWrapper(String taskName, wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName) {
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
        LC_CoreWrapper.errorMessages = new list<string>();
        integer errors=0;
        List<String> errorMessage = new List<String>();
        if (!gesOrderTasksByName.ContainsKey(taskName)) {
            errors++;
            system.debug('Failed to Update ' + taskName + ': Could not find Task by Name');
            errorMessage.add('Failed to Update ' + taskName + ': Could not find Task by Name');
        }
        GC_GES_Order_Task__c task = gesOrderTasksByName.get(taskName);
        if (!submitResponse.Success) {
            errors++;
            system.debug('Error from Web Service. ' + submitResponse.ErrorMessage);
            errorMessage.add('Error from Web Service. ' + submitResponse.ErrorMessage);
        }
        if (String.isNotBlank(submitResponse.LineNumber)) {
            task.Status__c = 'Active';
            task.Submitted_Date__c = convertExternalDateTime(submitResponse.EnteredDateTime);
            task.Line_Item_Number__c = String.valueOf(submitResponse.LineNumber);
            task.Line_Item_Status__c = String.valueOf(submitResponse.LineStatus);
            task.Order_Header_ID__c = String.valueOf(submitResponse.OrderHeaderId);
            task.Order_Number__c = String.valueOf(submitResponse.OrderNumber);
            task.Order_Line_ID__c = String.valueOf(submitResponse.OrderLineId);
        }
        if(errors > 0){
            String constructErrorMessage;
            if(errorMessage.size() > 0){
                constructErrorMessage =  String.join(errorMessage, ' \n ');
            }
            LC_CoreWrapper.errorMessages.addAll(errorMessage);
        } 
        LC_CoreWrapper.GoTask = task;
        return LC_CoreWrapper;
    }
    
    public static String getLogOrderEntryContents(String index, wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse) {
        String orderEntryStatus = '';
        if (!submitResponse.Success || String.isNotBlank(submitResponse.ErrorMessage)) {
            orderEntryStatus += 'Error Message: ' + submitResponse.ErrorMessage + '\r\n';
            if (String.isNotBlank(submitResponse.LineNumber)) {
                orderEntryStatus += 'Entered Time: ' + submitResponse.EnteredDateTime;
                orderEntryStatus += ' | Source Order: ' + submitResponse.SourceOrderCode + '\r\n';
                orderEntryStatus += 'Line Number: ' + submitResponse.LineNumber;
                orderEntryStatus += ' | Order Number: ' + submitResponse.OrderNumber;
                orderEntryStatus += ' | Order Header Id: ' + submitResponse.OrderHeaderId;
                orderEntryStatus += ' | Order Line Id: ' + submitResponse.OrderLineId + '\r\n';
                orderEntryStatus += ' | Order Line Status: ' + submitResponse.LineStatus + '\r\n';
            }
        }
        else {
            orderEntryStatus += 'Entered Time: ' + submitResponse.EnteredDateTime;
            orderEntryStatus += ' | Source Order: ' + submitResponse.SourceOrderCode + '\r\n';
            orderEntryStatus += 'Line Number: ' + submitResponse.LineNumber;
            orderEntryStatus += ' | Order Number: ' + submitResponse.OrderNumber;
            orderEntryStatus += ' | Order Header Id: ' + submitResponse.OrderHeaderId;
            orderEntryStatus += ' | Order Line Id: ' + submitResponse.OrderLineId + '\r\n';
            orderEntryStatus += ' | Order Line Status: ' + submitResponse.LineStatus + '\r\n';
        }
        return orderEntryStatus;
    }
    
    public static void validateSession(GC_Core_Session__c existingSession){
        GC_Core_Session__c session = existingSession;
        if(session!=null){
            try{
                CORE_SECURITY.UserLoginWithoutPassword_element request = new CORE_SECURITY.UserLoginWithoutPassword_element();
                request.AppSessionID = session.Core_Application_Session_ID__c;
                request.Email = UserInfo.getUserEmail();
                if (request.Email.ToLowerCase().contains('ethos')|| request.Email.ToLowerCase().contains('slkgroup')) {
                    request.Email = GC_OrderUtils.getCustomSettings().Default_Login_Email__c;
                }
                request.RetrieveSecurityGroups = false;
                CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
                CORE_SECURITY.AppSessionInfo a = s.UserLoginWithoutPassword(request);
                session.Is_Logged_In__c = true;
                session.Core_Application_Login_Expiration__c = a.Expiration;
            }catch(exception e){
                if(Test.isRunningTest()){
                    return;
                }
                CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
                CORE_SECURITY.AppSessionInfo a = s.StartAppSession();
                session.Core_Application_Session_ID__c = a.SessionID;
                session.Core_Application_Session_Expiration__c = a.Expiration;
                session.Is_Logged_In__c = false;
                upsert session;
            }
        }
    }
    
    public static DateTime convertExternalDateTime(DateTime dt) {
        try {
            if(dt != null){ // SAL-1341: added null check by Sajid - 11/07/24
                DateTime newDt = DateTime.newInstance(dt.Year(), dt.Month(), dt.Day(),
                                                      dt.Hour(), dt.Minute(), dt.Second());
                // TODO this is very finicky and shouldn't be the way we should be doing this.  Time is being returned without the timezone preserved, so it must be local time of the server.
                // we're adding in the offset of the current time zone to display the correct time.
                TimeZone tz = UserInfo.getTimeZone();
                newDt = newDt.addSeconds(-tz.getOffset(DateTime.now()) / 1000);
                return newDt;
            }else{
                return null;
            }
        }
        catch (Exception e) {
            return null;
        }
    }
    
    //------------------------------new Method----------------//
    public static LC_CoreUtils.LC_CoreUtilsWrapper submitOrderToCoreReturnsWrapper(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean doProcessOrder) {
        LC_CoreUtils.LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtils.LC_CoreUtilsWrapper();
        LC_CoreWrapper.coreLogs = new List<GC_Core_Interface_Log__c>();
        LC_CoreWrapper.errorMessages = new List<String>();
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        LC_CoreWrapper.GoTask = new GC_GES_Order_Task__c();
        LC_CoreUtils.LC_GESItemWrapper gesItemWrap = new LC_CoreUtils.LC_GESItemWrapper();
        integer errors=0;
        List<String> errorMessage = new List<String>();
        List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();
        for (GC_GES_Order_Task__c orderTask : gesOrderTasksByName.values()) {
            if (orderTask.Status__c != 'Approved') {
                continue;
            }
            CORE_ORDER.BasicHttpBinding_IOrderService submitQuery = new CORE_ORDER.BasicHttpBinding_IOrderService();
            try {
                system.debug('Entered GOT---------' + orderTask);
                wwwViadComV3_v1.SubmitShowOrgOrder_element submitRequest = new wwwViadComV3_v1.SubmitShowOrgOrder_element();
                submitRequest.applicationSessionId = sessionId;
                wwwViadComDataV3_v1.CreateShowOrgOrder showOrgOrder = new wwwViadComDataV3_v1.CreateShowOrgOrder();
                showOrgOrder.SourceOrderCode = orderTask.Name;
                showOrgOrder.DeliveryArea = orderTask.Delivery_Location__c;
                showOrgOrder.Itemnumber = Integer.valueOf(orderTask.Item_Number__c);
                showOrgOrder.BoothAreaId = Integer.valueOf(orderTask.Formula_Booth_Area_ID__c);
                showOrgOrder.CancelOrder = false;
                showOrgOrder.UserItemDescription = orderTask.User_Item_Description__c;
                showOrgOrder.ParentSourceOrderCode = orderTask.Order__r.Name; //SAL-620
                showOrgOrder.ItemType = orderTask.ItemType__c;
                showOrgOrder.Department = orderTask.Department__r.Name;
                
                // Check for Date/Time overrides
                if (orderTask.Completion_Date_Time__c != null) {
                    showOrgOrder.CompletionDateTime = convertToOracleDateTime(orderTask.Completion_Date_Time__c);
                }
                else {
                    showOrgOrder.CompletionDateTime = convertToOracleDateTime(orderTask.Formula_Completion_Date_Time__c);
                }
                
                if (orderTask.Removal_Date_Time__c != null) {
                    showOrgOrder.RemovalDateTime = convertToOracleDateTime(orderTask.Removal_Date_Time__c);
                }
                else {
                    showOrgOrder.RemovalDateTime = convertToOracleDateTime(orderTask.Formula_Removal_Date_Time__c);
                }
                if (orderTask.Delivery_Date_Time__c != null) {
                    showOrgOrder.DeliveryDateTime = convertToOracleDateTime(orderTask.Delivery_Date_Time__c);
                }
                else {
                    showOrgOrder.DeliveryDateTime = convertToOracleDateTime(orderTask.Formula_Delivery_Date_Time__c);
                }
                if (orderTask.Discount_Reason_Code__c != null) {
                    showOrgOrder.DiscountReasonCode = GC_GOTCreationController.getReasonCodes(orderTask.Discount_Reason_Code__c);                    
                }
                if (orderTask.Discount_Reason_Text__c != null) {
                    showOrgOrder.DiscountReasonText = orderTask.Discount_Reason_Text__c;
                }
                if (orderTask.Budget_Code__c != null) {
                    showOrgOrder.BudgetCode = orderTask.Budget_Code__c;
                }
                // Remarks updates.
                if (orderTask.Details_To_Invoice_Remarks__c != null) {
                    showOrgOrder.DetailsToInvoice = orderTask.Details_To_Invoice_Remarks__c;
                }
                if (orderTask.Add_Client_Special_Info_Order_Remarks__c != null) {
                    //SAL-1104
                    showOrgOrder.DetailsToProduction = orderTask.Add_Client_Special_Info_Order_Remarks__c; //Details_To_Production_Remarks__c
                }
                if (orderTask.Details_To_Show_Site_Remarks__c != null) {
                    showOrgOrder.DetailsToShowsite = orderTask.Details_To_Show_Site_Remarks__c;
                }
                if (String.isNotBlank(orderTask.Invoice_Remarks__c)) {
                    showOrgOrder.InvoiceRemarks = orderTask.Invoice_Remarks__c;
                }
                if (String.isNotBlank(orderTask.Production_Remarks__c)) {
                    showOrgOrder.ProductionRemarks = orderTask.Production_Remarks__c;
                }
                if (String.isNotBlank(orderTask.Item_Type_Remarks__c)) {
                    showOrgOrder.ItemTypeRemarks = orderTask.Item_Type_Remarks__c;
                }
                if (String.isNotBlank(orderTask.Show_Site_Remarks__c)) {
                    showOrgOrder.ShowSiteRemarks = orderTask.Show_Site_Remarks__c;
                }
                if (String.isNotBlank(orderTask.Price__c)) {
                    showOrgOrder.Price = Decimal.valueOf(orderTask.Price__c);
                }
                if (orderTask.New_Price__c != null) {
                    showOrgOrder.NewPrice = orderTask.New_Price__c;
                }
                if (orderTask.Booth_Area_Discount_Override__c != null) {
                    showOrgOrder.DiscountPercentageOverride = Decimal.valueOf('' + orderTask.Booth_Area_Discount_Override__c);
                }
                if (String.isNotBlank(orderTask.SA_Venue_Location__c)) {
                    showOrgOrder.VenueLocation = orderTask.SA_Venue_Location__r.Name;
                }
                if (String.isNotBlank(orderTask.Description__c)) {
                    showOrgOrder.OrderDescription = orderTask.Description__c;
                }
                
                // We don't need to push units, it should be only stored in salesforce.
                if (String.isNotBlank(orderTask.UOM__c)) {
                    showOrgOrder.UOM = orderTask.UOM__c;
                }
                if (String.isNotBlank(orderTask.Onsite_Contact_Person_FML__c)) {
                    showOrgOrder.OnsiteContact = orderTask.Onsite_Contact_Person_FML__c;
                }
                if (String.isNotBlank(orderTask.Onsite_Contact_Person_Number_FML__c)) {
                    showOrgOrder.OnsiteContactNumber = orderTask.Onsite_Contact_Person_Number_FML__c;
                }
                /*if (String.isNotBlank(orderTask.Show_Management_Field__c)) {
showOrgOrder.Instructions = orderTask.Show_Management_Field__c.stripHtmlTags();
}*/
                if (String.isNotBlank(orderTask.Special_Instructions_Client_Remarks__c)) {
                    showOrgOrder.Instructions = orderTask.Special_Instructions_Client_Remarks__c;
                }
                if (String.isNotBlank(orderTask.File_Reference_Link__c)) {
                    showOrgOrder.FileReference = orderTask.File_Reference_Link__c;
                }
                if (String.isNotBlank(orderTask.Order_Line_ID__c)) {
                    showOrgOrder.UpdateOrderLineId = Integer.valueOf(orderTask.Order_Line_ID__c);
                }
                if (String.isNotBlank(orderTask.Parent_GEM_Structure__c)) {
                    showOrgOrder.ParentSourceOrderCode = orderTask.Parent_GEM_Structure__r.Name;
                }
                //Added by KN for SAL- 1008 on Jun 06,2019
                if (orderTask.HideSourceOrderCodes__c != null) {
                    showOrgOrder.HideSourceOrderCodes = orderTask.HideSourceOrderCodes__c;
                }
                if (orderTask.Item_Template__c == 'GEM Structures') {
                    if (orderTask.QuantityNum__c != null) {
                        showOrgOrder.Quantity = Integer.valueOf(orderTask.QuantityNum__c);
                    }
                }
                
                if (orderTask.Item_Template__c == 'Basic' || orderTask.Item_Template__c.Contains('Graphics')) {
                    if (orderTask.QuantityNum__c != null) {
                        showOrgOrder.Quantity = Integer.valueOf(orderTask.QuantityNum__c);
                    }
                }
                
                if (orderTask.Item_Template__c == 'Graphics' || orderTask.Item_Template__c == 'Custom Graphics') {
                    //if (String.isNotBlank(orderTask.Layout__c)) {
                    //    showOrgOrder.Layout = orderTask.Layout__c.stripHtmlTags();
                    // }
                    if (String.isNotBlank(orderTask.Client_Layout_Notes__c)) {
                        showOrgOrder.Layout = orderTask.Client_Layout_Notes__c;
                    }
                    //if (String.isNotBlank(orderTask.Sign_Copy__c)) {
                    //    showOrgOrder.Copy = orderTask.Sign_Copy__c.stripHtmlTags();
                    // }
                    if (String.isNotBlank(orderTask.Sign_Copy_Plain__c)) {
                        showOrgOrder.Copy = orderTask.Sign_Copy_Plain__c;
                    }
                    if (String.isNotBlank(orderTask.Installation_Method__c)) {
                        showOrgOrder.Install = orderTask.Installation_Method__c;
                    }
                    if (String.isNotBlank(orderTask.Sign_Title__c)) {
                        showOrgOrder.ItemTitle = orderTask.Sign_Title__c;
                    }
                    if (String.isNotBlank(orderTask.GOT_Sign_Type_Other__c)) {
                        showOrgOrder.ItemType = orderTask.GOT_Sign_Type_Other__c;
                    }
                    else if (String.isNotBlank(orderTask.GOT_Sign_Type__c)) {
                        showOrgOrder.ItemType = orderTask.GOT_Sign_Type__c;
                    }
                    if (String.isNotBlank(orderTask.GOT_Single_Double_Sided__c)) {
                        showOrgOrder.Sided = orderTask.GOT_Single_Double_Sided__c;
                    }
                    if (String.isNotBlank(orderTask.GOT_Copy_Placement__c)) {
                        showOrgOrder.Placement = orderTask.GOT_Copy_Placement__c;
                    }
                    if (String.isNotBlank(orderTask.Material__c)) {
                        showOrgOrder.Material = String.valueOf(orderTask.Material__r.Name);
                    }
                    if (orderTask.Outdoors__c != null) {
                        showOrgOrder.Outdoors = orderTask.Outdoors__c;
                    }
                    if (String.isNotBlank(orderTask.Save_Signs__c)) {
                        showOrgOrder.Save = orderTask.Save_Signs__c;
                    }
                    if (String.isNotBlank(orderTask.GOT_Background__c)) {
                        showOrgOrder.Background = orderTask.GOT_Background__c;
                    }
                }
                
                if (orderTask.Item_Template__c == 'Custom Graphics') {
                    if (orderTask.Sign_Length__c != null) {
                        showOrgOrder.Length = Integer.valueof(orderTask.Sign_Length__c);
                    }
                    if (orderTask.Sign_Width__c != null) {
                        showOrgOrder.Width = Integer.valueof(orderTask.Sign_Width__c);
                    }
                }
                if (orderTask.Item_Template__c.Contains('Carpet')) {
                    if (orderTask.Electrical_Ordered__c != null) {
                        showOrgOrder.ElectricalOrdered = orderTask.Electrical_Ordered__c;
                    }
                    if (orderTask.Electrical_Under__c != null) {
                        showOrgOrder.ElectricalUnder = orderTask.Electrical_Under__c;
                    }
                    if (orderTask.UOM__c == 'SF' && orderTask.Carpet_Length__c != null) {
                        showOrgOrder.Length = Integer.valueof(orderTask.Carpet_Length__c);
                    }
                    if (orderTask.UOM__c == 'SF' && orderTask.Carpet_Width__c != null) {
                        showOrgOrder.Width = Integer.valueof(orderTask.Carpet_Width__c);
                    }
                    
                    if (orderTask.QuantityNum__c != null) {
                        showOrgOrder.Quantity = Integer.valueOf(orderTask.QuantityNum__c);
                    }
                }
                if (orderTask.Item_Template__c.Contains('Labor')){
                    if (orderTask.Labor_In_Out__c == 'IN' || orderTask.Labor_In_Out__c == 'OUT') {
                        showOrgOrder.LaborMode = orderTask.Labor_In_Out__c;
                    }
                    if (orderTask.QuantityNum__c != null) {
                        showOrgOrder.Quantity = Integer.valueOf(orderTask.QuantityNum__c);
                    }
                } 
                //showOrgOrder.LaborMode = 'IN';
                submitRequest.order = showOrgOrder;
                wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse;
                
                if (Test.isRunningTest()) {
                    submitResponse = GC_TestUtils.getSubmitShowOrgOrderResponse(submitRequest);
                }
                else {
                    submitResponse = submitQuery.SubmitShowOrgOrder(submitRequest);
                }
                GC_Core_Interface_Log__c coreLog = new GC_Core_Interface_Log__c();
                gesItemWrap.itemId = orderTask.Id;
                gesItemWrap.itemName = orderTask.Name;
                if (submitResponse != null) {
                    String status = !submitResponse.Success || String.isNotBlank(submitResponse.ErrorMessage) ? 'Error' : 'Success';
                    gesItemWrap.itemStatus = status == 'Success' ? 'Item has been submitted successfully' : 'Item is failed, please see logs for more details';
                    String prettyPrintResponse = getLogOrderEntryContents(orderTask.Name, submitResponse);
                    coreLog = createNewLog('Submit Order ' + orderTask.Name, prettyPrintResponse, status, currentOrder, orderTask);
                    LC_CoreWrapper.coreLogs.add(coreLog);
                    if (String.isNotBlank(submitResponse.ErrorMessage)) {
                        errors++;
                        LC_CoreWrapper.errorMessages.add(orderTask.Name+' '+submitResponse.ErrorMessage);
                    }
                    if (String.isNotBlank(submitResponse.LineNumber)) {
                        task = updateGesOrderTaskReturnsWrapper(submitResponse.SourceOrderCode, submitResponse, gesOrderTasksByName).GoTask;
                        LC_CoreWrapper.errorMessages.addAll(updateGesOrderTaskReturnsWrapper(submitResponse.SourceOrderCode, submitResponse, gesOrderTasksByName).errorMessages); 
                        if (task != null) {
                            tasksToUpdate.add(task);
                        }
                        else {
                            errors++;
                            LC_CoreWrapper.errorMessages.add(orderTask.Name+' Task is blank');
                        }
                    }
                }
                else {
                    gesItemWrap.itemStatus = 'Failed to obtain response from Web Service while Submitting Item';
                    String errorMsg = orderTask.Name+' Failed to obtain response from Web Service while Submitting Order';
                    errors++;
                    LC_CoreWrapper.errorMessages.add(errorMsg);
                    coreLog = createNewLog('Submit Order ' + orderTask.Name, errorMsg, 'Error', currentOrder, orderTask);
                    LC_CoreWrapper.coreLogs.add(coreLog);
                }
                LC_CoreWrapper.gesItemWrapper = new List<LC_CoreUtils.LC_GESItemWrapper>{gesItemWrap};
            }
            catch (Exception e) {
                errors++;
                String errorMsg = orderTask.Name+' '+e.getMessage() + ' ' + e.getStackTraceString();
                coreLogs.add(createNewLog('Submit Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
                insert coreLogs;
                throw new LC_CoreUtilsException('Submit Order '+errorMsg);
            }
        }
        LC_CoreWrapper.tasksToUpdate = new list<GC_GES_Order_Task__c>();
        LC_CoreWrapper.tasksToUpdate = tasksToUpdate;
        //update tasksToUpdate;
        // GC-539 should update Order Status to Active / Cancelled.
        // GC-539 should update the Order Number as well, all being done via trigger.
        
        //-----------------done in a separate Method
        /* if (errors == 0 && doProcessOrder) {
processOrderBatch(sessionId, currentOrder, gesOrderTasksByName, false);
} */
        return LC_CoreWrapper;
    }
    
    //----------------------method for cancel in core
    public static LC_CoreUtilsWrapper cancelOrderInCoreReturnsWrapper(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean doProcessOrder) {
        
        LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtilsWrapper();
        Integer errors = 0;
        Integer tasksToCancel = 0;
        LC_CoreWrapper.coreLogs = new List<GC_Core_Interface_Log__c>();
        LC_CoreWrapper.errorMessages = new List<String>();
        LC_CoreWrapper.tasksToUpdate = new List<GC_GES_Order_Task__c>();
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
        LC_CoreWrapper.GoTask = new GC_GES_Order_Task__c();
        List<String> errorMessage = new List<String>();
        
        for (GC_GES_Order_Task__c orderTask : gesOrderTasksByName.values()) {
            if ((orderTask.Status__c == 'Canceled' || orderTask.Status__c == 'Active') && String.isNotBlank(orderTask.Order_Line_ID__c) && !orderTask.Core_Cancelled__c) {
                CORE_ORDER.BasicHttpBinding_IOrderService submitQuery = new CORE_ORDER.BasicHttpBinding_IOrderService();
                try {
                    wwwViadComV3_v1.SubmitShowOrgOrder_element submitRequest = new wwwViadComV3_v1.SubmitShowOrgOrder_element();
                    submitRequest.applicationSessionId = sessionId;
                    wwwViadComDataV3_v1.CreateShowOrgOrder showOrgOrder = new wwwViadComDataV3_v1.CreateShowOrgOrder();
                    showOrgOrder.SourceOrderCode = orderTask.Name;
                    showOrgOrder.UpdateOrderLineId = Integer.valueOf(orderTask.Order_Line_ID__c);
                    showOrgOrder.CancelOrder = true;
                    system.debug('orderTask.HideSourceOrderCodes__c==='+orderTask.HideSourceOrderCodes__c);
                    showOrgOrder.HideSourceOrderCodes= (orderTask.HideSourceOrderCodes__c!=null)?orderTask.HideSourceOrderCodes__c:false;
                    submitRequest.order = showOrgOrder;
                    
                    wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse;
                    if (Test.isRunningTest()) {
                        submitResponse = GC_TestUtils.getCancelShowOrgOrderResponse(submitRequest);
                    }
                    else {
                        submitResponse = submitQuery.SubmitShowOrgOrder(submitRequest);
                    }
                    if (submitResponse != null) {
                        String status = !submitResponse.Success || String.isNotBlank(submitResponse.ErrorMessage) ? 'Error' : 'Success';
                        String prettyPrintResponse = getLogOrderEntryContents(orderTask.Name, submitResponse);
                        coreLogs.add(createNewLog('Cancel Order ' + orderTask.Name, prettyPrintResponse, status, currentOrder, orderTask));
                        if (String.isNotBlank(submitResponse.ErrorMessage)) {
                            errors++;
                            errorMessage.add('Error from Web Service :'+submitResponse.ErrorMessage);
                        }
                        else {
                            tasksToCancel++;
                        }
                        prettyPrintResponse = getLogOrderEntryContents(orderTask.Name, submitResponse);
                    }
                    else {
                        String errorMsg = 'Failed to obtain response from Web Service while Cancelling Order';
                        errorMessage.add(errorMsg);
                        coreLogs.add(createNewLog('Cancel Order ' + orderTask.Name, errorMsg, 'Error', currentOrder, orderTask));
                    }
                }
                catch (Exception e) {
                    errors++;
                    String errorMsg = e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber();
                    errorMessage.add(errorMsg);
                    coreLogs.add(createNewLog('Cancel Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
                }
            }
        }
        LC_CoreWrapper.errorMessages.addAll(errorMessage);
        LC_CoreWrapper.coreLogs.addAll(coreLogs);
        return LC_CoreWrapper;
    }
    
    public static LC_CoreUtilsWrapper cancelOrderInCoreFromListViewPage(String sessionId, Map<Id,GC_Order__c> mapOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean isCancel) {
        LC_CoreUtilsWrapper LC_CoreWrapper = new LC_CoreUtilsWrapper();
        Integer errors = 0;
        Integer tasksToCancel = 0;
        LC_CoreWrapper.coreLogs = new List<GC_Core_Interface_Log__c>();
        LC_CoreWrapper.errorMessages = new List<String>();
        LC_CoreWrapper.tasksToUpdate = new List<GC_GES_Order_Task__c>();
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        List<String> errorMessage = new List<String>();
        List<GC_GES_Order_Task__c> listTasksToUpdate = new List<GC_GES_Order_Task__c>();
        GC_Order__c currentOrder = new GC_Order__c();
        List<LC_GESItemWrapper> listGESItemWrap = new List<LC_GESItemWrapper>();
        
        for (GC_GES_Order_Task__c orderTask : gesOrderTasksByName.values()) {
            currentOrder = mapOrder.get(orderTask.Order__c);
            CORE_ORDER.BasicHttpBinding_IOrderService submitQuery = new CORE_ORDER.BasicHttpBinding_IOrderService();
            try {
                wwwViadComV3_v1.SubmitShowOrgOrder_element submitRequest = new wwwViadComV3_v1.SubmitShowOrgOrder_element();
                submitRequest.applicationSessionId = sessionId;
                wwwViadComDataV3_v1.CreateShowOrgOrder showOrgOrder = new wwwViadComDataV3_v1.CreateShowOrgOrder();
                showOrgOrder.SourceOrderCode = orderTask.Name;
                showOrgOrder.UpdateOrderLineId = Integer.valueOf(orderTask.Order_Line_ID__c);
                showOrgOrder.CancelOrder = true;
                showOrgOrder.HideSourceOrderCodes= (orderTask.HideSourceOrderCodes__c!=null)?orderTask.HideSourceOrderCodes__c:false;
                submitRequest.order = showOrgOrder;
                
                wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse;
                if (Test.isRunningTest()) {
                    submitResponse = GC_TestUtils.getCancelShowOrgOrderResponse(submitRequest);
                }
                else {
                    submitResponse = submitQuery.SubmitShowOrgOrder(submitRequest);
                }
                
                LC_GESItemWrapper gesItemWrap = new LC_GESItemWrapper(); 
                gesItemWrap.itemId = orderTask.Id;
                gesItemWrap.itemName = orderTask.Name;
                
                if (submitResponse != null) {
                    String status = !submitResponse.Success || String.isNotBlank(submitResponse.ErrorMessage) ? 'Error' : 'Success';
                    gesItemWrap.itemStatus = status == 'Success' ? 'Item has been canceled and processed in Core sucessfully.' : 'Item is failed, please see logs for more details'; //SAL-1217 - cancel items in core GES Item Wrapper - 03/11/24
                    String prettyPrintResponse = getLogOrderEntryContents(orderTask.Name, submitResponse);
                    coreLogs.add(createNewLog('Cancel Order ' + orderTask.Name, prettyPrintResponse, status, currentOrder, orderTask));
                    if (String.isNotBlank(submitResponse.ErrorMessage)) {
                        errors++;
                        errorMessage.add('Error from Web Service :'+submitResponse.ErrorMessage);
                    }
                    else {
                        tasksToCancel++;
                    }
                    
                    GC_GES_Order_Task__c task = new GC_GES_Order_Task__c();
                    task.Id = orderTask.Id;
                    if (String.isNotBlank(submitResponse.LineNumber)) {
                        task.Status__c = 'Active';
                        task.Submitted_Date__c = convertExternalDateTime(submitResponse.EnteredDateTime);
                        task.Line_Item_Number__c = String.valueOf(submitResponse.LineNumber);
                        task.Line_Item_Status__c = String.valueOf(submitResponse.LineStatus);
                        task.Order_Header_ID__c = String.valueOf(submitResponse.OrderHeaderId);
                        task.Order_Number__c = String.valueOf(submitResponse.OrderNumber);
                        task.Order_Line_ID__c = String.valueOf(submitResponse.OrderLineId);
                    }
                    
                    if (isCancel && submitResponse.Success) {
                        task.Core_Cancelled__c = true;
                        task.Status__c = 'Canceled';
                    }
                    listTasksToUpdate.add(task);
                }
                else {
                    gesItemWrap.itemStatus = 'Failed to obtain response from Web Service while Cancelling Order';
                    String errorMsg = 'Failed to obtain response from Web Service while Cancelling Order';
                    errorMessage.add(errorMsg);
                    coreLogs.add(createNewLog('Cancel Order ' + orderTask.Name, errorMsg, 'Error', currentOrder, orderTask));
                }
                listGESItemWrap.add(gesItemWrap);
            }
            catch (Exception e) {
                errors++;
                String errorMsg = e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber();
                errorMessage.add(errorMsg);
                coreLogs.add(createNewLog('Cancel Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
            }
        }
        LC_CoreWrapper.tasksToUpdate.addAll(listTasksToUpdate);
        LC_CoreWrapper.gesItemWrapper = listGESItemWrap;
        LC_CoreWrapper.errorMessages.addAll(errorMessage);
        LC_CoreWrapper.coreLogs.addAll(coreLogs);
        return LC_CoreWrapper;
    }
    
    public static DateTime convertToOracleDateTime(DateTime dt) {
        try {
            DateTime newDt = DateTime.newInstance(dt.Year(), dt.Month(), dt.Day(),
                                                  dt.Hour(), dt.Minute(), dt.Second());
            // TODO this is very finicky and shouldn't be the way we should be doing this.  Time is being returned without the timezone preserved, so it must be local time of the server.
            // we're adding in the offset of the current time zone to display the correct time.
            //TimeZone tz = UserInfo.getTimeZone();
            //newDt = newDt.addSeconds(-tz.getOffset(DateTime.now()) / 1000);
            return newDt;
        }
        catch (Exception e) {
            return null;
        }
    }
    
    public static void insertCoreLogs(List<GC_Core_Interface_Log__c> resultLogs){
        try{
            upsert resultLogs;
        }catch(Exception e){
            system.debug('Exception---exception'+e);
            system.debug('Exception---exception'+e.getStackTraceString());
        }
    }
}