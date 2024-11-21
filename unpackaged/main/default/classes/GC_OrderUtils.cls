public without sharing class GC_OrderUtils {
    public static Boolean devMode = true;
    public static User currentUserInfo1 = [select Id, GC_Show_Role__c from User where Id =: UserInfo.getUserId()];
    public static string showRole = string.isNotBlank(currentUserInfo1.GC_Show_Role__c) ? currentUserInfo1.GC_Show_Role__c: '';
    
    public static GC_GES_Connect2_Settings__c settings { get; set; }
    public enum FieldToSort {
        Label, Value
    }

    public class TaskPermissions {
        public GC_GES_Order_Task__c got {get; set;}
        public Boolean CanEdit {get; set;}
        public Boolean CanClone {get; set;}
        public Boolean CanRevise {get; set;}
        public Boolean CanCancel {get; set;}
        public Boolean CanPlaceOnHold {get; set;}
        public Boolean CanReleaseFromHold {get; set;}
        public Boolean CanApprove {get; set;}
        public Boolean CanReset {get; set;}
        public Boolean CanRecall {get; set;}
        public Boolean CanSubmit {get; set;}
        public Boolean CanDelete {get; set;}
        public Boolean CanCommunityCancel {get; set;}
        public Boolean CanCommunityEdit {get; set;}
        public Boolean CanSubmitGraphics {get; set;}
        public Boolean CanSubmittoCore {get; set;}
        public Boolean canSubmitToReview {get; set;}        
        public Boolean canSubmitToAM {get; set;}  
        
        public TaskPermissions(GC_GES_Order_Task__c task) {
            this(task, GC_ApprovalUtils.isUnderApproval(task.Id));
        }
        
        public TaskPermissions(GC_GES_Order_Task__c task, Boolean isUnderApproval) {
            got = task;
            CanEdit = got.Status__c == 'New' || got.Status__c == 'Rejected' || got.Status__c == 'Submitted' || got.Status__c == 'Pending AM Review' ;
            CanClone = true; // all status's can be cloned;
            //CanRevise = got.Status__c == 'Active' || got.Status__c == 'Released';  --Amarab 06/22/2023 SAL-1287 GOT Edit Button Hidden when Orders are in Proof Status
            CanRevise = got.Status__c == 'Active' || got.Status__c == 'Released' || got.Status__c == 'Proof Waiting for Approval' || got.Status__c == 'Proof Changes Required' || got.Status__c == 'Proof Approved';
            //CanCancel = got.Status__c == 'Active' || got.Status__c == 'Submitted to Graphics' || got.Status__c == 'Released';  --Amarab 06/22/2023 SAL-1287 GOT Edit Button Hidden when Orders are in Proof Status
            CanCancel = got.Status__c == 'Active' || got.Status__c == 'Submitted to Graphics' || got.Status__c == 'Released' || got.Status__c == 'Proof Waiting for Approval' || got.Status__c == 'Proof Changes Required' || got.Status__c == 'Proof Approved';  
            CanApprove = got.Status__c == 'New' || got.Status__c == 'Rejected' || got.Status__c == 'Submitted' || (got.Status__c == 'Submitted to Graphics' &&showRole.contains('GC Graphics Project Manager') ) || (got.Status__c == 'Submitted For AM Review' && showRole.Contains('GC Account Manager') );
            CanPlaceOnHold = got.Status__c == 'New' || got.Status__c == 'Submitted' || got.Status__c == 'Approved' || got.Status__c == 'Rejected' || got.Status__c == 'Submitted to Graphics' || got.Status__c == 'Released' || got.Status__c == 'Pending AM Review' ;
            CanReleaseFromHold = got.Status__c == 'On Hold';
            CanReset = got.Status__c == 'Approved';
            CanRecall = isUnderApproval && ( (got.OwnerId == UserInfo.getUserId()  && got.Status__c == 'Submitted') || (got.Status__c == 'Submitted to Graphics' && showRole.Contains('GC Account Manager') ) || (got.Status__c == 'Submitted For AM Review' && showRole.Contains('GC Graphics Project Manager')) );            
            CanSubmit = ((got.Status__c == 'New' || got.Status__c == 'Rejected' ) && got.OwnerId == UserInfo.getUserId());            
            CanDelete = (got.Status__c == 'On Hold'|| got.Status__c == 'New' || got.Status__c == 'Approved' || got.Status__c == 'Rejected') && got.OwnerId == UserInfo.getUserId();
            CanCommunityCancel = got.Status__c == 'New' || got.Status__c == 'Approved' || got.Status__c == 'Rejected'||got.Status__c == 'On Hold';
            CanCommunityEdit = got.Status__c == 'New' || got.Status__c == 'Rejected' ||got.Status__c == 'On Hold' ;
            CanSubmitGraphics = (got.Item_Template__c != null && got.Item_Template__c.contains('Graphics'));
            CanSubmittoCore = got.Status__c == 'Approved';
            canSubmitToReview  = got.Status__c == 'Active' && (got.GPM_Approver_1__c != null || got.GPM_Approver_2__c != null || got.GPM_Approver_3__c != null) && (showRole != null && showRole.Contains('GC Account Manager'))  ; //SAL-421  
            canSubmitToAM= got.Status__c.Contains('Pending AM Review') && showRole.Contains('GC Graphics Project Manager') ;
            
        }
    }

    public static PageReference editTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        return vc.editAction();
    }
    public static PageReference cloneTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        return vc.cloneAction();
    }

    public static PageReference cancelTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);

        // TODO need to also do cancel from core, which requires web service call.
        // Can't easily be done right now.
        if (task.Status__c == 'Active') {
            GC_PageUtil.AddWarningMessage('Cancel an Active task requires submitting the cancel in core.');
        }

        vc.cancelAction();
        return null;
    }
    public static PageReference reviseTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        return vc.reviseAction();
    }
    public static PageReference placeOnHoldTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        vc.placeOnHoldAction();
        return null;
    }
    public static PageReference releaseFromHoldTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        vc.releaseFromHoldAction();
        return null;
    }
    public static PageReference approveTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        vc.approveForSubmitAction();
        return null;
    }
    public static PageReference reworkTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        vc.resetToNew();
        return null;
    }

    public static PageReference submitTask(GC_GES_Order_Task__c task) {
        ApexPages.StandardController sc = new ApexPages.StandardController(task);
        GC_GESOrderTaskViewController vc = new GC_GESOrderTaskViewController(sc);
        vc.submitRecord();
        return null;
    }

    public static void lookupServiceTypeAttributes(String showId, List<SelectOption> serviceTypeOptions) {
        List<GC_Show_Attribute__c> showAttributes = [select Id, Name, RecordType.Name from GC_Show_Attribute__c where Connect2_Show__c = :showId];

        if (serviceTypeOptions == null) {
            serviceTypeOptions = new List<SelectOption>();
        }

        serviceTypeOptions.clear();
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        serviceTypeOptions.add(noneSelectOption);

        for (GC_Show_Attribute__c showAttribute : showAttributes) {
            if (showAttribute.RecordType.Name == 'Show Service') {
                SelectOption option = new SelectOption(showAttribute.Id, showAttribute.Name);
                serviceTypeOptions.Add(option);
            }
        }
    }

    public static void lookupShowAttributes(String showId, List<SelectOption> materialOptions, List<SelectOption> venueOptions, List<SelectOption> departmentOptions) {
        List<GC_Show_Attribute__c> showAttributes = [select Id, Name, RecordType.Name from GC_Show_Attribute__c where Connect2_Show__c = :showId];

        if (venueOptions == null) {
            venueOptions = new List<SelectOption>();
        }

        if (materialOptions == null) {
            materialOptions = new List<SelectOption>();
        }

        if (departmentOptions == null) {
            departmentOptions = new List<SelectOption>();
        }

        venueOptions.clear();
        materialOptions.clear();
        departmentOptions.clear();
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        venueOptions.Add(noneSelectOption);
        materialOptions.Add(noneSelectOption);
        departmentOptions.Add(noneSelectOption);

        for (GC_Show_Attribute__c showAttribute : showAttributes) {
            if (showAttribute.RecordType.Name == 'Venue Location') {
                SelectOption option = new SelectOption(showAttribute.Id, showAttribute.Name);
                venueOptions.Add(option);
            } else if (showAttribute.RecordType.Name == 'Material') {
                SelectOption option = new SelectOption(showAttribute.Id, showAttribute.Name);
                materialOptions.Add(option);
            } else if (showAttribute.RecordType.Name == 'Department') {
                SelectOption option = new SelectOption(showAttribute.Id, showAttribute.Name);
                departmentOptions.Add(option);
            }
        }

        system.debug('venueOptions++++'+venueOptions);

        doSort(venueOptions,FieldToSort.Label);
        system.debug('venueOptionsSort++++'+venueOptions);
        //venueOptions.sort();
        //venueOptions.Add(noneSelectOption);
    }

    public static void doSort(List<Selectoption> opts, FieldToSort sortField) {
        
        Map<String, Selectoption> mapping = new Map<String, Selectoption>();
        // Suffix to avoid duplicate values like same labels or values are in inbound list 
        Integer suffix = 1;
        for (Selectoption opt : opts) {
            if (sortField == FieldToSort.Label) {
                mapping.put(    // Done this cryptic to save scriptlines, if this loop executes 10000 times
                                // it would every script statement would add 1, so 3 would lead to 30000.
                             (opt.getLabel() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            } else {
                mapping.put(    
                             (opt.getValue() + suffix++), // Key using Label + Suffix Counter  
                             opt);   
            }
        }
        
        List<String> sortKeys = new List<String>();
        sortKeys.addAll(mapping.keySet());
        sortKeys.sort();
        // clear the original collection to rebuilt it
        opts.clear();
        
        for (String key : sortKeys) {
            opts.add(mapping.get(key));
        }
    }

    public static GC_GES_Connect2_Settings__c getCustomSettings() {
        if (settings == null) {
            try {
                settings = [Select Id, Name, Send_Show_Org_Emails__c, Default_Login_Email__c, API_ENDPOINT__c From GC_GES_Connect2_Settings__c Where Name = 'GES Connect Settings'];
            } catch (QueryException e) {
                // Fill out defaults for running unit tests etc.
                settings = new GC_GES_Connect2_Settings__c();
                settings.Name = 'GES Connect Settings';
                settings.Send_Show_Org_Emails__c = false;
                settings.Default_Login_Email__c = 'LDrummond@ges.com';
                settings.API_ENDPOINT__c = 'https://xsysapi.viad.com';
            }
        }

        return settings;

        //List<GC_GES_Connect2_Settings__c> defaultCustomSettings = [select Id, Name, Send_Show_Org_Emails__c, Default_Login_Email__c, API_ENDPOINT__c from GC_GES_Connect2_Settings__c limit 1];
        //if (defaultCustomSettings.size() == 0) {
        //    GC_GES_Connect2_Settings__c newDefaults = new GC_GES_Connect2_Settings__c();
        //    newDefaults.Name = 'GES Connect Settings';
        //    newDefaults.Send_Show_Org_Emails__c = false;
        //    newDefaults.Default_Login_Email__c = 'LDrummond@ges.com';
        //    newDefaults.API_ENDPOINT__c = 'https://xsysapi.viad.com';
        //    return newDefaults;
        //}
        //else {
        //    GC_GES_Connect2_Settings__c appSettings = defaultCustomSettings[0];
        //    return appSettings;
        //}
    }

    public static void DeleteOrder(GC_Order__c order) {


    }

    public static Messaging.SingleEmailMessage generateVendorEmail(GC_Vendor_Order_Task__c vot, String vendorId,String showName,String serviceType){
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        String url='';
        url+='<a href="';
        url+=System.Label.GC_URLforLinks;
        url+=vot.Id;
        //url+='&showId=';
        if(vot.Order__c!=null){
            url+='&orderId='+vot.Order__c;
        }
        
        url+='">'+vot.Name;
        url+='</a>';
        set<id> attachId=new set<id>();
        mail.setTargetObjectId(vendorId);
        String subject = 'Vendor Order Task [' + vot.Name + '] has been created and sent for your review.';
        String message = '<p>The following Vendor Order Task has been created and sent for your review:</p>' +
                         '<p><b>Show Name:</b> ' + showName + '</p>' +   
                         '<p><b>Vendor Order:</b> ' + url + '</p>' +
                         '<p><b>Venue Location:</b> ' + (String.isNotBlank(vot.SA_Venue_Location_Ven__r.Name) ? vot.SA_Venue_Location_Ven__r.Name : '' ) + '</p>' +
                         '<p><b>Delivery Area:</b> ' + (String.isNotBlank(vot.Delivery_Location_Ven__c) ? vot.Delivery_Location_Ven__c : '' ) + '</p>' +
                         '<p><b>Delivery Date/Time:</b> ' + (vot.Delivery_Date_Time_Ven__c != null ? vot.Delivery_Date_Time_Ven__c.format() : '') + '</p>' +
                         '<p><b>Completion Date/Time:</b> ' + (vot.Completion_Date_Time_Ven__c != null ? vot.Completion_Date_Time_Ven__c.format() : '') + '</p>' +
                         '<p><b>Removal Date/Time:</b> ' +  (vot.Removal_Date_Time_Ven__c != null ? vot.Removal_Date_Time_Ven__c.format() : '') + '</p>' +
                         '<p><b>Service Type:</b> ' + serviceType + '</p>' +
                         '<p><b>Submitted By:</b> ' + UserInfo.getName() + '</p>';

        if (String.isNotBlank(vot.Vendor_Instructions__c)) {
            message += '<p><b>Instructions:</b> ' + vot.Vendor_Instructions__c + '</p>';
        }
         system.debug('notes and attachment======>'+vot.NotesAndAttachments);
        if (vot.NotesAndAttachments != null) {
            message += '<p><b>Attachments:</b></p>';
            
            
            //Newline of code for sending attachments
            for(NoteAndAttachment attach: vot.NotesAndAttachments) {
            attachId.add(attach.Id);
                // get the URL and find what the URL is before /apex/ to get the community name.
               // URL currentURL = URL.getCurrentRequestUrl();
                //String currentPath = currentURL.getPath();
                //String communityName = currentPath.substringBefore('/apex/');
                //String attachmentURL = URL.getSalesforceBaseUrl().toExternalForm() + communityName + '/servlet/servlet.FileDownload?file='+ attach.Id;
                //if (attach.isNote)
                  //  continue;
                 //message += '<p><a href=\"' + attachmentURL + '\">' + attach.Title + '</a></p>';
            }
            system.debug('vendor id =========>'+vendorId);
            for (Attachment a : [select Name, Body, BodyLength from Attachment where Id =:attachId]){
          
             Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                                       efa.setFileName(a.Name);
                                     efa.setBody(a.Body);
                                     fileAttachments.add(efa);
            
            }
         
         
           
        }
            system.debug('file size===========>'+fileAttachments.size());
            List<Messaging.Emailfileattachment> fileAsAttachments= new List<Messaging.Emailfileattachment> ();
            fileAsAttachments=GC_EmailUtils.getFileAttchmentsForSingle(vot.Id);
            If(fileAsAttachments.size()>0){
                fileAttachments.addAll(fileAsAttachments);
            }
            
            system.debug('file size===========>'+fileAttachments.size());
            if(fileAttachments.size()>0){
                mail.setFileAttachments(fileAttachments);
            }
            
            mail.setSenderDisplayName(UserInfo.getName());
            mail.setSubject(subject);
            mail.setHtmlBody(message);
            mail.setPlainTextBody(message.stripHtmlTags());
            mail.setSaveAsActivity(false);
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); //Sending mail commented this for SAL-622. It was sending emails twice @@ rksinha
            
        //Sending PageMessage
        //GC_PageUtil.AddConfirmMessage('Vendor Task has been Sent to the Vendor(s).');
        return mail;
    }
 
    
    

    public static Boolean validateVendorTask(GC_Vendor_Order_Task__c vot) {
        Integer errors = 0;
        if (vot.Service_Type__c != null && vot.Vendor__c == null) {
            vot.Vendor__c.addError('Vendor is required when specifying service');
            errors++;
        }
        if (vot.Service_Type2__c != null && vot.Vendor2__c == null) {
            vot.Vendor2__c.addError('Vendor is required when specifying service');
            errors++;
        }
        if (vot.Service_Type3__c != null && vot.Vendor3__c == null) {
            vot.Vendor3__c.addError('Vendor is required when specifying service');
            errors++;
        }
        if (vot.Service_Type4__c != null && vot.Vendor4__c == null) {
            vot.Vendor4__c.addError('Vendor is required when specifying service');
            errors++;
        }
        if (vot.Service_Type5__c != null && vot.Vendor5__c == null) {
            vot.Vendor5__c.addError('Vendor is required when specifying service');
            errors++;
        }
        return errors == 0;
    }
    
    public static User currentUserInfo(Id userId) {
       return [select GC_Show_Role__c from User where Id =: userId];
    }

    public class URLParameters {
        public Set<String> orderIds {get; set;}
        public Set<String> statusValues {get; set;}
    }
}