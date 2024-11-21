trigger BoothStagingAll on Booth_Staging__c(before insert) {

    if (trigger.isBefore && trigger.isInsert) {
        setBoothUpload();
    }

    public void setBoothUpload() {

        List<Booth_Upload_Settings__c> buss = [SELECT Id, Booth_Upload_Id__c FROM Booth_Upload_Settings__c WHERE User_Id__c = :UserInfo.getUserId()];
        System.debug('***buss : '+ buss );
        if (buss.size() > 0) {

            for(Booth_Staging__c b : trigger.new) {
                if(b.Booth_Upload__c ==null){
                    b.Booth_Upload__c = buss[0].Booth_Upload_Id__c;
                    System.debug('trigger bs: '+ b);
                }
            }
        }
        
    }

}