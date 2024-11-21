/**
* @author Ethos Solutions - www.ethos.com
* @description Utility logic for reflection (obtaining field labels, etc.)
* 2016-08-23 : Original Version
**/
public without sharing class GC_ReflectionUtil {
    public static Boolean fieldChanged(sObject oldObj, sObject newObj, String fieldName) {
        Object oldVal = oldObj.get(fieldName);
        Object newVal = newObj.get(fieldName);

        return oldVal != newVal;
    }

    public static Schema.DisplayType getDisplayType(String objectName, String fieldName) {
        Schema.DisplayType dispType = null;

        SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> objectFields = objToken.getDescribe().fields.getMap();
        dispType = objectFields.get(fieldName).getDescribe().getType();

        return dispType;
    }

    public static String getLabel(String objectName, String fieldName) {
        String label = null;

        SObjectType objToken = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> objectFields = objToken.getDescribe().fields.getMap();
        label = objectFields.get(fieldName).getDescribe().getLabel();

        return label;
    }
}