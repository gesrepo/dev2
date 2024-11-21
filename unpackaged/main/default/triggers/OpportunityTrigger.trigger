trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete){
    
    if(Userinfo.getProfileID()==Label.MergeSystemAdminId){
        return;
    }
    
    System.debug('Allowed SOQL Limit--> '+Limits.getLimitQueries());
    
    //update the OnPeak show field on Parent Opportunity - Sajid - 10/04/23 - SFDC-253
    Set<Id> parentOppIds = new Set<Id>();
    Id recTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('US_Housing').getRecordTypeId();
    //end SFDC-253
    
    Id recTypeIdEMEACustomBuild = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('EMEA_Custom_Build').getRecordTypeId();
    private static EMEA_Custom_Setting__c EMEACustomSetting = EMEA_Custom_Setting__c.getOrgDefaults();
    
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            List<Opportunity> oppForFieldUpdateList = new List<Opportunity>();
            List<Opportunity> oldOpportunityList = new List<Opportunity>();
            //to set data from Account references
            List<Opportunity> oppForAccountDataList = new List<Opportunity>();
            
            for(Opportunity opp :Trigger.new){
                if(opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId()
                   && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsProposalRecordTypeName).getRecordTypeId()
                   && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId()){
                       oppForFieldUpdateList.add(opp);
                       if(Trigger.isUpdate)
                           oldOpportunityList.add(Trigger.oldMap.get(opp.Id));
                   }
                
                if(!TriggerOptimizationUtility.SetDataFromAccountReferences_Handled.contains(opp.Id) && (opp.AccountId != null || opp.Prime_Contractor__c != null)){
                    oppForAccountDataList.add(opp);
                }
                
                if(opp.RecordTypeId == recTypeIdEMEACustomBuild){
                    opp.Pricebook2Id = EMEACustomSetting.Pricebook2Id__c;
                }
            }
            
            if(!oppForFieldUpdateList.isEmpty()){
                OpportunityTriggerHelper.updateOpportunityFieldsBeforeEvent(oldOpportunityList,oppForFieldUpdateList);
            }
            
            //to set data from Account references
            if(!oppForAccountDataList.isEmpty()){
                OpportunityTriggerHelper.setDataFromAccountReference(oppForAccountDataList);
            }
            
        }
        
        /*
Written By: Pradeep Sharma from Astadia
To delete the respective record from show occurence public object
*/  
        if(Trigger.isDelete){
            OpportunityTriggerHelper.deleteShowOccurrence(Trigger.old);
        }
    }
    
    if(Trigger.isAfter){
        /* start- SFDC-254 - Sajid - 10/13/23
         * Moved update related opporutunity names logic outside from if statement (isFirstTime)
         * Opportunity name changed from workflow(WF_Upd_Opp_Name) based on Facility, Show Name or YRMO field is changed.
         * When Opportunity is changed then updating the child oppty to recalculate the child oppty name, workflow rule will run on child opportunity update.
         * */
        if(Trigger.isUpdate){
            //to update related opporutunity names
            List<Opportunity> oppForRelatedOppsList = new List<Opportunity>();
            for(Opportunity opp :Trigger.new){
                //to update related opporutunity names
                if(opp.Name != Trigger.oldMap.get(opp.Id).Name && !TriggerOptimizationUtility.trg_upd_oppname_relatedOpps.contains(opp.Id)){
                    oppForRelatedOppsList.add(opp);
                    TriggerOptimizationUtility.trg_upd_oppname_relatedOpps.add(opp.Id);    
                }
            }
            
            //to update related opporutunity names
            if(!oppForRelatedOppsList.isEmpty()){
                OpportunityTriggerHelper.updateOpportunityNamesOnUpdate(oppForRelatedOppsList);
            }
        }
        // end- SFDC-254
        
        if(OpportunityTriggerHelper.isFirstTime){ /*Added to handle SOQL 101 error by Sajid SFDC-236 */
            OpportunityTriggerHelper.isFirstTime = false; /*Added to handle SOQL 101 error by Sajid SFDC-236 */
            //for show LOB details
            Set<Id> showIds = new Set<Id>();
            
            //recordTypes
            List<Id> recordTypeIds = OpportunityTriggerHelper.retrieveOpportunityRecordTypeIds();
            
            if(Trigger.isInsert){
                //to add contact role to opportunity
                List<Opportunity> oppForContactRoleOnInsert = new List<Opportunity>();
                //To create show occurences
                List<Opportunity> oppForShowOccurenceCreationOnInsert = new List<Opportunity>();
                //for GC Opportunities
                List<Opportunity> GC_opportunityList = new List<Opportunity>();
                //for rollup on Opportunity
                Set<Id> oppSetForRollup = new Set<Id>();
                //for show LOB details
                Set<Id> auxIds = new Set<Id>();
                //update show plan on Opportunity
                List<Opportunity> oppForShowPlanOnInsert = new List<Opportunity>();
                //set name for Opportunities
                //List<Opportunity> oppForNamingOnInsert = new List<Opportunity>();
                
                //added products when EMEA opportunity created - Sajid - 05/01/24 - SFDC-273
                Set<String> setCurrencyCode = new Set<String>();
                Map<Id, String> mapOppIdToCurrencyCode = new Map<Id, String>();
                
                for(Opportunity opp :Trigger.new){
                    //added products when EMEA opportunity created - Sajid - 05/01/24 - SFDC-273
                    if(opp.RecordTypeId == recTypeIdEMEACustomBuild){
                        setCurrencyCode.add(opp.CurrencyIsoCode);
                        mapOppIdToCurrencyCode.put(opp.Id,opp.CurrencyIsoCode);
                    }
                    //end SFDC-273
                    
                    //to add contact role to opportunity
                    if(opp.AccountId != null){
                        oppForContactRoleOnInsert.add(opp);
                    }
                    
                    //To create show occurences
                    oppForShowOccurenceCreationOnInsert.add(opp);
                    
                    //for GC Opportunity
                    GC_opportunityList.add(opp);
                    
                    //for rollup on Opportunity
                    if(opp.Show_Occurrence__c != null && !TriggerOptimizationUtility.RollUpSummary_Handled.contains(opp.Show_Occurrence__c)){
                        oppSetForRollup.add(opp.Show_Occurrence__c);
                        TriggerOptimizationUtility.RollUpSummary_Handled.add(opp.Show_Occurrence__c);
                    }
                    
                    //for show LOB details
                    if (opp.Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(opp.Show_Name__c)) {
                        showIds.add(opp.Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(opp.Show_Name__c);
                    }
                    if (opp.Show_Occurrence__c != null) {
                        auxIds.add(opp.Show_Occurrence__c);
                    }
                    
                    //update show plan on Opportunity
                    if(!TriggerOptimizationUtility.trg_Update_Showplan_New_Handled.contains(opp.Id)){
                        if(opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId()
                           && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsProposalRecordTypeName).getRecordTypeId()
                           && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId()){
                               oppForShowPlanOnInsert.add(opp);
                               TriggerOptimizationUtility.trg_Update_Showplan_New_Handled.add(opp.Id);
                           }
                    }
                    
                }
                
                //added products when EMEA opportunity created - Sajid - 05/01/24 - SFDC-273
                if(!mapOppIdToCurrencyCode.isEmpty()){
                    OpportunityTriggerHelper.createOpptyLineItems(setCurrencyCode,mapOppIdToCurrencyCode, (Map<id, Opportunity>) Trigger.newMap, EMEACustomSetting);
                }
                //end SFDC-273
                
                //for show LOB details
                List<Opportunity> triggerOpps = [SELECT Show_Name__c FROM Opportunity WHERE Id IN:auxIds];
                for(Opportunity opp : triggerOpps){
                    if (opp.Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(opp.Show_Name__c)) {
                        showIds.add(opp.Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(opp.Show_Name__c);
                    }
                }
                
                //for rollup on Opportunity
                if(!oppSetForRollup.isEmpty()){
                    OpportunityTriggerHelper.rollUpSummaryOnOpportunity(oppSetForRollup);
                }
                
                if(!oppForContactRoleOnInsert.isEmpty()){
                    OpportunityTriggerHelper.updateContactRoleOnUpdate(oppForContactRoleOnInsert);
                }
                
                if(!oppForShowOccurenceCreationOnInsert.isEmpty()){
                    OpportunityTriggerHelper.createShowOccurrencesOnInsert(oppForShowOccurenceCreationOnInsert);
                }
                
                //for GC Opportunity
                if(!GC_opportunityList.isEmpty() && GC_OpportunityTriggerHandler.runOnce()){
                    GC_OpportunityTriggerHandler.HandleOpps(GC_opportunityList);
                }
                
                //update show plan on Opportunity
                if(!oppForShowPlanOnInsert.isEmpty()){
                    OpportunityTriggerHelper.updateShowPlanOnInsert(oppForShowPlanOnInsert);
                }
                
                //update the OnPeak show field on Parent Opportunity - Sajid - 10/04/23 - SFDC-253
                for(Opportunity opp :Trigger.new){
                    if(opp.RecordTypeId == recTypeId && opp.Show_Occurrence__c != null && (opp.StageName == 'CV' || opp.StageName == 'CR')){
                        parentOppIds.add(opp.Show_Occurrence__c);
                    }
                }
                if(!parentOppIds.isEmpty()){
                    OpportunityTriggerHelper.updateOnPeakShowOnInsert(parentOppIds);
                }
                //end SFDC-253
                
            }
            
            if(Trigger.isUpdate){
                //submit for approval
                List<Opportunity> oppForSubmittion = new List<Opportunity>();
                //to add contact role to opportunity
                List<Opportunity> oppForContactRoleOnUpdate = new List<Opportunity>();
                //to update show occurrence public 
                List<Opportunity> oppForShowOccurenceCreationOnUpdate = new List<Opportunity>();
                //for GC Opportunities
                List<Opportunity> GC_opportunityList = new List<Opportunity>();
                //for rollup on Opportunity
                Set<Id> oppSetForRollup = new Set<Id>();
                
                /* sfdc-254 - commedted this logic by sajid - 10/13/23
                 //to update related opporutunity names
                List<Opportunity> oppForRelatedOppsList = new List<Opportunity>();
				*/
                
                //for show LOB details
                Set<Id> auxIds = new Set<Id>();
                //update show plan on Opportunity
                List<Opportunity> oppForShowPlanOnUpdate = new List<Opportunity>();
                //for naming
                //List<Opportunity> oppForNamingOnUpdate = new List<Opportunity>();
                
                for(Opportunity opp :Trigger.new){
                    System.debug('opp.Requested_Stage__c: '+opp.Requested_Stage__c + '/Trigger.oldMap.get(opp.Id).Requested_Stage__c'+Trigger.oldMap.get(opp.Id).Requested_Stage__c);
                    if(!TriggerOptimizationUtility.trg_opp_submit_for_approval.contains(opp.Id)
                       && opp.Requested_Stage__c != Trigger.oldMap.get(opp.Id).Requested_Stage__c
                       && opp.Requested_Stage__c != NULL 
                       && opp.Requested_Stage__c != ''
                       && opp.Requested_Stage__c != 'E&D - Projects'
                       && opp.Requested_Stage__c != 'E&D - Projects - Proposal'
                       && opp.Requested_Stage__c != 'E&D - Projects - Read Only'
                       && opp.Requested_Stage__c != 'SL1'
                       && opp.Requested_Stage__c != 'SL3'){
                           oppForSubmittion.add(opp);
                           TriggerOptimizationUtility.trg_opp_submit_for_approval.add(opp.Id);
                       }
                    
                    //to add contact role to Opportunity
                    if(opp.AccountId != null){
                        oppForContactRoleOnUpdate.add(opp);
                    }
                    
                    //for GC Opportunity
                    GC_opportunityList.add(opp);
                    
                    //to update show occurrence public 
                    oppForShowOccurenceCreationOnUpdate.add(opp);  
                    
                    //for rollup on Opportunity
                    oppSetForRollup.add(opp.Id);
                    if(opp.Show_Occurrence__c != null && !TriggerOptimizationUtility.RollUpSummary_Handled.contains(opp.Show_Occurrence__c)){
                        oppSetForRollup.add(opp.Show_Occurrence__c);
                        TriggerOptimizationUtility.RollUpSummary_Handled.add(opp.Show_Occurrence__c);
                    }
                    if(Trigger.oldMap.get(opp.Id).Show_Occurrence__c != null && !TriggerOptimizationUtility.RollUpSummary_Handled.contains(Trigger.oldMap.get(opp.Id).Show_Occurrence__c)){
                        oppSetForRollup.add(Trigger.oldMap.get(opp.Id).Show_Occurrence__c);
                        TriggerOptimizationUtility.RollUpSummary_Handled.add(Trigger.oldMap.get(opp.Id).Show_Occurrence__c);
                    }
                    
                    /* sfdc-254 - commedted this logic by sajid - 10/13/23
                    //to update related opporutunity names
                    if(opp.Name != Trigger.oldMap.get(opp.Id).Name && !TriggerOptimizationUtility.trg_upd_oppname_relatedOpps.contains(opp.Id)){
                        oppForRelatedOppsList.add(opp);
                        TriggerOptimizationUtility.trg_upd_oppname_relatedOpps.contains(opp.Id);
                    }
					*/

                    //for show LOB details
                    if (opp.Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(opp.Show_Name__c)) {
                        showIds.add(opp.Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(opp.Show_Name__c);
                    }
                    if (trigger.oldMap.get(opp.id).Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(trigger.oldMap.get(opp.id).Show_Name__c)) {
                        showIds.add(trigger.oldMap.get(opp.id).Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(trigger.oldMap.get(opp.id).Show_Name__c);
                    }
                    if (opp.Show_Occurrence__c != null) {
                        auxIds.add(opp.Show_Occurrence__c);
                    }
                    if (trigger.oldMap.get(opp.id).Show_Occurrence__c != null) {
                        auxIds.add(trigger.oldMap.get(opp.id).Show_Occurrence__c);
                    }
                    
                    //update show plan on Opportunity
                    if(!TriggerOptimizationUtility.trg_Update_Showplan_New_Handled.contains(opp.Id) && !Test.isRunningTest()){
                        if(opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId()
                           && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsProposalRecordTypeName).getRecordTypeId()
                           && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId()){
                               oppForShowPlanOnUpdate.add(opp);
                               TriggerOptimizationUtility.trg_Update_Showplan_New_Handled.add(opp.Id);
                           }
                    }
                    else if(Test.isRunningTest()){
                        oppForShowPlanOnUpdate.add(opp);
                    }
                    
                }
                
                //for show LOB details
                List<Opportunity> triggerOpps = [SELECT Show_Name__c FROM Opportunity WHERE Id IN:auxIds];
                for(Opportunity opp : triggerOpps){
                    if (opp.Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(opp.Show_Name__c)) {
                        showIds.add(opp.Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(opp.Show_Name__c);
                    }
                }
                
                //for rollup on Opportunity
                if(!oppSetForRollup.isEmpty()){
                    OpportunityTriggerHelper.rollUpSummaryOnOpportunity(oppSetForRollup);
                }
                
                if(!oppForSubmittion.isEmpty()){
                    OpportunityTriggerHelper.submitForApproval(oppForSubmittion);
                }
                
                //to add contact role to Opportunity
                if(!oppForContactRoleOnUpdate.isEmpty()){
                    OpportunityTriggerHelper.updateContactRoleOnUpdate(oppForContactRoleOnUpdate);
                }
                
                //to update show occurrence public
                if(!oppForShowOccurenceCreationOnUpdate.isEmpty()){
                    OpportunityTriggerHelper.createShowOccurrencesOnUpdate(oppForShowOccurenceCreationOnUpdate);
                }
                
                //for GC Opportunity
                if(!GC_opportunityList.isEmpty() && GC_OpportunityTriggerHandler.runOnce()){
                    GC_OpportunityTriggerHandler.HandleOpps(GC_opportunityList);
                }
                
                /* sfdc-254 - commedted this logic by sajid - 10/13/23
                //to update related opporutunity names
                if(!oppForRelatedOppsList.isEmpty()){
                    OpportunityTriggerHelper.updateOpportunityNamesOnUpdate(oppForRelatedOppsList);
                }
				*/
                
                //update show plan on Opportunity
                if(!oppForShowPlanOnUpdate.isEmpty()){
                    OpportunityTriggerHelper.updateShowPlanOnUpdate(Trigger.oldMap, oppForShowPlanOnUpdate);
                }
                
                //update the OnPeak show field on Parent Opportunity - Sajid - 10/04/23 - SFDC-253
                for(Opportunity opp :Trigger.new){
                    if(opp.Show_Occurrence__c != Trigger.oldMap.get(opp.Id).Show_Occurrence__c || opp.RecordTypeId != Trigger.oldMap.get(opp.Id).RecordTypeId || opp.StageName != Trigger.oldMap.get(opp.Id).StageName){
                        if(opp.Show_Occurrence__c != Trigger.oldMap.get(opp.Id).Show_Occurrence__c){
                            parentOppIds.add(Trigger.oldMap.get(opp.Id).Show_Occurrence__c);
                        }
                        parentOppIds.add(opp.Show_Occurrence__c);
                    } 
                }
                if(!parentOppIds.isEmpty()){
                    OpportunityTriggerHelper.updateOnPeakOnUpdate(parentOppIds);
                } 
                //end SFDC-253
            }
            
            if(Trigger.isDelete){
                //for rollup on Opportunity
                Set<Id> oppSetForRollup = new Set<Id>();
                //for show LOB details
                Set<Id> auxIds = new Set<Id>();
                //update show plan on Opportunity
                List<Opportunity> oppForShowPlanOnDelete = new List<Opportunity>();
                
                for(Opportunity opp :Trigger.old){
                    if(opp.Show_Occurrence__c != null && !TriggerOptimizationUtility.RollUpSummary_Handled.contains(opp.Show_Occurrence__c)){
                        oppSetForRollup.add(opp.Show_Occurrence__c);
                        TriggerOptimizationUtility.RollUpSummary_Handled.add(opp.Show_Occurrence__c);
                    }
                    
                    //for show LOB details
                    if (opp.Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(opp.Show_Name__c)) {
                        showIds.add(opp.Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(opp.Show_Name__c);
                    }
                    if (opp.Show_Occurrence__c != null) {
                        auxIds.add(opp.Show_Occurrence__c);
                    }
                    
                    //update show plan on Opportunity
                    if(!TriggerOptimizationUtility.trg_Update_Showplan_New_Handled.contains(opp.Id)){
                        if(opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsRecordTypeName).getRecordTypeId()
                           && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsProposalRecordTypeName).getRecordTypeId()
                           && opp.RecordTypeId != SObjectType.Opportunity.getRecordTypeInfosByName().get(Properties.edProjectsReadOnlyRecordTypeName).getRecordTypeId()){
                               oppForShowPlanOnDelete.add(opp);
                               TriggerOptimizationUtility.trg_Update_Showplan_New_Handled.add(opp.Id);
                           }
                    }
                }
                
                //for show LOB details
                List<Opportunity> parentOpps = [SELECT Show_Name__c FROM Opportunity WHERE Id IN:auxIds];
                for(Opportunity opp : parentOpps){
                    if (opp.Show_Name__c != null && !TriggerOptimizationUtility.ShowLOBDetails_Handled.contains(opp.Show_Name__c)) {
                        showIds.add(opp.Show_Name__c);
                        TriggerOptimizationUtility.ShowLOBDetails_Handled.add(opp.Show_Name__c);
                    }
                }
                
                if(!oppSetForRollup.isEmpty()){
                    OpportunityTriggerHelper.rollUpSummaryOnOpportunity(oppSetForRollup);
                }
                
                //update show plan on Opportunity
                if(!oppForShowPlanOnDelete.isEmpty()){
                    OpportunityTriggerHelper.updateShowPlanOnDelete(oppForShowPlanOnDelete);
                }
                
            }
            
            //for show LOB details
            if(!showIds.isEmpty())
                LOBDetailsCalculations.LOBDetailsCalculations(showIds);
        }
    }    
}