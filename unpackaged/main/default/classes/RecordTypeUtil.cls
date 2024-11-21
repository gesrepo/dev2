/*
Luke lim 
luke@vertiba
written 3/5
*/
global class RecordTypeUtil {
    
    //Holds the master map of all record types in the system
    private static Map<String,Id> allRecordTypes;
    
    //Indicates whether the list has already been retrieved
    private static Boolean isInitialized = false;
    
    //This method can be called from anywhere, and will return the record type id
    //matching the "recordTypeName" input if a match is found.
    
    public static Id getRecordTypeIDByDevName(String sObjectType, String recordTypeDeveloperName) {
    
        //Concatenate input together
        String key  =  sObjectType + recordTypeDeveloperName;
        key=key.toLowerCase();
        //First, check to see if the record type map has been initialized.
        if(!isInitialized) {
      
            //If we haven't initialized the map yet, then we enter this block where it gets initialized
            allRecordTypes = new Map<String, Id>();
            //Create the record type map
            
            for(RecordType r : [Select Name, DeveloperName, Id, sObjectType From RecordType where isActive=true]) {
                //Add a map entry, concatenating the sobject type + name as the key for each record type
               
              
                allRecordTypes.put((r.sObjectType + r.DeveloperName).toLowerCase(), r.Id);
            }
            //Indicate that we have initialized the record type map
            isInitialized = true;
        }
        //Finally, return the record type from the map
        return allRecordTypes.get(key);
    }
   
}