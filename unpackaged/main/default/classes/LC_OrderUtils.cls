public without sharing class LC_OrderUtils {
    public static Messaging.SingleEmailMessage generateVendorEmail(GC_Vendor_Order_Task__c vot, String vendorId,String showName,String serviceType){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        String url='';
        url+='<a href="';
        url+=System.Label.GC_URLforLinks;
        url+=vot.Id;
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
        if (vot.NotesAndAttachments != null) {
            message += '<p><b>Attachments:</b></p>';
            
            
            //Newline of code for sending attachments
            for(NoteAndAttachment attach: vot.NotesAndAttachments) {
                attachId.add(attach.Id);
            }
            for (Attachment a : [select Name, Body, BodyLength from Attachment where Id =:attachId]){
                
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(a.Name);
                efa.setBody(a.Body);
                fileAttachments.add(efa);
                
            }
            
            
            
        }
        List<Messaging.Emailfileattachment> fileAsAttachments= new List<Messaging.Emailfileattachment> ();
        fileAsAttachments=GC_EmailUtils.getFileAttchmentsForSingle(vot.Id);
        If(fileAsAttachments.size()>0){
            fileAttachments.addAll(fileAsAttachments);
        }
        
        if(fileAttachments.size()>0){
            mail.setFileAttachments(fileAttachments);
        }
        mail.setSenderDisplayName(UserInfo.getName());
        mail.setSubject(subject);
        mail.setHtmlBody(message);
        mail.setPlainTextBody(message.stripHtmlTags());
        mail.setSaveAsActivity(false);
        return mail;
    }
}