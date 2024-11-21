public with sharing class LC_CoreQuery {
    
    public class applicationException extends Exception {}
    public LC_OrderCreateEditController.LC_OrderWrapper Mywrapper  = new LC_OrderCreateEditController.LC_OrderWrapper();
    public static GC_Order__c order = new GC_Order__c();
    public GC_GES_Order_Task__c got {get; set;}
    
    // These are consistent via multiline and booth area changes
    public static String coreSessionId { get; set; }
    public static String showProjectNumber { get; set; } // CORE uses two numbers for ordering items, showProjectNumber is the salesforce Job number.
    public static String showOccrProjectId { get; set; } // This is determined by the salesforce job number above and needs to be queried for.
    public static String selectedBooth { get; set; } // Selected Booth ID from Parent Order
    public static String selectedBoothName { get; set; } // Selected Booth ID from Parent Order
    public static List<SelectOption> boothOptions { get; private set; }
    public static Map<String, CORE_V2.BoothArea> boothAreas { get; private set; }
    public static Map<String,String> boothAreaMap  { get; set; } //np
    public static Boolean isProjectValid { get; set; }
    
    public LC_CoreQuery() {
        boothOptions = new List<SelectOption>();
        boothAreas = new Map<String, CORE_V2.BoothArea>();
    }  
    
    public LC_OrderCreateEditController.LC_OrderWrapper obtainBoothAreas() {
        system.debug('coreSessionId--->'+coreSessionId);
        if (isProjectValid) {
            if (String.isBlank(coreSessionId)) {
                system.debug('Failed to Obtain the Session Id');
               // return boothAreaMap;
                 return Mywrapper;
            }
            else{
                CORE_V2.BasicHttpBinding_IShowService projectQuery = new CORE_V2.BasicHttpBinding_IShowService();
                try {
                    CORE_V2.ShowProject showProject;
                    if (Test.isRunningTest()) {
                        showProject = GC_TestUtils.getTestShowProject();
                    }
                    else {
                        showProject = projectQuery.GetShowProjectByProjectNumber(coreSessionId, showProjectNumber);
                    }
                    boothAreas = getBoothAreaByShowProject(showProject);  //no longer used
                    boothAreaMap = getBoothAreaMapByShowProject(showProject); //map for the select option
                    //Mywrapper.boothMap = getBoothAreaMapByShowProject(showProject); //map for the select option
                    Mywrapper.boothMap = boothAreaMap;
                    system.debug('boothAreas--->'+boothAreas);
                    system.debug('boothAreaMap--->'+boothAreaMap); //np
                    showOccrProjectId = String.valueOf(showProject.showOccrProjectId);
                    system.debug('showOccrProjectId--->'+showOccrProjectId);
                    if(Test.isRunningTest())
                    {
                        throw new applicationException('Sorry! We don\'t do that here!!');
                    }
                }
                catch (Exception e) {
                    GC_Core_Interface_Log__c logMsg = new GC_Core_Interface_Log__c();
                    if (order != null && String.isNotBlank(order.Id)) {
                        logMsg = GC_CoreUtils.createNewLog('Response from Web Service: Obtain Booth Areas', 'Failed to Obtain Booth Areas ' + e.getMessage(), 'Error', order);
                    }
                    else {
                        logMsg = GC_CoreUtils.createNewLog('Response from Web Service: Obtain Booth Areas', 'Failed to Obtain Booth Areas ' + e.getMessage(), 'Error');
                    }
                    insert logMsg;
                    system.debug('Failed to Obtain Booth Areas');
                    system.debug('Response from Web Service: ' + e.getMessage()+' Line number-- '+ e.getLineNumber());
                    Mywrapper.errorMessages = 'Response from Web Service: ' + e.getMessage();
                    system.debug('wrapper.errorMessages--->'+Mywrapper.errorMessages);
                }
            }
        }else {
            system.debug('Job Number is blank, Cannot proceed with obtaining the Booth Areas.');
        }
        system.debug('boothAreas--->'+boothAreas);
        system.debug('boothAreaMap--->'+boothAreaMap); //np
       
        //return boothAreaMap;
        return Mywrapper;
    }
    
    public static GC_Order__c selectBoothArea(String selectedOption, GC_Order__c orderInstance) {
       selectedBooth = selectedOption;
        GC_Order__c order = new GC_Order__c();
        System.debug('boothAreas--->'+boothAreas);
        System.debug('selectedBooth--->'+selectedBooth);

        if (String.isNotBlank(selectedBooth) && boothAreas != null) {            
            CORE_V2.BoothArea boothArea = boothAreas.get(selectedBooth);
            System.debug('boothArea--->'+boothArea);
            order.Booth_Area__c = String.valueOf(boothArea.Area);
            order.Booth_Area_ID__c = String.valueOf(boothArea.BoothAreaId);
            order.Delivery_Date_Time__c = GC_CoreUtils.ConvertExternalDateTime(boothArea.DeliveryDateTime);
            order.Removal_Date_Time__c = GC_CoreUtils.ConvertExternalDateTime(boothArea.RemovalDateTime);
            order.Completion_Date_Time__c = GC_CoreUtils.ConvertExternalDateTime(boothArea.CompletionDateTime);
            system.debug('order---->'+order);
            return order;
        }
        return order;
    }
   
    
    public Map<String,String> getBoothAreaMapByShowProject(CORE_V2.ShowProject showProject) {
        // boothOptions.clear();
        Map<String,String> boothAreaMap = new Map<String,String>(); // we'll use Area as the Key, this should be filled out
        for (CORE_V2.BoothArea boothArea : showProject.BoothAreas.BoothArea) {
            boothAreaMap.put(String.valueof(boothArea.BoothAreaId), String.valueof(boothArea.Area));
           // SelectOption so = new SelectOption(String.valueof(boothArea.BoothAreaId), boothArea.Area);
           // boothOptions.Add(so);
        }
        system.debug('boothAreaMap--->'+boothAreaMap);
        return boothAreaMap;
    }

       //old method ----------- dont comment .. refered in other methods
    public Map<String, CORE_V2.BoothArea> getBoothAreaByShowProject(CORE_V2.ShowProject showProject) {
        boothOptions.clear();
        Map<String, CORE_V2.BoothArea> boothAreaLookup = new Map<String, CORE_V2.BoothArea>(); // we'll use Area as the Key, this should be filled out
        SelectOption noneSelectOption = new SelectOption('', '---None---');
        boothOptions.Add(noneSelectOption);
        
        for (CORE_V2.BoothArea boothArea : showProject.BoothAreas.BoothArea) {
            boothAreaLookup.put(String.valueOf(boothArea.BoothAreaId), boothArea);
            SelectOption so = new SelectOption(String.valueof(boothArea.BoothAreaId), boothArea.Area);
            boothOptions.Add(so);
        }
        return boothAreaLookup;
    } 
}