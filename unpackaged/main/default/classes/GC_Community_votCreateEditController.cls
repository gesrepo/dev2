/**
* @author Ethos Solutions - www.ethos.com
* @description Controller for the Vendor Order Task create edit Page
* 2016-04-12 : Original Version
**/
public with sharing class GC_Community_votCreateEditController {
    public GC_Vendor_Order_Task__c vot {get; set;}
    public String showId {get; set;}
    public GC_Connect2_Show__c show {get; set;}
    public GC_Order__c order {get; set;}
    public List<SelectOption> serviceTypes { get; private set; }
    public List<SelectOption> gesOrderTasksForVendors { get; private set; }

    public List<SelectOption> userslist { get; set; }
    public List<SelectOption> userslist1 { get; set; }
    public List<SelectOption> userslist2 { get; set; }
    public List<SelectOption> userslist3 { get; set; }
    public List<SelectOption> userslist4 { get; set; }

    public String vendorSelect {get; set;}
    public Boolean selectAllGesOT {get; set;}
    public Boolean disableGESOT {get; set;}

    public GC_Community_votCreateEditController() {
        String votId = ApexPages.currentPage().getParameters().get('votId');
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        showId = ApexPages.currentPage().getParameters().get('showId');
        show = GC_Connect2ShowDao.getInstance().getConnect2ShowById(showId);
        order = GC_OrderDao.getInstance().getOrderById(orderId);
        GC_Vendor_Order_Task__c votQuery = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById1(votId);

        if (votQuery != null) {
            vot = votQuery;
        } else {
            //vot = new GC_Vendor_Order_Task__c(Connect2_Show__c = showId);
            vot = new GC_Vendor_Order_Task__c();
            vot.Order__c = order.Id;
        }

        LookupShowAttributes();

        if (order != null) {
            List<GC_GES_Order_Task__c> gesTasks = GC_GESOrderTaskDao.getInstance().getByGesOrderIdAndExcludeStatus(order.Id, 'Archived');

            if (gesOrderTasksForVendors == null) {
                gesOrderTasksForVendors = new List<SelectOption>();
            }

            gesOrderTasksForVendors.clear();
            gesOrderTasksForVendors.add(new SelectOption('', '----None----'));

            for (GC_GES_Order_Task__c task : gesTasks) {
                String displayValue = task.Name + ' - ' + task.Description__c + ' (' + task.Status__c + ')';
                gesOrderTasksForVendors.add(new SelectOption(task.Id, displayValue));
            }
        }

        if(vot.SelectAllOrderTasks__c == true)
        {   
            disableGESOT = true;
        }
        else{
            disableGESOT = false; 
        }

        //Populate Vendors
        String showAttr = '';
        if(vot.Service_Type__c != null)
        {
            List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type__c];
            if(showAttributes.size() > 0)
            {
                showAttr = showAttributes[0].Name;
            }
            //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];

            List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];

            if (userslist == null) {
                userslist = new List<SelectOption>();
            }

            userslist.clear();
            //SelectOption noneSelectOption = new SelectOption('', '---None---');
            //serviceTypeOptions.add(noneSelectOption);

            for(GC_Show_Team_Member__c stm1: stmVen)
            {
                if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                    userslist.Add(option);
                }
                else
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                    userslist.Add(option);
                }
            }
        }

        if(vot.Service_Type2__c != null)
        {
            List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type2__c];
            if(showAttributes.size() > 0)
            {
                showAttr = showAttributes[0].Name;
            }
            //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
            List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
            if (userslist1 == null) {
                userslist1 = new List<SelectOption>();
            }

            userslist1.clear();
            //SelectOption noneSelectOption = new SelectOption('', '---None---');
            //serviceTypeOptions.add(noneSelectOption);

            for(GC_Show_Team_Member__c stm1: stmVen)
            {
                if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                    userslist1.Add(option);
                }
                else
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                    userslist1.Add(option);
                }
            }
        }

        if(vot.Service_Type3__c != null)
        {
            List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type3__c];
            if(showAttributes.size() > 0)
            {
                showAttr = showAttributes[0].Name;
            }
            //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
            List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
            if (userslist2 == null) {
                userslist2 = new List<SelectOption>();
            }

            userslist2.clear();
            //SelectOption noneSelectOption = new SelectOption('', '---None---');
            //serviceTypeOptions.add(noneSelectOption);

            for(GC_Show_Team_Member__c stm1: stmVen)
            {
                if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                    userslist2.Add(option);
                }
                else
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                    userslist2.Add(option);
                }
            }
        }

        if(vot.Service_Type4__c != null)
        {
            List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type4__c];
            if(showAttributes.size() > 0)
            {
                showAttr = showAttributes[0].Name;
            }
            //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
            List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
            if (userslist3 == null) {
                userslist3 = new List<SelectOption>();
            }

            userslist3.clear();
            //SelectOption noneSelectOption = new SelectOption('', '---None---');
            //serviceTypeOptions.add(noneSelectOption);

            for(GC_Show_Team_Member__c stm1: stmVen)
            {
                if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                    userslist3.Add(option);
                }
                else
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                    userslist3.Add(option);
                }
            }
        }

        if(vot.Service_Type5__c != null)
        {
            List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type5__c];
            if(showAttributes.size() > 0)
            {
                showAttr = showAttributes[0].Name;
            }
            //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
            List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
            if (userslist4 == null) {
                userslist4 = new List<SelectOption>();
            }

            userslist4.clear();
            //SelectOption noneSelectOption = new SelectOption('', '---None---');
            //serviceTypeOptions.add(noneSelectOption);

            for(GC_Show_Team_Member__c stm1: stmVen)
            {
                if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                    userslist4.Add(option);
                }
                else
                {
                    SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                    userslist4.Add(option);
                }
            }
        }
    }

    public void LookupShowAttributes() {
        List<GC_Show_Attribute__c> showAttributes = [select Id, Name, RecordType.Name from GC_Show_Attribute__c where Connect2_Show__c = :showId];

        if (serviceTypes == null) {
            serviceTypes = new List<SelectOption>();
        }

        serviceTypes.clear();
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        serviceTypes.Add(noneSelectOption);

        for (GC_Show_Attribute__c showAttribute : showAttributes) {
            if (showAttribute.RecordType.Name == 'Show Service') {
                SelectOption option = new SelectOption(showAttribute.Id, showAttribute.Name);
                serviceTypes.Add(option);
            }
        }
    }
    /**
     * @description Allows the user to save the values
     * @param Param data type Param description
     * @param Param data type Param description
     * @return Return data type Return description
     **/
    public PageReference saveRecord() {
        try {
            upsert vot;
            String showId = ApexPages.currentPage().getParameters().get('showId');
            String orderId = ApexPages.currentPage().getParameters().get('orderId');
            String votId = vot.Id;

            if (String.isNotBlank(showId) && String.isNotBlank(orderId) && String.isNotBlank(votId)) {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_votView?showId=' + showId + '&orderId=' + orderId + '&votId=' + votId);
            } else {
                return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + showId + '&orderId=' + orderId);
            }
        } catch (Exception e) {
            GC_PageUtil.AddErrorMessage(e.getMessage());
            GC_PageUtil.AddErrorMessage(e.getStackTraceString());
            return null;
        }
    }

    public PageReference cancel() {
        String orderId = ApexPages.currentPage().getParameters().get('orderId');
        String votId = ApexPages.currentPage().getParameters().get('votId');
        String showId = ApexPages.currentPage().getParameters().get('showId');
        String isClone = ApexPages.currentPage().getParameters().get('isClone');
        String originalVotId = ApexPages.currentPage().getParameters().get('originalVotId');

        if (String.isNotBlank(isClone) && String.isNotBlank(votId) && String.isNotBlank(originalVotId)) {
            vot = GC_VendorOrderTaskDao.getInstance().getVendorOrderTaskById(vot.Id);

            Database.delete(vot, false);
            PageReference pr = new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_votView');
            pr.getParameters().put('showId', showId);
            pr.getParameters().put('orderId', orderId);
            pr.getParameters().put('votId', originalVotId);
            return pr;

        }

        if (String.isNotBlank(votId) && String.isNotBlank(showId) && String.isNotBlank(orderId)) {
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_votView?votId=' + votId + '&showId=' + showId + '&orderId=' + orderId);
        }

        if (String.isNotBlank(showId) && String.isNotBlank(orderId)) {
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView?showId=' + showId + '&orderId=' + orderId);
        } else {
            return new PageReference(GC_PageUtil.CheckApexDomain() + '/GC_Community_OrderView');
        }
    }

    public PageReference filterVendors() {
        String showAttr = '';
        //system.debug('selectedVendorTask.task.Service_Type__c'+selectedVendorTask.task.Service_Type__c);
        //system.debug('vendorSelect++++'+vendorSelect);
        if(vendorSelect == 'Vendor1')
        {
            if(vot.Service_Type__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                if (userslist == null) {
                    userslist = new List<SelectOption>();
                }

                userslist.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist.Add(option);
                    }
                }
            }
            else
            {
                userslist.clear();
            }
        }

        if(vendorSelect == 'Vendor2')
        {
            if(vot.Service_Type2__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type2__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                if (userslist1 == null) {
                    userslist1 = new List<SelectOption>();
                }

                userslist1.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist1.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist1.Add(option);
                    }
                }
            }
            else
            {
                userslist1.clear();
            }
        }

        if(vendorSelect == 'Vendor3')
        {
            if(vot.Service_Type3__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type3__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                if (userslist2 == null) {
                    userslist2 = new List<SelectOption>();
                }

                userslist2.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist2.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist2.Add(option);
                    }
                }
            }
            else
            {
                userslist2.clear();
            }
        }

        if(vendorSelect == 'Vendor4')
        {
            if(vot.Service_Type4__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type4__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                if (userslist3 == null) {
                    userslist3 = new List<SelectOption>();
                }

                userslist3.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist3.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist3.Add(option);
                    }
                }
            }
            else
            {
                userslist3.clear();
            }
        }

        if(vendorSelect == 'Vendor5')
        {
            if(vot.Service_Type5__c != null)
            {
                List<GC_Show_Attribute__c> showAttributes = [select Id, Name from GC_Show_Attribute__c where Id = :vot.Service_Type5__c];
                if(showAttributes.size() > 0)
                {
                    showAttr = showAttributes[0].Name;
                }
                //List<User> filterUsers = [select Id,Name,CompanyName from User where Profile.Name = 'GC Community Vendor' and IsActive = TRUE and ServiceType__c =:showAttr];
                List<GC_Show_Team_Member__c> stmVen = [select Id,User__c,User__r.Name,User__r.CompanyName from GC_Show_Team_Member__c where Service_Type__c =: showAttributes[0].Id];
                if (userslist4 == null) {
                    userslist4 = new List<SelectOption>();
                }

                userslist4.clear();
                //SelectOption noneSelectOption = new SelectOption('', '---None---');
                //serviceTypeOptions.add(noneSelectOption);

                for(GC_Show_Team_Member__c stm1: stmVen)
                {
                    if(stm1.User__r.CompanyName != null || String.isNotBlank(stm1.User__r.CompanyName))
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name+' - '+stm1.User__r.CompanyName);
                        userslist4.Add(option);
                    }
                    else
                    {
                        SelectOption option = new SelectOption(stm1.User__c, stm1.User__r.Name);
                        userslist4.Add(option);
                    }
                }
            }
            else
            {
                userslist4.clear();
            }
        }
        return null;
    }

    public PageReference otDropDownReadOnly() {
        //system.debug('selectAllGesOT++++++'+selectAllGesOT);
        if(vot.SelectAllOrderTasks__c == true)
        {   
            disableGESOT = true;
            vot.GESOrderTask1__c = null;
            vot.GESOrderTask2__c = null;
            vot.GESOrderTask3__c = null;
            vot.GESOrderTask4__c = null;
            vot.GESOrderTask5__c = null;
        }
        else{
            disableGESOT = false; 
        }
        //system.debug('disableGESOT++++++'+disableGESOT); 
        return null;
    }
}