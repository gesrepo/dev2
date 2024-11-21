public class ICS_AR_Adjustments_Approver_Update {

    public static List<AR_Adjustments__c> AR_Adjustments_Approverdetails(List<AR_Adjustments__c> ARList){
        List<AR_Adjustments__c> AdjustmentList = ARList;
        
        system.debug('AdjustmentList==='+AdjustmentList.size());
        
         List<ICS_Approver_Matrix__c> CRMList = [select  Transaction_Types__c,Max_Amount__c, Min_Amount__c,location__c,
                                                LOB_Approver__c, F_R_Approver__c,    CSO_Approver__c,  LOB__c,
                                                AR1_Approver__c,AR2_Approver__c,Additional_Approver__c,Sales_Channel__c
                                                 from ICS_Approver_Matrix__c];
        
        Set<Id> approverIds = new Set<Id>();
        for(ICS_Approver_Matrix__c cr : CRMList){
            approverIds.add(cr.LOB_Approver__c);
            approverIds.add(cr.F_R_Approver__c); 
            approverIds.add(cr.AR1_Approver__c);
            approverIds.add(cr.CSO_Approver__c);
            approverIds.add(cr.AR2_Approver__c);
            
        }
        
        //system.debug('CRMList==='+CRMList);
        
        List<Employees__c> EmployeeList = [select id, Email_Address__c from Employees__c where id in :approverIds ];
        
       // system.debug('EmployeeList==='+EmployeeList);
        
        Map<Id, String> EmployeeIdEmailMap = new Map<Id, String>();
        for(Employees__c u : EmployeeList){
            EmployeeIdEmailMap.put(u.id, u.Email_Address__c);
            //system.debug(u.id+'==>'+u.Email_Address__c);
        }
        
        
            
        for(AR_Adjustments__c ar : AdjustmentList){
            system.debug('1st for loop');
            for(ICS_Approver_Matrix__c cr : CRMList){
                system.debug('2nd for loop');               
                if(cr.Transaction_Types__c == 'AR Adjustments'){
                    system.debug('1st if loop');    
                    if (ar.Case_location__c == cr.Location__c ){
                        system.debug('2nd if loop');
                        if(ar.Case_Sales_Channel__c == cr.Sales_Channel__c ){
                            system.debug('3rd if loop');
                           // if(ar.LOB__c == cr.LOB__c){
                                if(cr.Min_Amount__c == null){
                                    system.debug('4th if loop');
                                    if (ar.Amount__c <= cr.Max_Amount__c){
                                        system.debug('5th if loop');
                                        ar.DAM_LOB_Approver__c = cr.LOB_Approver__c;
                                        ar.DAM_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.LOB_Approver__c);
                                        ar.F_R_Approver__c = cr.F_R_Approver__c;
                                        ar.F_A_Approver_Email__c = EmployeeIdEmailMap.get(cr.F_R_Approver__c);
                                        ar.AR1_Approver_Name__c = cr.AR1_Approver__c;
                                        ar.AR1_Approver_Email__c = EmployeeIdEmailMap.get(cr.AR1_Approver__c);
                                        ar.CSO_Approver_Name__c = cr.CSO_Approver__c;
                                        ar.CSO_Approver_Email__c = EmployeeIdEmailMap.get(cr.CSO_Approver__c);  
                                        ar.AR2_Approver_Name__c = cr.AR2_Approver__c;
                                        ar.AR2_Approver_Email__c = EmployeeIdEmailMap.get(cr.AR2_Approver__c);
                                    }
                                }
                   
                                if(cr.Max_Amount__c == null){
                                    if (ar.Amount__c >= cr.Min_Amount__c){
                                        ar.DAM_LOB_Approver__c = cr.LOB_Approver__c;
                                        ar.DAM_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.LOB_Approver__c);
                                        ar.F_R_Approver__c = cr.F_R_Approver__c;
                                        ar.F_A_Approver_Email__c = EmployeeIdEmailMap.get(cr.F_R_Approver__c);
                                        ar.AR1_Approver_Name__c = cr.AR1_Approver__c;
                                        ar.AR1_Approver_Email__c = EmployeeIdEmailMap.get(cr.AR1_Approver__c);
                                        ar.CSO_Approver_Name__c = cr.CSO_Approver__c;
                                        ar.CSO_Approver_Email__c = EmployeeIdEmailMap.get(cr.CSO_Approver__c);
                                        ar.AR2_Approver_Name__c = cr.AR2_Approver__c;
                                        ar.AR2_Approver_Email__c = EmployeeIdEmailMap.get(cr.AR2_Approver__c);
                                    }
                                }
                            //}   
                        }                
                    }   
                             
                }
            }
        }
        system.debug('AdjustmentList==='+AdjustmentList);
        return AdjustmentList;
    } 
}