/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for the Vendor Order Task view page
* 2016-04-12 : Original Version
**/
public with sharing class GC_Community_votViewController {
    public GC_Vendor_Order_Task__c vot {get; set;}
    public Id newVotId {get; set;}
    public String showId {get; set;}
    public String orderId {get; set;}
    public GC_Connect2_Show__c show {get; set;}
    public GC_Order__c order {get; set;}
    public Boolean CanCancel {get; set;}
    public Boolean CanEdit {get; set;}
    public Boolean CanClone {get; set;}
    public Boolean CanSubmit {get; set;}
     public GC_Task_Field_Manager__c taskFieldManager {get; set;}

    public  List<GC_GES_Order_Task__c> gesOrderTasks {get; set;}

    public GC_Community_votViewController() {
        String votId = ApexPages.currentPage().getParameters().get('votId');
        showId = ApexPages.currentPage().getParameters().get('showId');
        orderId = ApexPages.currentPage().getParameters().get('orderId');

        show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
        order = GC_OrderDao.getInstance().getOrderById(orderId);
        //vot = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(votId);
        vot = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById1(votId);
        //vot = this.getVendorOrderTaskById(votId);getVendorOrderTaskById1

        CanClone = true;
        CanEdit = vot.Status__c == 'New';
        Cansubmit = vot.Status__c == 'New';
        CanCancel = vot.Status__c == 'New';
        List<Profile> profile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
        String profileName = profile[0].Name;

        if (profileName == 'GC Community Vendor') {
            CanEdit = false;
            CanClone = false;
            CanSubmit = false;
            CanCancel = false;
        }


        if(vot.SelectAllOrderTasks__c == true)
        {   
            gesOrderTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(orderId, 'Archived');
        }
        try{
            taskFieldManager = [SELECT id, name, Background__c,Booth_Area_Discount__c,Budget_Code__c,Client_Layout_Notes__c,Completion_Date_Time__c,Connect2_Show__c,Copy_Placement__c,Default_Completion_Date_Time__c,Default_Installation_Delivery_Date_Time__c,Default_Removal_Date_Time__c,Delivery_Area__c,File_Reference_Link_Folder__c,Installation_Delivery_Date_Time__c,Installation_Method__c,Onsite_Contact_Person__c,Onsite_Contact_Person_Number__c,Outdoors__c,Price__c,Removal_Date_Time__c,Save_Signs__c,Sign_Copy__c,Sign_Title__c,Sign_Type__c,Sign_Type_Other__c,Single_Double_Sided__c,Special_Instructions_Client_Remarks__c,User__c,User_Item_Description__c FROM GC_Task_Field_Manager__c WHERE Connect2_Show__c=:showId LIMIT 1];
        }catch(exception e){
            taskFieldManager= new GC_Task_Field_Manager__c();
        }
    }

    public PageReference editRecord() {
        PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_votCreateEdit');
        String showId = ApexPages.currentPage().getParameters().get('showId');
        String votId = ApexPages.currentPage().getParameters().get('votId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        pr.getParameters().put('showId', showId);
        pr.getParameters().put('votId', votId);
        pr.getParameters().put('orderId', orderId);
        return pr;
    }
    public PageReference cancel() {
        String showId = ApexPages.currentPage().getParameters().get('showId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        vot.Status__c = 'Canceled';
        Database.update(vot, false);
        return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + showId + '&orderId=' + orderId);
    }

    public PageReference cloneTask() {
        String showId = ApexPages.currentPage().getParameters().get('showId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        Savepoint sp = Database.setSavepoint();
        GC_Vendor_Order_Task__c newVot;

        try {
            vot = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);
            newVot = vot.clone(false);
            newVot.Order__c = orderId;
            newVot.Status__c = 'New';
            //newVot.Last_Revision__c = null;
            //newVot.Revision__c = 1;
            //newVot.Vendor__c = null;
            //newVot.Vendor_Instructions__c = null;
            //newVot.Submitted_Date__c = null;
            //newVot.Previous_Revision__c = null;
            newVot.OwnerId = UserInfo.getUserId();
            insert newVot;
            newVotId = newVot.Id;


            List<Note> notesList = new List<Note>();
            List<Note> notes = [select Body, Id, OwnerId, ParentId, Title from Note where ParentId = :vot.Id];

            for (Note note : notes) {
                Note newNote = note.clone(false);
                newNote.ParentId = newVotId;
                newNote.Body = note.Body;
                newNote.Title = note.Title;
                newNote.OwnerId = UserInfo.getUserId();
                notesList.add(newNote);
            }

            insert notesList;

            List<Attachment> attachmentsList = new List<Attachment>();
            List<Attachment> attachments = [select Body, Id, OwnerId, ParentId, Name from Attachment where ParentId = :vot.Id];

            for (Attachment attachment : attachments) {
                Attachment newAttachment = attachment.clone(false);
                newAttachment.ParentId = newVotId;
                newAttachment.Body = Attachment.Body;
                newAttachment.Name = Attachment.Name;
                newAttachment.OwnerId = UserInfo.getUserId();
                AttachmentsList.add(newAttachment);
            }

            insert attachmentsList;

            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_votCreateEdit');
            pr.getParameters().put('showId', showId);
            pr.getParameters().put('orderId', orderId);
            pr.getParameters().put('votId', newVotId);
            pr.getParameters().put('isClone', '1');
            pr.getParameters().put('originalVotId', vot.Id);
            return pr;
        } catch (Exception e) {
            Database.rollback(sp);
            GC_PageUtil.AddErrorMessage(' Failed to Clone the Task: ' + e.getMessage());
            return null;
        }
    }

    public PageReference submitRecord() {
        String votId = ApexPages.currentPage().getParameters().get('votId');
        String showId = ApexPages.currentPage().getParameters().get('showId');

        if (vot.Vendor__c == null) {
            GC_PageUtil.AddErrorMessage('Select vendor.');
            return null;
        }

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        if (vot.Vendor__c == null) {
            GC_PageUtil.AddErrorMessage('Please add vendor for ' + vot.Name + '.');
            return null;
        }

        if (vot.Vendor__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type__r.Name));
        }

        if (vot.Vendor2__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor2__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type2__r.Name));
        }

        if (vot.Vendor3__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor3__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type3__r.Name));
        }

        if (vot.Vendor4__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor4__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type4__r.Name));
        }

        if (vot.Vendor5__c != null) {
            emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor5__c,show.Name+' - '+show.Show_Name__c,vot.Service_Type5__r.Name));
        }

        //set allOrNone to false to allow non-error messages to be sent even if some fail
        Messaging.sendEmail(emailMessages, false);
        vot.Status__c = 'Sent';
        vot.Submitted_Date__c = Date.today();
        CanSubmit = false;
        CanEdit = false;
        update vot;
        GC_PageUtil.AddInfoMessage('Task has been Submitted.');
        return null;
    }

     

    public static String quote(String inStr) {
        if (inStr == null) {
            inStr = '';
        }
        return '\'' + String.escapeSingleQuotes(inStr) + '\'';
    }
}