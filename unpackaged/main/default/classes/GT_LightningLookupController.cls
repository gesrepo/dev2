/**
* @Author		:		Karthik N
* @Date		:		18-Aug-2018
* @Desc		:		Controller for Lookup Lightning Component
* */
public class GT_LightningLookupController {
    
    /**
* Returns JSON of list of ResultWrapper to Lex Components
* @objectName - Name of SObject
* @fld_API_Text - API name of field to display to user while searching
* @fld_API_Val - API name of field to be returned by Lookup COmponent
* @lim   - Total number of record to be returned
* @fld_API_Search - API name of field to be searched
* @searchText - text to be searched
* */
    @AuraEnabled 
    public static String searchDB(String objectName, String fld_API_Text, String fld_API_Val, 
                                  Integer lim,String fld_API_Search,String searchText ){
                                      
                                      searchText='\'%' + String.escapeSingleQuotes(searchText.trim()) + '%\'';
                                      
                                      
                                      String query = 'SELECT '+ fld_API_Val + ', ' + fld_API_Text +
                                          ' FROM '+ objectName +
                                          ' WHERE '+ fld_API_Search +' LIKE '+ searchText + 
                                          ' LIMIT '+ lim;
                                      
                                      List<sObject> sobjList = Database.query(query);
                                      system.debug('query-----------' + query);
                                      system.debug('sobjList-----------' + sobjList.size());
                                      List<ResultWrapper> lstRet = new List<ResultWrapper>();
                                      
                                      for(sObject s : sobjList){
                                          ResultWrapper obj = new ResultWrapper();
                                          obj.objName = objectName;
                                          obj.text = String.valueOf(s.get(fld_API_Text)) ;
                                          obj.val = String.valueOf(s.get(fld_API_Val))  ;
                                          lstRet.add(obj);
                                      } 
                                      return JSON.serialize(lstRet) ;
                                  }
    
    public class ResultWrapper{
        public String objName {get;set;}
        public String text{get;set;}
        public String val{get;set;}
    }
}