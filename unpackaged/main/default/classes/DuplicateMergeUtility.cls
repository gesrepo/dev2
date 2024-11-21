public with sharing class DuplicateMergeUtility {
      public static void updateContactWithValues(Contact contactA, List<Contact> contactList) {
        
        if (contactA == null || contactList == null || contactList.isEmpty()) {
            return;
        }
        Map<String, String> fieldValuesMap = new Map<String, String>();
        Set<String> updatedFields = new Set<String>();
        for (Contact contact : contactList) {
            for (Schema.SObjectField field : Schema.Contact.SObjectType.getDescribe().fields.getMap().values()) {
                String fieldName = field.getDescribe().getName();
                
                
                if (updatedFields.contains(fieldName)) {
                    continue;
                }
                
                String valueFromList = (String)contact.get(fieldName);
                String valueFromA = (String)contactA.get(fieldName);
                
                if (String.isBlank(valueFromA) && !String.isBlank(valueFromList)) {
                    fieldValuesMap.put(fieldName, valueFromList);
                    updatedFields.add(fieldName);
                }
            }
        }
        for (String fieldName : fieldValuesMap.keySet()) {
            contactA.put(fieldName, fieldValuesMap.get(fieldName));
        }
        try{
            update contactA;
        }
        catch(exception ex){
            system.debug(ex.getLineNumber()+ex.getMessage());
        }
    }
}