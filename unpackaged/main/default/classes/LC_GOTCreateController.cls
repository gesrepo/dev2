public with sharing class LC_GOTCreateController {
    
    @AuraEnabled
    public static String getSessionId(){
        try{
            String sId = LC_CoreUtils.getSessionID().Core_Application_Session_ID__c;
            return sId;
        }catch(exception e){
            return '';
        }}
    
    @AuraEnabled
    public static GC_GES_Order_Task__c getGESOrderTask(string gotId, string context){
        GC_GES_Order_Task__c got = new GC_GES_Order_Task__c();
        got = GC_GESOrderTaskDao.getInstance().getGESOrderTaskById(gotId);
        if(got != null){
            if(String.isBlank(got.Client_Layout_Notes__c) && !String.isBlank(got.Layout__c)){
                got.Client_Layout_Notes__c = copyRichTextToLong(got.Layout__c);
            }
            if(String.isBlank(got.Sign_Copy_Plain__c) && !String.isBlank(got.Sign_Copy__c)){
                got.Sign_Copy_Plain__c = copyRichTextToLong(got.Sign_Copy__c);
            }
            if(String.isBlank(got.Special_Instructions_Client_Remarks__c) && !String.isBlank(got.Show_Management_Field__c)){
                got.Special_Instructions_Client_Remarks__c = copyRichTextToLong(got.Show_Management_Field__c);
            }
            if(context.equalsIgnoreCase('Clone')){
                return GC_PageUtil.cloneTask(got);
            }
            else return got; }
        else
            return new GC_GES_Order_Task__c();
    }
    public static String copyRichTextToLong(string rTF){
        string lTF = '';
        lTF = rTF;
        lTF = lTF.replaceAll('<br[^>]+>', '\n');
        lTF = lTF.replaceAll('<[^>]+>',' ');
        lTF = lTF.replaceAll('&#39;', '\'');
        lTF = lTF.replaceAll('&quot;', '"');
        lTF = lTF.replaceAll('&amp;', '&');
        return lTF;
    }
    @AuraEnabled
    public static GC_Task_Field_Manager__c getTaskFieldManager(string orderId){
        string sId = LC_AppUtils.getShowIdforOrder(orderId).Connect2_Show__c;
        GC_Task_Field_Manager__c tfm = LC_UserPrefrenceTabController.getTaskField(sId);
        if(!String.isBlank(tfm.Id))
            return tfm;
        
        else { tfm = LC_AppUtils.getDefaultTaskFields();
              return tfm;
             }
    }
    @AuraEnabled
    public static Boolean getUserPermission(){
        return LC_GESOrderTaskViewController.getUserPermission();
    }
    @AuraEnabled
    Public static GC_GES_Order_Task__c saveGESOrderTask(id orderId, GC_GES_Order_Task__c gotObj, string context){
        if(validateSave(gotObj, orderId)){
            gotObj.Order__c = orderId;
            gotObj.Layout__c = String.isBlank(gotObj.Client_Layout_Notes__c) ? null : gotObj.Client_Layout_Notes__c;
            gotObj.Sign_Copy__c = String.isBlank(gotObj.Sign_Copy_Plain__c) ? null : gotObj.Sign_Copy_Plain__c;
            gotObj.Show_Management_Field__c = String.isBlank(gotObj.Special_Instructions_Client_Remarks__c) ? null : gotObj.Special_Instructions_Client_Remarks__c;
            
            if (gotObj.Item_Template__c != null && gotObj.Item_Template__c.contains('Carpet') && gotObj.Carpet_Length__c != null && gotObj.Carpet_Width__c != null && gotObj.UOM__c == 'SF')
                gotObj.QuantityNum__c = Integer.valueof(gotObj.Carpet_Length__c * gotObj.Carpet_Width__c);
            
            if(context.equalsIgnoreCase('Revise'))
                gotObj = reviseOrderTask(gotObj);
            
            else if(context.equalsIgnoreCase('Rework'))
                gotObj.Status__c = 'New';
            
            gotObj = processOrderTask(gotObj); //In all cases, edit or create, an internal user will have direct approval
            try{
                upsert gotObj;
            }
            catch (DmlException de){
                throw new AuraHandledException(de.getMessage());
            }
            catch (Exception ex){
                throw new AuraHandledException(ex.getMessage());
            }
            return gotObj;
        }
        else 
            return new GC_GES_Order_Task__c();
    }
    
    @AuraEnabled
    public static LC_CoreTaskQuery.ProductListWrapper getAllDataMap(String coreSSID, string orderId){
        if (String.isBlank(coreSSID))
            throw new AuraHandledException('Invalid Session');
        
        orderId=LC_AppUtils.validateId(orderId);
        string sId=LC_AppUtils.getShowIdforOrder(orderId).Connect2_Show__c;
        
        GC_Order__c[] orders=[SELECT Connect2_Show__c, Booth_Area_ID__c FROM GC_Order__c WHERE Id =:orderId LIMIT 1];
        string bId=orders[0].Booth_Area_ID__c;
        if (String.isBlank(bId))
            throw new AuraHandledException('No booth area associated with this order. Booth area is required to create the GES order task');
        
        GC_Connect2_Show__c[] shows=[SELECT Job_Number__c FROM GC_Connect2_Show__c WHERE Id =:sId LIMIT 1];
        string showProjNum=shows[0].Job_Number__c;
        if (String.isBlank(showProjNum))
            throw new AuraHandledException('Job number is blank. Cannot proceed with selecting order items');
        
    return LC_CoreTaskQuery.obtainProducts(showProjNum, bId, coreSSID);
}

public static GC_GES_Order_Task__c processOrderTask(GC_GES_Order_Task__c got){
    if(GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_ACCT_MANAGER) ||
       GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_SALES_MGR) || 
       GC_SecurityUtil.userHasRole(GC_SecurityUtil.R_DIRECTOR_ACCT_MGMT)){
           if(String.isEmpty(got.Status__c) || got.Status__c.equals('New'))
               got.Status__c = 'Approved'; 
       }
    return got;
}

@AuraEnabled(cacheable=true)
public static ShowAttributeOptionsType getDeptsVenuesAndMaterials(string orderId){
    GC_Order__c order = LC_AppUtils.getShowIdforOrder(orderId);
    string showId = order.Connect2_Show__c;
    
    List<GC_Show_Attribute__c> showAttributes = [select Id, Name, RecordType.Name from GC_Show_Attribute__c where Connect2_Show__c = :showId];
    
    List<ShowAttribute> serviceTypeOptions = new List<ShowAttribute>();
    List <ShowAttribute> venueOptions = new List <ShowAttribute>();
    List <ShowAttribute> materialOptions = new List <ShowAttribute>();
    List <ShowAttribute> departmentOptions = new List <ShowAttribute>();
    List <ShowAttribute> discRsnOptions = new List <ShowAttribute>();
    
    for (GC_Show_Attribute__c showAttribute : showAttributes) {
        ShowAttribute sa = new ShowAttribute (showAttribute.Id, showAttribute.Name);
        switch on showAttribute.RecordType.Name {
            when 'Show Service' {
                serviceTypeOptions.Add(sa);
            }
            when 'Venue Location' {
                venueOptions.Add(sa);
            }
            when 'Material' {
                materialOptions.Add(sa);
            }
            when 'Department' {
                departmentOptions.Add(sa);
            }
        }
    }
    ShowAttributeOptionsType saOpt = new ShowAttributeOptionsType();
    saOpt.ServiceTypes = serviceTypeOptions;
    saOpt.Venues = venueOptions;
    saOpt.Materials = materialOptions;
    saOpt.Departments = departmentOptions;
    return saOpt;
}

@AuraEnabled(cacheable=true)
public static OrderDates getOrderDates(string orderId){
    GC_Order__c order = LC_AppUtils.getShowIdforOrder(orderId);
    OrderDates od = new OrderDates();
    od.DefaultDeliveryDt = order.Delivery_Date_Time__c;
    od.DefaultCompletionDt = order.Completion_Date_Time__c;
    od.DefaultRemovalDt = order.Removal_Date_Time__c;
    return od;
}

public class OrderDates{
    @AuraEnabled
    public DateTime DefaultDeliveryDt { get; set; }
    @AuraEnabled
    public DateTime DefaultCompletionDt { get; set; }
    @AuraEnabled
    public DateTime DefaultRemovalDt { get; set; }
    OrderDates(){}
}

public class ShowAttribute{
    @AuraEnabled
    public String showAttrId { get; set; }
    @AuraEnabled
    public String showAttrName {get; set; }
    
    ShowAttribute(String Id, String Name){
        showAttrId = Id;
        showAttrName = Name;
    }
}

public class ShowAttributeOptionsType{
    @AuraEnabled
    public List<ShowAttribute> ServiceTypes { get; set; }
    @AuraEnabled
    public List<ShowAttribute> Venues {get; set; }
    @AuraEnabled
    public List<ShowAttribute> Materials {get; set; }
    @AuraEnabled
    public List<ShowAttribute> Departments {get; set; }
    
    ShowAttributeOptionsType(){}
}

public class PickListValues{
    @AuraEnabled
    public List<String> SignTypes {get; set;}
    @AuraEnabled
    public List<String> Backgrounds {get; set;}
    @AuraEnabled
    public List<String> InstallationMethods {get; set;}
    @AuraEnabled
    public List<String> CopyPlacements {get; set;}
    @AuraEnabled
    public List<String> SingleDoubleSided {get; set;}
    @AuraEnabled
    public List<String> ReasonCodes {get; set;}
    
    PickListValues(){}
}

@AuraEnabled(cacheable=true)
public static PickListValues getAllPicklistValues(){
    List<String> signTypes = new List<String>();
    List<Schema.PicklistEntry> pickListSignTypes = GC_GES_Order_Task__c.GOT_Sign_Type__c.getDescribe().getPicklistValues();
    for( Schema.PicklistEntry pickListSignType : pickListSignTypes){
        signTypes.add(pickListSignType.getLabel());
    }
    
    List<String> backgrounds = new List<String>();
    List<Schema.PicklistEntry> pickListBackgrounds = GC_GES_Order_Task__c.GOT_Background__c.getDescribe().getPicklistValues();
    for( Schema.PicklistEntry pickListBackground : pickListBackgrounds){
        backgrounds.add(pickListBackground.getLabel());
    }
    
    List<String> installMethods = new List<String>();
    List<Schema.PicklistEntry> pickListInstlMethods = GC_GES_Order_Task__c.Installation_Method__c.getDescribe().getPicklistValues();
    for( Schema.PicklistEntry pickListInstlMethod : pickListInstlMethods){
        installMethods.add(pickListInstlMethod.getLabel());
    }
    
    List<String> copyPlacements = new List<String>();        
    List<Schema.PicklistEntry> pickListCopyPlacements = GC_GES_Order_Task__c.GOT_Copy_Placement__c.getDescribe().getPicklistValues();
    for( Schema.PicklistEntry pickListCopyPlacement : pickListCopyPlacements){
        copyPlacements.add(pickListCopyPlacement.getLabel());
    }
    
    List<String> snglDblSided = new List<String>();        
    List<Schema.PicklistEntry> pickListSnglDblSideds = GC_GES_Order_Task__c.GOT_Single_Double_Sided__c.getDescribe().getPicklistValues();
    for( Schema.PicklistEntry pickListSnglDblSided : pickListSnglDblSideds){
        snglDblSided.add(pickListSnglDblSided.getLabel());
    }
    
    List<String> discReasonCodes = new List<String>();
    List<Schema.PicklistEntry> pickListDiscRsnCodes = GC_GES_Order_Task__c.Discount_Reason_Code__c.getDescribe().getPicklistValues();
    for( Schema.PicklistEntry pickListDiscRsnCode : pickListDiscRsnCodes){
        discReasonCodes.add(pickListDiscRsnCode.getLabel());
    }
    
    PickListValues pvs = new PickListValues();
    pvs.SignTypes = signTypes;
    pvs.Backgrounds = backgrounds;
    pvs.InstallationMethods = installMethods;
    pvs.CopyPlacements = copyPlacements;
    pvs.SingleDoubleSided = snglDblSided;
    pvs.ReasonCodes = discReasonCodes;
    return pvs;
}

private static GC_GES_Order_Task__c reviseOrderTask(GC_GES_Order_Task__c gotObj){
    GC_GES_Order_Task__c task = gotObj;
    
    //if (task.Status__c != 'Active' && task.Status__c != 'Released')   --Amarab 06/22/2023 SAL-1287 GOT Edit Button Hidden when Orders are in Proof Status
    if (task.Status__c != 'Active' && task.Status__c != 'Released' && task.Status__c != 'Proof Waiting for Approval' && task.Status__c != 'Proof Changes Required' && task.Status__c != 'Proof Approved')
        throw new AuraHandledException('You may only revise an Active/Released GES Order Task');
    
    task.Revision__c = task.Revision__c + 1;
    task.Last_Revision__c = DateTime.Now();
    //currentRevision.Previous_Revision__c = task.Id;
    //task.Submitted_Date__c = null;
    task.Status__c = 'New';
    //task.Line_Item_Number__c = null;
    //task.Line_Item_Status__c = null;
    // task.Order_Header_ID__c = null;
    //task.Order_Number__c = null;
    task.OwnerId = UserInfo.getUserId();
    task.Is_On_Hold__c = false;
    return  task;
}

public static Boolean validateSave(GC_GES_Order_Task__c gotObj, string orderId){
    List<String> requiredFieldNames = new List<String>();
    String emptyfields = '';        
    if((gotObj.Parent_Category__c == null) || String.isBlank(gotObj.Parent_Category__c))
        requiredFieldNames.add('Parent Category');
    if((gotObj.Child_Category__c == null) || String.isBlank(gotObj.Child_Category__c))
        requiredFieldNames.add('Child Category');
    if((gotObj.Item_Category__c == null) || String.isBlank(gotObj.Item_Category__c))
        requiredFieldNames.add('Item Category');
    if((gotObj.QuantityNum__c == null) || String.isBlank(String.valueOf(gotObj.QuantityNum__c)))
        requiredFieldNames.add('Quantity');
    if(getUserPermission()){
        if((gotObj.Booth_Area_Discount_Override__c != null) && (gotObj.Booth_Area_Discount_Override__c > 0.0)){
            if((gotObj.Discount_Reason_Code__c == null) || String.isBlank(gotObj.Discount_Reason_Code__c))
                requiredFieldNames.add('Discount Reason Code');
            
            //Amarab 01/04/2023 SAL-1220 Make Discount Reason Text not required
            //if((gotObj.Discount_Reason_Text__c == null) || String.isBlank(gotObj.Discount_Reason_Text__c))
                //requiredFieldNames.add('Discount Reason Text');
        }
    }
    
    if((gotObj.Item_Number__c == null) || String.isBlank(gotObj.Item_Number__c))
        requiredFieldNames.add('Item Number');
    
    if((gotObj.Parent_Category__c == 'LABOR') && (String.isBlank(gotObj.Labor_In_Out__c)))
        requiredFieldNames.add('Labor In/Out');
    
    if (String.isNotBlank(gotObj.Description__c) && gotObj.Description__c == 'GRAPHICS FOR GEM STRUCTURE'
        && String.isBlank(gotObj.Parent_GEM_Structure__c))
        requiredFieldNames.add('Active GEM Structure');
    
    if (gotObj.Item_Template__c.contains('Carpet') && gotObj.UOM__c == 'SF') {
        
        if(requiredFieldNames.indexOf('Quantity') > -1)
            requiredFieldNames.remove(requiredFieldNames.indexOf('Quantity')); // not required in this case
        
        if (String.isBlank(String.valueOf(gotObj.Carpet_Length__c)))
            requiredFieldNames.add('Carpet Length');
        
        if (String.isBlank(String.valueOf(gotObj.Carpet_Width__c)))
            requiredFieldNames.add('Carpet Width');      
    }
    
    if (gotObj.Item_Template__c == 'Carpet' || gotObj.Item_Template__c == 'Custom Carpet') {                
        if (gotObj.Electrical_Ordered__c == null) 
            requiredFieldNames.add('Electrical Ordered');  
        
        if (gotObj.Electrical_Under__c == null)
            requiredFieldNames.add('Electrical Under');  
    }
    
    //Checks for Task field manager, Get all fields of tfm
    Map<String, Schema.SObjectField> all_fields = GC_Task_Field_Manager__c.sObjectType.getDescribe().fields.getMap();
    
    Map<string, string>  tfmToGotMap = TaskFieldToGOTFieldMap.loadMap();
    Map<string, string> requiredFieldsMap = new Map<string, string>();  
    
    GC_Task_Field_Manager__c taskFieldManager =  getTaskFieldManager(orderId);
    SObject sTaskField = (SObject)taskFieldManager;
    
    for(Schema.sObjectField fld:all_fields.values()){            
        if(fld.getDescribe().getName().contains('__c') && (fld.getDescribe().getName() !='User__c'
                                                           && fld.getDescribe().getName()!='Connect2_Show__c'
                                                           && fld.getDescribe().getName()!='Hide_Order_Level_File_Upload__c')){
                                                               if(sTaskField.get(fld) == 'Shown and Required')
                                                               {
                                                                   requiredFieldsMap.put(fld.getDescribe().getName(), fld.getDescribe().getLabel());
                                                               }
                                                           }
    }
    
    SObject sGOT = (SObject)gotObj;
    
    for (String key : requiredFieldsMap.keySet()){            
        if(String.isNotblank(tfmToGotMap.get(key))){
            String gotFieldRelatedToTFM = tfmToGotMap.get(key);
            String gotLabelRelatedToTFM = requiredFieldsMap.get(key);               
            if(sGOT.get(gotFieldRelatedToTFM) == null){
                requiredFieldNames.add(gotLabelRelatedToTFM);
            }else if(sGOT.get(gotFieldRelatedToTFM)!= null && !gotFieldRelatedToTFM.containsIgnoreCase('Time')){
                String sObjValue = (String)sGOT.get(gotFieldRelatedToTFM);
                if(String.isBlank(sObjValue.trim()))
                    requiredFieldNames.add(gotLabelRelatedToTFM);
            }
        }
    }
    emptyfields += String.join(requiredFieldNames, ', ');
    if(String.isNotBlank(emptyfields)){
        throw new AuraHandledException('The following field(s) are required: ' + emptyfields);
    }
    else
        return true;
}
}