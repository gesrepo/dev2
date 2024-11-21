public class Redirect {
    public PageReference result{set;get;}
    public  Redirect(ApexPages.StandardController controller){
        result=new PageReference('/apex/Newboothcreation');
        String boothId=controller.getId();
        List<Booth_Area__c> gc=[select Connect2_Show__r.Id from Booth_Area__c where id =: controller.getId() limit 1];
        result.getParameters().put('Id',gc.get(0).Connect2_Show__c);
        result.getParameters().put('BoothId', boothId);
        result.setRedirect(true);
    }
    public PageReference navigate(){
        return result;
    }
}