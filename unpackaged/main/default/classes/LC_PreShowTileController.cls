public  without sharing  class LC_PreShowTileController {
    @AuraEnabled
    public static List<AS_Tile__c> getTilesForShowTeamMember(String projectNumber) {
        List<AS_Tile__c> allowedTiles = new List<AS_Tile__c>();
        List<string> tilesToBeDisplayedInPreShow= new List<string>();
        tilesToBeDisplayedInPreShow.add('OrdersPreshow');
        tilesToBeDisplayedInPreShow.add('GraphicProofingPreshow');
        tilesToBeDisplayedInPreShow.add('ProofBookPreshow');
        tilesToBeDisplayedInPreShow.add('AnalyticsPreshow');
        tilesToBeDisplayedInPreShow.add('TasksPreshow');        
        try{
            if(System.Label.LC_AtShowOverride.contains(UserInfo.getProfileId())){
                List<GC_Connect2_Show__c> showList=[SELECT id, name, SharePoint_Link__c, Sponsorship_Link__c FROM GC_Connect2_Show__c WHERE Job_Number__c=:projectNumber];
                if(string.isNotBlank(showList[0].SharePoint_Link__c)){
                    tilesToBeDisplayedInPreShow.add('SharePoint');
                }
                if(string.isNotBlank(showList[0].Sponsorship_Link__c)){
                    tilesToBeDisplayedInPreShow.add('Sponsorship');
                }
                allowedTiles= [SELECT id, Name, Image_Link__c FROM AS_Tile__c WHERE (Is_Active__c=true AND Image_Link__c!=null AND Name In :tilesToBeDisplayedInPreShow) ORDER BY Order_Of_Display__c ];
            }else{
                GC_Show_Team_Member__c stm = new GC_Show_Team_Member__c();
                String jobNumber = '';
                stm= [SELECT id, Name, Pre_show_Tile_Access__c,Connect2_Show__r.SharePoint_Link__c,Connect2_Show__r.Sponsorship_Link__c FROM GC_Show_Team_Member__c WHERE User__c=:UserInfo.getUserId() AND Connect2_Show__r.Job_Number__c=:projectNumber LIMIT 1];
                string[] accessGivenForTiles = stm.Pre_show_Tile_Access__c.split(';');
                if(string.isNotBlank(stm.Connect2_Show__r.SharePoint_Link__c)){
                    tilesToBeDisplayedInPreShow.add('SharePoint');
                }
                if(string.isNotBlank(stm.Connect2_Show__r.Sponsorship_Link__c)){
                    tilesToBeDisplayedInPreShow.add('Sponsorship');
                }
                allowedTiles= [SELECT id, Name, Image_Link__c FROM AS_Tile__c WHERE  (Is_Active__c=true AND name IN :accessGivenForTiles AND Name In :tilesToBeDisplayedInPreShow) ORDER BY Order_Of_Display__c ];
            }
            
        }catch(exception e){
            allowedTiles = new List<AS_Tile__c>();
            system.debug('error=='+e.getMessage()+e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
        return allowedTiles;
    }
    
    
}