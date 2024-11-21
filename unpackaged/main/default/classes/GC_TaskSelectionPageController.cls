public with sharing class GC_TaskSelectionPageController {
    
    public GC_Order__c currentOrder {get; set;}
    public static final String newStatus = 'New';
    public GC_Connect2_Show__c currentShow = new GC_Connect2_Show__c();
    public List<GesTaskWrapper> gesOrderTasks {get; set;}
    public List<VendorTaskWrapper> venOrderTasks {get; set;}
    private List<GC_GES_Order_Task__c> selectedGots=  new List<GC_GES_Order_Task__c>(); 
    private List<GC_Vendor_Order_Task__c> selectedVots=  new List<GC_Vendor_Order_Task__c>();
    
    //constructor
    public GC_TaskSelectionPageController() {
        currentOrder=new GC_Order__c();
        string orderId = ApexPages.currentPage().getParameters().get('Id');
        String whereClause = 'Order__c = \'' + orderId + '\' AND Status__c = \'' + newStatus + '\'';
        gesOrderTasks= new List<GesTaskWrapper> ();
        venOrderTasks= new List<VendorTaskWrapper> ();
        try{
            currentOrder= GC_OrderDao.getInstance().getOrderById(orderId);
            currentShow= GC_Connect2ShowDao.getInstance().getConnect2ShowById(currentOrder.Connect2_Show__c);
            List<GC_GES_Order_Task__c>allGots= new List<GC_GES_Order_Task__c>();
            allGots= GC_GESOrderTaskDao.getInstance().getByWhere(whereClause);
            List<GC_Vendor_Order_Task__c>allVots= new List<GC_Vendor_Order_Task__c>();
            allVots= GC_VendorOrderTaskDao.getInstance().getByGesOrderId(orderId);
            if(allGots.size()>0){
                for(GC_GES_Order_Task__c got: allGots){
                    GesTaskWrapper wrappedGot= new  GesTaskWrapper(got);
                    gesOrderTasks.add(wrappedGot);
                }
            }
            
            if(allVots.size()>0){
                for(GC_Vendor_Order_Task__c vot: allVots){
                    if(vot.Status__c==newStatus){
                        VendorTaskWrapper wrappedVot= new  VendorTaskWrapper(vot);
                        venOrderTasks.add(wrappedVot);
                    }
                }
            }
            
        }catch(exception e){
            GC_PageUtil.AddErrorMessage('Sorry, there are no tasks associated with this order. Please check again.');
        }
        
    }
    
    public class VendorTaskWrapper {
        public Boolean isSelected {get; set;}
        public GC_Vendor_Order_Task__c task {get; set;}
        public VendorTaskWrapper (GC_Vendor_Order_Task__c vot) {
            isSelected = false;
            this.task= vot;
        }
    }
    public class GesTaskWrapper {
        public Boolean isSelected {get; set;}
        public GC_GES_Order_Task__c task {get; set;}
        public GesTaskWrapper (GC_GES_Order_Task__c got) {
            isSelected = false;
            task= got;
        }
    }
    
    public void selectTasks(){
        selectedGots.clear();
        selectedVots.clear();   
        for(GesTaskWrapper wrappedGot: gesOrderTasks){
            if(wrappedGot.isSelected){
                selectedGots.add(wrappedGot.task);
            }
        }
        
        for(VendorTaskWrapper wrappedVot:venOrderTasks){
            if(wrappedVot.isSelected){
                selectedVots.add(wrappedVot.task);
            }
        }
    }
    
    public PageReference submitTasks(){
        Set<Id> approverUserIds = new Set<Id>();
        Integer errors = 0;
        Integer newCount = 0;
        List<GC_GES_Order_Task__c> gotsToSubmit = new List<GC_GES_Order_Task__c>();
        List<GC_Vendor_Order_Task__c> votsToSubmit = new List<GC_Vendor_Order_Task__c>();
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        
        String showId = GC_PageUtil.getParam('showId');
        if (String.isBlank(showId)) {
            showId = currentShow.id;
        }
        if(selectedGots.size()==0 && selectedVots.size()==0){
            GC_PageUtil.AddErrorMessage('No Tasks are selected to be submitted.');
            return null;
        }
        
        List<GC_Show_Team_Member__c> teams = [SELECT Id, Name, User__c, Connect2_Show__c, Show_Role__c , User__r.Email
                                              FROM GC_Show_Team_Member__c
                                              WHERE Connect2_Show__c = :showId AND Show_Role__c = 'Account Manager'];
        if (teams.size() == 0) {
            GC_PageUtil.AddErrorMessage('An account manager is not found for this show.');
            return null;
        }       
        for (GC_Show_Team_Member__c team : teams) {
            approverUserIds.add(team.User__c);
        }
        for (GC_GES_Order_Task__c got : selectedGots) {
            gotsToSubmit.add(got);
            newCount++;
        }
        if(selectedGots.size()>0&& !GC_ApprovalUtils.submitForApproval(showId, gotsToSubmit)) {
            errors++;
        }
        
        for (GC_Vendor_Order_Task__c vot : selectedVots) {
            newCount ++;
            if (vot.Vendor__c == null) {
                GC_PageUtil.AddErrorMessage('Please add vendor for ' + vot.Name + '.');
                return null;
            }

            if (vot.Vendor__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type__r.Name));
            }

            if (vot.Vendor2__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor2__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type2__r.Name));
            }

            if (vot.Vendor3__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor3__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type3__r.Name));
            }

            if (vot.Vendor4__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor4__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type4__r.Name));
            }

            if (vot.Vendor5__c != null) {
                emailMessages.add(GC_OrderUtils.generateVendorEmail(vot, vot.Vendor5__c,currentShow.Name+ ' '+currentShow.Show_Name__c,vot.Service_Type5__r.Name));
            }
            vot.Status__c = 'Sent';
            vot.Submitted_Date__c = Date.today();
            votsToSubmit.add(vot);          
             
        }
        
        if (newCount == 0) {
            GC_PageUtil.AddInfoMessage('No New Order Tasks to submit.');
            errors++;
        }
        if (errors > 0) {
            system.debug('errors=='+errors);
            return null;
        }
        update votsToSubmit;
        if (emailMessages.size() > 0) {
            Messaging.SendEmail(emailMessages, false);
        }
        
        PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView');
        pr.getParameters().put('orderId', currentOrder.Id);     
        pr.getParameters().put('showId', currentShow.Id);   
        pr.setRedirect(true);
        return pr;
    }   
}