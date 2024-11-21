/**
* @author Ethos Solutions - www.ethos.com
* @description Utility class to get information from CORE
* 2016-04-13 : Original Version
**/
public with sharing class GC_CoreUtils {
    public static Boolean devMode = false;
    
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
                insert session;
            }
        }
        else if (existingSession.size() > 0 && existingSession.get(0).Core_Application_Session_Expiration__c < DateTime.Now()) {
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
        
        // validateSession(session);
        system.debug('session.Core_Application_Session_ID__c==='+session.Core_Application_Session_ID__c);
        return session;
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
                if (request.Email.ToLowerCase().contains('ethos')|| request.Email.ToLowerCase().contains('slkgroup')) {
                    request.Email = GC_OrderUtils.getCustomSettings().Default_Login_Email__c;
                }
                request.RetrieveSecurityGroups = false;
                CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService s = new CORE_SECURITY_IMPL.BasicHttpBinding_IAuthenticationService();
                CORE_SECURITY.AppSessionInfo a = s.UserLoginWithoutPassword(request);
                session.Is_Logged_In__c = true;
                session.Core_Application_Login_Expiration__c = a.Expiration;
            }
            update session;
        }
        return session;
    }
    
    public static String getAPIEndpoint() {
        return GC_OrderUtils.getCustomSettings().API_ENDPOINT__c;
    }
    
    public static DateTime convertExternalDateTime(DateTime dt) {
        try {
            DateTime newDt = DateTime.newInstance(dt.Year(), dt.Month(), dt.Day(),
                                                  dt.Hour(), dt.Minute(), dt.Second());
            // TODO this is very finicky and shouldn't be the way we should be doing this.  Time is being returned without the timezone preserved, so it must be local time of the server.
            // we're adding in the offset of the current time zone to display the correct time.
            TimeZone tz = UserInfo.getTimeZone();
            newDt = newDt.addSeconds(-tz.getOffset(DateTime.now()) / 1000);
            return newDt;
        }
        catch (Exception e) {
            return null;
        }
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
    
    public static void submitOrderToCore(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName) {
        submitOrderToCore(sessionId, currentOrder, gesOrderTasksByName, true);
    }
    
    public static List<GC_Core_Interface_Log__c> submitOrderToCore(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean doProcessOrder) {
        System.debug('List<GC_Core_Interface_Log__c> submitOrderToCore');
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        Integer errors = 0;
        List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();
        for (GC_GES_Order_Task__c orderTask : gesOrderTasksByName.values()) {
            if (orderTask.Status__c != 'Approved') {
                //GC_PageUtil.AddDeveloperMessage(orderTask.Name + ' needs to be in an Approved Status');
                continue;
            }
            CORE_ORDER.BasicHttpBinding_IOrderService submitQuery = new CORE_ORDER.BasicHttpBinding_IOrderService();
            try {
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
                    system.debug('showOrgOrder.DiscountReasonCode==='+showOrgOrder.DiscountReasonCode);
                           
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
                if (orderTask.Details_To_Production_Remarks__c != null) {
                    showOrgOrder.DetailsToProduction = orderTask.Details_To_Production_Remarks__c;
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
                
                if (String.isNotBlank(orderTask.Show_Management_Field__c)) {
                    showOrgOrder.Instructions = orderTask.Show_Management_Field__c.stripHtmlTags();
                }
                
                if (String.isNotBlank(orderTask.File_Reference_Link__c)) {
                    showOrgOrder.FileReference = orderTask.File_Reference_Link__c;
                }
                if (String.isNotBlank(orderTask.Order_Line_ID__c)) {
                    showOrgOrder.UpdateOrderLineId = Integer.valueOf(orderTask.Order_Line_ID__c);
                }
                 system.debug('valueOrderNumber==='+orderTask.Parent_GEM_Structure__r.Order_Number__c);
                if (String.isNotBlank(orderTask.Parent_GEM_Structure__c)) {
                     showOrgOrder.ParentSourceOrderCode = orderTask.Parent_GEM_Structure__r.Name;
                    
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
                    if (String.isNotBlank(orderTask.Layout__c)) {
                        showOrgOrder.Layout = orderTask.Layout__c.stripHtmlTags();
                    }
                    if (String.isNotBlank(orderTask.Sign_Copy__c)) {
                        showOrgOrder.Copy = orderTask.Sign_Copy__c.stripHtmlTags();
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
                    //system.debug('submitRequest.order===' + submitRequest.order);
                }
                
                if (submitResponse != null) {
                    String status = !submitResponse.Success || String.isNotBlank(submitResponse.ErrorMessage) ? 'Error' : 'Success';
                    String prettyPrintResponse = getLogOrderEntryContents(orderTask.Name, submitResponse);
                    coreLogs.add(createNewLog('Submit Order ' + orderTask.Name, prettyPrintResponse, status, currentOrder, orderTask));
                    if (String.isNotBlank(submitResponse.ErrorMessage)) {
                        errors++;
                    }
                    if (String.isNotBlank(submitResponse.LineNumber)) {
                        GC_GES_Order_Task__c task = updateGesOrderTask(submitResponse.SourceOrderCode, submitResponse, gesOrderTasksByName);
                        if (task != null) {
                            tasksToUpdate.add(task);
                        }
                        else {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Task is blank'));
                        }
                    }
                }
                else {
                    String errorMsg = 'Failed to obtain response from Web Service while Submitting Order';
                    GC_PageUtil.AddErrorMessage(errorMsg);
                    coreLogs.add(createNewLog('Submit Order ' + orderTask.Name, errorMsg, 'Error', currentOrder, orderTask));
                }
            }
            catch (Exception e) {
                errors++;
                String errorMsg = e.getMessage() + ' ' + e.getStackTraceString();
                GC_PageUtil.AddErrorMessage(errorMsg);
                coreLogs.add(createNewLog('Submit Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
            }
        }
        update tasksToUpdate;
        // GC-539 should update Order Status to Active / Cancelled.
        // GC-539 should update the Order Number as well, all being done via trigger.
        if (errors == 0 && doProcessOrder) {
            processOrderBatch(sessionId, currentOrder, gesOrderTasksByName, false);
        }
        //insert coreLogs; --- checking on the webservices error
        //system.debug('coreLogs1==='+coreLogs);
        return coreLogs;
    }
    
    public static List<GC_Core_Interface_Log__c> cancelOrderInCore(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean doProcessOrder) {
        Integer errors = 0;
        Integer tasksToCancel = 0;
        List<GC_Core_Interface_Log__c> coreLogs = new List<GC_Core_Interface_Log__c>();
        for (GC_GES_Order_Task__c orderTask : gesOrderTasksByName.values()) {
            if (orderTask.Status__c == 'Canceled' && String.isNotBlank(orderTask.Order_Line_ID__c) && !orderTask.Core_Cancelled__c) {
                CORE_ORDER.BasicHttpBinding_IOrderService submitQuery = new CORE_ORDER.BasicHttpBinding_IOrderService();
                try {
                    
                    wwwViadComV3_v1.SubmitShowOrgOrder_element submitRequest = new wwwViadComV3_v1.SubmitShowOrgOrder_element();
                    submitRequest.applicationSessionId = sessionId;
                    wwwViadComDataV3_v1.CreateShowOrgOrder showOrgOrder = new wwwViadComDataV3_v1.CreateShowOrgOrder();
                    showOrgOrder.SourceOrderCode = orderTask.Name;
                    showOrgOrder.UpdateOrderLineId = Integer.valueOf(orderTask.Order_Line_ID__c);
                    showOrgOrder.CancelOrder = true;
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
                        }
                        else {
                            tasksToCancel++;
                        }
                        GC_CoreUtils.getLogOrderEntryContents(orderTask.Name, submitResponse);
                    }
                    else {
                        String errorMsg = 'Failed to obtain response from Web Service while Cancelling Order';
                        GC_PageUtil.AddErrorMessage(errorMsg);
                        coreLogs.add(createNewLog('Cancel Order ' + orderTask.Name, errorMsg, 'Error', currentOrder, orderTask));
                    }
                }
                catch (Exception e) {
                    errors++;
                    String errorMsg = e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getLineNumber();
                    GC_PageUtil.AddErrorMessage(errorMsg);
                    coreLogs.add(createNewLog('Cancel Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
                }
            }
        }
        if (errors == 0 && tasksToCancel > 0 && doProcessOrder) {
            processOrderBatch(sessionId, currentOrder, gesOrderTasksByName, true);
        }
        system.debug('coreLogs2==='+coreLogs);
        //insert coreLogs;
        return coreLogs;
    }
    
    public static List<GC_Core_Interface_Log__c> processOrderBatch(String sessionId, GC_Order__c currentOrder, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName, Boolean isCancel) {
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
                List<GC_GES_Order_Task__c> tasksToUpdate = new List<GC_GES_Order_Task__c>();
                
                for (wwwViadComDataV3_v1.ShowOrgOrderEntryStatus status : submitResponse.ShowOrgOrderEntryStatus) {
                    system.debug('status.orderno==='+String.valueOf(status.OrderNumber));
                    
                    GC_GES_Order_Task__c task = updateGesOrderTask(status.SourceOrderCode, status, gesOrderTasksByName);
                    
                    if (task != null) {
                        if (isCancel) {
                            task.Core_Cancelled__c = true;
                            task.Status__c = 'Canceled';
                        }
                        tasksToUpdate.add(task);
                        String logStatus = !status.Success || String.isNotBlank(status.ErrorMessage) ? 'Error' : 'Success';
                        String prettyPrintResponse = getLogOrderEntryContents(task.Name, status);
                        coreLogs.add(createNewLog('Process Order ' + task.Name, prettyPrintResponse, logStatus, currentOrder, task));
                    }
                    else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Task is blank'));
                    }
                    if (status.OrderNumber != null) {
                        currentOrder.Order_Number__c = String.valueOf(status.OrderNumber);
                        system.debug(String.valueOf(status.OrderNumber));
                        currentOrder.Status__c = 'Active';
                        // TODO last submitted date here
                    }
                    else {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'No Order Number'));
                    }
                }
                update tasksToUpdate;
                // No need to update the current order, since the trigger will take care of it.
            }
            else {
                system.debug('submitResponse2=='+submitResponse );
                String errorMsg = submitResponse != null ? 'Nothing to Process' : 'Failed to obtain a valid response from Web Service while Processing Order';
                GC_PageUtil.AddErrorMessage(errorMsg);
                coreLogs.add(createNewLog('Process Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
            }
        }
        catch (Exception e) {
            String errorMsg = e.getMessage() + ' ' + e.getStackTraceString();
            GC_PageUtil.AddErrorMessage(errorMsg);
            coreLogs.add(createNewLog('Process Order ' + currentOrder.Name, errorMsg, 'Error', currentOrder));
        }
        //insert coreLogs;
        system.debug('coreLogs3==='+coreLogs);
        return coreLogs;
    }
    
    public static GC_GES_Order_Task__c updateGesOrderTask(String taskName, wwwViadComDataV3_v1.ShowOrgOrderEntryStatus submitResponse, Map<String, GC_GES_Order_Task__c> gesOrderTasksByName) {
        if (!gesOrderTasksByName.ContainsKey(taskName)) {
            GC_PageUtil.AddErrorMessage('Failed to Update ' + taskName + ': Could not find Task by Name');
            return null;
        }
        GC_GES_Order_Task__c task = gesOrderTasksByName.get(taskName);
        if (!submitResponse.Success) {
            GC_PageUtil.AddErrorMessage('Error from Web Service. ' + submitResponse.ErrorMessage);
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
        return task;
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
    
    
}