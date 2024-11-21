public class RecordTypeSelectionController {
     @AuraEnabled
    public static list<recordtype> getRecordtype(string objectname){
      string query = 'select id  , name  from recordtype where sobjecttype=\''+objectname+'\'';
        return Database.query(query); 
 
    }

}