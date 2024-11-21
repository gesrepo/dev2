public class CG_ClaimFolderCreationHandler {
    
    public static void createFolders(List<Claims__Claim__c> newClaims){
        List<String> folderNamesForWorkersCompensation = new List<String>();
        folderNamesForWorkersCompensation.add('Correspondence');
        folderNamesForWorkersCompensation.add('Filings');
        folderNamesForWorkersCompensation.add('IIP');
        folderNamesForWorkersCompensation.add('Investigation');
        folderNamesForWorkersCompensation.add('Medical');
        folderNamesForWorkersCompensation.add('Pictures');
        folderNamesForWorkersCompensation.add('Reserves');
        folderNamesForWorkersCompensation.add('TMWDP');
        folderNamesForWorkersCompensation.add('Wage Info');
        
        List<String> folderNamesForOtherRecordType = new List<String>();
        folderNamesForOtherRecordType.add('Budges & Invoices');
        folderNamesForOtherRecordType.add('Claim File');
        folderNamesForOtherRecordType.add('Correspondence');
        folderNamesForOtherRecordType.add('Contracts');
        folderNamesForOtherRecordType.add('Discovery');
        folderNamesForOtherRecordType.add('Experts');
        folderNamesForOtherRecordType.add('Investigation');
        folderNamesForOtherRecordType.add('Medical');
        folderNamesForOtherRecordType.add('Pictures');
        folderNamesForOtherRecordType.add('Pleadings');
        folderNamesForOtherRecordType.add('Production to Csl');
        
        List<Claim_File__c> folderList = new List<Claim_File__c>();
        Id recordTypeIdWorkersCompensation = Schema.SObjectType.Claims__Claim__c.getRecordTypeInfosByName().get('Workers Compensation').getRecordTypeId();
        
        for(Claims__Claim__c claim : newClaims){
            if(claim.RecordTypeID == recordTypeIdWorkersCompensation){
                for(Integer i = 0; i < folderNamesForWorkersCompensation.size(); i ++){    
                    Claim_File__c newFolder = new Claim_File__c();
                    newFolder.File_Name__c = folderNamesForWorkersCompensation[i];
                    newFolder.Content_Type__c = 'Folder';
                    newFolder.Parent__c = claim.Id;
                    newFolder.Is_Latest_Version__c = true;
                    newFolder.File_Size_in_Bytes__c = 0;
                    newFolder.WIP__c = false;
                    folderList.add(newFolder);
                }
            }

            else{
                for(Integer i = 0; i < folderNamesForOtherRecordType.size(); i ++){      
                    Claim_File__c newFolder = new Claim_File__c();
                    newFolder.File_Name__c = folderNamesForOtherRecordType[i];
                    newFolder.Content_Type__c = 'Folder';
                    newFolder.Parent__c = claim.Id;
                    newFolder.Is_Latest_Version__c = true;
                    newFolder.File_Size_in_Bytes__c = 0;
                    newFolder.WIP__c = false;
                    folderList.add(newFolder);
                }
            }
        }
        
        insert folderList;
        system.debug('The folders are created successfully for Claims.');
    }
    
    public static List<Claims__Claim__c> getAllClaims(){
        List<Claims__Claim__c> claims = new List<Claims__Claim__c>();
        String queryStr = 'SELECT Id, RecordTypeId FROM Claims__Claim__c LIMIT 1000';
        claims = Database.query(queryStr);
        return claims;
    }

    public static void createFoldersOnAllClaims(){
        List<Claims__Claim__c> allClaims = getAllClaims();
        if(null != allClaims && allClaims.size() > 0){
            createFolders(allClaims);
        }
        else{
            System.debug('CG_ClaimFolderCreationHandler.createFoldersOnAllClaims() | No Claims__Claim__c records are found.');   
        }
    }    
    
}