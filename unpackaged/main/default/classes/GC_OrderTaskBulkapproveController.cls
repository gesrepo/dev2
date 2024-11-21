public with sharing class GC_OrderTaskBulkapproveController {

    public List<GC_GES_Order_Task__c> gots {get; set;}

    public GC_OrderTaskBulkapproveController(ApexPages.StandardSetController controller) {
        gots = controller.getSelected();
    }

    public void loadAction() {
        List<GC_GES_Order_Task__c> approveNewList = new List<GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> updatedList = new List<GC_GES_Order_Task__c>();
        List<GC_GES_Order_Task__c> approveSubmittedList = new List<GC_GES_Order_Task__c>();
        Set<String> ids = new Set<String>();
        Set<String> updatedIds = new Set<String>();
        for (GC_GES_Order_Task__c got : gots) {
             ids.add(got.Id);
        }

        gots = new List<GC_GES_Order_Task__c>();
        gots = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(ids);
        for (GC_GES_Order_Task__c got : gots) {
            Boolean validate = GC_PageUtil.validateGesTask(got);
            if (validate) {
                if (got.Status__c == 'New') {
                    approveNewList.add(got);
                    updatedIds.add(got.Id);
                }

                if(got.Status__c == 'Submitted' ||got.Status__c == 'Submitted to Graphics') {
                    approveSubmittedList.add(got);
                    updatedIds.add(got.Id);
                }
            }
        }

        if (approveNewList.size() > 0) {
            for (GC_GES_Order_Task__c approveNew : approveNewList) {
                 approveNew.Status__c = 'Approved';
            }

            update approveNewList;
        }

        if (approveSubmittedList.size() > 0) {
            GC_ApprovalUtils.approveTasks(approveSubmittedList);
        }

        gots = new List<GC_GES_Order_Task__c>();
        gots = GC_GESOrderTaskDao.getInstance().getGESOrderTaskByIds(updatedIds);
    }

    public PageReference backAction() {
        return new PageReference('/' + GC_GES_Order_Task__c.sobjecttype.getDescribe().getKeyPrefix());
    }
}