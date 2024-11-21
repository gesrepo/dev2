public class ICS_CreditMemo_Handler {
    public static List<Credit_Memo_ICS__c> CMapproverdetails(List<Credit_Memo_ICS__c> CrList) {
        Set<String> setCategory = new Set<String>();
        for(Credit_Memo_ICS__c cm : CrList) {
            setCategory.add(cm.Reason_Code_Category__c);
        }
        system.debug('inside aeee');
        List<ICS_Approver_Matrix__c> CRMList = [select  Transaction_Types__c,Max_Amount__c, Min_Amount__c,Location__c,
                                                  LOB_Approver__c, F_R_Approver__c,AR1_Approver__c,AR2_Approver__c,CSO_Approver__c,
                                                   Additional_Approver__c,Reason_Code_Category__c,Sales_Channel__c, LOB__c  
                                                    from ICS_Approver_Matrix__c where Reason_Code_Category__c IN: setCategory ];
            Set<Id> approverIds = new Set<Id>();
        Map<String, Map<String, Map<String, Map<String, List<ICS_Approver_Matrix__c >>>>> mapICSApproverMatrix 
                                = new Map<String, Map<String, Map<String, Map<String, List<ICS_Approver_Matrix__c >>>>>();
            system.debug(CRMList);
            system.debug(CrList);
            for(ICS_Approver_Matrix__c cr : CRMList){
                approverIds.add(cr.LOB_Approver__c);
                approverIds.add(cr.F_R_Approver__c);
                approverIds.add(cr.AR1_Approver__c);
                approverIds.add(cr.CSO_Approver__c);
                approverIds.add(cr.AR2_Approver__c); 
                approverIds.add(cr.Additional_Approver__c);
                if(!mapICSApproverMatrix.containsKey(cr.Reason_Code_Category__c)) {
                    mapICSApproverMatrix.put(cr.Reason_Code_Category__c, new Map<String, Map<String, Map<String, List<ICS_Approver_Matrix__c >>>>());
                }
                String location = 'null';
                if(cr.Location__c != null) {
                    location = cr.Location__c;
                }
                system.debug(location);
                String salesChannel = 'null';
                if(cr.Sales_Channel__c != null)
                // && system.label.CL_ICS_Sales_Channel.contains(cr.Sales_Channel__c)) 
                {
                    salesChannel = cr.Sales_Channel__c;
                }
                String LOB = 'null';
                if(cr.LOB__c != null)
                // && system.label.CL_ICS_LOB.contains(cr.LOB__c))
                 {
                    LOB = cr.LOB__c;
                }
                if(!mapICSApproverMatrix.get(cr.Reason_Code_Category__c).containsKey(location )) {
                    mapICSApproverMatrix.get(cr.Reason_Code_Category__c).put(location , new Map<String, Map<String, List<ICS_Approver_Matrix__c >>>());
                }

                if(!mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).containsKey(salesChannel)) {
                        mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).put(salesChannel, new Map<String, List<ICS_Approver_Matrix__c >>());
                }
            /*    if(salesChannel == 'Revenue Show Org') {
                    system.debug('salesChannel===='+salesChannel);
                    system.debug('cr.Reason_Code_Category__c===='+cr.Reason_Code_Category__c);
                    system.debug('location===='+location);
                    system.debug('cr===='+cr);
                    if(!mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel).containsKey('Revenue Show Org')) {
                            mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).put('Revenue Show Org', new List<ICS_Approver_Matrix__c>());
                    }
                    mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).get('Revenue Show Org').add(cr);
                    system.debug('salesChannel1===='+mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).get('Revenue Show Org'));
                } */
                
                
                 if(LOB != cr.LOB__c) {
                    system.debug('salesChannel===='+salesChannel);
                    system.debug('cr.Reason_Code_Category__c===='+cr.Reason_Code_Category__c);
                    system.debug('location===='+location);
                    system.debug('cr===='+cr);
                    if(!mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel).containsKey(LOB)) {
                            mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).put('None', new List<ICS_Approver_Matrix__c>());
                    }
                    mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).get('None').add(cr);
                    system.debug('salesChannel1===='+mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).get('Revenue Show Org'));
                } 
                

                else
                {
                    if(!mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel).containsKey(LOB)) {
                            mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).put(LOB, new List<ICS_Approver_Matrix__c>());
                    }
                    mapICSApproverMatrix.get(cr.Reason_Code_Category__c).get(location ).get(salesChannel ).get(LOB).add(cr);
                }
                                    
            }   
            //system.debug(' mapICSApproverMatrix===='+ mapICSApproverMatrix.get('Cat - A').get('null').get('E&E (Trade Show)'));    
        List<Employees__c> EmployeeList = [select id, Email_Address__c from Employees__c where id in :approverIds ];
            Map<Id, String> EmployeeIdEmailMap = new Map<Id, String>();
            for(Employees__c u : EmployeeList){
                EmployeeIdEmailMap.put(u.id, u.Email_Address__c);
            }
        for(Credit_Memo_ICS__c cm : CrList){
            cm.LOB_Approver_Name__c = null;
            cm.LOB_Approver_Email_ID__c = '';
            cm.F_R_Approver_Name__c = null;
            cm.F_R_Approver_Email_ID__c = '';
            cm.AR1_Approver_Name__c = null;
            cm.AR1_Approver_Email_ID__c = '';
            cm.CSO_Approver_Name__c = null;
            cm.CSO_Approver_Email__c = '';
            cm.AR2_Approver_Name__c = null;
            cm.AR2_Approver_Email_ID__c = '';
            cm.Additional_Approver_Name__c = null;
            cm.Additional_Approver_Email_ID__c = '';
            ICS_Approver_Matrix__c cr = new ICS_Approver_Matrix__c();
            system.debug('cm==='+cm);
            String location = 'null';
            system.debug('location'+location);
            if(cm.Case_Location__c != null) {
                location = cm.Case_Location__c;
            }
            system.debug('cm.Case_Sales_Channel__c=='+cm.Case_Sales_Channel__c);
     /*       if(cm.Case_Sales_Channel__c =='Revenue Show Org'){
                system.debug('cm.Reason_Code_Category__c=='+cm.Reason_Code_Category__c);
                system.debug('location==='+location);
                system.debug('cm.Case_Sales_Channel__c===='+cm.Case_Sales_Channel__c);
                if(cm.Reason_Code_Category__c != null && mapICSApproverMatrix.get(cm.Reason_Code_Category__c) != null 
                && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location) != null
                && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c) !=null
                && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get(cm.Case_Sales_Channel__c) != null)
               {
                for(ICS_Approver_Matrix__c ICSApproverMatrix : mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get(cm.Case_Sales_Channel__c)) {
                    if((cm.Total_Amount__c == 0 && ICSApproverMatrix.Min_Amount__c == 0) 
                        || (cm.Total_Amount__c > ICSApproverMatrix.Min_Amount__c && cm.Total_Amount__c <= ICSApproverMatrix.Max_Amount__c && ICSApproverMatrix.Max_Amount__c != null)
                        || (cm.Total_Amount__c == ICSApproverMatrix.Min_Amount__c && cm.Total_Amount__c != 0) 
                        || (cm.Total_Amount__c >= ICSApproverMatrix.Min_Amount__c && ICSApproverMatrix.Max_Amount__c == null )) {
                system.debug('ICSApproverMatrix1==='+ICSApproverMatrix);
                            cr = ICSApproverMatrix;
                            break;
                    }
                }
            }
        }*/
        

        

             if(cm.Reason_Code_Category__c != null && mapICSApproverMatrix.get(cm.Reason_Code_Category__c) != null 
                && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location) != null
                && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c) != null
                && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get(cm.Credit_LOB__c) != null)
                {
                system.debug('aaa==='+mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get(cm.Credit_LOB__c));
                for(ICS_Approver_Matrix__c ICSApproverMatrix : mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get(cm.Credit_LOB__c)) {
                    if((cm.Total_Amount__c == 0 && ICSApproverMatrix.Min_Amount__c == 0) 
                        || (cm.Total_Amount__c > ICSApproverMatrix.Min_Amount__c && cm.Total_Amount__c <= ICSApproverMatrix.Max_Amount__c && ICSApproverMatrix.Max_Amount__c != null)
                        || (cm.Total_Amount__c == ICSApproverMatrix.Min_Amount__c && cm.Total_Amount__c != 0) 
                        || (cm.Total_Amount__c >= ICSApproverMatrix.Min_Amount__c && ICSApproverMatrix.Max_Amount__c == null )) {
                system.debug('ICSApproverMatrix1==='+ICSApproverMatrix);
                            cr = ICSApproverMatrix;
                            break;
                    }
                }
            }
            
            else if(cm.Credit_LOB__c != cr.LOB__c){
            if(cm.Reason_Code_Category__c != null && mapICSApproverMatrix.get(cm.Reason_Code_Category__c) != null 
            && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location) != null
            && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c) != null
            && mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get('None') != null)
            {
                for(ICS_Approver_Matrix__c ICSApproverMatrix : mapICSApproverMatrix.get(cm.Reason_Code_Category__c).get(location).get(cm.Case_Sales_Channel__c).get('None')) {
                if((cm.Total_Amount__c == 0 && ICSApproverMatrix.Min_Amount__c == 0) 
                || (cm.Total_Amount__c > ICSApproverMatrix.Min_Amount__c && cm.Total_Amount__c <= ICSApproverMatrix.Max_Amount__c && ICSApproverMatrix.Max_Amount__c != null)
                || (cm.Total_Amount__c == ICSApproverMatrix.Min_Amount__c && cm.Total_Amount__c != 0) 
                || (cm.Total_Amount__c >= ICSApproverMatrix.Min_Amount__c && ICSApproverMatrix.Max_Amount__c == null )) {
                system.debug('ICSApproverMatrix1==='+ICSApproverMatrix);
                cr = ICSApproverMatrix;
                break;
                    }
                }
            }
        }
        
            
            
            
            if(cr.Id != null) {
                system.debug('Inside approver assignment');
                cm.LOB_Approver_Name__c = cr.LOB_Approver__c;
                cm.LOB_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.LOB_Approver__c);
                cm.F_R_Approver_Name__c = cr.F_R_Approver__c;
                cm.F_R_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.F_R_Approver__c);
                cm.AR1_Approver_Name__c = cr.AR1_Approver__c;
                cm.AR1_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.AR1_Approver__c);
                cm.CSO_Approver_Name__c = cr.CSO_Approver__c;
                cm.CSO_Approver_Email__c = EmployeeIdEmailMap.get(cr.CSO_Approver__c);                
                cm.AR2_Approver_Name__c = cr.AR2_Approver__c;
                cm.AR2_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.AR2_Approver__c);
                cm.Additional_Approver_Name__c = cr.Additional_Approver__c;
                cm.Additional_Approver_Email_ID__c = EmployeeIdEmailMap.get(cr.Additional_Approver__c); 
                system.debug('Inside approver assignment- end');
            }
        }
        
        return CrList;
    }
    
    public static void updateReasonCategoryCode(List<Credit_Memo_ICS__c> listCreditMemo) {
        for(Credit_Memo_ICS__c cm : listCreditMemo) {
            if(system.Label.CL_ICSCatA.contains(cm.Credit_Memo_Reason__c)) {
                cm.Reason_Code_Category__c = 'Cat - A';
            } else
            if(system.Label.CL_ICSCatB.contains(cm.Credit_Memo_Reason__c)) {
                cm.Reason_Code_Category__c = 'Cat - B';
            } else
            if(system.Label.CL_ICSCatC.contains(cm.Credit_Memo_Reason__c)) {
                cm.Reason_Code_Category__c = 'Cat - C';
            }
        }
    }
}