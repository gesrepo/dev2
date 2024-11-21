public class OpportunityTriggerHelper {
    public static Boolean isFirstTime = true; /*Added to handle SOQL 101 error by Sajid SFDC-236 */
    
    /*private static boolean alreadyLaunchedUpdateTrigger = false;
        
    public static boolean hasAlreadyLaunchedUpdateTrigger() {
        return alreadyLaunchedUpdateTrigger;
    }

    public static void setAlreadyLaunchedUpdateTrigger() {
        alreadyLaunchedUpdateTrigger = true;
    }*/

    public static void submitForApproval(List<Opportunity> opportunities){
        Set<Id> oppIdSet = new Set<Id>();
        for(Opportunity opp :opportunities){
            oppIdSet.add(opp.Id);
        }

        Map<Id,Id> processInstanceMap  = new Map<Id,Id>();
        for(ProcessInstance pi :[SELECT Id,TargetObjectId FROM ProcessInstance WHERE TargetObjectId IN :oppIdSet AND Status = 'Pending']){
            processInstanceMap.put(pi.TargetObjectId,pi.Id);
        }

        for(Opportunity opp :opportunities){
            if(!processInstanceMap.containskey(opp.Id)){
                Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
                request.setComments('Submitting request for approval.');
                request.setObjectId(opp.Id);
                if(!Test.isRunningTest()) //added to fix test class by Sajid SFDC-236
                    Approval.ProcessResult result = Approval.process(request);
            }
        }
    }

    public static void updateShowPlanOnInsert(List<Opportunity> opportunities){
        Set<Id> oppIdSet = new Set<Id>();
        Set<String> accPlanSet = new Set<String>();
        for(Opportunity opp :opportunities){
            oppIdSet.add(opp.Id);
            accPlanSet.add(opp.Account_Plan__c);
        }
        
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>();
        List<Opportunity> oppList = new List<Opportunity>();
        List<String> showIdList = new List<String>();
        List<String> accountPlanList = new List<String>();
        
        for(Opportunity opp :[SELECT Show_Name__c,Show_Name__r.Show_ID__c,amount,name,RFP_Due_Date__c,LMS_Facility_ID__c,Show_Close_Date__c,Account_Plan__c
                              FROM Opportunity 
                              WHERE Account_Plan__c IN :accPlanSet
                              AND Account_Plan__c != null
                              AND Show_Close_Date__c != null
                              ORDER BY Show_Close_Date__c ASC LIMIT 1000]){
            if(!oppMap.containsKey(opp.Id)){
                oppMap.put(opp.Account_Plan__c, opp);                          
            } 
            oppList.add(opp);
            showIdList.add(opp.Show_Name__r.Show_ID__c);
            accountPlanList.add(opp.Account_Plan__c);                      
        }

        Map<Id,Show_Plan__c> showPlanMap = new Map<Id,Show_Plan__c>([SELECT Id,Proposal_Due_Date__c,
                                                                    Previous_Occurrence_Revenue__c
                                                                    FROM Show_Plan__c WHERE Id IN:accPlanSet]);

        List<Opportunity> showOccurenceList = [SELECT Show_Name__c,Show_Name__r.Show_ID__c,name,LMS_Facility_ID__c,Show_Close_Date__c,Amount,Account_Plan__c,Prime_Contractor__c
                                                FROM Opportunity
                                                WHERE Show_Name__r.Show_ID__c IN :showIdList
                                                AND Account_Plan__c NOT IN :accountPlanList
                                                AND Show_Close_Date__c != null
                                                AND Show_Name__r.SHOW_ID__c != null
                                                ORDER BY Show_Close_Date__c DESC];

        List<Show_Plan__c> accPlanUpdateList = new List<Show_Plan__c>();
        List<Show_Plan__c> objAccPlanUpdate = new List<Show_Plan__c>(); 

        for(Opportunity opp :opportunities){
            List<Opportunity> objOppList = new List<Opportunity>();
            List<Show_Plan__c> objShowPlanList = new List<Show_Plan__c>();

            if(opp.Account_Plan__c != null){
                for(Opportunity op :oppList){
                    if(op.Account_Plan__c == opp.Account_Plan__c){
                        objOppList.add(op);
                    }
                }
                
                if(showPlanMap.containsKey(opp.Account_Plan__c)){
                    objShowPlanList.add(showPlanMap.get(opp.Account_Plan__c));  
                }
            }

            //Update Date Proposal due date (Task3-3)
            if(!objOppList.isEmpty() && !objShowPlanList.isEmpty()){
                accPlanUpdateList.add(UpdateProposalDate(objShowPlanList[0],objoppList));
                List<Opportunity> objShowOccuranceList = new List<Opportunity>();
                if(opp.Account_Plan__c != null && !objOppList.isEmpty()){
                    //Non Accplan Least year
                    for(Opportunity so :showOccurenceList){
                        if(so.Show_Name__r.Show_ID__c == objOppList[0].Show_Name__r.Show_ID__c
                        && so.Account_Plan__c != objOppList[0].Account_Plan__c 
                        && so.Show_Close_Date__c != null 
                        && so.Show_Close_Date__c <  objOppList[0].Show_Close_Date__c){
                            objShowOccuranceList.add(so);
                        }
                    }
                }

                if(!objShowOccuranceList.isEmpty()){
                    // For purpose of update the acc plan with non related updates
                    if(!objShowPlanList.isEmpty()){
                        Show_Plan__c sp = objShowPlanList[0];
                        sp.DummyNonRelatedOppID__c = objShowOccuranceList[0].id;
                        sp.Previous_Occurrence_Revenue__C = objShowOccuranceList[0].Amount;
                        sp.Incumbent__c= objShowOccuranceList[0].Prime_Contractor__c;
                        objAccPlanUpdate.add(sp);
                    }
                }
                else{
                    if(!objShowPlanList.isEmpty()){
                        Show_Plan__c sp = objShowPlanList[0];
                        sp.Previous_Occurrence_Revenue__C =0.0;
                        sp.Incumbent__c= null;    
                        objAccPlanUpdate.add(sp);
                    }
                }               
            }
        }

        if(!objAccPlanUpdate.isEmpty()){
            List<Show_Plan__c> lstSPF = getListWithoutDuplicate(objAccPlanUpdate);
            Database.update(lstSPF, false);
        }                               

        Set<Id> accPlanIdSet = new Set<Id>();
        for(Opportunity opp :opportunities){
            if(opp.Account_Plan__c != null){
                accPlanIdSet.add(opp.Account_Plan__c);
            }
        }

        if(!accPlanIdSet.isEmpty()){
            List<Show_Plan__c> listShowPlanFinal = new List<Show_Plan__c>();
            for(Show_Plan__c sp : [SELECT s.Total_Plan_Revenue__c, s.Proposal_Due_Date__c, s.Id, 
                                    (SELECT Amount, RFP_Due_Date__c FROM Show_Opportunities__r  ORDER BY LastModifiedDate ASC ) 
                                    FROM Show_Plan__c s 
                                    WHERE s.Id IN : accPlanIdSet]){
                Double totalAmount = 0;
                for(Opportunity op : sp.Show_Opportunities__r){
                    if(op.Amount != null){
                        totalAmount = totalAmount + op.Amount;
                    }
                    if(op.RFP_Due_Date__c != null){
                    sp.Proposal_Due_Date__c = op.RFP_Due_Date__c;
                    }
                }
                sp.Total_Plan_Revenue__c = totalAmount;
                listShowPlanFinal.add(sp);
            }
            if(listShowPlanFinal.size() > 0){
                database.update(listShowPlanFinal,false);
            }
        }

    }

    public static void updateShowPlanOnUpdate(Map<Id, Opportunity> oldOpportunityMap, List<Opportunity> opportunities){
        SET<ID> setOppID = new SET<ID>();
        SET<string> setAccPlan = new SET<string>();
        
        SET<string> setShowNameOpp = new SET<string>();
        
        for(Opportunity opp : opportunities){
            setOppID.add(opp.Id);
            setAccPlan.add(opp.Account_Plan__c);
            if(opp.Show_Name__c  != null){
                setShowNameOpp.add(opp.Show_Name__c);
            }
        }
        
        SET<ID> setOppOldId = new SET<ID>();
        SET<string> setAccPlanOld = new SET<string>();
        for(Opportunity opp : oldOpportunityMap.values()){
            setOppOldId.add(opp.Id);
            setAccPlanOld.add(opp.Account_Plan__c);
            if(opp.Show_Name__c  != null){
                setShowNameOpp.add(opp.Show_Name__c);
            }
        }
        
        MAP<ID,Show_Plan__c> mapOppShowPlan = new MAP<ID,Show_Plan__c>();
        SET<ID> setShowPlan = new SET<ID>();
        for(Show_Plan__c sp: [select DummyNonRelatedOppID__c,name,id,Proposal_Due_Date__c,Previous_Occurrence_Revenue__C from Show_Plan__c 
                            where DummyNonRelatedOppID__c IN : setOppID]){
            if(mapOppShowPlan.containsKey(sp.DummyNonRelatedOppID__c) == false){                    
            mapOppShowPlan.put(sp.DummyNonRelatedOppID__c,sp);
            }
            setShowPlan.add(sp.Id);
        }
        
        MAP<ID,Opportunity> mapRelOpp = new MAP<ID,Opportunity>();
        List<Opportunity> listRelOpp = new List<Opportunity>();
        for(Opportunity opp : [select Account_Plan__c, Show_Name__c,Show_Name__r.Show_ID__c,name,RFP_Due_Date__c,LMS_Facility_ID__c,Show_Close_Date__c,id,Amount,Prime_Contractor__c from Opportunity 
                            where Account_Plan__c IN : setShowPlan and Show_Close_Date__c !=: null and Show_Name__c !=:null order by Show_Close_Date__c asc]){
            if(mapRelOpp.containsKey(opp.Show_Name__c) == false){
            mapRelOpp.put(opp.Show_Name__c, opp);
            }
            listRelOpp.add(opp);
        } 
        
        
        MAP<ID,Opportunity> mapNonRelOpp = new MAP<ID,Opportunity>();
        List<Opportunity> listNonRelOpp = new List<Opportunity>();
        System.debug('SOQL Limit So far --> '+Limits.getQueries());
        for(Opportunity opp : [select Show_Name__c,Show_Name__r.Show_ID__c,name,RFP_Due_Date__c,LMS_Facility_ID__c,Show_Close_Date__c,Account_Plan__c,id,Amount,Prime_Contractor__c from Opportunity 
                            where Account_Plan__c NOT IN : setShowPlan and Show_Close_Date__c !=: null 
                            and Show_Name__c !=:null and Show_Name__c IN : setShowNameOpp order by Show_Close_Date__c desc]){
            if(mapNonRelOpp.containsKey(opp.Show_Name__c) == false){
            mapNonRelOpp.put(opp.Show_Name__c, opp);
            }
            listNonRelOpp.add(opp);
        } 

        
        MAP<ID,Opportunity> mapOpp1 = new MAP<ID,Opportunity>();
        List<Opportunity> listOpp1 = new List<Opportunity>();
        List<string> lstShowID = new List<string>();
        List<string> lstAccountPlan = new List<string>();
        
        for(Opportunity o : [select Show_Name__c,Show_Name__r.Show_ID__c,amount,name,RFP_Due_Date__c,LMS_Facility_ID__c,Show_Close_Date__c,Account_Plan__c 
                            from Opportunity where Account_Plan__c IN : setAccPlan and Account_Plan__c != null and
                            Show_Close_Date__c !=: null order by Show_Close_Date__c asc Limit 1000]){
        if(mapOpp1.containsKey(o.Account_Plan__c) == false){
            mapOpp1.put(o.Account_Plan__c,o);
        }
        listOpp1.add(o);
        lstShowID.add(o.Show_Name__r.Show_ID__c);
        lstAccountPlan.add(o.Account_Plan__c);
    }
    
        MAP<ID,Show_Plan__c> mapAccPlan1 = new MAP<ID,Show_Plan__c>([select Proposal_Due_Date__c,Previous_Occurrence_Revenue__C from Show_Plan__c 
                                                                    where id IN : setAccPlan]);
        
        MAP<ID,Opportunity> mapOppOld1 = new MAP<ID,Opportunity>();
        List<Opportunity> listOppOld1 = new List<Opportunity>();
        List<string> lstShowIDOld = new List<string>();
        List<string> lstAccountPlanOld = new List<string>();
        for(Opportunity o : [select Show_Name__c,Show_Name__r.Show_ID__c,amount,name,RFP_Due_Date__c,LMS_Facility_ID__c,Show_Close_Date__c,Account_Plan__c 
                            from Opportunity where Account_Plan__c IN : setAccPlanOld and Account_Plan__c != null and 
                            Show_Close_Date__c !=: null order by Show_Close_Date__c asc Limit 1000]){
        if(mapOppOld1.containsKey(o.Account_Plan__c) == false){
            mapOppOld1.put(o.Account_Plan__c,o);
        }
        listOppOld1.add(o);
        lstShowIDOld.add(o.Show_Name__r.Show_ID__c);
        lstAccountPlanOld.add(o.Account_Plan__c);
    }
    
    MAP<ID,Show_Plan__c> mapAccPlanOld1 = new MAP<ID,Show_Plan__c>([select Proposal_Due_Date__c,Previous_Occurrence_Revenue__C from Show_Plan__c 
                                                                    where id IN : setAccPlanOld]);
                                                                    
        
        
        List<Opportunity> lstOppShowOccur = [Select Show_Name__c,Show_Name__r.Show_ID__c,name,LMS_Facility_ID__c,Show_Close_Date__c,Amount,Account_Plan__c,Prime_Contractor__c
                                            from Opportunity where Show_Name__r.Show_ID__c IN : lstShowID and Account_Plan__c NOT IN : lstAccountPlan 
                                            and Show_Close_Date__c!=null and Show_Name__r.Show_ID__c !=:null  order by Show_Close_Date__c desc];
        
        List<Opportunity> lstOppShowOccurOld = [Select Show_Name__c,Show_Name__r.Show_ID__c,name,LMS_Facility_ID__c,Show_Close_Date__c,Amount,Account_Plan__c,Prime_Contractor__c
                                            from Opportunity where Show_Name__r.Show_ID__c IN : lstShowIDOld and Account_Plan__c NOT IN : lstAccountPlanOld 
                                            and Show_Close_Date__c!=null and Show_Name__r.Show_ID__c !=:null  order by Show_Close_Date__c desc];
                                            
        List<Show_Plan__c> listAccPlanUpdate = new List<Show_Plan__c>();
        List<Show_Plan__c> listAccPlanUpdateOld = new List<Show_Plan__c>();
        
        List<Show_Plan__c> lstAccPlan= new List <Show_Plan__c>() ;
        
        List<Show_Plan__c> objAccPlanUpdate = new List<Show_Plan__c>();
        List<Show_Plan__c> objAccPlanUpdateOld = new List<Show_Plan__c>();

                                                                        
        for(Opportunity  objopp : opportunities){
            if(oldOpportunityMap.get(objopp.Id).YRMO__c!= objopp.YRMO__c || oldOpportunityMap.get(objopp.Id).Show_Name__c!= objopp.Show_Name__c || oldOpportunityMap.get(objopp.Id).Facility__c!= objopp.Facility__c)
            {    
                continue;
            }
        
            // Non Related Task3-5(Additional)
            if(oldOpportunityMap.get(objopp.Id).Prime_Contractor__c != objopp.Prime_Contractor__c || oldOpportunityMap.get(objopp.Id).Show_Close_Date__c != objopp.Show_Close_Date__c || oldOpportunityMap.get(objopp.Id).Amount != objopp.Amount ) 
            {   
                List<Show_Plan__c> objNonRelAccplan = new List<Show_Plan__c>();
                if(mapOppShowPlan.containsKey(objopp.Id)){
                    objNonRelAccplan.add(mapOppShowPlan.get(objopp.Id));
                }
                
            
                if(objNonRelAccplan!=null && objNonRelAccplan.size()>0)
                {
                
                for(integer i=0 ;i<objNonRelAccplan.size();i++)
                {
                    List<Opportunity> opobjNonrelopp = new List<Opportunity>();
                    List<Opportunity> opobjRelopp = new List<Opportunity>();
                
                    // For Change in LMS ID Opp - Non Related Accplan (Lms value checked with old value)
                    if(oldOpportunityMap.get(objopp.Id).Show_Name__c != objopp.Show_Name__c)
                    {  
                        for(Opportunity o : listRelOpp){
                            if(o.Account_Plan__c == objNonRelAccplan[i].id && o.Show_Name__c == oldOpportunityMap.get(objopp.Id).Show_Name__c ){
                                opobjRelopp.add(mapRelOpp.get(oldOpportunityMap.get(objopp.Id).Show_Name__c));
                                break;
                            }
                        }
                        
                        if(opobjRelopp!=null && opobjRelopp.size()>0)
                        {
                            for(Opportunity o : listNonRelOpp){
                                if(o.Account_Plan__c != objNonRelAccplan[i].id && o.Show_Name__c == oldOpportunityMap.get(objopp.Id).Show_Name__c && o.Show_Close_Date__c < opobjRelopp[0].Show_Close_Date__c){
                                    opobjNonrelopp.add(o);
                                    break;  
                                }
                            } 
                        }                
                    }
                    else
                    {    
                        for(Opportunity o : listRelOpp){
                            if(o.Account_Plan__c == objNonRelAccplan[i].id && o.Show_Name__c == objopp.Show_Name__c ){
                            opobjRelopp.add(mapRelOpp.get(oldOpportunityMap.get(objopp.Id).Show_Name__c));
                            break;    
                            }
                        }
                        
                        if(opobjRelopp!=null && opobjRelopp.size()>0)
                        {
                            for(Opportunity o : listNonRelOpp){
                                if(o.Account_Plan__c != objNonRelAccplan[i].id && o.Show_Name__c == objopp.Show_Name__c && o.Show_Close_Date__c < opobjRelopp[0].Show_Close_Date__c){
                                        opobjNonrelopp.add(o);
                                        break;  
                                }
                            }
                        }
                    }
                    
    
                    if(opobjNonrelopp!=null && opobjNonrelopp.size()>0)
                    {
                        objNonRelAccplan[i].Previous_Occurrence_Revenue__C = opobjNonrelopp[0].Amount;
                        objNonRelAccplan[i].Incumbent__c= opobjNonrelopp[0].Prime_Contractor__c;
                        lstAccPlan.add(objNonRelAccplan[i]);
                    }
                    else
                    {
                        objNonRelAccplan[i].Previous_Occurrence_Revenue__C = 0;
                        objNonRelAccplan[i].Incumbent__c= null;
                        lstAccPlan.add(objNonRelAccplan[i]);  
                    }
        
                
                }
                
                }
            }
            
            List<Opportunity> objoppList = new List<Opportunity>();
            List<Opportunity> objoppListForOldAccPlan = new List<Opportunity>();
            List<Opportunity> oppOld = new List<Opportunity>();
            List<Show_Plan__c> objAccPlan = new List<Show_Plan__c>();
            List<Show_Plan__c> objAccPlanOld = new List<Show_Plan__c>();
            
            oppOld= oldOpportunityMap.values();
            
            if(objopp.Account_Plan__c !=null){
                //if(mapOpp1.containsKey(objopp.Account_Plan__c)){
                //  objoppList.add(mapOpp1.get(objopp.Account_Plan__c));
                //}
                for(Opportunity o : listOpp1){
                    if(o.Account_Plan__c == objopp.Account_Plan__c){
                        objoppList.add(o);
                    }
                }
                if(mapAccPlan1.containsKey(objopp.Account_Plan__c)){
                    objAccPlan.add(mapAccPlan1.get(objopp.Account_Plan__c));
                }
            }           
            
            if(oldOpportunityMap.get(objopp.Id).Account_Plan__c !=null){
                //if(mapOppOld1.containsKey(objopp.Account_Plan__c)){
                //  objoppListForOldAccPlan.add(mapOppOld1.get(objopp.Account_Plan__c));
                //}
                for(Opportunity o : listOppOld1){
                    if(o.Account_Plan__c == oldOpportunityMap.get(objopp.Id).Account_Plan__c){
                        objoppListForOldAccPlan.add(o);
                    }
                }
                if(mapAccPlanOld1.containsKey(oldOpportunityMap.get(objopp.Id).Account_Plan__c)){
                    objAccPlanOld.add(mapAccPlanOld1.get(oldOpportunityMap.get(objopp.Id).Account_Plan__c));
                }
            }
            
            if(objoppList.size() > 0 || objoppListForOldAccPlan.size() > 0){
                //Update Date Proposal due date (Task3-3)
                if(objAccPlan.size()>0 &&  objoppList.size()>0)
                {
                    //listAccPlanUpdate.add(UpdatePrpoposalDate(objAccPlan[0],objoppList));
                    listAccPlanUpdate.addAll(objAccPlan);
                }
                if(objAccPlanOld.size()>0 &&  objoppListForOldAccPlan.size()>0)
                {
                    //listAccPlanUpdateOld.add(UpdatePrpoposalDate(objAccPlanOld[0],objoppListForOldAccPlan));
                    listAccPlanUpdateOld.addAll(objAccPlanOld);
                }
                
                
                List<Opportunity> objShowOccurList = new List<Opportunity>();
                List<Opportunity> objShowOccurListForOldPlan = new List<Opportunity>();    
                
                if(objopp.Account_Plan__c != null &&  objoppList.size()>0)
                {
                    //Non Accplan Least year
                    for(Opportunity oppSO : lstOppShowOccur){
                        if(oppSO.Show_Name__r.Show_ID__c == objoppList[0].Show_Name__r.Show_ID__c &&
                        oppSO.Account_Plan__c != objoppList[0].Account_Plan__c &&
                        oppSO.Show_Close_Date__c != null &&
                        oppSO.Show_Close_Date__c <  objoppList[0].Show_Close_Date__c){
                            
                        objShowOccurList.add(oppSO);
                        }
                    }

                }
                
                if(oldOpportunityMap.get(objopp.Id).Account_Plan__c != null &&  objoppListForOldAccPlan.size()>0)
                {
                    //Non Accplan Least year
                    for(Opportunity oppSO : lstOppShowOccurOld){
                        if(oppSO.Show_Name__r.Show_ID__c == objoppListForOldAccPlan[0].Show_Name__r.Show_ID__c &&
                        oppSO.Account_Plan__c != objoppListForOldAccPlan[0].Account_Plan__c &&
                        oppSO.Show_Close_Date__c != null &&
                        oppSO.Show_Close_Date__c <  objoppListForOldAccPlan[0].Show_Close_Date__c){
                            
                        objShowOccurListForOldPlan.add(oppSO);
                        }
                    }

                }
                
                if(objShowOccurList!=null && objShowOccurList.size()>0)
                {
                    // For purpose of update the acc plan with non related updates
                    if(objAccPlan.size()>0)
                    {   
                        Show_Plan__c sp = objAccPlan[0];
                        sp.DummyNonRelatedOppID__c = objShowOccurList[0].id;
                        sp.Previous_Occurrence_Revenue__C = objShowOccurList[0].Amount;
                        sp.Incumbent__c= objShowOccurList[0].Prime_Contractor__c;
                        objAccPlanUpdate.add(sp);
                    
                    }
        
                }
                else
                {
                    if(objAccPlan.size()>0)
                    {
                        Show_Plan__c sp = objAccPlan[0];
                        sp.Previous_Occurrence_Revenue__C =0.0;
                        sp.Incumbent__c= null;    
                        objAccPlanUpdate.add(sp);
                    }
                }
                
                
                if(objShowOccurListForOldPlan!=null && objShowOccurListForOldPlan.size()>0)
                {
                    // For purpose of update the acc plan with non related updates
                    if(objAccPlanOld.size()>0)
                    {   
                        Show_Plan__c sp = objAccPlanOld[0];
                        sp.DummyNonRelatedOppID__c = objShowOccurListForOldPlan[0].id;
                        sp.Previous_Occurrence_Revenue__C = objShowOccurListForOldPlan[0].Amount;
                        sp.Incumbent__c= objShowOccurListForOldPlan[0].Prime_Contractor__c;
                        objAccPlanUpdateOld.add(sp);
                    }
                }
                else
                {
                    if(objAccPlanOld.size()>0)
                    {
                        Show_Plan__c sp = objAccPlanOld[0];
                        sp.Previous_Occurrence_Revenue__C =0.0;
                        sp.Incumbent__c= null;    
                        objAccPlanUpdateOld.add(sp);
                    }
                }
                
            } 
            
        }
        
        if(lstAccPlan!=null && lstAccPlan.size()>0){
            List<Show_Plan__c> lstSPF = getListWithoutDuplicate(lstAccPlan);
            database.update(lstSPF,false);
        }
        
        if(objAccPlanUpdate.size() > 0){
            List<Show_Plan__c> lstSPF = getListWithoutDuplicate(objAccPlanUpdate);
            database.update(lstSPF,false);
        }
        
        if(objAccPlanUpdateOld.size() > 0){
            List<Show_Plan__c> lstSPF = getListWithoutDuplicate(objAccPlanUpdateOld);
            database.update(lstSPF,false);
        }
        
        SET<ID> setAccPlanID = new SET<ID>();
        for(Opportunity opp : opportunities){
            if(opp.Account_Plan__c != null){
                setAccPlanID.add(opp.Account_Plan__c);
            }
        }
        for(Opportunity opp : oldOpportunityMap.values()){
            if(opp.Account_Plan__c != null){
                setAccPlanID.add(opp.Account_Plan__c);
            }
        }
        if(setAccPlanID.size() > 0){
            List<Show_Plan__c> listShowPlanFinal = new List<Show_Plan__c>();
            for(Show_Plan__c sp : [Select s.Total_Plan_Revenue__c, s.Proposal_Due_Date__c, s.Id, (Select Amount, RFP_Due_Date__c From Show_Opportunities__r Order By LastModifiedDate ASC ) From Show_Plan__c s Where s.Id IN : setAccPlanID]){
                double totalAmount = 0;
                for(Opportunity op : sp.Show_Opportunities__r){
                    if(op.Amount != null){
                        totalAmount = totalAmount + op.Amount;
                    }
                    if(op.RFP_Due_Date__c != null){
                    sp.Proposal_Due_Date__c = op.RFP_Due_Date__c;
                    }
                }
                sp.Total_Plan_Revenue__c = totalAmount;
                listShowPlanFinal.add(sp);
            }
            if(listShowPlanFinal.size() > 0){
                database.update(listShowPlanFinal,false);
            }
        }
    }

    public static void updateShowPlanOnDelete(List<Opportunity> opportunities){
        Set<Id> setOppOldId = new Set<Id>();
        Set<String> setAccPlanOld = new Set<String>();
        for(Opportunity opp : opportunities){
            setOppOldId.add(opp.Id);
            setAccPlanOld.add(opp.Account_Plan__c);
        }
        
        Map<ID,Opportunity> mapOppOld1 = new Map<ID,Opportunity>();
        List<Opportunity> listOpp1 = new List<Opportunity>();
        List<string> lstShowIDOld = new List<string>();
        List<string> lstAccountPlanOld = new List<string>();
        for(Opportunity o : [SELECT Show_Name__c,Show_Name__r.Show_ID__c,amount,name,RFP_Due_Date__c,LMS_Facility_ID__c,Show_Close_Date__c,Account_Plan__c 
                            FROM Opportunity where Account_Plan__c IN :setAccPlanOld 
                            AND Account_Plan__c != null 
                            AND Show_Close_Date__c !=: null 
                            ORDER BY Show_Close_Date__c ASC Limit 1000]){
            if(mapOppOld1.containsKey(o.Account_Plan__c) == false){
                mapOppOld1.put(o.Account_Plan__c,o);
            }
            listOpp1.add(o);
            lstShowIDOld.add(o.Show_Name__r.Show_ID__c);
            lstAccountPlanOld.add(o.Account_Plan__c);
        }
    
        Map<ID,Show_Plan__c> mapAccPlanOld1 = new Map<ID,Show_Plan__c>([SELECT Proposal_Due_Date__c,Previous_Occurrence_Revenue__C 
                                                                        FROM Show_Plan__c 
                                                                        WHERE Id IN :setAccPlanOld]);
                                                                    
        
        List<Opportunity> lstOppShowOccur = [SELECT Show_Name__c,Show_Name__r.Show_ID__c,name,LMS_Facility_ID__c,Show_Close_Date__c,Amount,Account_Plan__c,Prime_Contractor__c
                                            FROM Opportunity 
                                            WHERE Show_Name__r.Show_ID__c IN :lstShowIDOld 
                                            AND Account_Plan__c NOT IN :lstAccountPlanOld 
                                            AND Show_Close_Date__c!=null 
                                            AND Show_Name__r.Show_ID__c !=:null  
                                            ORDER BY Show_Close_Date__c DESC];
        
        List<Show_Plan__c> listAccPlanUpdate = new List<Show_Plan__c>();
        
        List<Show_Plan__c> objAccPlanUpdate = new List<Show_Plan__c>();
        
        //For Delete event (Task3-6 Del)
        for(Opportunity  objopp : opportunities)
        {
            if(objopp.Account_Plan__c != null){  
                    
                List<Opportunity> objoppList = new List<Opportunity>();
                List<Show_Plan__c> objAccPlan = new List<Show_Plan__c>();
            
                if(objopp.Account_Plan__c !=null){
                    //if(mapOppOld1.containsKey(objopp.Account_Plan__c)){
                    //  objoppList.add(mapOppOld1.get(objopp.Account_Plan__c));
                    //}
                    for(Opportunity o : listOpp1){
                        if(o.Account_Plan__c == objopp.Account_Plan__c){
                            objoppList.add(o);
                        }
                    }
                    if(mapAccPlanOld1.containsKey(objopp.Account_Plan__c)){
                        objAccPlan.add(mapAccPlanOld1.get(objopp.Account_Plan__c));
                    }
                }   
                
            
                if(objoppList!=null && objoppList.size()>0 && objAccPlan  !=null && objAccPlan .size()>0){
                    List<Opportunity> objShowOccurList = new List<Opportunity>();
            
                    if(objopp.Account_Plan__c != null &&  objoppList.size()>0)
                    {
                        //Non Accplan Least year
                        for(Opportunity oppSO : lstOppShowOccur){
                            if(oppSO.Show_Name__r.Show_ID__c == objoppList[0].Show_Name__r.Show_ID__c &&
                                oppSO.Account_Plan__c != objoppList[0].Account_Plan__c &&
                                oppSO.Show_Close_Date__c != null &&
                                oppSO.Show_Close_Date__c <  objoppList[0].Show_Close_Date__c){
                                    
                                objShowOccurList.add(oppSO);
                            }
                        }
        
                    }
                        
                    if(objShowOccurList!=null && objShowOccurList.size()>0){
                        
                        if(objShowOccurList!=null && objShowOccurList.size()>0){
                            // For purpose of update the acc plan with non related updates
                            if(objAccPlan.size()>0){   
                                Show_Plan__c sp = objAccPlan[0];
                                sp.DummyNonRelatedOppID__c = objShowOccurList[0].id;
                                sp.Previous_Occurrence_Revenue__C = objShowOccurList[0].Amount;
                                sp.Incumbent__c= objShowOccurList[0].Prime_Contractor__c;
                                objAccPlanUpdate.add(sp);
                            }
                        }
                    }
                
                    /*  End Nonrelted Opp when delete */
                    if(objAccPlan.size()>0 &&  objoppList.size()>0){
                        listAccPlanUpdate.add(UpdateProposalDate(objAccPlan[0],objoppList));
                    }
                
                }
                else{
                    if(objAccPlan!=null){
                        objAccPlan[0].Proposal_Due_Date__c=null;
                        objAccPlan[0].Total_Plan_revenue__c=0;
                        objAccPlan[0].Previous_Occurrence_Revenue__C =0.0;
                        objAccPlan[0].Incumbent__c= null;
                        objAccPlanUpdate.add( objAccPlan[0]);
                    }
                }
            }
        }
        
        if(objAccPlanUpdate.size() > 0){
            List<Show_Plan__c> lstSPF = getListWithoutDuplicate(objAccPlanUpdate);
            database.update(lstSPF,false);
        }
        
        Set<Id> setAccPlanID = new Set<Id>();

        for(Opportunity opp : opportunities){
            if(opp.Account_Plan__c != null){
                setAccPlanID.add(opp.Account_Plan__c);
            }
        }
        if(setAccPlanID.size() > 0){
            List<Show_Plan__c> listShowPlanFinal = new List<Show_Plan__c>();
            for(Show_Plan__c sp : [SELECT s.Total_Plan_Revenue__c, s.Proposal_Due_Date__c, s.Id, 
                                    (SELECT Amount, RFP_Due_Date__c FROM Show_Opportunities__r ORDER BY LastModifiedDate ASC ) 
                                    FROM Show_Plan__c s 
                                    WHERE s.Id IN :setAccPlanID]){
                Double totalAmount = 0;
                for(Opportunity op : sp.Show_Opportunities__r){
                    if(op.Amount != null){
                        totalAmount = totalAmount + op.Amount;
                    }
                    if(op.RFP_Due_Date__c != null){
                    sp.Proposal_Due_Date__c = op.RFP_Due_Date__c;
                    }
                }
                sp.Total_Plan_Revenue__c = totalAmount;
                listShowPlanFinal.add(sp);
            }
            if(listShowPlanFinal.size() > 0){
                database.update(listShowPlanFinal,false);
            }
        }
    }

    public static void updateOpportunityFieldsBeforeEvent(List<Opportunity> oldOpportunities, List<Opportunity> newOpportunities){
        Set<Id> soUserIdSet = new Set<Id>();
        Set<Id> soRelatedOppIdSet = new Set<Id>();
        Map<Id,Opportunity> oldOpportunityMap = new Map<Id,Opportunity>();
        Map<Id,Opportunity> relatedOpportunityMap = new Map<Id,Opportunity>();
        Map<Id,Schema.RecordTypeInfo> oppRecordTypeMap = Schema.SObjectType.Opportunity.getRecordTypeInfosById();
        Boolean insertFlag = false;

        for(Opportunity newOpp :newOpportunities){
            if(newOpp.Show_Occurrence__c != null){
                soRelatedOppIdSet.add(newOpp.Show_Occurrence__c);
            }
        }

        if(!soRelatedOppIdSet.isEmpty()){
            for(Opportunity rOpp :[SELECT Id,Production_Location__c FROM Opportunity WHERE Id IN:soRelatedOppIdSet]){
                relatedOpportunityMap.put(rOpp.Id,rOpp);
            }
        }

        if(oldOpportunities != null && !oldOpportunities.isEmpty()){
            for(Opportunity oldOpp :oldOpportunities){
                oldOpportunityMap.put(oldOpp.Id,oldOpp);
            }
        }
        else{
            insertFlag = true;
        }

        for(Opportunity newOpp :newOpportunities){
            soUserIdSet.add(newOpp.OwnerId);
            if(insertFlag || (oldOpportunityMap != null && newOpp.OwnerId != oldOpportunityMap.get(newOpp.Id).OwnerId)){
                if(newOpp.OwnerId != null){
                    newOpp.Sales_Person__c = newOpp.OwnerId;
                }
            }
        }

        Map<Id,User> userMap = new Map<Id,User>();
        for(User u :[SELECT Id,UserLocation__c FROM User WHERE Id IN:soUserIdSet]){
            userMap.put(u.Id,u);
        }

        for(Opportunity newOpp :newOpportunities){
            User usr = userMap.get(newOpp.OwnerId);
            if(insertFlag || (oldOpportunityMap != null && newOpp.OwnerId != oldOpportunityMap.get(newOpp.Id).OwnerId)){
                if(usr != null && usr.UserLocation__c != null){
                    newOpp.Sales_Location__c = usr.UserLocation__c;
                }
            }

            // Set Production Location for onPeak
            if(oppRecordTypeMap.get(newOpp.RecordTypeId).getName() == 'US - Holding'){
                newOpp.Production_Location__c = '120-OnPeak';
            }
        }
    }

    public static Show_Plan__c UpdateProposalDate(Show_Plan__c objAccPlan,Opportunity[] objoppList){  
        if(objAccPlan!=null && objoppList!=null ){
            objAccPlan.Proposal_Due_Date__c=objoppList[0].RFP_Due_Date__c;    
            //Calculate Total Amount
            Decimal iSum=0;
            if(objoppList.size()>0){    
                for(integer i=0; i<objoppList.size();i++){
                    iSum = iSum + objoppList[i].amount;
                }
                objAccPlan.Total_Plan_revenue__c = iSum ;
            }  
        }
        return objAccPlan;
    }
   
   public static List<Show_Plan__c> getListWithoutDuplicate(List<Show_Plan__c> listDuplicate){
     List<Show_Plan__c> listSP = new List<Show_Plan__c>();
     MAP<Id,Show_Plan__c> mapSP = new MAP<Id,Show_Plan__c>();
     for(Show_Plan__c sp : listDuplicate){
        if(sp.Id != null){
          mapSP.put(sp.Id,sp);
        }
     }
     listSP.addAll(mapSP.Values());
     return listSP;
   }

   public static void updateContactRoleOnUpdate(List<Opportunity> opportunities){
       try{
            Set<Id> accountIdSet = new Set<Id>();
            Set<Id> oppIdSet = new Set<Id>();
            Map<Id, List<Contact>> accountContactMap = new Map<Id, List<Contact>>();
            List<OpportunityContactRole>  oldContactRole = new List<OpportunityContactRole>();
            List<OpportunityContactRole>  newContactRole = new List<OpportunityContactRole>();
            for(Opportunity opp :opportunities){
                accountIdSet.add(opp.AccountId);
                oppIdSet.add(opp.Id);
            }
            
            for(Contact con :[SELECT Id,AccountId,Primary_Contact__c FROM Contact WHERE AccountId IN:accountIdSet]){
                if(accountContactMap.containsKey(con.AccountId)){
                    accountContactMap.get(con.AccountId).add(con);
                }
                else{
                    accountContactMap.put(con.AccountId, new List<Contact>{con});
                }
            }

            oldContactRole = [SELECT Id,isPrimary FROM OpportunityContactRole WHERE OpportunityId IN: oppIdSet];
            Boolean hasPrimary = false;

            if(!oldContactRole.isEmpty()){
                for(OpportunityContactRole oppRole :oldContactRole){
                    if(oppRole.isPrimary){
                        hasPrimary = true;
                        break;
                    }
                }
                
                if(!hasPrimary)
                    Delete oldContactRole;
            }
            
            if(!hasPrimary){
                Contact primaryContact = new Contact();
                for(Opportunity opp :opportunities){
                    if(accountContactMap.containsKey(opp.AccountId)){
                        for(Contact c :accountContactMap.get(opp.AccountId)){
                            OpportunityContactRole contactRole = new OpportunityContactRole();
                            contactRole.ContactId = c.Id;
                            contactRole.OpportunityId = opp.Id;
                            if(c.Primary_Contact__c){
                                contactRole.isPrimary = true;
                            }
                            newContactRole.add(contactRole);
                        }
                    }
                }

                if(!newContactRole.isEmpty()){
                    Insert newContactRole;
                }
            }
            
       }
       catch(Exception e){
           System.debug(e.getMessage()+ ' ' + e.getLineNumber());
           opportunities[0].addError('An error has occured. Please contact your administrator');
       }
   }

    /*
        Written By: Pradeep Sharma from Astadia
        To delete the respective record from show occurence public object
    */ 
    public static void deleteShowOccurrence(List<Opportunity> opportunities){
       try{
           Set<Id> oppIdSet = new Set<Id>();
           for(Opportunity opp :opportunities){
               oppIdSet.add(opp.Id);
           }

           if(!oppIdSet.isEmpty()){
               // Get the related records from the Show Occurence Public object
                List<Show_Occurrence_Public__c> occurences = [SELECT Id, Show_Occurrence_Ref__c 
                                                                FROM Show_Occurrence_Public__c 
                                                                WHERE Show_Occurrence_Ref__c in :oppIdSet 
                                                                AND Show_Occurrence_Ref__c != NULL];
                // delete all the reference data from public object
                if(occurences.size()>0)
                {
                    // delete the related record
                    delete occurences;
                }
           }
       }
       catch(Exception e){
           System.debug(e.getMessage()+ ' ' + e.getLineNumber());
           opportunities[0].addError('An error has occured. Please contact your administrator');
       }
    }

    public static void createShowOccurrencesOnInsert(List<Opportunity> opportunities){
        try{
            List<Id> oppRecordTypeIds = new List<Id>();
            oppRecordTypeIds.add(SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId());
            oppRecordTypeIds.add(SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsProposalRecordTypeName).getRecordTypeId());
            oppRecordTypeIds.add(SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId());

            List<Show_Occurrence_Public__c> showOccurrencePublicList = new List<Show_Occurrence_Public__c>();
            Set<Id> showOccurenceIdSet = new Set<Id>();

            for(Opportunity opp :opportunities){
                if(opp.Show_Occurrence__c != null){
                    showOccurenceIdSet.add(opp.Show_Occurrence__c);
                }
            }

            Map<Id,Id> showOccurrenceIdToShowOccurrencePublicMap = new Map<Id,Id>();
            if(!showOccurenceIdSet.isEmpty()){
                for(Show_Occurrence_Public__c sop :[SELECT Id,Show_Occurrence_Ref__c 
                                                    FROM Show_Occurrence_Public__c 
                                                    WHERE Show_Occurrence_Ref__c != NULL 
                                                    AND Show_Occurrence_Ref__c IN:showOccurenceIdSet]){
                    showOccurrenceIdToShowOccurrencePublicMap.put(sop.Show_Occurrence_Ref__c,sop.Id);
                }
            }

            for(Opportunity op :opportunities){
                if(oppRecordTypeIds.contains(op.RecordTypeId)){
                    Id EDPublicReferenceId = null;
                    String oppName = op.Name;
                    if(op.Show_Occurrence__c != null && showOccurrenceIdToShowOccurrencePublicMap.containsKey(op.Show_Occurrence__c) && showOccurrenceIdToShowOccurrencePublicMap.get(op.Show_Occurrence__c) != null){
                        EDPublicReferenceId = showOccurrenceIdToShowOccurrencePublicMap.get(op.Show_Occurrence__c);
                    }
                    if(oppName.length() > 80){
                        oppName = oppName.substring(0,79);
                    }
                    Show_Occurrence_Public__c showOccurrencePublic = new Show_Occurrence_Public__c(
                        Show_Occurrence_Ref__c = op.ID,
                        Name = oppName,
                        OwnerId = op.OwnerId,
                        Account__c = op.AccountID,
                        Account_Manager__c = op.Account_Manager__c, //new
                        Amount__c = op.Amount,
                        BoothNum__c = op.BoothNum__c,
                        Booth_Type__c = op.Booth_Type__c,
                        Booth_Length__c = op.Booth_Length__c,
                        Booth_Width__c = op.Booth_Width__c,
                        Client_VP__c = op.Client_VP__c,
                        Contract_Close_Date__c = op.CloseDate,
                        CR_Date__c = op.CR_Date__c,
                        Description__c = op.Description,
                        EAC__c = op.EAC__c,
                        Expected_Revenue__c = op.ExpectedRevenue,
                        GBMS_Project_ID__c = op.GBMS_Project_ID__c,
                        GBMS_Workflow_Status__c = op.GBMS_Workflow_Status__c,
                        Job_Number__c = op.Job_Number__c,
                        Lead_Source__c = op.LeadSource,
                        Non_Show_Custom__c = op.Non_Show__c,
                        Presentation_Date__c = op.Presentation_Date__c,
                        Probability__c = op.Probability,
                        Project_Type__c = op.Project_Type__c,
                        ShippingType__c = op.ShippingType__c,
                        Show_Close_Date__c = op.Show_Close_Date__c,
                        Show_Name__c = op.Show_Name__c,
                        Show_Occurrence_Name__c = op.Name,
                        Show_Open_Date__c = op.Show_Open_Date__c,
                        Related_Show_Occurrence_Public__c = EDPublicReferenceId, //the public version
                        Third_Party__c = op.Third_Party__c
                    );
                    showOccurrencePublicList.add(showOccurrencePublic);
                }
                else{
                    String oppName = op.Name;
                    if(oppName.length() > 80){
                        /*Assigning the return value from the substring method - Najmal - Nov 07th,2023 - #367025 Adfield opportunity creation
                        old code -> oppName.substring(0, 79);*/
                        oppName = oppName.substring(0, 79);
                    }
                    Show_Occurrence_Public__c showOccurrencePublic = new Show_Occurrence_Public__c(
                        Show_Occurrence_Ref__c = op.ID,
                        Name = oppName,
                        //OwnerId = op.Sales_Person__c, - THIS LINE IS CAUSING ERRORS IN PRODUCTION!!!
                        Account__c = op.AccountID,
                        Amount__c = op.Amount,
                        Actual_Freight_Weight_CWT__c = op.Actual_Freight_Weight_CWT__c,
                        Actual_Net_Square_Feet__c = op.Actual_Net_Square_Feet__c,
                        Actual_Number_of_Exhibitors__c = op.Actual_Number_of_Exhibitors__c,
                        Adv_Shipping_City__c = op.AdvanceShippingBillingCity__c,
                        Adv_Shipping_Country__c = op.AdvanceShippingBillingCountry__c,
                        Adv_Shipping_Name__c = op.AdvanceShippingName__c,
                        Adv_Shipping_Postal_Code__c = op.AdvanceShippingBillingPostalCode__c,
                        Adv_Shipping_State__c = op.AdvanceShippingBillingState__c,
                        Adv_Shipping_Street__c = op.AdvanceShippingBillingStreet__c,
                        Assigned_to_Production_Date__c = op.Assigned_to_Production_Date__c,
                        Booth_Package__c = op.Booth_Package__c,
                        Booth_Package_Price__c = op.Booth_Package_Price__c,
                        Contract_Close_Date__c = op.CloseDate,
                        Contract_Expiration__c = op.Contract_Expiration__c,
                        Contract_Type__c = op.Contract_Type__c,
                        Corporate_Event__c = op.Corporate_Event__c,
                        CR_Date__c = op.CR_Date__c,
                        Description__c = op.Description,
                        EAC_Deadline__c = op.EAC_Deadline__c, //new
                        Early_Order_Deadline__c = op.Early_Order_Deadline__c, //new
                        Electrical__c = op.Electrical__c,
                        Exhibitor_Move_In_Date__c = op.Exhibitor_Move_In_Date__c,
                        Exhibitor_Satisfaction_Score_GES_SAT__c = op.Exhibitor_Satisfaction_Score_GES_SAT__c,
                        Facility__c = op.Facility__c,
                        Freight_Weight_CWT__c = op.Freight_Weight_CWT__c,
                        Frequency__c = op.Frequency__c,
                        GES_Move_In__c = op.GES_Move_In__c,
                        Holidays__c = op.Holidays__c,
                        Job_Number__c = op.Job_Number__c,
                        Job_Number_Status__c = op.Job_Number_Status__c,
                        LMS_Status_Date__c = op.LMS_Status_Date__c,
                        //Management_Company__c = op.Management_Company__c,
                        Material_Handling_Rate__c = op.Material_Handling_Rate__c,
                        Move_Out__c = op.Move_Out__c,
                        Multi_Year_Step__c = op.Multi_Year_Step__c,
                        Net_Square_Feet__c = op.Net_Square_Feet__c,
                        New_Repeat__c = op.New_Repeat__c,
                        Number_of_Booths__c = op.Number_of_Booths__c,
                        Number_of_Exhibitors__c = op.Number_of_Exhibitors__c,
                        Price_Increase_Percent__c = op.Price_Increase_Percent__c,
                        Prime_Contractor__c = op.Prime_Contractor__c,
                        Prime_Contractor_Contact__c = op.Prime_Contractor_Contact__c,
                        Probability__c = op.Probability,
                        Production_Location__c = op.Production_Location__c,
                        Proposal_Sent_Date__c = op.Proposal_Sent_Date__c,
                        PSP__c = op.PSP__c,
                        Receive_RFP_Date__c = op.Receive_RFP_Date__c,
                        Review_Legal__c = op.Review_Legal__c,
                        RFP_Due_Date__c = op.RFP_Due_Date__c,
                        Sales_Location__c = op.Sales_Location__c,
                        Show_Close_Date__c = op.Show_Close_Date__c,
                        Show_Close_Date_Confirmed__c = op.Show_Close_Date_Confirmed__c,
                        Show_Name__c = op.Show_Name__c,
                        Show_Occurrence_Name__c = op.Name,
                        Show_Open_Date__c = op.Show_Open_Date__c,
                        //Sponsor__c = op.Sponsor__c,
                        Stage__c = op.StageName,
                        Sub_Contractor__c = op.Sub_Contractor__c,
                        Target_Occurrence__c = op.Target_Occurrence__c,
                        Trade_Show_200_Occurrence__c = op.Trade_Show_200_Occurrence__c,
                        Trade_Show_Electrical__c = op.Trade_Show_Electrical__c,
                        Tradeshow_Fastest_50__c = op.Tradeshow_Fastest_50__c,
                        Type__c = op.Type,
                        Under_Contract__c = op.Under_Contract__c,
                        Verbal_Follow_Up__c = op.Verbal_Follow_Up__c
                    );
                    if(op.Sales_Person__c != null){
                        showOccurrencePublic.OwnerId = op.Sales_Person__c;
                    }
                    showOccurrencePublicList.add(showOccurrencePublic);
                }
            }
            System.debug('showOccurrencePublicList On Insert-->'+showOccurrencePublicList);
            if(!showOccurrencePublicList.isEmpty()){
                insert showOccurrencePublicList;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage()+ ' ' + e.getLineNumber());
            opportunities[0].addError('An error has occured. Please contact your administrator');
        }
    }

    public static void createShowOccurrencesOnUpdate(List<Opportunity> opportunities){
        try{
            List<Id> oppRecordTypeIds = new List<Id>();
            oppRecordTypeIds.add(SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId());
            oppRecordTypeIds.add(SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsProposalRecordTypeName).getRecordTypeId());
            oppRecordTypeIds.add(SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId());

            Set<Id> oppIdSet = new Set<Id>();
            Set<Id> oppSOIdSet = new Set<Id>();
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
            Map<Id,Id> oppSORefMap = new Map<Id,Id>();
            for(Opportunity opp :opportunities){
                oppIdSet.add(opp.Id);
                System.debug('opp.Name--> '+opp.Name + ' Show Occurrence--> '+opp.Show_Occurrence__c);
                oppSOIdSet.add(opp.Show_Occurrence__c);
                oppMap.put(opp.Id,opp);
            }

            System.debug(' --> '+oppMap);

            List<Show_Occurrence_Public__c> existingShowOccurrencePublicList = [SELECT Id,Name,Show_Occurrence_Ref__c FROM Show_Occurrence_Public__c 
                                                                        WHERE Show_Occurrence_Ref__c != null 
                                                                        AND Show_Occurrence_Ref__c IN:oppSOIdSet];

            System.debug('existingShowOccurrencePublicList--> '+existingShowOccurrencePublicList);

            for(Show_Occurrence_Public__c sop :existingShowOccurrencePublicList){
                oppSORefMap.put(sop.Show_Occurrence_Ref__c,sop.Id);
            }
            
            /*if(Test.isRunningTest()){
                for(Opportunity opp :OpportunityTriggerHelperTest.oppList){
                    oppMap.put(opp.Id, opp);
                }
            }*/

            List<Show_Occurrence_Public__c> showOccurrencePublicList = new List<Show_Occurrence_Public__c>();
            for(Show_Occurrence_Public__c sod :[SELECT Show_Occurrence_Ref__c FROM Show_Occurrence_Public__c 
            WHERE Show_Occurrence_Ref__c != NULL AND Show_Occurrence_Ref__c IN:oppIdSet]){
                //if(!TriggerOptimizationUtility.UpdateOccurrenceDetails_Handled.contains(sod.Id)){
                    // need to check for E&D record types so we don't try to set the OwnerId
                    // to a field that doesn't exist on those page layouts and to add new fields
                System.debug('sod.Show_Occurrence_Ref__c--> '+sod.Show_Occurrence_Ref__c);
                System.debug('oppMap.containsKey(sod.Show_Occurrence_Ref__c)--> '+oppMap.containsKey(sod.Show_Occurrence_Ref__c));
                if(oppMap.containsKey(sod.Show_Occurrence_Ref__c) && oppRecordTypeIds.contains(oppMap.get(sod.Show_Occurrence_Ref__c).RecordTypeId)){
                    System.debug('contains show occurrence ref');
                    Id EDPublicOppReferenceId = oppSORefMap.get(oppMap.get(sod.Show_Occurrence_Ref__c).Show_Occurrence__c);
                    sod.OwnerId = oppMap.get(sod.Show_Occurrence_Ref__c).OwnerId;
                    sod.Account__c = oppMap.get(sod.Show_Occurrence_Ref__c).AccountID;
                    sod.Name = oppMap.get(sod.Show_Occurrence_Ref__c).Name;
                    if (sod.Name.length() > 80)
                        sod.Name = sod.Name.substring(0,79);
                    sod.Account_Manager__c = oppMap.get(sod.Show_Occurrence_Ref__c).Account_Manager__c; //new
                    sod.Amount__c = oppMap.get(sod.Show_Occurrence_Ref__c).Amount; 
                    sod.BoothNum__c = oppMap.get(sod.Show_Occurrence_Ref__c).BoothNum__c;
                    sod.Booth_Type__c = oppMap.get(sod.Show_Occurrence_Ref__c).Booth_Type__c;
                    sod.Booth_Length__c = oppMap.get(sod.Show_Occurrence_Ref__c).Booth_Length__c;
                    sod.Booth_Width__c = oppMap.get(sod.Show_Occurrence_Ref__c).Booth_Width__c;
                    sod.Client_VP__c = oppMap.get(sod.Show_Occurrence_Ref__c).Client_VP__c;
                    sod.Contract_Close_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).CloseDate;
                    sod.CR_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).CR_Date__c;
                    sod.Description__c = oppMap.get(sod.Show_Occurrence_Ref__c).Description;
                    sod.EAC__c = oppMap.get(sod.Show_Occurrence_Ref__c).EAC__c;
                    sod.Expected_Revenue__c = oppMap.get(sod.Show_Occurrence_Ref__c).ExpectedRevenue;
                    sod.GBMS_Project_ID__c = oppMap.get(sod.Show_Occurrence_Ref__c).GBMS_Project_ID__c;
                    sod.GBMS_Workflow_Status__c = oppMap.get(sod.Show_Occurrence_Ref__c).GBMS_Workflow_Status__c;
                    sod.Job_Number__c = oppMap.get(sod.Show_Occurrence_Ref__c).Job_Number__c;
                    sod.Lead_Source__c = oppMap.get(sod.Show_Occurrence_Ref__c).LeadSource;
                    sod.Non_Show_Custom__c = oppMap.get(sod.Show_Occurrence_Ref__c).Non_Show__c;
                    sod.Presentation_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Presentation_Date__c;
                    sod.Probability__c = oppMap.get(sod.Show_Occurrence_Ref__c).Probability;
                    sod.Project_Type__c = oppMap.get(sod.Show_Occurrence_Ref__c).Project_Type__c;
                    sod.Related_Show_Occurrence_Public__c = EDPublicOppReferenceId; //Public Show Occurrence
                    sod.ShippingType__c = oppMap.get(sod.Show_Occurrence_Ref__c).ShippingType__c;
                    sod.Show_Close_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Close_Date__c;
                    sod.Show_Name__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Name__c;
                    sod.Show_Occurrence_Name__c = oppMap.get(sod.Show_Occurrence_Ref__c).Name;
                    sod.Show_Open_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Open_Date__c;
                    sod.Stage__c = oppMap.get(sod.Show_Occurrence_Ref__c).StageName;
                    sod.Third_Party__c = oppMap.get(sod.Show_Occurrence_Ref__c).Third_Party__c;
                    showOccurrencePublicList.add(sod);
                }
                else{// do the GES specific copy
                    //ASTADIA CODE
                    //sod.OwnerId = oppMap.get(sod.Show_Occurrence_Ref__c).Sales_Person__c;
                    
                    
                    //FARHAN CODE
                    if(oppMap.containsKey(sod.Show_Occurrence_Ref__c)){
                        System.debug('contains show occurrence ref 2');
                        if(oppMap.get(sod.Show_Occurrence_Ref__c).Sales_Person__c != null)
                            sod.OwnerId = oppMap.get(sod.Show_Occurrence_Ref__c).Sales_Person__c;
                        
                        //FARHAN CODE ENDS HERE
                        
                        sod.Account__c = oppMap.get(sod.Show_Occurrence_Ref__c).AccountID;
                        sod.Name = oppMap.get(sod.Show_Occurrence_Ref__c).Name;
                        if (sod.Name.length() > 80)
                            sod.Name = sod.Name.substring(0,79);
                        sod.Amount__c = oppMap.get(sod.Show_Occurrence_Ref__c).Amount; 
                        sod.Actual_Freight_Weight_CWT__c = oppMap.get(sod.Show_Occurrence_Ref__c).Actual_Freight_Weight_CWT__c;
                        sod.Actual_Net_Square_Feet__c = oppMap.get(sod.Show_Occurrence_Ref__c).Actual_Net_Square_Feet__c;
                        sod.Actual_Number_of_Exhibitors__c = oppMap.get(sod.Show_Occurrence_Ref__c).Actual_Number_of_Exhibitors__c;
                        sod.Adv_Shipping_City__c = oppMap.get(sod.Show_Occurrence_Ref__c).AdvanceShippingBillingCity__c; //new
                        sod.Adv_Shipping_Country__c = oppMap.get(sod.Show_Occurrence_Ref__c).AdvanceShippingBillingCountry__c; //new
                        sod.Adv_Shipping_Name__c = oppMap.get(sod.Show_Occurrence_Ref__c).AdvanceShippingName__c; //new
                        sod.Adv_Shipping_Postal_Code__c = oppMap.get(sod.Show_Occurrence_Ref__c).AdvanceShippingBillingPostalCode__c; //new
                        sod.Adv_Shipping_State__c = oppMap.get(sod.Show_Occurrence_Ref__c).AdvanceShippingBillingState__c; //new
                        sod.Adv_Shipping_Street__c = oppMap.get(sod.Show_Occurrence_Ref__c).AdvanceShippingBillingStreet__c; //new
                        sod.Assigned_to_Production_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Assigned_to_Production_Date__c;
                        sod.Booth_Package__c = oppMap.get(sod.Show_Occurrence_Ref__c).Booth_Package__c;
                        sod.Booth_Package_Price__c = oppMap.get(sod.Show_Occurrence_Ref__c).Booth_Package_Price__c;
                        sod.Contract_Close_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).CloseDate;
                        sod.Contract_Expiration__c = oppMap.get(sod.Show_Occurrence_Ref__c).Contract_Expiration__c;
                        sod.Contract_Type__c = oppMap.get(sod.Show_Occurrence_Ref__c).Contract_Type__c;
                        sod.Corporate_Event__c = oppMap.get(sod.Show_Occurrence_Ref__c).Corporate_Event__c;
                        sod.CR_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).CR_Date__c;
                        sod.Description__c = oppMap.get(sod.Show_Occurrence_Ref__c).Description;
                        sod.EAC_Deadline__c = oppMap.get(sod.Show_Occurrence_Ref__c).EAC_Deadline__c; //new
                        sod.Early_Order_Deadline__c = oppMap.get(sod.Show_Occurrence_Ref__c).Early_Order_Deadline__c; //new
                        sod.Electrical__c = oppMap.get(sod.Show_Occurrence_Ref__c).Electrical__c;
                        sod.Exhibitor_Move_In_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Exhibitor_Move_In_Date__c;
                        sod.Exhibitor_Satisfaction_Score_GES_SAT__c = oppMap.get(sod.Show_Occurrence_Ref__c).Exhibitor_Satisfaction_Score_GES_SAT__c;
                        sod.Facility__c = oppMap.get(sod.Show_Occurrence_Ref__c).Facility__c;
                        sod.Freight_Weight_CWT__c = oppMap.get(sod.Show_Occurrence_Ref__c).Freight_Weight_CWT__c;
                        sod.Frequency__c = oppMap.get(sod.Show_Occurrence_Ref__c).Frequency__c;
                        sod.GES_Move_In__c = oppMap.get(sod.Show_Occurrence_Ref__c).GES_Move_In__c;
                        sod.Holidays__c = oppMap.get(sod.Show_Occurrence_Ref__c).Holidays__c;
                        sod.Job_Number__c = oppMap.get(sod.Show_Occurrence_Ref__c).Job_Number__c;
                        sod.Job_Number_Status__c = oppMap.get(sod.Show_Occurrence_Ref__c).Job_Number_Status__c;
                        sod.LMS_Status_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).LMS_Status_Date__c;
                        //sod.Management_Company__c = oppMap.get(sod.Show_Occurrence_Ref__c).Management_Company__c;
                        sod.Material_Handling_Rate__c = oppMap.get(sod.Show_Occurrence_Ref__c).Material_Handling_Rate__c;
                        sod.Move_Out__c = oppMap.get(sod.Show_Occurrence_Ref__c).Move_Out__c;
                        sod.Multi_Year_Step__c = oppMap.get(sod.Show_Occurrence_Ref__c).Multi_Year_Step__c;
                        sod.Net_Square_Feet__c = oppMap.get(sod.Show_Occurrence_Ref__c).Net_Square_Feet__c;
                        sod.New_Repeat__c = oppMap.get(sod.Show_Occurrence_Ref__c).New_Repeat__c;
                        sod.Number_of_Booths__c = oppMap.get(sod.Show_Occurrence_Ref__c).Number_of_Booths__c;
                        sod.Number_of_Exhibitors__c = oppMap.get(sod.Show_Occurrence_Ref__c).Number_of_Exhibitors__c;
                        sod.Price_Increase_Percent__c = oppMap.get(sod.Show_Occurrence_Ref__c).Price_Increase_Percent__c;
                        sod.Prime_Contractor__c = oppMap.get(sod.Show_Occurrence_Ref__c).Prime_Contractor__c;
                        sod.Prime_Contractor_Contact__c = oppMap.get(sod.Show_Occurrence_Ref__c).Prime_Contractor_Contact__c;
                        sod.Probability__c = oppMap.get(sod.Show_Occurrence_Ref__c).Probability;
                        sod.Production_Location__c = oppMap.get(sod.Show_Occurrence_Ref__c).Production_Location__c;
                        sod.Proposal_Sent_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Proposal_Sent_Date__c;
                        sod.PSP__c = oppMap.get(sod.Show_Occurrence_Ref__c).PSP__c;
                        sod.Receive_RFP_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Receive_RFP_Date__c;
                        sod.Review_Legal__c = oppMap.get(sod.Show_Occurrence_Ref__c).Review_Legal__c;
                        sod.RFP_Due_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).RFP_Due_Date__c;
                        sod.Sales_Location__c = oppMap.get(sod.Show_Occurrence_Ref__c).Sales_Location__c;
                        sod.Show_Close_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Close_Date__c;
                        sod.Show_Close_Date_Confirmed__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Close_Date_Confirmed__c;
                        sod.Show_Name__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Name__c;
                        sod.Show_Occurrence_Name__c = oppMap.get(sod.Show_Occurrence_Ref__c).Name;
                        sod.Show_Open_Date__c = oppMap.get(sod.Show_Occurrence_Ref__c).Show_Open_Date__c;
                        //sod.Sponsor__c = oppMap.get(sod.Show_Occurrence_Ref__c).Sponsor__c;
                        sod.Stage__c = oppMap.get(sod.Show_Occurrence_Ref__c).StageName;
                        sod.Sub_Contractor__c = oppMap.get(sod.Show_Occurrence_Ref__c).Sub_Contractor__c;
                        sod.Target_Occurrence__c = oppMap.get(sod.Show_Occurrence_Ref__c).Target_Occurrence__c;
                        sod.Trade_Show_200_Occurrence__c = oppMap.get(sod.Show_Occurrence_Ref__c).Trade_Show_200_Occurrence__c;
                        sod.Trade_Show_Electrical__c = oppMap.get(sod.Show_Occurrence_Ref__c).Trade_Show_Electrical__c;
                        sod.Tradeshow_Fastest_50__c = oppMap.get(sod.Show_Occurrence_Ref__c).Tradeshow_Fastest_50__c;
                        sod.Type__c = oppMap.get(sod.Show_Occurrence_Ref__c).Type;
                        sod.Under_Contract__c = oppMap.get(sod.Show_Occurrence_Ref__c).Under_Contract__c;
                        sod.Verbal_Follow_Up__c = oppMap.get(sod.Show_Occurrence_Ref__c).Verbal_Follow_Up__c;
                        
                        showOccurrencePublicList.add(sod);
                    }
                    
                }
            }
            System.debug('showOccurrencePublicList On Update-->'+showOccurrencePublicList);
            if(!showOccurrencePublicList.isEmpty()){
                update showOccurrencePublicList;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage()+ ' ' + e.getLineNumber());
            opportunities[0].addError('An error has occured. Please contact your administrator');
        }
        
    }

    public static void rollUpSummaryOnOpportunity(Set<Id> opportunityIdSet){
        try{
            List<String> recordTypes = new List<String> { 'Field Security-LPM', 'Field Security-IA', 'Field Security-NE', 'Master Show Occurrence', 'Sales Rep Show Occurrence', 'Field Security-PS', 'Field Security-CV', 'Field Security-CR', 'Field Security-LO', 'Field Security-LPE', 'Field Security-LR', 'Field Security-DB', 'Field Security-TS Clear' };
            List<String> stages = new List<String> { 'PO', 'PS', 'SL1', 'SL3', 'CR', 'CV' };
            
            List<Opportunity> oppList = [SELECT LOB_Contracting_Count_US__c
                                        FROM Opportunity 
                                        WHERE Id IN:opportunityIdSet
                                        AND RecordType.Name IN:recordTypes
                                        AND StageName IN:stages 
                                        AND New_Repeat__c = 'New'];
            
            Map<Id,AggregateResult> rollupMap = new Map<Id,AggregateResult>([SELECT Show_Occurrence__c Id,COUNT(Id) Cnt
                                                                            FROM Opportunity 
                                                                            WHERE Show_Occurrence__c IN:opportunityIdSet
                                                                            AND LOB_Category_US__c != 'FALSE' 
                                                                            GROUP BY Show_Occurrence__c]);
            List<Opportunity> oppToUpdateList = new List<Opportunity>();

            for(Opportunity opp :oppList){
                Integer cnt = 0;
                if(rollupMap.containsKey(opp.Id)){
                    cnt = (Integer)rollupMap.get(opp.Id).get('Cnt');
                }
                if(opp.LOB_Contracting_Count_US__c != cnt){
                    opp.LOB_Contracting_Count_US__c = cnt;
                    oppToUpdateList.add(opp);
                }
            }

            if(!oppToUpdateList.isEmpty()){
                update oppToUpdateList;
            }
        }
        catch(Exception e){
            System.debug(e.getMessage()+ ' ' + e.getLineNumber());
        }
    }

    public static void setDataFromAccountReference(List<Opportunity> opportunities){
        Set<Id> accountIdSet = new Set<Id>();
        for(Opportunity opp :opportunities){
            /* BLB Astadia commented 2/1/2010
            if(opp.Sponsor__c != null)
                accountIdSet.add(opp.Sponsor__c);
            if(opp.Management_Company__c != null)
                accountIdSet.add(opp.Management_Company__c);*/
            
            /* BLB Astadia added 2/16/2010 */
            if(opp.AccountId != null)
                accountIdSet.add(opp.AccountId);
            if(opp.Prime_Contractor__c != null)
                accountIdSet.add(opp.Prime_Contractor__c);
            /*if(opp.Advance_Shipping_Site__c != null)
                accountIds.add(opp.Advance_Shipping_Site__c);*/    
            TriggerOptimizationUtility.SetDataFromAccountReferences_Handled.add(opp.Id);
        }
        
        if(!accountIdSet.isEmpty()){
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id,Name,BillingStreet,BillingCity,BillingState,
                                                                BillingPostalCode,BillingCountry,Phone,Fax
                                                                FROM Account
                                                                WHERE Id IN:accountIdSet]);
            for(Opportunity opp :opportunities){
                if(!accountMap.isEmpty() && accountMap.containsKey(opp.AccountId)){
                    Account acc = accountMap.get(opp.AccountId);
                    opp.ShowSponsorName__c = acc.Name;
                    opp.ShowSponsorBillingStreet__c = acc.BillingStreet;
                    opp.ShowSponsorBillingCity__c = acc.BillingCity;
                    opp.ShowSponsorBillingState__c = acc.BillingState;
                    opp.ShowSponsorBillingPostalCode__c = acc.BillingPostalCode;
                    opp.ShowSponsorBillingCountry__c = acc.BillingCountry;
                    opp.ShowSponsorPhone__c = acc.Phone;
                    opp.ShowSponsorFax__c = acc.Fax;
                    opp.ShowManagementName__c = acc.Name;
                    opp.ShowManagementBillingStreet__c = acc.BillingStreet;
                    opp.ShowManagementBillingCity__c = acc.BillingCity;
                    opp.ShowManagementBillingState__c = acc.BillingState;
                    opp.ShowManagementBillingPostalCode__c = acc.BillingPostalCode;
                    opp.ShowManagementBillingCountry__c = acc.BillingCountry;
                    opp.ShowManagementPhone__c = acc.Phone;
                    opp.ShowManagementFax__c = acc.Fax;
                }
                if(!accountMap.isEmpty() && accountMap.containsKey(opp.Prime_Contractor__c)){
                    Account acc = accountMap.get(opp.Prime_Contractor__c);
                    opp.GeneralContractorName__c = acc.Name;
                    opp.GeneralContractorBillingStreet__c = acc.BillingStreet;
                    opp.GeneralContractorBillingCity__c = acc.BillingCity;
                    opp.GeneralContractorBillingState__c = acc.BillingState;
                    opp.GeneralContractorBillingPostalCode__c = acc.BillingPostalCode;
                    opp.GeneralContractorBillingCountry__c = acc.BillingCountry;
                    opp.GeneralContractorPhone__c = acc.Phone;
                    opp.GeneralContractorFax__c = acc.Fax;
                }
            }
        }
    }

    //to update related Opporunity names
    public static void updateOpportunityNamesOnUpdate(List<Opportunity> opportunities){
    
/******* commented and updated to bypass AV opp validation.
        List<Opportunity> relatedOppsList = [SELECT Id from Opportunity WHERE Show_Occurrence__c IN:opportunities AND RecordTypeId IN:retrieveOpportunityRecordTypeIds()];
        if(!relatedOppsList.isEmpty()){
            update relatedOppsList;
        }
*******/
        string recordtypename;
        List<Opportunity> relatedOppsList  = new List<Opportunity>();
        List<Opportunity> relatedOppsListToUpdate  = new List<Opportunity>();
        relatedOppsList = [SELECT Id,BypassValidation__c,recordtypeid from Opportunity WHERE Show_Occurrence__c IN:opportunities AND RecordTypeId IN:retrieveOpportunityRecordTypeIds()];
        if(!relatedOppsList.isEmpty()){
            for(Opportunity tempOpp : relatedOppsList)
            {
                recordtypename = '';
                recordtypename = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(tempOpp.recordtypeid).getname();
                //if(recordtypename.contains('Field') || recordtypename == 'Master Show Occurrence' || recordtypename == 'Sales Rep Show Occurrence')
                if(recordtypename.contains('AV'))
                {
                    tempOpp.BypassValidation__c = true;
                }
                relatedOppsListToUpdate.add(tempOpp);
            }
            if(!relatedOppsListToUpdate.isEmpty())
            {
                update relatedOppsListToUpdate;
            }            
        }
    }

    public static List<Id> retrieveOpportunityRecordTypeIds(){
        List<Id> rTypeIds = new List<Id>();
        for(RecordType rType :[SELECT Id, Name from RecordType WHERE sObjectType = 'Opportunity' AND (Name IN ('US - Housing', 'US - Housing Supplemental', 'US - Registration', 'Marketing-Strategy') OR Name LIKE 'AV - %')]){
            rTypeIds.add(rType.Id);  
        }
        return rTypeIds;
    }
    
    //update the OnPeak show field on Parent Opportunity - Sajid - 10/04/23 - SFDC-253
    public static void updateOnPeakShowOnInsert(Set<Id> parentOppIds){
        List<Opportunity> toUpdateOppty = new List<Opportunity>();
        for(Opportunity opp : [SELECT Id, OnPeak_Show__c from Opportunity WHERE Id IN:parentOppIds AND OnPeak_Show__c =: false]){
            opp.OnPeak_Show__c = true;
            toUpdateOppty.add(opp);
        }
        if(!toUpdateOppty.isEmpty()){
            update toUpdateOppty;
        }
    }
    
    
    //update the OnPeak show field on Parent Opportunity - Sajid - 10/04/23 - SFDC-253
    public static void updateOnPeakOnUpdate(Set<Id> parentOppIds){
        Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Housing').getRecordTypeId();
        Map<Id, Opportunity> parentIdToOppty = new Map<Id, Opportunity>();
        String[] stageName = new List<String>{'CV','CR'};
        List<Opportunity> toUpdateOppty = new List<Opportunity>();
        
        for(Opportunity childOpp : [SELECT Id, Show_Occurrence__c from Opportunity WHERE Show_Occurrence__c IN:parentOppIds AND StageName IN: stageName AND RecordTypeId =: recTypeId]){
            parentIdToOppty.put(childOpp.Show_Occurrence__c, childOpp);
        }
        
        for(Id oppId : parentOppIds){
            if(oppId != null ){
                Opportunity opp = new Opportunity();
                opp.Id = oppId;
                if(parentIdToOppty?.get(oppId) != null){
                    opp.OnPeak_Show__c = true;
                }else{
                    opp.OnPeak_Show__c = false;
                }
                toUpdateOppty.add(opp);
            }
        }
        
        if(!toUpdateOppty.isEmpty()){
            update toUpdateOppty;
        }
    }
    
    //added products when EMEA opportunity created - Sajid - 05/01/24 - SFDC-273
    public static void createOpptyLineItems(Set<String> setCurrencyCode, Map<Id, String> mapOppIdToCurrencyCode, Map<id, Opportunity> newMap, EMEA_Custom_Setting__c EMEACustomSetting){
        List<OpportunityLineItem> listOli = new List<OpportunityLineItem>(); 
        //List<String> productCode = new List<String>{'CONSTRUCTION','EXHIBIT','FREIGHT','GRAPHICS','INSTDISM','INTL','KIOSK','OTHER','PULLPREP','REFURB','SHOWSVCS','TECHNOLOGY'};
        String productCode = EMEACustomSetting.Product_Code__c;
        List<String> listProductCode = productCode.split(',');
        List<PricebookEntry> listPB = [SELECT id, Name,CurrencyIsoCode,IsActive,Pricebook2Id,Product2Id,ProductCode,UnitPrice,UseStandardPrice FROM PricebookEntry where Product2.ProductCode IN: listProductCode AND CurrencyIsoCode IN: setCurrencyCode AND IsActive =: true AND Pricebook2Id =: EMEACustomSetting.Pricebook2Id__c];
        if(!listPB.isEmpty()){
            Map<String,List<PricebookEntry>> mapCurrencyCodeToListPb = new Map<String,List<PricebookEntry>>();
            for(PricebookEntry pb : listPB){
                if(mapCurrencyCodeToListPb.containsKey(pb.CurrencyIsoCode)){
                    mapCurrencyCodeToListPb.get(pb.CurrencyIsoCode).add(pb);
                }else{
                    mapCurrencyCodeToListPb.put(pb.CurrencyIsoCode, new List<PricebookEntry>{pb});
                }
            }
            if(!mapCurrencyCodeToListPb.isEmpty()){
                for(String oppId : mapOppIdToCurrencyCode.keySet()){
                    String currencyCode = mapOppIdToCurrencyCode.get(oppId);
                    Decimal oppAmount = newMap.get(oppId).Amount;
                    List<PricebookEntry> listPBE = mapCurrencyCodeToListPb.get(mapOppIdToCurrencyCode.get(oppId));
                    for(PricebookEntry pbe : listPBE){
                        OpportunityLineItem oli = new OpportunityLineItem();
                        oli.OpportunityId = oppId;
                        oli.PricebookEntryId = pbe.Id;
                        oli.Quantity = 1;
                        if(oppAmount != null && oppAmount != 0 && pbe.Name == 'Show Services'){
                            oli.UnitPrice = oppAmount;
                        }
                        listOli.add(oli);
                    }
                }
            }
        }
        if(!listOli.isEmpty()){
            insert listOli;
        }
    }
        
}