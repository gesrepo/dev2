public class CA_PersonalObjectController {
    
    @AuraEnabled(cacheable=true)	
    public static ObjectSettingsWrapper getFields(String obName, string profileName) {
        ObjectSettingsWrapper tempObjectSettingsWrapper= new ObjectSettingsWrapper();
        try{
			tempObjectSettingsWrapper.fieldWraps = new List<FieldWrapper>();
			List<CA_Personalized_Object_Setting__c> caPOS = [select id, name, Delete_Children__c,Field_Label_Map__c,Logo__c,Number_Of_Sections__c,Object_Color__c,Object_Label__c,Object_Name__c,Profile_Name__c,Run_Trigger__c,Available_Tiles__c,Available_Reports__c,Create_Button_Label__c,Error_Message__c,Global_Button_Style__c,Record_Type_ID__c,Save_Button_Label__c,Success_Message__c,Search_Filters__c,Table_Columns__c,Customer_Logo__c,Home_Page_Style__c,Analytics_Link__c,Files_Link__c,Graphic_Proofing_Link__c,Ordering_Link__c,Tasks_Link__c  FROM CA_Personalized_Object_Setting__c WHERE Profile_Name__c=:profileName and Object_Name__c=:obName LIMIT 1];
			
			Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
			Map <String, Schema.SObjectField> fieldMap = schemaMap.get(obName).getDescribe().fields.getMap();
			List<String> fNames = new List<String>();	
			
			if(caPOS.size()==0){
				tempObjectSettingsWrapper.settingsObj= new CA_Personalized_Object_Setting__c(Profile_Name__c=profileName,Object_Name__c=obName);	
				
				for(Schema.SObjectField sfield : fieldMap.Values()){                      
					schema.describefieldresult dfield = sfield.getDescribe();
					FieldWrapper fWrap = new FieldWrapper(dfield.getname(),false,false,dfield.getLabel(),string.valueOf(dfield.getType()));
					tempObjectSettingsWrapper.fieldWraps.add(fWrap);
				}
			}else{
				tempObjectSettingsWrapper.settingsObj=caPOS[0];
				Map<string,FieldSettings> apiToFieldSettings = new Map<string,FieldSettings>();
				FieldSettingStorageObj tempStorageObj = new FieldSettingStorageObj();
				tempStorageObj=(FieldSettingStorageObj)JSON.deserialize(caPOS[0].Field_Label_Map__c, FieldSettingStorageObj.class);
				apiToFieldSettings=tempStorageObj.apiToFieldSettings;
				
				for(Schema.SObjectField sfield : fieldMap.Values()){
					schema.describefieldresult dfield = sfield.getDescribe();
					if(apiToFieldSettings.containsKey(dfield.getname())){
						FieldSettings singleSetting= apiToFieldSettings.get(dfield.getname());
						// remove null from required
						Boolean isReqd=singleSetting.isRequired==null?false:singleSetting.isRequired;
						FieldWrapper fWrap = new FieldWrapper(dfield.getname(),singleSetting.isReadOnly,isReqd,singleSetting.displayLabel,singleSetting.dataType);
						tempObjectSettingsWrapper.fieldWraps.add(fWrap);
					}else{						
						FieldWrapper fWrap = new FieldWrapper(dfield.getname(),false,false,dfield.getLabel(),string.valueOf(dfield.getType()));
						tempObjectSettingsWrapper.fieldWraps.add(fWrap);
					}
				}
				
				/*for(string fieldApi:apiToFieldSettings.keySet()){
					FieldSettings singleSetting= apiToFieldSettings.get(fieldApi);
					// remove null from required
					Boolean isReqd=singleSetting.isRequired==null?false:singleSetting.isRequired;
					FieldWrapper fWrap = new FieldWrapper(fieldApi,singleSetting.isReadOnly,isReqd,singleSetting.displayLabel,singleSetting.dataType);
					tempObjectSettingsWrapper.fieldWraps.add(fWrap);
				}**/
			}
		}catch(exception e){
			
		}
        return tempObjectSettingsWrapper;
    }
    
    @AuraEnabled
    public static string updateFields(List<FieldWrapper> fws, CA_Personalized_Object_Setting__c settingsObj, string selectedTileStr, string selectedReportStr ){
        //make the function name as updateObjectSettings 
        //system.debug('fws===' +fws);
        Map<string,FieldSettings> apiToFieldSettings = new Map<string,FieldSettings>();
        for(FieldWrapper singleFieldSetting:fws){
            apiToFieldSettings.put(singleFieldSetting.fieldApi,new FieldSettings(singleFieldSetting.isReadOnly,singleFieldSetting.isRequired,singleFieldSetting.displayLabel,singleFieldSetting.dataType));
        }
        FieldSettingStorageObj tempStorageObj= new FieldSettingStorageObj(apiToFieldSettings);
        String jsonStr = JSON.serialize(tempStorageObj);
        //system.debug('jsonStr===' + jsonStr);
		//system.debug('settingsObj===' + settingsObj);

        List<CA_Personalized_Object_Setting__c> caPOS = [SELECT id, name, Delete_Children__c,Field_Label_Map__c,Logo__c,
                                                         Number_Of_Sections__c,Object_Color__c,Object_Label__c,Object_Name__c,
                                                         Profile_Name__c,Run_Trigger__c,Available_Tiles__c,Available_Reports__c,Create_Button_Label__c,Error_Message__c,Global_Button_Style__c,Record_Type_ID__c,Save_Button_Label__c,Success_Message__c,Search_Filters__c,Table_Columns__c,Customer_Logo__c,Home_Page_Style__c,Analytics_Link__c,Files_Link__c,Graphic_Proofing_Link__c,Ordering_Link__c,Tasks_Link__c  FROM CA_Personalized_Object_Setting__c 
                                                         WHERE Profile_Name__c=:settingsObj.Profile_Name__c and Object_Name__c=:settingsObj.Object_Name__c LIMIT 1];
        
        CA_Personalized_Object_Setting__c tempCPO;
        if(caPOS.size() > 0)
            tempCPO = caPOS[0];
        else{
            tempCPO = new CA_Personalized_Object_Setting__c();
        }
        
        tempCPO.Field_Label_Map__c = jsonStr;
		tempCPO.Delete_Children__c = settingsObj.Delete_Children__c;
		tempCPO.Logo__c = settingsObj.Logo__c;
		tempCPO.Number_Of_Sections__c = settingsObj.Number_Of_Sections__c;
		tempCPO.Object_Color__c = settingsObj.Object_Color__c;
		tempCPO.Object_Label__c = settingsObj.Object_Label__c;
		tempCPO.Object_Name__c = settingsObj.Object_Name__c;
		tempCPO.Profile_Name__c = settingsObj.Profile_Name__c;
		tempCPO.Run_Trigger__c = settingsObj.Run_Trigger__c;
        tempCPO.Available_Tiles__c = selectedTileStr;
        
        
        
        tempCPO.Record_Type_ID__c = settingsObj.Record_Type_ID__c;
		if(string.isNotBlank(settingsObj.Save_Button_Label__c)){
			tempCPO.Save_Button_Label__c = settingsObj.Save_Button_Label__c;
		}
        if(string.isNotBlank(settingsObj.Success_Message__c)){
			tempCPO.Success_Message__c = settingsObj.Success_Message__c;
		}
        if(string.isNotBlank(settingsObj.Home_Page_Style__c)){
			tempCPO.Home_Page_Style__c = settingsObj.Home_Page_Style__c;
		}
		if(string.isNotBlank(settingsObj.Global_Button_Style__c)){
			tempCPO.Global_Button_Style__c = settingsObj.Global_Button_Style__c;
		}
		if(string.isNotBlank(settingsObj.Create_Button_Label__c)){
			tempCPO.Create_Button_Label__c = settingsObj.Create_Button_Label__c;
		}
		if(string.isNotBlank(settingsObj.Error_Message__c)){
			tempCPO.Error_Message__c = settingsObj.Error_Message__c;
		}
        if(string.isNotBlank(settingsObj.Search_Filters__c)){
			tempCPO.Search_Filters__c = settingsObj.Search_Filters__c;
		}
		if(string.isNotBlank(settingsObj.Table_Columns__c)){
			tempCPO.Table_Columns__c = settingsObj.Table_Columns__c;
		}
        if(string.isNotBlank(settingsObj.Analytics_Link__c)){
			tempCPO.Analytics_Link__c = settingsObj.Analytics_Link__c;
		}
        if(string.isNotBlank(settingsObj.Files_Link__c)){
			tempCPO.Files_Link__c = settingsObj.Files_Link__c;
		}
        if(string.isNotBlank(settingsObj.Graphic_Proofing_Link__c)){
			tempCPO.Graphic_Proofing_Link__c = settingsObj.Graphic_Proofing_Link__c;
		}
        if(string.isNotBlank(settingsObj.Ordering_Link__c)){
			tempCPO.Ordering_Link__c = settingsObj.Ordering_Link__c;
		}
        if(string.isNotBlank(settingsObj.Tasks_Link__c)){
			tempCPO.Tasks_Link__c = settingsObj.Tasks_Link__c;
		}
        tempCPO.Customer_Logo__c = settingsObj.Customer_Logo__c;
        
        tempCPO.Available_Reports__c = selectedReportStr;
		//system.debug('tempCPO==='+tempCPO);
        upsert tempCPO;
		system.debug('tempCPO==='+tempCPO.id);
        return tempCPO.id;
    }
    
    public class ObjectSettingsWrapper{
        @AuraEnabled
        public CA_Personalized_Object_Setting__c settingsObj {get; set;}
        @AuraEnabled
        public List<FieldWrapper> fieldWraps {get; set;}        
        public ObjectSettingsWrapper(){}        
    }
    
    public class FieldWrapper{
        @AuraEnabled
        public String fieldApi {get; set;}
        @AuraEnabled
        public Boolean isReadOnly {get; set;}
		@AuraEnabled
        public Boolean isRequired {get; set;}
        @AuraEnabled
        public String displayLabel {get; set;}
        @AuraEnabled
        public String dataType {get; set;}
        
        public FieldWrapper(String fieldApi,Boolean isReadOnly,Boolean isRequired,String displayLabel, String dataType){
            this.fieldApi=fieldApi;
            this.isReadOnly=isReadOnly;
			this.isRequired=isRequired;
            this.displayLabel=displayLabel;
            this.dataType=dataType;
        }
        public FieldWrapper(){}
    }
    
    public class FieldSettings{
        @AuraEnabled
        public Boolean isReadOnly {get; set;}
		@AuraEnabled
        public Boolean isRequired {get; set;}
        @AuraEnabled
        public String displayLabel {get; set;}
        @AuraEnabled
        public String dataType {get; set;}
        
        public FieldSettings(Boolean isReadOnly,Boolean isRequired,String displayLabel,String dataType){
            this.isReadOnly=isReadOnly;
			this.isRequired=isRequired;
            this.displayLabel=displayLabel;
            this.dataType=dataType;
        }
    }
    
    public class FieldSettingStorageObj{
        @AuraEnabled
        Map<string,FieldSettings> apiToFieldSettings {get; set;}
        
        public FieldSettingStorageObj(Map<string,FieldSettings> apiToFieldSettings){
            this.apiToFieldSettings=apiToFieldSettings;
        }
        public FieldSettingStorageObj(){}
    }
}