public class ICS_Refunds_Approver_Update {
    //public static Void CMapproverdetails(List<Credit_Memo_ICS__c> CrList){
    
    public static List<Refunds_ICS__c> Refunds_Approverdetails(List<Refunds_ICS__c> CrList){
    List<Refunds_ICS__c> RefundsList = CrList;
        
        List<ICS_Approver_Matrix__c> CRMList = [select  Transaction_Types__c,Max_Amount__c, Min_Amount__c,    
                                                AR1_Approver__c,AR2_Approver__c, CSO_Approver__c
                                                    from ICS_Approver_Matrix__c where Transaction_Types__c = 'Refunds'];
        
        Set<Id> approverIds = new Set<Id>();
        for(ICS_Approver_Matrix__c cr : CRMList){
            approverIds.add(cr.AR1_Approver__c);
            approverIds.add(cr.AR2_Approver__c);
        }
        List<Employees__c> EmployeeList = [select id, Email_Address__c from Employees__c where id in :approverIds ];
        
        Map<Id, String> EmployeeIdEmailMap = new Map<Id, String>();
        for(Employees__c u : EmployeeList){
            EmployeeIdEmailMap.put(u.id, u.Email_Address__c);
        }  
           for(Refunds_ICS__c cm : RefundsList){
           for(ICS_Approver_Matrix__c cr : CRMList){
                   system.debug('cr==='+cr);
                  if (cr.Min_Amount__c != null && cr.Max_Amount__c != null){
                      if (cm.Amount__c >= cr.Min_Amount__c && cm.Amount__c <= cr.Max_Amount__c){
                            system.debug('cm==='+cm);
                            system.debug('cr1==='+cr);
                            cm.AR1_Approver_Name__c = cr.AR1_Approver__c;
                            cm.AR1_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.AR1_Approver__c);
                            cm.CSO_Approver_Name__c = cr.CSO_Approver__c;
                            //cm.CSO_Approver_EmailID__c = EmployeeIdEmailMap.get(cr.CSO_Approver__c);
                            cm.AR2_Approver_Name__c = cr.AR2_Approver__c;
                            cm.AR2_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.AR2_Approver__c);
                          system.debug('cm==='+cm);
                          break;
                         }
                   }
                else if(cr.Max_Amount__c == null){
                      if (cm.Amount__c >= cr.Min_Amount__c){
                        cm.AR1_Approver_Name__c = cr.AR1_Approver__c;
                        cm.AR1_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.AR1_Approver__c);
                        cm.CSO_Approver_Name__c = cr.CSO_Approver__c;
                        //cm.CSO_Approver_EmailID__c = EmployeeIdEmailMap.get(cr.CSO_Approver__c);  
                        cm.AR2_Approver_Name__c = cr.AR2_Approver__c;
                        cm.AR2_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.AR2_Approver__c);
                          break;
                   }
               }                 
             
           }   
               system.debug('c2=='+cm); 
        }
        return RefundsList;
    }    
}